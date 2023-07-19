// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChangePasswordState {
  bool get isCurrentPasswordVisible => throw _privateConstructorUsedError;
  bool get isNewPasswordVisible => throw _privateConstructorUsedError;
  bool get isConfirmPasswordVisible => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChangePasswordStateCopyWith<ChangePasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangePasswordStateCopyWith<$Res> {
  factory $ChangePasswordStateCopyWith(
          ChangePasswordState value, $Res Function(ChangePasswordState) then) =
      _$ChangePasswordStateCopyWithImpl<$Res, ChangePasswordState>;
  @useResult
  $Res call(
      {bool isCurrentPasswordVisible,
      bool isNewPasswordVisible,
      bool isConfirmPasswordVisible});
}

/// @nodoc
class _$ChangePasswordStateCopyWithImpl<$Res, $Val extends ChangePasswordState>
    implements $ChangePasswordStateCopyWith<$Res> {
  _$ChangePasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCurrentPasswordVisible = null,
    Object? isNewPasswordVisible = null,
    Object? isConfirmPasswordVisible = null,
  }) {
    return _then(_value.copyWith(
      isCurrentPasswordVisible: null == isCurrentPasswordVisible
          ? _value.isCurrentPasswordVisible
          : isCurrentPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isNewPasswordVisible: null == isNewPasswordVisible
          ? _value.isNewPasswordVisible
          : isNewPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmPasswordVisible: null == isConfirmPasswordVisible
          ? _value.isConfirmPasswordVisible
          : isConfirmPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChangePasswordStateCopyWith<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  factory _$$_ChangePasswordStateCopyWith(_$_ChangePasswordState value,
          $Res Function(_$_ChangePasswordState) then) =
      __$$_ChangePasswordStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCurrentPasswordVisible,
      bool isNewPasswordVisible,
      bool isConfirmPasswordVisible});
}

/// @nodoc
class __$$_ChangePasswordStateCopyWithImpl<$Res>
    extends _$ChangePasswordStateCopyWithImpl<$Res, _$_ChangePasswordState>
    implements _$$_ChangePasswordStateCopyWith<$Res> {
  __$$_ChangePasswordStateCopyWithImpl(_$_ChangePasswordState _value,
      $Res Function(_$_ChangePasswordState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCurrentPasswordVisible = null,
    Object? isNewPasswordVisible = null,
    Object? isConfirmPasswordVisible = null,
  }) {
    return _then(_$_ChangePasswordState(
      isCurrentPasswordVisible: null == isCurrentPasswordVisible
          ? _value.isCurrentPasswordVisible
          : isCurrentPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isNewPasswordVisible: null == isNewPasswordVisible
          ? _value.isNewPasswordVisible
          : isNewPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isConfirmPasswordVisible: null == isConfirmPasswordVisible
          ? _value.isConfirmPasswordVisible
          : isConfirmPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ChangePasswordState implements _ChangePasswordState {
  const _$_ChangePasswordState(
      {this.isCurrentPasswordVisible = false,
      this.isNewPasswordVisible = false,
      this.isConfirmPasswordVisible = false});

  @override
  @JsonKey()
  final bool isCurrentPasswordVisible;
  @override
  @JsonKey()
  final bool isNewPasswordVisible;
  @override
  @JsonKey()
  final bool isConfirmPasswordVisible;

  @override
  String toString() {
    return 'ChangePasswordState(isCurrentPasswordVisible: $isCurrentPasswordVisible, isNewPasswordVisible: $isNewPasswordVisible, isConfirmPasswordVisible: $isConfirmPasswordVisible)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChangePasswordState &&
            (identical(
                    other.isCurrentPasswordVisible, isCurrentPasswordVisible) ||
                other.isCurrentPasswordVisible == isCurrentPasswordVisible) &&
            (identical(other.isNewPasswordVisible, isNewPasswordVisible) ||
                other.isNewPasswordVisible == isNewPasswordVisible) &&
            (identical(
                    other.isConfirmPasswordVisible, isConfirmPasswordVisible) ||
                other.isConfirmPasswordVisible == isConfirmPasswordVisible));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isCurrentPasswordVisible,
      isNewPasswordVisible, isConfirmPasswordVisible);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangePasswordStateCopyWith<_$_ChangePasswordState> get copyWith =>
      __$$_ChangePasswordStateCopyWithImpl<_$_ChangePasswordState>(
          this, _$identity);
}

abstract class _ChangePasswordState implements ChangePasswordState {
  const factory _ChangePasswordState(
      {final bool isCurrentPasswordVisible,
      final bool isNewPasswordVisible,
      final bool isConfirmPasswordVisible}) = _$_ChangePasswordState;

  @override
  bool get isCurrentPasswordVisible;
  @override
  bool get isNewPasswordVisible;
  @override
  bool get isConfirmPasswordVisible;
  @override
  @JsonKey(ignore: true)
  _$$_ChangePasswordStateCopyWith<_$_ChangePasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}
