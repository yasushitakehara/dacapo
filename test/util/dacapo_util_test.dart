import 'package:dacapo/util/dacapo_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toRepeatDelayMilliSecond', () {
    int actual = DaCapoUtil.toRepeatDelayMilliSecond(0.0);
    expect(actual, 0);

    actual = DaCapoUtil.toRepeatDelayMilliSecond(3.0);
    expect(actual, 3000);

    actual = DaCapoUtil.toRepeatDelayMilliSecond(3.3);
    expect(actual, 3300);
  });

  test('toSliderValue', () {
    double actual = DaCapoUtil.toSliderValue(0);
    expect(actual, 0);

    actual = DaCapoUtil.toSliderValue(3000);
    expect(actual, 3.0);

    actual = DaCapoUtil.toSliderValue(3300);
    expect(actual, 3.3);
  });
}
