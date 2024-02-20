class Response {
  final String msg;
  final String tag;
  final dynamic data;
  final int code;
  final String token;

  const Response({
    required this.msg,
    this.data,
    this.tag = '',
    required this.code,
    this.token = '',
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    try {
      return Response(
        msg: json['msg'] as String? ?? '',
        data: json['data'],
        tag: json['tag'] as String? ?? '',
        code: json['code'],
        token: json['token'] as String? ?? ''
      );
    } catch (e) {
      throw FormatException('Error al convertir JSON a Response: $e');
    }
  }

  @override
  String toString() {
    return "msg: $msg\ntag: $tag\ndata:$data\ncode: $code\ntoken:$token";
  }
}
