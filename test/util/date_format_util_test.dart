import 'package:dacapo/util/date_format_util.dart';
import 'package:flutter_test/flutter_test.dart';

// expect yyyyMMddTHHmmss
final _scoreDtoIdFormat = RegExp(r'^\d{8}T\d{6}$');

void main() {
  test('createScoreDtoID', () {
    String actualStr = DateFormatUtil.createScoreDtoID();
    expect(_scoreDtoIdFormat.hasMatch(actualStr), isTrue);

    DateTime actualDateTime = DateTime.parse(actualStr);
    final diffMS = DateTime.now().difference(actualDateTime).inMilliseconds;

    // actualDateTime must be near current date time.
    expect(diffMS, lessThanOrEqualTo(2000));
  });
}
