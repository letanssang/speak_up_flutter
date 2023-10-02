import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/common_word/common_word.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'common_word_type_state.freezed.dart';

@freezed
class CommonWordTypeState with _$CommonWordTypeState {
  const factory CommonWordTypeState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(LoadingStatus.initial) LoadingStatus searchLoadingStatus,
    @Default([]) List<CommonWord> commonWordList,
    @Default([]) List<CommonWord> suggestionList,
  }) = _CommonWordTypeState;
}
