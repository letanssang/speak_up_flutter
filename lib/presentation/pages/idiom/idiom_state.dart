import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/idiom/idiom.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';

part 'idiom_state.freezed.dart';

@freezed
class IdiomState with _$IdiomState {
  const factory IdiomState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<Idiom> idioms,
    @Default(0) int progress,
  }) = _IdiomState;
}
