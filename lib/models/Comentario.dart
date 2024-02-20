class Comentario {
  final String cuerpo;
  final bool estado;
  final DateTime fecha;
  final double longitud;
  final double latitud;
  final String usuario;
  final String noticia;
  final String external_id;
  
  Comentario({
    required this.cuerpo,
    required this.estado,
    required this.fecha,
    required this.longitud,
    required this.latitud,
    required this.usuario,
    required this.noticia,
    required this.external_id
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      cuerpo: json['cuerpo'],
      estado: json['estado'],
      fecha: DateTime.parse(json['fecha']),
      longitud: json['longitud'],
      latitud: json['latitud'],
      usuario: json['usuario'],
      noticia: json['noticia'],
      external_id: json['external_id']
    );
  }

  @override
  String toString() {
    return "cuerpo:$cuerpo\nestado:$estado\nfecha:$fecha\nlongitud:$longitud\nlatitud:$latitud\nusuario:$usuario\nnoticia:$noticia\nexternal_id:$external_id";
  }
}