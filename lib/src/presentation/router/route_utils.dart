enum APPAGE { splash, home, login, error }

extension AppPageExtension on APPAGE {
  String get toPath {
    switch (this) {
      case APPAGE.login:
        return "/";
      case APPAGE.splash:
        return "/splash";
      case APPAGE.home:
        return "/home";
      case APPAGE.error:
        return "/error";
    }
  }

  String get toName {
    switch (this) {
      case APPAGE.login:
        return "LOGIN";
      case APPAGE.splash:
        return "SPLASH";
      case APPAGE.home:
        return "HOME";
      case APPAGE.error:
        return "ERROR";
    }
  }
}
