import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moi_results_mobile_app_2022/localization/localization_constants.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../providers/pol_stn_map_provider.dart';
import '../providers/wilayat_select_provider.dart';
import '../shared/global.dart';

class MapPageJSON extends StatefulWidget {
  const MapPageJSON({Key? key}) : super(key: key);

  @override
  _MapPageJSONState createState() => _MapPageJSONState();
}

class _MapPageJSONState extends State<MapPageJSON> {

  // Completer<GoogleMapController> _controller = Completer();
  WilayatSelectProvider? _wilayatSelectProvider;
  PollingStationMapProvider? _pollingStationMapProvider;

  // late List<Model> _data;
  late MapShapeSource _mapSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapShapeLayerController _controller;

  // static final CameraPosition _initialView = CameraPosition(
  //   target: LatLng(21.97, 56.15),
  //   zoom: 6,
  // );

  void _onWilayatChange(String? wilayatCode){
    _wilayatSelectProvider!.setSelectedWilayatCode(wilayatCode!);
    _pollingStationMapProvider!.filterPollingStations(wilayatCode);
    _controller.clearMarkers();
    for(int i = 0; i < _pollingStationMapProvider!.getGeoJSONMapMarkers().length; i++){
      _controller.insertMarker(i);
    }
  }

  @override
  initState() {
    _wilayatSelectProvider = Provider.of<WilayatSelectProvider>(context, listen: false);
    _pollingStationMapProvider = Provider.of<PollingStationMapProvider>(context, listen: false);
    String? selectedWilayatCode = [null, ''].contains(GlobalVars.registeredWilayatCode) ? "0" : GlobalVars.registeredWilayatCode;
    _pollingStationMapProvider!.filterPollingStations(selectedWilayatCode, callNotifyListeners: false);

    _mapSource = MapShapeSource.asset(
      'assets/maps/oman.json',
      // shapeDataField: 'STATE_NAME',
      dataCount: _pollingStationMapProvider!.getGeoJSONMapMarkers().length,
      primaryValueMapper: (index) => _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].polStnName,
    );
    _zoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      maxZoomLevel: 50,
    );
    _controller = MapShapeLayerController();

    super.initState();
  }

  void displayBottomSheet(BuildContext context, {required String wilayatName, required String polStnName, required double latitude, required double longitude}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          return Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Wjts.text(context, wilayatName,
                                      size: TextSize.xl, weight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Wjts.text(context, polStnName,
                                      align: TextAlign.center,
                                      size: TextSize.l, weight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    child: Wjts.text(context, Translations.mapsPageGetDir.tr()),
                                    onPressed: (){
                                      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                      canLaunchUrlString(googleUrl).then((canLaunch) {
                                        if(canLaunch){
                                          launchUrlString(googleUrl);
                                        }else{
                                          debugPrint('cannot open directions...');
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wjts.appBar(context, Translations.mapsPageTitle.tr()),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Wjts.wilayatSelect(context, selectedValue: _wilayatSelectProvider!.getSelectedWilayatCode(), onChangeHandler: _onWilayatChange, showOptionForAllWilayats: true),
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Consumer<PollingStationMapProvider>(
                              builder: (context, data, child) {
                                return Wjts.text(context, '${Translations.mapsPageRegular.tr()}: ${data.getRegularPolStnCount()}', weight: FontWeight.bold, color: AppColours.regPolStnColor);
                              }
                            ),
                            Consumer<PollingStationMapProvider>(
                              builder: (context, data, child) {
                                return Wjts.text(context, '${Translations.mapsPageUnified.tr()}: ${_pollingStationMapProvider!.getUnifiedPolStnCount()}', weight: FontWeight.bold, color: AppColours.uniPolStnColor);
                              }
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SfMaps(
                  layers: <MapLayer>[
                    MapShapeLayer(
                      zoomPanBehavior: _zoomPanBehavior,
                      source: _mapSource,
                      controller: _controller,
                      initialMarkersCount: _pollingStationMapProvider!.getGeoJSONMapMarkers().length,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].lat,
                          longitude: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].lng,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.location,
                                color: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].isUnified ? AppColours.uniPolStnColor : AppColours.regPolStnColor,
                              ),
                              onPressed: (){
                                displayBottomSheet(context,
                                  wilayatName: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].wilayatName,
                                  polStnName: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].polStnName,
                                  latitude: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].lat,
                                  longitude: _pollingStationMapProvider!.getGeoJSONMapMarkers()[index].lng,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () async {
            _zoomPanBehavior.zoomLevel = 1;
            // final GoogleMapController controller = await _controller.future;
            // controller.animateCamera(CameraUpdate.newCameraPosition(_initialView));
          },
          child: const Icon(CupertinoIcons.refresh_circled),
        ),
      )
    );
  }
}

// class Model {
//   const Model({required this.wilayatName, required this.polStnName, required this.lat, required this.lng, required this.isUnified});
//
//   final String wilayatName;
//   final String polStnName;
//   final double lat;
//   final double lng;
//   final bool isUnified;
// }