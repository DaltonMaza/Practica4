class Cuenta {
  final String correo;
  final String clave;
  final bool estado;
  final String persona;
  final String rol;
  final String external_id;

  Cuenta({
    required this.correo,
    required this.clave,
    required this.estado,
    required this.persona,
    required this.rol,
    this.external_id = ''
  });

  factory Cuenta.fromJson(Map<String, dynamic> json) {
    return Cuenta(
      correo: json['correo'],
      clave: json['clave'],
      estado: json['estado'],
      persona: json['persona'],
      rol: json['rol'],
      external_id: json['external_id']
    );
  }

  @override
  String toString() {
    return "correo:$correo\nclave:$clave\nestado:$estado\npersona:$persona\nrol:$rol\nexternal_id:$external_id";
  }
}