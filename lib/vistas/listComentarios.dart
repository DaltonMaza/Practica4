import 'package:flutter/material.dart';
import 'package:primera_app/models/Comentario.dart';
import 'package:primera_app/models/Cuenta.dart';
import 'package:primera_app/services/httpServices.dart';
import 'package:primera_app/vistas/detalleComentario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListComentarios extends StatefulWidget {
  const ListComentarios({Key? key}) : super(key: key);

  @override
  _ListComentariosState createState() => _ListComentariosState();
}

class _ListComentariosState extends State<ListComentarios> {
  List<Cuenta> cuentas = [];
  dynamic rol;
  Future<dynamic>? baneado;

  // Obtiene el rol activo
  Future<String?> _obtenerRol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("rol");
  }

  // Obtiene el external de la cuenta logeada
  Future<String?> _obtenerCuenta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("external_id");
  }

  Future<List<Comentario>> obtenercomentarios() async {
    List<Comentario> comentarios = [];
    List<Cuenta> cuentaTemp = [];

    rol = await _obtenerRol();
    String? externalCuenta = await _obtenerCuenta();

    final response = await obtener('comentario', false);

    if (rol.toString() == "ADMINISTRADOR") {
      for (var i = 0; i < response.data.length; i++) {
        Comentario aux = Comentario.fromJson(response.data[i]);
        final cuentaResponse =
            await obtener('cuenta/getById/${aux.usuario}', false);
        if (cuentaResponse.code == 200) {
          // Mostrar los comentarios de las cuentas activas
          Cuenta cuentaAux = Cuenta.fromJson(cuentaResponse.data);
          if (cuentaAux.estado) {
            cuentaTemp.add(cuentaAux);
            comentarios.add(aux);
          }
        }
      }
    } else {
      // Mostar solo los comentarios que le pertenecen
      for (var i = 0; i < response.data.length; i++) {
        Comentario aux = Comentario.fromJson(response.data[i]);
        final cuentaResponse =
            await obtener('cuenta/getById/${aux.usuario}', false);
        Cuenta cuentaAux = Cuenta.fromJson(cuentaResponse.data);
        if (cuentaAux.external_id == externalCuenta) {
          comentarios.add(aux);
          cuentaTemp.add(cuentaAux);
        }
      }
    }

    cuentas = cuentaTemp;

    return comentarios;
  }

  Future<String?> obtenerCuentaActual() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("external_id");
  }

  void banear(String idUsuario) async {
    final cuentaAux = await obtener('cuenta/getById/$idUsuario', false);
    Cuenta cuenta = Cuenta.fromJson(cuentaAux.data);
    String? cuentaActual = await obtenerCuentaActual();

    setState(() {
      if (cuenta.external_id == cuentaActual.toString()) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ERROR'),
              content: const Text('No puedes banear tu cuenta'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // cierra el modal
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        baneado = obtener('cuenta/banearById/$idUsuario', false);

        baneado?.then((response) => {
              if (response.code == 200)
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Exito'),
                        content: const Text('Cuenta baneada Exitosamente'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // cierra el modal
                              Navigator.of(context).pop();
                              // obtiene nuevamente la lista de comentarios para mostrar
                              obtenercomentarios();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  )
                }
              else
                {
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
                  )
                }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Comentario>>(
      future: obtenercomentarios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child:
                  Text('Error al cargar los comentarios, vuelva a intentar.'));
        } else if (snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No existen comentarios disponibles.'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              if (snapshot.data![index].estado) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          // correo del dueño del comentario
                          cuentas[index].correo,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.data![index].cuerpo,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        if (rol == "ADMINISTRADOR")
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirmar'),
                                      content: Text(
                                          'Desea banear al usuario "${cuentas[index].correo}"'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            banear(
                                                snapshot.data![index].usuario);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Text('Banear'),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalleComentario(
                                    comentario: snapshot.data![index],
                                  ),
                                ),
                              );
                            },
                            child: const Text('Editar'),
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Text(
                  "Error al recuperar los comentarios",
                  style: TextStyle(fontSize: 14),
                );
              }
            },
          );
        } else {
          // Si no hay datos, muestra un mensaje de carga
          return const Center(child: Text('No hay comentarios disponibles'));
        }
      },
    );
  }
}
