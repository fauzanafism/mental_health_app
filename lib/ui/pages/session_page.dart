import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class Session extends StatelessWidget {
  const Session({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FlutterMap(
        options: MapOptions(center: LatLng(-6.59, 106.804), zoom: 11.2),
        children: [
          TileLayer(
            urlTemplate: 'http://{s}.google.com/vt?lyrs=m&x={x}&y={y}&z={z}',
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
            tileProvider: NetworkTileProvider(),
            maxZoom: 19,
          )
        ],
      ),
    );
  }
}
