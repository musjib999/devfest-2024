class ApiEndPoints {
  static const String _baseUrl = "http://192.168.43.41:3000/";
  static const String _appUrl = "${_baseUrl}api/v1/";

  static String get post => "${_appUrl}post";
  static String get user => "${_appUrl}user";
}
