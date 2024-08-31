class QrParser {
  static const String seperator = ';';

  static String parseHost(String rawData) {
    var data = rawData.split(seperator);
    if (data.length != 3) {
      throw Exception('Invalid QR Code');
    }
    var v = data[0];
    var t = data[1];
    var id = data[2];

    switch (v) {
      case "v2":
        if (t != "u") throw Exception('Invalid QR Code');
        return id;
      default:
        throw Exception('Invalid QR Code');
    }
  }

  static String encodeUid(String uniqueCode) {
    return 'v2;u;$uniqueCode';
  }
}
