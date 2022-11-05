class DaCapoUtil {
  DaCapoUtil._();

  static int toRepeatDelayMilliSecond(double sliderValue) {
    return (sliderValue * 1000).toInt();
  }

  static int toSliderValue(int repeatDelayMilliSecond) {
    return (repeatDelayMilliSecond / 1000).toInt();
  }
}
