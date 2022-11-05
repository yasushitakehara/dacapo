import 'dart:convert';
import 'dart:io';

import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: is it thread-safe?
class ScoreDao {
  static const String scoreDtoKeyForPref = 'scoreDtos';
  ScoreDao._();

  // may need DI structure in future
  static ScoreDao dao = ScoreDao._();

  Future<List<ScoreDto>> load() async {
    logger.fine('load');
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

  Future<void> save(List<ScoreDto> scoreDtoList) async {
    logger.fine('save');
    final prefs = await SharedPreferences.getInstance();
    final jsonStrList = <String>[];
    for (ScoreDto dto in scoreDtoList) {
      jsonStrList.add(jsonEncode(dto));
    }
    prefs.setStringList(scoreDtoKeyForPref, jsonStrList);
    logger.info('saved ${jsonStrList.toString()}');
  }

  Future<void> update(ScoreDto updatingDto) async {
    logger.info('update ${updatingDto.toString()}');
    final currentDtoList = await load();
    final newDtoList = <ScoreDto>[];
    for (ScoreDto currentDto in currentDtoList) {
      if (currentDto.ID == updatingDto.ID) {
        logger.info('bingo! ${updatingDto.ID}');
        if (currentDto.imageFilePath != updatingDto.imageFilePath) {
          File imageFile = File(currentDto.imageFilePath!);
          if (imageFile.existsSync()) {
            imageFile.deleteSync();
          }
          logger.info('deleted ${currentDto.imageFilePath}');
        }
        if (currentDto.videoFilePath != updatingDto.videoFilePath) {
          File videoFile = File(currentDto.videoFilePath!);
          if (videoFile.existsSync()) {
            videoFile.deleteSync();
          }
          logger.info('deleted ${currentDto.videoFilePath}');
          newDtoList.add(updatingDto);
        } else {
          newDtoList.add(currentDto);
        }
      }
    }
    save(newDtoList);
  }

  Future<void> delete(String deletingID) async {
    logger.info('delete');
    final currentDtoList = await load();
    final newDtoList = <ScoreDto>[];
    for (ScoreDto dto in currentDtoList) {
      if (dto.ID == deletingID) {
        logger.info('bingo! ${dto.ID}');
        if (dto.imageFilePath != null) {
          File imageFile = File(dto.imageFilePath!);
          if (imageFile.existsSync()) {
            imageFile.deleteSync();
          }
          logger.info('deleted ${dto.imageFilePath}');
        }
        if (dto.videoFilePath != null) {
          File videoFile = File(dto.videoFilePath!);
          if (videoFile.existsSync()) {
            videoFile.deleteSync();
          }
          logger.info('deleted ${dto.videoFilePath}');
        }
        continue;
      }
      newDtoList.add(dto);
    }
    save(newDtoList);
  }
}
