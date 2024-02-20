import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:primera_app/models/Comentario.dart';
import 'package:primera_app/services/httpServices.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  List<Comentario> comentarios = [];
  Future<dynamic>? futureComentario;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _obtenerComentarios();
  }

  void _obtenerComentarios() async {
    setState(() {
      futureComentario = obtener('comentario', false);

      futureComentario?.then((response) {
        if (response.code != 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Error al Recuperar los comentarios.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (response.code == 200) {
          for (var i = 0; i < response.data.length; i++) {
            Comentario aux = Comentario.fromJson(response.data[i]);
            comentarios.add(aux);
            markers.add(
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(comentarios[i].latitud, comentarios[i].longitud),
                child: const Icon(Icons.place, color: Colors.red),
              ),
            );
          }
        }
      });
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FlutterMap(
  //     options: const MapOptions(
  //       initialCenter: LatLng(-4.033321, -79.204485),
  //       initialZoom: 11,
  //     ),
  //     children: [
  //       TileLayer(
  //         urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  //         userAgentPackageName: 'com.example.app',
  //       ),
  //       const MarkerLayer(
  //         markers: [
  //           // TODO marcadores en la posición de los comentarios
  //           Marker(
  //             point: LatLng(-4.033321, -79.204485),
  //             width: 10,
  //             height: 10,
  //             child: Icon(Icons.location_history_rounded),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(-4.033321, -79.204485),
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
