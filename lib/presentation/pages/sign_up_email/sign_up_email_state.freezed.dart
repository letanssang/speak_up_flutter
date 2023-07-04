// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_email_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SignUpEmailState {
  bool get isPasswordVisible => throw _privateConstructorUsedError;
  bool get isSignUpButtonEnabled => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignUpEmailStateCopyWith<SignUpEmailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpEmailStateCopyWith<$Res> {
  factory $SignUpEmailStateCopyWith(
          SignUpEmailState value, $Res Function(SignUpEmailState) then) =
      _$SignUpEmailStateCopyWithImpl<$Res, SignUpEmailState>;
  @useResult
  $Res call(
      {bool isPasswordVisible,
      bool isSignUpButtonEnabled,
      String userName,
      String email,
      String password});
}

/// @nodoc
class _$SignUpEmailStateCopyWithImpl<$Res, $Val extends SignUpEmailState>
    implements $SignUpEmailStateCopyWith<$Res> {
  _$SignUpEmailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPasswordVisible = null,
    Object? isSignUpButtonEnabled = null,
    Object? userName = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      isPasswordVisible: null == isPasswordVisible
          ? _value.isPasswordVisible
          : isPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isSignUpButtonEnabled: null == isSignUpButtonEnabled
          ? _value.isSignUpButtonEnabled
          : isSignUpButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SignUpEmailStateCopyWith<$Res>
    implements $SignUpEmailStateCopyWith<$Res> {
  factory _$$_SignUpEmailStateCopyWith(
          _$_SignUpEmailState value, $Res Function(_$_SignUpEmailState) then) =
      __$$_SignUpEmailStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isPasswordVisible,
      bool isSignUpButtonEnabled,
      String userName,
      String email,
      String password});
}

/// @nodoc
class __$$_SignUpEmailStateCopyWithImpl<$Res>
    extends _$SignUpEmailStateCopyWithImpl<$Res, _$_SignUpEmailState>
    implements _$$_SignUpEmailStateCopyWith<$Res> {
  __$$_SignUpEmailStateCopyWithImpl(
      _$_SignUpEmailState _value, $Res Function(_$_SignUpEmailState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPasswordVisible = null,
    Object? isSignUpButtonEnabled = null,
    Object? userName = null,
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$_SignUpEmailState(
      isPasswordVisible: null == isPasswordVisible
          ? _value.isPasswordVisible
          : isPasswordVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isSignUpButtonEnabled: null == isSignUpButtonEnabled
          ? _value.isSignUpButtonEnabled
          : isSignUpButtonEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SignUpEmailState implements _SignUpEmailState {
  const _$_SignUpEmailState(
      {this.isPasswordVisible = false,
      this.isSignUpButtonEnabled = false,
      this.userName = '',
      this.email = '',
      this.password = ''});

  @override
  @JsonKey()
  final bool isPasswordVisible;
  @override
  @JsonKey()
  final bool isSignUpButtonEnabled;
  @override
  @JsonKey()
  final String userName;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;

  @override
  String toString() {
    return 'SignUpEmailState(isPasswordVisible: $isPasswordVisible, isSignUpButtonEnabled: $isSignUpButtonEnabled, userName: $userName, email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SignUpEmailState &&
            (identical(other.isPasswordVisible, isPasswordVisible) ||
                other.isPasswordVisible == isPasswordVisible) &&
            (identical(other.isSignUpButtonEnabled, isSignUpButtonEnabled) ||
                other.isSignUpButtonEnabled == isSignUpButtonEnabled) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isPasswordVisible,
      isSignUpButtonEnabled, userName, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SignUpEmailStateCopyWith<_$_SignUpEmailState> get copyWith =>
      __$$_SignUpEmailStateCopyWithImpl<_$_SignUpEmailState>(this, _$identity);
}

abstract class _SignUpEmailState implements SignUpEmailState {
  const factory _SignUpEmailState(
      {final bool isPasswordVisible,
      final bool isSignUpButtonEnabled,
      final String userName,
      final String email,
      final String password}) = _$_SignUpEmailState;

  @override
  bool get isPasswordVisible;
  @override
  bool get isSignUpButtonEnabled;
  @override
  String get userName;
  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$_SignUpEmailStateCopyWith<_$_SignUpEmailState> get copyWith =>
      throw _privateConstructorUsedError;
}
