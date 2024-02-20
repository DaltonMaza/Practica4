class Noticia {
  final String titulo;
  final String cuerpo;
  final String tipoNoticia;
  final String archivo;
  final DateTime fecha;
  final bool estado;
  final String persona;
  final String external_id;
  
  Noticia({
    required this.titulo,
    required this.cuerpo,
    required this.tipoNoticia,
    required this.archivo,
    required this.fecha,
    required this.estado,
    required this.persona,
    required this.external_id
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['titulo'],
      cuerpo: json['cuerpo'],
      tipoNoticia: json['tipoNoticia'],
      archivo: json['archivo'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
      persona: json['persona'],
      external_id: json['external_id']
    );
  }

  @override
  String toString() {
    return "titulo: $titulo\ncuerpo:$cuerpo\ntipoNoticia:$tipoNoticia\narcivo:$archivo\nfecha:$fecha\nestado:$estado\npersona:$persona\nexternal_id:$external_id";
  }
}