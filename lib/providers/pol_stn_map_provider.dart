import 'package:flutter/foundation.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/polling_station_vm.dart';
import '../models/wilayat_vm.dart';


class PollingStationMapProvider extends ChangeNotifier{
  final List<WilayatVM> _wilayats;
  final List<PollingStationVM> _pollingStations;
  // final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final List<GeoJSONMapMarker> _geoJSONMapMarkers = [];
  int _regularPolStnCount = 0, _unifiedPolStnCount = 0;
  final bool _isEnglish;

  PollingStationMapProvider({required List<PollingStationVM> pollingStations, required List<WilayatVM> wilayats, required bool isEnglish})
    : _pollingStations = pollingStations,
      _wilayats = wilayats,
      _isEnglish = isEnglish;

  void filterPollingStations(String? wilayatCode, {bool callNotifyListeners = true}){
    // _markers.clear();
    _geoJSONMapMarkers.clear();
    _unifiedPolStnCount = 0;
    _regularPolStnCount = 0;
    for (var polStn in _pollingStations) {
      if(polStn.wilayatCode == wilayatCode || wilayatCode == "0"){
        if(polStn.isUnified!){
          _unifiedPolStnCount += 1;
        }else{
          _regularPolStnCount += 1;
        }
        _geoJSONMapMarkers.add(GeoJSONMapMarker(
          wilayatName: _isEnglish ? _wilayats.firstWhere((w) => w.code == polStn.wilayatCode).nameEn! : _wilayats.firstWhere((w) => w.code == polStn.wilayatCode).nameAr!,
          polStnName: _isEnglish ? polStn.nameEn! : polStn.nameAr!,
          lat: polStn.lat!,
          lng: polStn.lng!,
          isUnified: polStn.isUnified!)
        );
        // final MarkerId markerId = MarkerId(polStn.id.toString());
        // _markers[markerId] = Marker(
        //   markerId: markerId,
        //   position: LatLng(polStn.lat!, polStn.lng!),
        //   icon: polStn.isUnified! ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure) : BitmapDescriptor.defaultMarker,
        //   infoWindow: InfoWindow(
        //       title: _isEnglish ? polStn.nameEn : polStn.nameAr
        //   ),
        //   // onTap: () {
        //   //   _onMarkerTapped(markerId);
        //   // }
        // );
      }
    }
    if(callNotifyListeners){
      notifyListeners();
    }
  }

  int getRegularPolStnCount() => _regularPolStnCount;
  int getUnifiedPolStnCount() => _unifiedPolStnCount;
  // Map<MarkerId, Marker> getMapMarkers() => _markers;
  List<GeoJSONMapMarker> getGeoJSONMapMarkers() => _geoJSONMapMarkers;

// void _onMarkerTapped(MarkerId markerId) {
//   // final Marker tappedMarker = markers[markerId];
//   // if (tappedMarker != null) {
//   //   setState(() {
//   //     final MarkerId previousMarkerId = selectedMarker;
//   //     if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
//   //       final Marker resetOld = markers[previousMarkerId].copyWith(iconParam: BitmapDescriptor.defaultMarker);
//   //       markers[previousMarkerId] = resetOld;
//   //     }
//   //     selectedMarker = markerId;
//   //     final Marker newMarker = tappedMarker.copyWith(
//   //       iconParam: BitmapDescriptor.defaultMarkerWithHue(
//   //         BitmapDescriptor.hueGreen,
//   //       ),
//   //     );
//   //     markers[markerId] = newMarker;
//   //   });
//   // }
// }

}

class GeoJSONMapMarker {
  const GeoJSONMapMarker({required this.wilayatName, required this.polStnName, required this.lat, required this.lng, required this.isUnified});

  final String wilayatName;
  final String polStnName;
  final double lat;
  final double lng;
  final bool isUnified;
}