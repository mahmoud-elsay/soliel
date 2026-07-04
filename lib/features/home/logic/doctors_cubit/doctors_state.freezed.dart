// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctors_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DoctorsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<DoctorModel> doctors) success,
    required TResult Function(ApiErrorModel error) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DoctorModel> doctors)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DoctorModel> doctors)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(DoctorsLoading value) loading,
    required TResult Function(DoctorsSuccess value) success,
    required TResult Function(DoctorsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(DoctorsLoading value)? loading,
    TResult? Function(DoctorsSuccess value)? success,
    TResult? Function(DoctorsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(DoctorsLoading value)? loading,
    TResult Function(DoctorsSuccess value)? success,
    TResult Function(DoctorsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoctorsStateCopyWith<$Res> {
  factory $DoctorsStateCopyWith(
    DoctorsState value,
    $Res Function(DoctorsState) then,
  ) = _$DoctorsStateCopyWithImpl<$Res, DoctorsState>;
}

/// @nodoc
class _$DoctorsStateCopyWithImpl<$Res, $Val extends DoctorsState>
    implements $DoctorsStateCopyWith<$Res> {
  _$DoctorsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DoctorsState
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
    extends _$DoctorsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'DoctorsState.initial()';
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
    required TResult Function(List<DoctorModel> doctors) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DoctorModel> doctors)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DoctorModel> doctors)? success,
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
    required TResult Function(DoctorsLoading value) loading,
    required TResult Function(DoctorsSuccess value) success,
    required TResult Function(DoctorsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(DoctorsLoading value)? loading,
    TResult? Function(DoctorsSuccess value)? success,
    TResult? Function(DoctorsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(DoctorsLoading value)? loading,
    TResult Function(DoctorsSuccess value)? success,
    TResult Function(DoctorsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements DoctorsState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$DoctorsLoadingImplCopyWith<$Res> {
  factory _$$DoctorsLoadingImplCopyWith(
    _$DoctorsLoadingImpl value,
    $Res Function(_$DoctorsLoadingImpl) then,
  ) = __$$DoctorsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DoctorsLoadingImplCopyWithImpl<$Res>
    extends _$DoctorsStateCopyWithImpl<$Res, _$DoctorsLoadingImpl>
    implements _$$DoctorsLoadingImplCopyWith<$Res> {
  __$$DoctorsLoadingImplCopyWithImpl(
    _$DoctorsLoadingImpl _value,
    $Res Function(_$DoctorsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DoctorsLoadingImpl implements DoctorsLoading {
  const _$DoctorsLoadingImpl();

  @override
  String toString() {
    return 'DoctorsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DoctorsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<DoctorModel> doctors) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DoctorModel> doctors)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DoctorModel> doctors)? success,
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
    required TResult Function(DoctorsLoading value) loading,
    required TResult Function(DoctorsSuccess value) success,
    required TResult Function(DoctorsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(DoctorsLoading value)? loading,
    TResult? Function(DoctorsSuccess value)? success,
    TResult? Function(DoctorsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(DoctorsLoading value)? loading,
    TResult Function(DoctorsSuccess value)? success,
    TResult Function(DoctorsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DoctorsLoading implements DoctorsState {
  const factory DoctorsLoading() = _$DoctorsLoadingImpl;
}

/// @nodoc
abstract class _$$DoctorsSuccessImplCopyWith<$Res> {
  factory _$$DoctorsSuccessImplCopyWith(
    _$DoctorsSuccessImpl value,
    $Res Function(_$DoctorsSuccessImpl) then,
  ) = __$$DoctorsSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<DoctorModel> doctors});
}

/// @nodoc
class __$$DoctorsSuccessImplCopyWithImpl<$Res>
    extends _$DoctorsStateCopyWithImpl<$Res, _$DoctorsSuccessImpl>
    implements _$$DoctorsSuccessImplCopyWith<$Res> {
  __$$DoctorsSuccessImplCopyWithImpl(
    _$DoctorsSuccessImpl _value,
    $Res Function(_$DoctorsSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? doctors = null}) {
    return _then(
      _$DoctorsSuccessImpl(
        null == doctors
            ? _value._doctors
            : doctors // ignore: cast_nullable_to_non_nullable
                  as List<DoctorModel>,
      ),
    );
  }
}

/// @nodoc

class _$DoctorsSuccessImpl implements DoctorsSuccess {
  const _$DoctorsSuccessImpl(final List<DoctorModel> doctors)
    : _doctors = doctors;

  final List<DoctorModel> _doctors;
  @override
  List<DoctorModel> get doctors {
    if (_doctors is EqualUnmodifiableListView) return _doctors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_doctors);
  }

  @override
  String toString() {
    return 'DoctorsState.success(doctors: $doctors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoctorsSuccessImpl &&
            const DeepCollectionEquality().equals(other._doctors, _doctors));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_doctors));

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoctorsSuccessImplCopyWith<_$DoctorsSuccessImpl> get copyWith =>
      __$$DoctorsSuccessImplCopyWithImpl<_$DoctorsSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<DoctorModel> doctors) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return success(doctors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DoctorModel> doctors)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return success?.call(doctors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DoctorModel> doctors)? success,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(doctors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(DoctorsLoading value) loading,
    required TResult Function(DoctorsSuccess value) success,
    required TResult Function(DoctorsError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(DoctorsLoading value)? loading,
    TResult? Function(DoctorsSuccess value)? success,
    TResult? Function(DoctorsError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(DoctorsLoading value)? loading,
    TResult Function(DoctorsSuccess value)? success,
    TResult Function(DoctorsError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class DoctorsSuccess implements DoctorsState {
  const factory DoctorsSuccess(final List<DoctorModel> doctors) =
      _$DoctorsSuccessImpl;

  List<DoctorModel> get doctors;

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoctorsSuccessImplCopyWith<_$DoctorsSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoctorsErrorImplCopyWith<$Res> {
  factory _$$DoctorsErrorImplCopyWith(
    _$DoctorsErrorImpl value,
    $Res Function(_$DoctorsErrorImpl) then,
  ) = __$$DoctorsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ApiErrorModel error});
}

/// @nodoc
class __$$DoctorsErrorImplCopyWithImpl<$Res>
    extends _$DoctorsStateCopyWithImpl<$Res, _$DoctorsErrorImpl>
    implements _$$DoctorsErrorImplCopyWith<$Res> {
  __$$DoctorsErrorImplCopyWithImpl(
    _$DoctorsErrorImpl _value,
    $Res Function(_$DoctorsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$DoctorsErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as ApiErrorModel,
      ),
    );
  }
}

/// @nodoc

class _$DoctorsErrorImpl implements DoctorsError {
  const _$DoctorsErrorImpl({required this.error});

  @override
  final ApiErrorModel error;

  @override
  String toString() {
    return 'DoctorsState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoctorsErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoctorsErrorImplCopyWith<_$DoctorsErrorImpl> get copyWith =>
      __$$DoctorsErrorImplCopyWithImpl<_$DoctorsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<DoctorModel> doctors) success,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<DoctorModel> doctors)? success,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<DoctorModel> doctors)? success,
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
    required TResult Function(DoctorsLoading value) loading,
    required TResult Function(DoctorsSuccess value) success,
    required TResult Function(DoctorsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(DoctorsLoading value)? loading,
    TResult? Function(DoctorsSuccess value)? success,
    TResult? Function(DoctorsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(DoctorsLoading value)? loading,
    TResult Function(DoctorsSuccess value)? success,
    TResult Function(DoctorsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DoctorsError implements DoctorsState {
  const factory DoctorsError({required final ApiErrorModel error}) =
      _$DoctorsErrorImpl;

  ApiErrorModel get error;

  /// Create a copy of DoctorsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoctorsErrorImplCopyWith<_$DoctorsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
