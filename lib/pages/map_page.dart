// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:proof_of_concepts/shared/global_variables.dart';
// import 'package:proof_of_concepts/providers/wilayat_select_provider.dart';
// import 'package:proof_of_concepts/providers/pol_stn_map_provider.dart';
// import 'package:provider/provider.dart';
//
//
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//
//   Completer<GoogleMapController> _controller = Completer();
//   WilayatSelectProvider? _wilayatSelectProvider;
//   PollingStationMapProvider? _pollingStationMapProvider;
//
//   static final CameraPosition _initialView = CameraPosition(
//     target: LatLng(21.97, 56.15),
//     zoom: 6,
//   );
//
//   void _onWilayatChange(String? wilayatCode){
//     _wilayatSelectProvider!.setSelectedWilayatCode(wilayatCode!);
//     _pollingStationMapProvider!.filterPollingStations(wilayatCode);
//   }
//
//   @override
//   initState() {
//     _wilayatSelectProvider = Provider.of<WilayatSelectProvider>(context, listen: false);
//     _pollingStationMapProvider = Provider.of<PollingStationMapProvider>(context, listen: false);
//     String? selectedWilayatCode = [null, ''].contains(GlobalVars.registeredWilayatCode) ? "0" : GlobalVars.registeredWilayatCode;
//     _pollingStationMapProvider!.filterPollingStations(selectedWilayatCode, callNotifyListeners: false);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Polling Stations'),
//         centerTitle: true,
//         elevation: 10,
//       ),
//       body: Container(
//         //color: Colors.red[100],
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Card(
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 8,
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
//                             child: Wjts.wilayatSelect(context, selectedValue: _wilayatSelectProvider!.getSelectedWilayatCode(), onChangeHandler: _onWilayatChange, showOptionForAllWilayats: true),
//                           )
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Column(
//                             children: [
//                               Consumer<PollingStationMapProvider>(
//                                 builder: (context, data, child) {
//                                   return Text('Regular: ${data.getRegularPolStnCount()}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700]));
//                                 }
//                               ),
//                               Consumer<PollingStationMapProvider>(
//                                   builder: (context, data, child) {
//                                     return Text('Unified: ${_pollingStationMapProvider!.getUnifiedPolStnCount()}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700]));
//                                   }
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Expanded(
//               child: Card(
//                 child: Consumer<PollingStationMapProvider>(
//                   builder: (context, data, child) {
//                     return GoogleMap(
//                       mapType: MapType.normal,
//                       mapToolbarEnabled: true,
//                       zoomControlsEnabled: false,
//                       myLocationButtonEnabled: true,
//                       myLocationEnabled: true,
//                       initialCameraPosition: _initialView,
//                       onMapCreated: (GoogleMapController controller) {
//                         _controller.complete(controller);
//                       },
//                       markers: Set<Marker>.of(data.getMapMarkers().values),
//                     );
//                   }
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 50.0),
//         child: FloatingActionButton(
//           onPressed: () async {
//             final GoogleMapController controller = await _controller.future;
//             controller.animateCamera(CameraUpdate.newCameraPosition(_initialView));
//           },
//           child: Icon(CupertinoIcons.refresh_circled),
//         ),
//       )
//     );
//   }
// }
