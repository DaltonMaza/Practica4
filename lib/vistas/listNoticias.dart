import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:primera_app/models/Noticia.dart';
import 'package:primera_app/services/httpServices.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:primera_app/vistas/detalleNoticia.dart';

class ListNoticias extends StatefulWidget {
  const ListNoticias({Key? key}) : super(key: key);

  @override
  _ListNoticiasState createState() => _ListNoticiasState();
}

class _ListNoticiasState extends State<ListNoticias> {
  Future<List<Noticia>> obtenerNoticias() async {
    final response = await obtener('noticia', true);
    if (response.code == 200) {
      // final List<Noticia> noticias = List<Noticia>.empty();
      final noticias = <Noticia>[];
      for (var i = 0; i < response.data.length; i++) {
        final Noticia aux = Noticia.fromJson(response.data[i]);
        noticias.add(aux);
      }
      return noticias;
    } else {
      throw Exception('Error al obtener noticias: ${response.code}');
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Noticia>>(
      future: obtenerNoticias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Error al cargar las noticias, vuelva a intentar.'));
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              if (snapshot.data![index].estado) {
                //Formatear la fecha de cada noticia
                final fechaF = DateFormat('yyyy-MM-DD')
                    .format(snapshot.data![index].fecha);

                // Constrir la tarjeta para cada noticia
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //imagen de la noticia
                        // Center(
                        //   child: Image.network(
                        //     // 'http://192.168.1.5:3000/multimedia/${noticia['archivo']}',
                        //     'https://mapu-bucket.s3.amazonaws.com/1707228103942_65c23bc7d1d4195d61946f58.png',
                        //     width: 100,
                        //     height: 100,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        Text(
                          snapshot.data![index].titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.data![index].cuerpo,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fecha: ${fechaF}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleNoticia(
                                  noticia: snapshot.data![index],
                                ),
                              ),
                            );
                          },
                          child: Text('Ver Noticia / Comentar'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                print("Noticia inactiva");
              }
            },
          );
        } else {
          // Si no hay datos, muestra un mensaje de carga
          return Center(child: Text('No hay noticias disponibles'));
        }
      },
    );
  }
}
