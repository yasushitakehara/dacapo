import 'package:intl/intl.dart';

class DateFormatUtil {
  DateFormatUtil._();

  static String createScoreDtoID() {
    DateTime now = DateTime.now();
    DateFormat outputFormat = DateFormat('yyyyMMddTHHmmss');
    return outputFormat.format(now);
  }
}
