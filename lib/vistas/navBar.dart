import 'package:flutter/material.dart';
import 'package:primera_app/vistas/listComentarios.dart';
import 'package:primera_app/vistas/listNoticias.dart';
import 'package:primera_app/vistas/mapa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  late String _rol = "";

  static const List<Widget> _widgetOptions = <Widget>[
    ListNoticias(),
    ListComentarios(),
    Mapa()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  void _checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rol = prefs.getString("rol") ?? ""; // Obtener el rol del usuario de SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias Locales'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Lista de Noticias',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Comentarios',
          ),
          if (_rol == "ADMINISTRADOR") // Mostrar el ícono del mapa solo si el usuario es administrador
            const BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}