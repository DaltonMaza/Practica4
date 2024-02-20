import 'dart:async';
import 'package:flutter/material.dart';
import 'package:primera_app/services/httpServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SesionView extends StatefulWidget {
  const SesionView({Key? key}) : super(key: key);

  @override
  _SesionViewState createState() => _SesionViewState();
}

class _SesionViewState extends State<SesionView> {
  late Future<dynamic> futureResponse;
  Future<dynamic>? futureLogin;

  //? Formkey para el formulario. privada _
  final _formkey = GlobalKey<FormState>();

  //* variables para validacion
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();

  void guardarToken(String token) {}

  void _iniciarSesion() {
    setState(() {
      // if (_formkey.currentState!.validate()) {
        Map<String, String> mapa = {
          "correo": correoControl.text,
          "clave": claveControl.text,
        };
        // Map<String, String> mapa = {
        //   "correo": "leomaza@ymail.com",
        //   "clave": "12345",
        // };

        futureLogin = enviar('cuenta/login', false, mapa, true);

        futureLogin?.then((response) {
          if (response.code == 200) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('token', response.token);
            });

            Map<String, dynamic> decodedToken = JwtDecoder.decode(response.token);

            String externalId = decodedToken['external_id'];

            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('external_id', externalId);
            });

            String rol = decodedToken['rol'];

            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('rol', rol);
            });

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Exito'),
                  content: const Text('Inicio de sesión exitoso.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/navBar');
                        // Navigator.pushNamed(context, '/listNoticias');
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
                  content: const Text('Los datos ingresados son incorrectos.'),
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
        }).catchError((error) {
          print('Error en la solicitud: $error');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                    'Ocurrió un error al iniciar sesión. Por favor, intenta de nuevo más tarde.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        });
      // } else {
      //   print('No se pudo iniciar sesión, reintente.');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey, //* Asignación del key
      child: Scaffold(
        body: ListView(
          // body: Center(
          padding: const EdgeInsets.all(32),
          // child: FutureBuilder<Response>(
          // // child: FutureBuilder<Album>(
          //   future: futureResponse,
          //   // future: futureAlbum,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Text(snapshot.data!.datos.toString());
          //     } else if (snapshot.hasError) {
          //       return Text('${snapshot.error}');
          //     }

          //     // By default, show a loading spinner.
          //     return const CircularProgressIndicator();
          //   },
          // )

          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Noticias",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("App de noticias",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text("Inicio de sesion",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20)),
            ),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: correoControl,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar su correo";
                    }
                    //! No me valida mi correo gerente@gerente.com
                    // if (isEmail(value.toString())) {
                    //   return "Debe ser un correo valido";
                    // }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Correo',
                      suffixIcon: Icon(Icons.alternate_email)),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true, // Para ocultar la contraseña
                  controller: claveControl,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return "Debe ingresar una clave";
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Clave', suffixIcon: Icon(Icons.key)),
                )),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _iniciarSesion,
                child: const Text('Inicio'),
              ),
            ),
            Row(
              children: <Widget>[
                const Text('No tienes una cuenta?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
