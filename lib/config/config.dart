class Config {
  static const String debugUrl = "http://127.0.0.1:8000";
  static const String prodUrl =
      "https://daanish-inayat-batikin.pbp.cs.ui.ac.id";
  static const bool prodMode = false;
  static String get baseUrl {
    if (prodMode) {
      return prodUrl;
    } else {
      return debugUrl;
    }
  }
}
