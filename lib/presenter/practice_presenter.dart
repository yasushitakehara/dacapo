import 'package:dacapo/model/repository/score_dao.dart';
import 'package:dacapo/model/score_dto.dart';
import 'package:dacapo/util/logger.dart';

class PracticePresenter {
  void update(ScoreDto dto) async {
    logger.fine('update');
    ScoreDao.dao.update(dto);
  }
}
