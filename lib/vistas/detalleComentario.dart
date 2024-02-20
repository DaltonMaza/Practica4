import 'package:flutter/material.dart';
import 'package:primera_app/models/Comentario.dart';
import 'package:primera_app/services/httpServices.dart';

class DetalleComentario extends StatefulWidget {
  final Comentario comentario;

  DetalleComentario({required this.comentario});

  @override
  _DetalleComentarioState createState() => _DetalleComentarioState();
}

class _DetalleComentarioState extends State<DetalleComentario> {
  late TextEditingController _controller;
  Future<dynamic>? futureComentario;

  @override
  void initState() {
    super.initState();
    // setear el cuerpo del comentario
    _controller = TextEditingController(text: widget.comentario.cuerpo);
  }

  void modificarComentario() async {
    String nuevoCuerpo = _controller.text;

    Map<String, String> data = {
      "cuerpo": nuevoCuerpo,
      "external_id": widget.comentario.external_id
    };

    setState(() {
      futureComentario =
          enviar('comentario/actualizar', true, data, false);

      futureComentario?.then((response) {
        if (response.code == 200) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Exito'),
                content: const Text('Comentario Guardado Exitosamente'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // cierra el modal
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/navBar');
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Error al guardar el comentario.'),
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
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Comentario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Cuerpo del comentario',
                border: OutlineInputBorder(),
              ),
              maxLength: 500,
            ),
            const SizedBox(height: 10),
            //botón de guardar
            ElevatedButton(
              onPressed: () {
                modificarComentario();
              },
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
