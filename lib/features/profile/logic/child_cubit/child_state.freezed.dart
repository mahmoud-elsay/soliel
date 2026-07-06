// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChildState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AddChildResponse response) success,
    required TResult Function(ApiErrorModel error) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AddChildResponse response)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AddChildResponse response)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ChildLoading value) loading,
    required TResult Function(ChildSuccess value) success,
    required TResult Function(ChildError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ChildLoading value)? loading,
    TResult? Function(ChildSuccess value)? success,
    TResult? Function(ChildError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ChildLoading value)? loading,
    TResult Function(ChildSuccess value)? success,
    TResult Function(ChildError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildStateCopyWith<$Res> {
  factory $ChildStateCopyWith(
    ChildState value,
    $Res Function(ChildState) then,
  ) = _$ChildStateCopyWithImpl<$Res, ChildState>;
}

/// @nodoc
class _$ChildStateCopyWithImpl<$Res, $Val extends ChildState>
    implements $ChildStateCopyWith<$Res> {
  _$ChildStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildState
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
    extends _$ChildStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ChildState.initial()';
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
    required TResult Function(AddChildResponse response) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AddChildResponse response)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AddChildResponse response)? success,
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
    required TResult Function(ChildLoading value) loading,
    required TResult Function(ChildSuccess value) success,
    required TResult Function(ChildError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ChildLoading value)? loading,
    TResult? Function(ChildSuccess value)? success,
    TResult? Function(ChildError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ChildLoading value)? loading,
    TResult Function(ChildSuccess value)? success,
    TResult Function(ChildError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ChildState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$ChildLoadingImplCopyWith<$Res> {
  factory _$$ChildLoadingImplCopyWith(
    _$ChildLoadingImpl value,
    $Res Function(_$ChildLoadingImpl) then,
  ) = __$$ChildLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChildLoadingImplCopyWithImpl<$Res>
    extends _$ChildStateCopyWithImpl<$Res, _$ChildLoadingImpl>
    implements _$$ChildLoadingImplCopyWith<$Res> {
  __$$ChildLoadingImplCopyWithImpl(
    _$ChildLoadingImpl _value,
    $Res Function(_$ChildLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ChildLoadingImpl implements ChildLoading {
  const _$ChildLoadingImpl();

  @override
  String toString() {
    return 'ChildState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChildLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AddChildResponse response) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AddChildResponse response)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AddChildResponse response)? success,
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
    required TResult Function(ChildLoading value) loading,
    required TResult Function(ChildSuccess value) success,
    required TResult Function(ChildError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ChildLoading value)? loading,
    TResult? Function(ChildSuccess value)? success,
    TResult? Function(ChildError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ChildLoading value)? loading,
    TResult Function(ChildSuccess value)? success,
    TResult Function(ChildError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ChildLoading implements ChildState {
  const factory ChildLoading() = _$ChildLoadingImpl;
}

/// @nodoc
abstract class _$$ChildSuccessImplCopyWith<$Res> {
  factory _$$ChildSuccessImplCopyWith(
    _$ChildSuccessImpl value,
    $Res Function(_$ChildSuccessImpl) then,
  ) = __$$ChildSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AddChildResponse response});
}

/// @nodoc
class __$$ChildSuccessImplCopyWithImpl<$Res>
    extends _$ChildStateCopyWithImpl<$Res, _$ChildSuccessImpl>
    implements _$$ChildSuccessImplCopyWith<$Res> {
  __$$ChildSuccessImplCopyWithImpl(
    _$ChildSuccessImpl _value,
    $Res Function(_$ChildSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? response = null}) {
    return _then(
      _$ChildSuccessImpl(
        null == response
            ? _value.response
            : response // ignore: cast_nullable_to_non_nullable
                  as AddChildResponse,
      ),
    );
  }
}

/// @nodoc

class _$ChildSuccessImpl implements ChildSuccess {
  const _$ChildSuccessImpl(this.response);

  @override
  final AddChildResponse response;

  @override
  String toString() {
    return 'ChildState.success(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildSuccessImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildSuccessImplCopyWith<_$ChildSuccessImpl> get copyWith =>
      __$$ChildSuccessImplCopyWithImpl<_$ChildSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AddChildResponse response) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return success(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AddChildResponse response)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return success?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AddChildResponse response)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(ChildLoading value) loading,
    required TResult Function(ChildSuccess value) success,
    required TResult Function(ChildError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ChildLoading value)? loading,
    TResult? Function(ChildSuccess value)? success,
    TResult? Function(ChildError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ChildLoading value)? loading,
    TResult Function(ChildSuccess value)? success,
    TResult Function(ChildError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class ChildSuccess implements ChildState {
  const factory ChildSuccess(final AddChildResponse response) =
      _$ChildSuccessImpl;

  AddChildResponse get response;

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildSuccessImplCopyWith<_$ChildSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChildErrorImplCopyWith<$Res> {
  factory _$$ChildErrorImplCopyWith(
    _$ChildErrorImpl value,
    $Res Function(_$ChildErrorImpl) then,
  ) = __$$ChildErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ApiErrorModel error});
}

/// @nodoc
class __$$ChildErrorImplCopyWithImpl<$Res>
    extends _$ChildStateCopyWithImpl<$Res, _$ChildErrorImpl>
    implements _$$ChildErrorImplCopyWith<$Res> {
  __$$ChildErrorImplCopyWithImpl(
    _$ChildErrorImpl _value,
    $Res Function(_$ChildErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$ChildErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as ApiErrorModel,
      ),
    );
  }
}

/// @nodoc

class _$ChildErrorImpl implements ChildError {
  const _$ChildErrorImpl({required this.error});

  @override
  final ApiErrorModel error;

  @override
  String toString() {
    return 'ChildState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildErrorImplCopyWith<_$ChildErrorImpl> get copyWith =>
      __$$ChildErrorImplCopyWithImpl<_$ChildErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(AddChildResponse response) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(AddChildResponse response)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(AddChildResponse response)? success,
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
    required TResult Function(ChildLoading value) loading,
    required TResult Function(ChildSuccess value) success,
    required TResult Function(ChildError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(ChildLoading value)? loading,
    TResult? Function(ChildSuccess value)? success,
    TResult? Function(ChildError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(ChildLoading value)? loading,
    TResult Function(ChildSuccess value)? success,
    TResult Function(ChildError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ChildError implements ChildState {
  const factory ChildError({required final ApiErrorModel error}) =
      _$ChildErrorImpl;

  ApiErrorModel get error;

  /// Create a copy of ChildState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildErrorImplCopyWith<_$ChildErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
