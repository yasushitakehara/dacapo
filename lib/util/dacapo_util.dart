class DaCapoUtil {
  DaCapoUtil._();

  static int toRepeatDelayMilliSecond(double sliderValue) {
    return (sliderValue * 1000).toInt();
  }

  static double toSliderValue(int repeatDelayMilliSecond) {
    return repeatDelayMilliSecond / 1000;
  }
}
