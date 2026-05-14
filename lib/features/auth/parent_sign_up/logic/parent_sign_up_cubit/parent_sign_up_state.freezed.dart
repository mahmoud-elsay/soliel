// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parent_sign_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ParentSignUpState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ParentSignUpResponseBody data) success,
    required TResult Function(ApiErrorModel error) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ParentSignUpResponseBody data)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ParentSignUpResponseBody data)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ParentSignUpLoading value) loading,
    required TResult Function(ParentSignUpSuccess value) success,
    required TResult Function(ParentSignUpError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ParentSignUpLoading value)? loading,
    TResult? Function(ParentSignUpSuccess value)? success,
    TResult? Function(ParentSignUpError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ParentSignUpLoading value)? loading,
    TResult Function(ParentSignUpSuccess value)? success,
    TResult Function(ParentSignUpError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParentSignUpStateCopyWith<$Res> {
  factory $ParentSignUpStateCopyWith(
    ParentSignUpState value,
    $Res Function(ParentSignUpState) then,
  ) = _$ParentSignUpStateCopyWithImpl<$Res, ParentSignUpState>;
}

/// @nodoc
class _$ParentSignUpStateCopyWithImpl<$Res, $Val extends ParentSignUpState>
    implements $ParentSignUpStateCopyWith<$Res> {
  _$ParentSignUpStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ParentSignUpStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ParentSignUpState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ParentSignUpResponseBody data) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ParentSignUpResponseBody data)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ParentSignUpResponseBody data)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ParentSignUpLoading value) loading,
    required TResult Function(ParentSignUpSuccess value) success,
    required TResult Function(ParentSignUpError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ParentSignUpLoading value)? loading,
    TResult? Function(ParentSignUpSuccess value)? success,
    TResult? Function(ParentSignUpError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ParentSignUpLoading value)? loading,
    TResult Function(ParentSignUpSuccess value)? success,
    TResult Function(ParentSignUpError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ParentSignUpState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$ParentSignUpLoadingImplCopyWith<$Res> {
  factory _$$ParentSignUpLoadingImplCopyWith(
    _$ParentSignUpLoadingImpl value,
    $Res Function(_$ParentSignUpLoadingImpl) then,
  ) = __$$ParentSignUpLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ParentSignUpLoadingImplCopyWithImpl<$Res>
    extends _$ParentSignUpStateCopyWithImpl<$Res, _$ParentSignUpLoadingImpl>
    implements _$$ParentSignUpLoadingImplCopyWith<$Res> {
  __$$ParentSignUpLoadingImplCopyWithImpl(
    _$ParentSignUpLoadingImpl _value,
    $Res Function(_$ParentSignUpLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ParentSignUpLoadingImpl implements ParentSignUpLoading {
  const _$ParentSignUpLoadingImpl();

  @override
  String toString() {
    return 'ParentSignUpState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParentSignUpLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ParentSignUpResponseBody data) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ParentSignUpResponseBody data)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ParentSignUpResponseBody data)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ParentSignUpLoading value) loading,
    required TResult Function(ParentSignUpSuccess value) success,
    required TResult Function(ParentSignUpError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ParentSignUpLoading value)? loading,
    TResult? Function(ParentSignUpSuccess value)? success,
    TResult? Function(ParentSignUpError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ParentSignUpLoading value)? loading,
    TResult Function(ParentSignUpSuccess value)? success,
    TResult Function(ParentSignUpError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ParentSignUpLoading implements ParentSignUpState {
  const factory ParentSignUpLoading() = _$ParentSignUpLoadingImpl;
}

/// @nodoc
abstract class _$$ParentSignUpSuccessImplCopyWith<$Res> {
  factory _$$ParentSignUpSuccessImplCopyWith(
    _$ParentSignUpSuccessImpl value,
    $Res Function(_$ParentSignUpSuccessImpl) then,
  ) = __$$ParentSignUpSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ParentSignUpResponseBody data});
}

/// @nodoc
class __$$ParentSignUpSuccessImplCopyWithImpl<$Res>
    extends _$ParentSignUpStateCopyWithImpl<$Res, _$ParentSignUpSuccessImpl>
    implements _$$ParentSignUpSuccessImplCopyWith<$Res> {
  __$$ParentSignUpSuccessImplCopyWithImpl(
    _$ParentSignUpSuccessImpl _value,
    $Res Function(_$ParentSignUpSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null}) {
    return _then(
      _$ParentSignUpSuccessImpl(
        null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ParentSignUpResponseBody,
      ),
    );
  }
}

/// @nodoc

class _$ParentSignUpSuccessImpl implements ParentSignUpSuccess {
  const _$ParentSignUpSuccessImpl(this.data);

  @override
  final ParentSignUpResponseBody data;

  @override
  String toString() {
    return 'ParentSignUpState.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParentSignUpSuccessImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParentSignUpSuccessImplCopyWith<_$ParentSignUpSuccessImpl> get copyWith =>
      __$$ParentSignUpSuccessImplCopyWithImpl<_$ParentSignUpSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ParentSignUpResponseBody data) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ParentSignUpResponseBody data)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ParentSignUpResponseBody data)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ParentSignUpLoading value) loading,
    required TResult Function(ParentSignUpSuccess value) success,
    required TResult Function(ParentSignUpError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ParentSignUpLoading value)? loading,
    TResult? Function(ParentSignUpSuccess value)? success,
    TResult? Function(ParentSignUpError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ParentSignUpLoading value)? loading,
    TResult Function(ParentSignUpSuccess value)? success,
    TResult Function(ParentSignUpError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class ParentSignUpSuccess implements ParentSignUpState {
  const factory ParentSignUpSuccess(final ParentSignUpResponseBody data) =
      _$ParentSignUpSuccessImpl;

  ParentSignUpResponseBody get data;

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParentSignUpSuccessImplCopyWith<_$ParentSignUpSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParentSignUpErrorImplCopyWith<$Res> {
  factory _$$ParentSignUpErrorImplCopyWith(
    _$ParentSignUpErrorImpl value,
    $Res Function(_$ParentSignUpErrorImpl) then,
  ) = __$$ParentSignUpErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ApiErrorModel error});
}

/// @nodoc
class __$$ParentSignUpErrorImplCopyWithImpl<$Res>
    extends _$ParentSignUpStateCopyWithImpl<$Res, _$ParentSignUpErrorImpl>
    implements _$$ParentSignUpErrorImplCopyWith<$Res> {
  __$$ParentSignUpErrorImplCopyWithImpl(
    _$ParentSignUpErrorImpl _value,
    $Res Function(_$ParentSignUpErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$ParentSignUpErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as ApiErrorModel,
      ),
    );
  }
}

/// @nodoc

class _$ParentSignUpErrorImpl implements ParentSignUpError {
  const _$ParentSignUpErrorImpl({required this.error});

  @override
  final ApiErrorModel error;

  @override
  String toString() {
    return 'ParentSignUpState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParentSignUpErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParentSignUpErrorImplCopyWith<_$ParentSignUpErrorImpl> get copyWith =>
      __$$ParentSignUpErrorImplCopyWithImpl<_$ParentSignUpErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(ParentSignUpResponseBody data) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(ParentSignUpResponseBody data)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(ParentSignUpResponseBody data)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ParentSignUpLoading value) loading,
    required TResult Function(ParentSignUpSuccess value) success,
    required TResult Function(ParentSignUpError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ParentSignUpLoading value)? loading,
    TResult? Function(ParentSignUpSuccess value)? success,
    TResult? Function(ParentSignUpError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ParentSignUpLoading value)? loading,
    TResult Function(ParentSignUpSuccess value)? success,
    TResult Function(ParentSignUpError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ParentSignUpError implements ParentSignUpState {
  const factory ParentSignUpError({required final ApiErrorModel error}) =
      _$ParentSignUpErrorImpl;

  ApiErrorModel get error;

  /// Create a copy of ParentSignUpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParentSignUpErrorImplCopyWith<_$ParentSignUpErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
