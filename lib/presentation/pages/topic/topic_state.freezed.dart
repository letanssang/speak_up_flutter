// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TopicState {
  LoadingStatus get loadingStatus => throw _privateConstructorUsedError;
  List<Sentence> get sentences => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopicStateCopyWith<TopicState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicStateCopyWith<$Res> {
  factory $TopicStateCopyWith(
          TopicState value, $Res Function(TopicState) then) =
      _$TopicStateCopyWithImpl<$Res, TopicState>;
  @useResult
  $Res call({LoadingStatus loadingStatus, List<Sentence> sentences});
}

/// @nodoc
class _$TopicStateCopyWithImpl<$Res, $Val extends TopicState>
    implements $TopicStateCopyWith<$Res> {
  _$TopicStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingStatus = null,
    Object? sentences = null,
  }) {
    return _then(_value.copyWith(
      loadingStatus: null == loadingStatus
          ? _value.loadingStatus
          : loadingStatus // ignore: cast_nullable_to_non_nullable
              as LoadingStatus,
      sentences: null == sentences
          ? _value.sentences
          : sentences // ignore: cast_nullable_to_non_nullable
              as List<Sentence>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TopicStateCopyWith<$Res>
    implements $TopicStateCopyWith<$Res> {
  factory _$$_TopicStateCopyWith(
          _$_TopicState value, $Res Function(_$_TopicState) then) =
      __$$_TopicStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LoadingStatus loadingStatus, List<Sentence> sentences});
}

/// @nodoc
class __$$_TopicStateCopyWithImpl<$Res>
    extends _$TopicStateCopyWithImpl<$Res, _$_TopicState>
    implements _$$_TopicStateCopyWith<$Res> {
  __$$_TopicStateCopyWithImpl(
      _$_TopicState _value, $Res Function(_$_TopicState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingStatus = null,
    Object? sentences = null,
  }) {
    return _then(_$_TopicState(
      loadingStatus: null == loadingStatus
          ? _value.loadingStatus
          : loadingStatus // ignore: cast_nullable_to_non_nullable
              as LoadingStatus,
      sentences: null == sentences
          ? _value._sentences
          : sentences // ignore: cast_nullable_to_non_nullable
              as List<Sentence>,
    ));
  }
}

/// @nodoc

class _$_TopicState implements _TopicState {
  const _$_TopicState(
      {this.loadingStatus = LoadingStatus.initial,
      final List<Sentence> sentences = const []})
      : _sentences = sentences;

  @override
  @JsonKey()
  final LoadingStatus loadingStatus;
  final List<Sentence> _sentences;
  @override
  @JsonKey()
  List<Sentence> get sentences {
    if (_sentences is EqualUnmodifiableListView) return _sentences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sentences);
  }

  @override
  String toString() {
    return 'TopicState(loadingStatus: $loadingStatus, sentences: $sentences)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TopicState &&
            (identical(other.loadingStatus, loadingStatus) ||
                other.loadingStatus == loadingStatus) &&
            const DeepCollectionEquality()
                .equals(other._sentences, _sentences));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadingStatus,
      const DeepCollectionEquality().hash(_sentences));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TopicStateCopyWith<_$_TopicState> get copyWith =>
      __$$_TopicStateCopyWithImpl<_$_TopicState>(this, _$identity);
}

abstract class _TopicState implements TopicState {
  const factory _TopicState(
      {final LoadingStatus loadingStatus,
      final List<Sentence> sentences}) = _$_TopicState;

  @override
  LoadingStatus get loadingStatus;
  @override
  List<Sentence> get sentences;
  @override
  @JsonKey(ignore: true)
  _$$_TopicStateCopyWith<_$_TopicState> get copyWith =>
      throw _privateConstructorUsedError;
}
