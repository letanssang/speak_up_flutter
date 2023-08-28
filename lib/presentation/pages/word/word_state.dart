import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/data/models/word_detail_response.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'word_state.freezed.dart';

@freezed
class WordState with _$WordState {
  const factory WordState({
    WordDetailResponse? detailWord,
    @Default(LoadingStatus.initial) loadingStatus,
  }) = _WordState;
}