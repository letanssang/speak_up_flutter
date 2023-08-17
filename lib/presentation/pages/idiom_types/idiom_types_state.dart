import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/idiom_type/idiom_type.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'idiom_types_state.freezed.dart';

@freezed
class IdiomTypesState with _$IdiomTypesState {
  const factory IdiomTypesState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<IdiomType> idiomTypes,
  }) = _IdiomTypesState;
}
