import 'package:dacapo/util/date_format_util.dart';

class ScoreDto {
  String? ID;
  String? imageFilePath;
  String? videoFilePath;
  int? repeatDelayMilliSeconds = 1000;

  static createNewScoreDto(String imageFilePath) {
    final dto = ScoreDto();
    dto.ID = DateFormatUtil.createScoreDtoID();
    dto.imageFilePath = imageFilePath;
    return dto;
  }
}
