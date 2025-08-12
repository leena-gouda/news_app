class LogoHelper {
  static const String defaultLogo = "assets/icons/default.png";

  static String getLogoUrl(String? sourceName) {
    if (sourceName == null || sourceName.trim().isEmpty) {
      return "https://logo.clearbit.com/example.com";
    }

    final domain = sourceName.toLowerCase().replaceAll(RegExp(r"[^\w]"), "") + ".com";
    return "https://logo.clearbit.com/$domain";
  }
}
//return "https://www.google.com/s2/favicons?domain=$domain";