import 'package:dacapo/util/date_format_util.dart';

class ScoreDto {
  ScoreDto();
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

  ScoreDto.fromJson(Map<String, dynamic> json)
      : ID = json["ID"],
        imageFilePath = json["imageFilePath"],
        videoFilePath = json["videoFilePath"],
        repeatDelayMilliSeconds = json["repeatDelayMilliSeconds"];

  Map<String, dynamic> toJson() {
    return {
      'ID': ID,
      'imageFilePath': imageFilePath,
      'videoFilePath': videoFilePath,
      'repeatDelayMilliSeconds': repeatDelayMilliSeconds
    };
  }
}
