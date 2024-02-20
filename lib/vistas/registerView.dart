import 'package:flutter/material.dart';
import 'package:primera_app/services/httpServices.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formkey = GlobalKey<FormState>();

  Future<dynamic>? futureRegister;

  final TextEditingController correo = TextEditingController();
  final TextEditingController clave = TextEditingController();
  final TextEditingController nombres = TextEditingController();
  final TextEditingController apellidos = TextEditingController();

  void _registrarse() {
    setState(() {
      if (_formkey.currentState!.validate()) {
        Map<String, String> mapa = {
          "nombres": nombres.text,
          "apellidos": apellidos.text,
          "correo": correo.text,
          "clave": clave.text,
        };

        futureRegister = enviar('cuenta', false, mapa, true);

        futureRegister?.then((response) {
          if (response.code == 200) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Exito'),
                  content: Text('Registro completado exitosamente.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text('OK'),
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
                  title: Text('Error'),
                  content: Text('No se pudo completar el registro. Inténtalo de nuevo más tarde.'),
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
          }
        }).catchError((error) {
          print('Error en la solicitud de registro: $error');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Ocurrió un error al intentar registrarse. Por favor, intenta de nuevo más tarde.'),
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

      } else {
        print('No se completó el registro debido a errores en el formulario');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
          body: ListView(
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
            child: const Text("Registro",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 20)),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: nombres,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Debe ingresar sus nombres";
                  }
                },
                decoration: const InputDecoration(labelText: 'Nombres'),
              )),
          Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: apellidos,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Debe ingresar sus apellidos";
                  }
                },
                decoration: const InputDecoration(labelText: 'Apellidos'),
              )),
          Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correo,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Debe ingresar su correo";
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Correo',
                    suffixIcon: Icon(Icons.alternate_email)),
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
                obscureText: true,
                controller: clave,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Debe ingresar una clave";
                  }
                },
                decoration: const InputDecoration(
                    labelText: 'Clave', suffixIcon: Icon(Icons.key))),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              onPressed: _registrarse,
              child: const Text('Registrar'),
            ),
          ),
          Row(
            children: <Widget>[
              const Text('Ya tienes una cuenta?'),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Iniciar sesion',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          )
        ],
      )),
    );
  }
}
