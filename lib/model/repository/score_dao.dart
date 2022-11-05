import 'dart:convert';

import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: is it thread-safe?
class ScoreDao {
  static const String scoreDtoKeyForPref = 'scoreDtos';
  ScoreDao._();

  // may need DI structure in future
  static ScoreDao dao = ScoreDao._();

  Future<List<ScoreDto>> loadScoreDtoList() async {
    logger.fine('loadScoreDtoList');
    final prefs = await SharedPreferences.getInstance();
    var dtoJsonStrList = prefs.getStringList(scoreDtoKeyForPref);
    logger.info(dtoJsonStrList);
    dtoJsonStrList ??= [];

    final list = <ScoreDto>[];
    for (var dtoJsonStr in dtoJsonStrList) {
      var dtoJsonMap = jsonDecode(dtoJsonStr);
      var dto = ScoreDto()
        ..ID = dtoJsonMap["ID"]
        ..imageFilePath = dtoJsonMap["imageFilePath"]
        ..repeatDelayMilliSeconds = dtoJsonMap["repeatDelayMilliSeconds"]
        ..videoFilePath = dtoJsonMap["videoFilePath"];
      list.add(dto);
    }

    return list;
  }

  Future<void> saveScoreDtoList(List<ScoreDto> scoreDtoList) async {
    logger.fine('saveScoreDtoList');
    final prefs = await SharedPreferences.getInstance();
    final jsonStrList = <String>[];
    for (var dto in scoreDtoList) {
      jsonStrList.add(jsonEncode(dto));
    }
    prefs.setStringList(scoreDtoKeyForPref, jsonStrList);
    logger.info(jsonStrList);
  }
}
