import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:primera_app/models/Comentario.dart';
import 'package:primera_app/models/Cuenta.dart';
import 'package:primera_app/models/Noticia.dart';
import 'package:primera_app/models/Posicion.dart';
import 'package:primera_app/services/httpServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleNoticia extends StatefulWidget {
  final Noticia noticia;

  DetalleNoticia({required this.noticia});

  @override
  _DetalleNoticiaState createState() => _DetalleNoticiaState();
}

class _DetalleNoticiaState extends State<DetalleNoticia> {
  List<Comentario> comentarios = [];
  List<Cuenta> cuentas = [];
  Future<dynamic>? futureComentario;

  //LLama a obtener comentarios cuando se carga la pantalla
  @override
  void initState() {
    super.initState();
    _obtenerComentarios();
  }

  //Obtener la última página de comentarios de la noticia
  Future<void> _obtenerComentarios() async {
    dynamic page = 1;
    dynamic response;
    while (true) {
      response = await obtener(
          'comentario/getById/${widget.noticia.external_id}?limit=10&page=$page',
          false);
      if (response.data.length < 10 && response.data.length != 0) {
        break;
      }
      if (response.data.length == 0 && page > 1) {
        page = page - 1;
        break;
      }
      page = page + 1;
    }

    response = await obtener(
        'comentario/getById/${widget.noticia.external_id}?limit=10&page=$page',
        false);

    List<Comentario> comentariosTemp = [];
    // Listado de cuentas para mostrar el correo de quien comentó
    List<Cuenta> cuentasTemp = [];

    if (response.code == 200) {
      for (var i = 0; i < response.data.length; i++) {
        Comentario aux = Comentario.fromJson(response.data[i]);
        final cuentaResponse =
            await obtener('cuenta/getById/${aux.usuario}', false);
        if (cuentaResponse.code == 200) {
          // Mostrar los comentarios de las cuentas activas
          Cuenta cuentaAux = Cuenta.fromJson(cuentaResponse.data);
          if (cuentaAux.estado) {
            cuentasTemp.add(cuentaAux);
            comentariosTemp.add(aux);
          }
        }
      }
      setState(() {
        //para que se actualize la vista luego de recuperar todos los comentarios
        comentarios = comentariosTemp;
        cuentas = cuentasTemp;
      });
    } else {
      print("Error al recuperar los comentarios de la noticia.");
    }
  }

  // Función para mostrar el cuadro de diálogo para agregar comentarios
  void mostrarCuadroComentarios(
      BuildContext context, String external_idNoticia) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Comentario'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Escribe tu comentario aquí'),
            autofocus: true,
            maxLength: 500,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                setState(() {
                  // Guadar el comentario
                  _guardarComentario(controller.text, external_idNoticia);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Obtiene el usuario activo, así guardo su comentario
  Future<String?> _obtenerUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("external_id");
  }

  // Obtiene la posición del dispositivo
  Future<Posicion> obtenerPosicion() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Posicion aux = Posicion(longitud: posicion.longitude, latitud: posicion.latitude);
    return aux;
  }

  // Guarda el comentario en la bdd relacionando la noticia y el usuario
  void _guardarComentario(String comentario, String external_id_noticia) async {
    String? usuario = await _obtenerUsuario();
    Posicion pos = await obtenerPosicion();

    Map<String, String> comentarioJson = {
      "cuerpo": comentario,
      "latitud": pos.latitud.toString(),
      "longitud": pos.longitud.toString(),
      "usuario": usuario?.toString() ?? "",
      "noticia": external_id_noticia
    };

    setState(() {
      futureComentario = enviar('comentario', true, comentarioJson, false);

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
                      // obtiene nuevamente la lista de comentarios para mostrar el recién agregado
                      _obtenerComentarios();
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
        title: const Text('Detalle de Noticia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.noticia.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              DateFormat('yyyy-MM-DD').format(widget.noticia.fecha),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              widget.noticia.cuerpo,
              style: const TextStyle(fontSize: 18),
            ),
            // TODO imagen de la noticia
            // Image.network(
            //   noticia.archivo
            // ),
            const SizedBox(height: 20),
            //botón de comentar
            ElevatedButton(
              onPressed: () {
                mostrarCuadroComentarios(context, widget.noticia.external_id);
              },
              child: const Text('Comentar'),
            ),
            const SizedBox(height: 20),
            // Listado de comentarios
            const Text(
              'Comentarios:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: comentarios.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        // correo del dueño del comentario
                        cuentas[index].correo,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        // comentario
                        comentarios[index].cuerpo,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
