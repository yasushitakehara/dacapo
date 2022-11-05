import 'package:dacapo/util/date_format_util.dart';

class ScoreDto {
  late String ID;
  String imageFilePath;
  String? videoFilePath;
  int repeatDelayMilliSeconds = 1000;

  ScoreDto(this.imageFilePath) {
    ID = DateFormatUtil.createScoreDtoID();
  }
}
