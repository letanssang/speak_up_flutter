import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/phonetic/phonetic.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'ipa_state.freezed.dart';

@freezed
class IpaState with _$IpaState {
  const factory IpaState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(LoadingStatus.initial) LoadingStatus progressLoadingStatus,
    @Default([]) List<Phonetic> vowels,
    @Default([]) List<Phonetic> consonants,
    @Default([]) List<bool> isDoneVowelList,
    @Default([]) List<bool> isDoneConsonantList,
  }) = _IpaState;
}
