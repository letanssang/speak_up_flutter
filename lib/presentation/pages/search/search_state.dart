import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default(LoadingStatus.initial) loadingStatus,
    @Default([]) List<String> suggestionList,
  }) = _SearchState;
}
