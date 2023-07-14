import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speak_up/domain/entities/topic/topic.dart';
import 'package:speak_up/presentation/utilities/enums/loading_status.dart';
part 'category_state.freezed.dart';
@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default([]) List<Topic> topics,
  }) = _CategoryState;
}