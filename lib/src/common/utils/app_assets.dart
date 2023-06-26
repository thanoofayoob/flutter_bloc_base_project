class AppAssets {
  AppAssets._();

  static const String _imagePath = "assets/images/";
  static const String _pngImagePath = "assets/pngs/";


  static String getImagePath(String imageName,
      {bool defPath = false, bool isSvg = true}) {
    if (defPath) {
      if (isSvg) {
        return _imagePath + imageName;
      } else {
        return _pngImagePath + imageName;
      }
    } else {
      // String? currentTheme = GetStorage().read(THEME_MODE);
      // bool isDark = currentTheme == null || currentTheme == DARK ? true : false;
      // bool isDark = false;
      // if (isSvg) {
      //   return isDark ? _imagePath + imageName : _lightImagePath + imageName;
      // } else {
      //   return isDark ? _pngImagePath + imageName : _lightPngPath + imageName;
      // }

      return '';
    }
  }
}
