// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_email_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SignInEmailState {
  LoadingStatus get loadingStatus => throw _privateConstructorUsedError;
  bool get isPasswordVisible => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignInEmailStateCopyWith<SignInEmailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInEmailStateCopyWith<$Res> {
  factory $SignInEmailStateCopyWith(
          SignInEmailState value, $Res Function(SignInEmailState) then) =
      _$SignInEmailStateCopyWithImpl<$Res, SignInEmailState>;
  @useResult
  $Res call(
      {LoadingStatus loadingStatus,
      bool isPasswordVisible,
      String email,
      String password,
      String errorMessage});
}

/// @nodoc
class _$SignInEmailStateCopyWithImpl<$Res, $Val extends SignInEmailState>
    implements $SignInEmailStateCopyWith<$Res> {
  _$SignInEmailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingStatus = null,
    Object? isPasswordVisible = null,
    Object? email = null,
    Object? password = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      loadingStatus: null == loadingStatus
          ? _value.loadingStatus
          : loadingStatus // ignore: cast_nullable_to_non_nullable
              as LoadingStatus,
      isPasswordVisible: null == isPasswordVisible
          ? _value.isPasswordVisible
          : isPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SignInEmailStateCopyWith<$Res>
    implements $SignInEmailStateCopyWith<$Res> {
  factory _$$_SignInEmailStateCopyWith(
          _$_SignInEmailState value, $Res Function(_$_SignInEmailState) then) =
      __$$_SignInEmailStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LoadingStatus loadingStatus,
      bool isPasswordVisible,
      String email,
      String password,
      String errorMessage});
}

/// @nodoc
class __$$_SignInEmailStateCopyWithImpl<$Res>
    extends _$SignInEmailStateCopyWithImpl<$Res, _$_SignInEmailState>
    implements _$$_SignInEmailStateCopyWith<$Res> {
  __$$_SignInEmailStateCopyWithImpl(
      _$_SignInEmailState _value, $Res Function(_$_SignInEmailState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingStatus = null,
    Object? isPasswordVisible = null,
    Object? email = null,
    Object? password = null,
    Object? errorMessage = null,
  }) {
    return _then(_$_SignInEmailState(
      loadingStatus: null == loadingStatus
          ? _value.loadingStatus
          : loadingStatus // ignore: cast_nullable_to_non_nullable
              as LoadingStatus,
      isPasswordVisible: null == isPasswordVisible
          ? _value.isPasswordVisible
          : isPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SignInEmailState implements _SignInEmailState {
  const _$_SignInEmailState(
      {this.loadingStatus = LoadingStatus.initial,
      this.isPasswordVisible = true,
      this.email = '',
      this.password = '',
      this.errorMessage = ''});

  @override
  @JsonKey()
  final LoadingStatus loadingStatus;
  @override
  @JsonKey()
  final bool isPasswordVisible;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'SignInEmailState(loadingStatus: $loadingStatus, isPasswordVisible: $isPasswordVisible, email: $email, password: $password, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SignInEmailState &&
            (identical(other.loadingStatus, loadingStatus) ||
                other.loadingStatus == loadingStatus) &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadingStatus, isPasswordVisible,
      email, password, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SignInEmailStateCopyWith<_$_SignInEmailState> get copyWith =>
      __$$_SignInEmailStateCopyWithImpl<_$_SignInEmailState>(this, _$identity);
}

abstract class _SignInEmailState implements SignInEmailState {
  const factory _SignInEmailState(
      {final LoadingStatus loadingStatus,
      final bool isPasswordVisible,
      final String email,
      final String password,
      final String errorMessage}) = _$_SignInEmailState;

  @override
  LoadingStatus get loadingStatus;
  @override
  bool get isPasswordVisible;
  @override
  String get email;
  @override
  String get password;
  @override
  String get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$_SignInEmailStateCopyWith<_$_SignInEmailState> get copyWith =>
      throw _privateConstructorUsedError;
}
