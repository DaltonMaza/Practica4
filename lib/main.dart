import 'package:flutter/material.dart';
import 'package:primera_app/vistas/listComentarios.dart';
import 'package:primera_app/vistas/listNoticias.dart';
import 'package:primera_app/vistas/mapa.dart';
import 'package:primera_app/vistas/navBar.dart';
import 'package:primera_app/vistas/page404.dart';
import 'package:primera_app/vistas/registerView.dart';
import 'package:primera_app/vistas/sesionView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 04',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //! asignar la pag principal
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),

      //* Rutas de la App
      // home: const SesionView(),
      home: const SesionView(),
      // initialRoute: '/navBar',
      initialRoute: '/login',
      routes: {
        '/navBar': (context) => const NavBar(),
        '/login': (context) => const SesionView(),
        '/register': (context) => const RegisterView(),
        '/listNoticias': (context) => const ListNoticias(),
        '/listComentarios': (context) => const ListComentarios(),
        '/mapa': (context) => const Mapa(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const Page404());
      },
    );
  }
}