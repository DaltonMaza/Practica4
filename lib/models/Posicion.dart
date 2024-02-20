class Posicion {
  final double longitud;
  final double latitud;
  
  Posicion({
    required this.longitud,
    required this.latitud
  });

  factory Posicion.fromJson(Map<String, dynamic> json) {
    return Posicion(
      longitud: json['longitud'],
      latitud: json['latitud'],
    );
  }

  @override
  String toString() {
    return "longitud:$longitud\nlatitud:$latitud";
  }
}