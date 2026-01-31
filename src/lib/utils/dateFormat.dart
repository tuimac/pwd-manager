class DateConverter {
  static String dateForDisplay(String dateData) {
    dateData = dateData.replaceFirst('-', '/');
    dateData = dateData.replaceFirst('-', '/');
    dateData = dateData.replaceFirst('-', ' ');
    dateData = dateData.replaceFirst('-', ':');
    dateData = dateData.replaceFirst('-', ':');
    return dateData;
  }

  static String dateForFileName(String dateData) {
    dateData = dateData.replaceFirst('/', '-');
    dateData = dateData.replaceFirst('/', '-');
    dateData = dateData.replaceFirst(' ', '-');
    dateData = dateData.replaceFirst(':', '-');
    dateData = dateData.replaceFirst(':', '-');
    return dateData;
  }

  static int getNow() {
    return (DateTime.now().millisecondsSinceEpoch / 1000).floor();
  }
}
