// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assessment_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AssessmentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssessmentStateCopyWith<$Res> {
  factory $AssessmentStateCopyWith(
    AssessmentState value,
    $Res Function(AssessmentState) then,
  ) = _$AssessmentStateCopyWithImpl<$Res, AssessmentState>;
}

/// @nodoc
class _$AssessmentStateCopyWithImpl<$Res, $Val extends AssessmentState>
    implements $AssessmentStateCopyWith<$Res> {
  _$AssessmentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssessmentState
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
    extends _$AssessmentStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AssessmentState.initial()';
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
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
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
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AssessmentState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$AssessmentFieldsLoadingImplCopyWith<$Res> {
  factory _$$AssessmentFieldsLoadingImplCopyWith(
    _$AssessmentFieldsLoadingImpl value,
    $Res Function(_$AssessmentFieldsLoadingImpl) then,
  ) = __$$AssessmentFieldsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AssessmentFieldsLoadingImplCopyWithImpl<$Res>
    extends _$AssessmentStateCopyWithImpl<$Res, _$AssessmentFieldsLoadingImpl>
    implements _$$AssessmentFieldsLoadingImplCopyWith<$Res> {
  __$$AssessmentFieldsLoadingImplCopyWithImpl(
    _$AssessmentFieldsLoadingImpl _value,
    $Res Function(_$AssessmentFieldsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AssessmentFieldsLoadingImpl implements AssessmentFieldsLoading {
  const _$AssessmentFieldsLoadingImpl();

  @override
  String toString() {
    return 'AssessmentState.fieldsLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentFieldsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return fieldsLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return fieldsLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (fieldsLoading != null) {
      return fieldsLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return fieldsLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return fieldsLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (fieldsLoading != null) {
      return fieldsLoading(this);
    }
    return orElse();
  }
}

abstract class AssessmentFieldsLoading implements AssessmentState {
  const factory AssessmentFieldsLoading() = _$AssessmentFieldsLoadingImpl;
}

/// @nodoc
abstract class _$$AssessmentFieldsSuccessImplCopyWith<$Res> {
  factory _$$AssessmentFieldsSuccessImplCopyWith(
    _$AssessmentFieldsSuccessImpl value,
    $Res Function(_$AssessmentFieldsSuccessImpl) then,
  ) = __$$AssessmentFieldsSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<AssessmentFieldModel> fields});
}

/// @nodoc
class __$$AssessmentFieldsSuccessImplCopyWithImpl<$Res>
    extends _$AssessmentStateCopyWithImpl<$Res, _$AssessmentFieldsSuccessImpl>
    implements _$$AssessmentFieldsSuccessImplCopyWith<$Res> {
  __$$AssessmentFieldsSuccessImplCopyWithImpl(
    _$AssessmentFieldsSuccessImpl _value,
    $Res Function(_$AssessmentFieldsSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? fields = null}) {
    return _then(
      _$AssessmentFieldsSuccessImpl(
        null == fields
            ? _value._fields
            : fields // ignore: cast_nullable_to_non_nullable
                  as List<AssessmentFieldModel>,
      ),
    );
  }
}

/// @nodoc

class _$AssessmentFieldsSuccessImpl implements AssessmentFieldsSuccess {
  const _$AssessmentFieldsSuccessImpl(final List<AssessmentFieldModel> fields)
    : _fields = fields;

  final List<AssessmentFieldModel> _fields;
  @override
  List<AssessmentFieldModel> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
  }

  @override
  String toString() {
    return 'AssessmentState.fieldsSuccess(fields: $fields)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentFieldsSuccessImpl &&
            const DeepCollectionEquality().equals(other._fields, _fields));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_fields));

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentFieldsSuccessImplCopyWith<_$AssessmentFieldsSuccessImpl>
  get copyWith =>
      __$$AssessmentFieldsSuccessImplCopyWithImpl<
        _$AssessmentFieldsSuccessImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return fieldsSuccess(fields);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return fieldsSuccess?.call(fields);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (fieldsSuccess != null) {
      return fieldsSuccess(fields);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return fieldsSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return fieldsSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (fieldsSuccess != null) {
      return fieldsSuccess(this);
    }
    return orElse();
  }
}

abstract class AssessmentFieldsSuccess implements AssessmentState {
  const factory AssessmentFieldsSuccess(
    final List<AssessmentFieldModel> fields,
  ) = _$AssessmentFieldsSuccessImpl;

  List<AssessmentFieldModel> get fields;

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentFieldsSuccessImplCopyWith<_$AssessmentFieldsSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AssessmentQuestionsLoadingImplCopyWith<$Res> {
  factory _$$AssessmentQuestionsLoadingImplCopyWith(
    _$AssessmentQuestionsLoadingImpl value,
    $Res Function(_$AssessmentQuestionsLoadingImpl) then,
  ) = __$$AssessmentQuestionsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AssessmentQuestionsLoadingImplCopyWithImpl<$Res>
    extends
        _$AssessmentStateCopyWithImpl<$Res, _$AssessmentQuestionsLoadingImpl>
    implements _$$AssessmentQuestionsLoadingImplCopyWith<$Res> {
  __$$AssessmentQuestionsLoadingImplCopyWithImpl(
    _$AssessmentQuestionsLoadingImpl _value,
    $Res Function(_$AssessmentQuestionsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AssessmentQuestionsLoadingImpl implements AssessmentQuestionsLoading {
  const _$AssessmentQuestionsLoadingImpl();

  @override
  String toString() {
    return 'AssessmentState.questionsLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentQuestionsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return questionsLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return questionsLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (questionsLoading != null) {
      return questionsLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return questionsLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return questionsLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (questionsLoading != null) {
      return questionsLoading(this);
    }
    return orElse();
  }
}

abstract class AssessmentQuestionsLoading implements AssessmentState {
  const factory AssessmentQuestionsLoading() = _$AssessmentQuestionsLoadingImpl;
}

/// @nodoc
abstract class _$$AssessmentQuestionsSuccessImplCopyWith<$Res> {
  factory _$$AssessmentQuestionsSuccessImplCopyWith(
    _$AssessmentQuestionsSuccessImpl value,
    $Res Function(_$AssessmentQuestionsSuccessImpl) then,
  ) = __$$AssessmentQuestionsSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<AssessmentQuestionModel> questions});
}

/// @nodoc
class __$$AssessmentQuestionsSuccessImplCopyWithImpl<$Res>
    extends
        _$AssessmentStateCopyWithImpl<$Res, _$AssessmentQuestionsSuccessImpl>
    implements _$$AssessmentQuestionsSuccessImplCopyWith<$Res> {
  __$$AssessmentQuestionsSuccessImplCopyWithImpl(
    _$AssessmentQuestionsSuccessImpl _value,
    $Res Function(_$AssessmentQuestionsSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? questions = null}) {
    return _then(
      _$AssessmentQuestionsSuccessImpl(
        null == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<AssessmentQuestionModel>,
      ),
    );
  }
}

/// @nodoc

class _$AssessmentQuestionsSuccessImpl implements AssessmentQuestionsSuccess {
  const _$AssessmentQuestionsSuccessImpl(
    final List<AssessmentQuestionModel> questions,
  ) : _questions = questions;

  final List<AssessmentQuestionModel> _questions;
  @override
  List<AssessmentQuestionModel> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'AssessmentState.questionsSuccess(questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentQuestionsSuccessImpl &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_questions));

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentQuestionsSuccessImplCopyWith<_$AssessmentQuestionsSuccessImpl>
  get copyWith =>
      __$$AssessmentQuestionsSuccessImplCopyWithImpl<
        _$AssessmentQuestionsSuccessImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return questionsSuccess(questions);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return questionsSuccess?.call(questions);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (questionsSuccess != null) {
      return questionsSuccess(questions);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return questionsSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return questionsSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (questionsSuccess != null) {
      return questionsSuccess(this);
    }
    return orElse();
  }
}

abstract class AssessmentQuestionsSuccess implements AssessmentState {
  const factory AssessmentQuestionsSuccess(
    final List<AssessmentQuestionModel> questions,
  ) = _$AssessmentQuestionsSuccessImpl;

  List<AssessmentQuestionModel> get questions;

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentQuestionsSuccessImplCopyWith<_$AssessmentQuestionsSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AssessmentSubmitLoadingImplCopyWith<$Res> {
  factory _$$AssessmentSubmitLoadingImplCopyWith(
    _$AssessmentSubmitLoadingImpl value,
    $Res Function(_$AssessmentSubmitLoadingImpl) then,
  ) = __$$AssessmentSubmitLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AssessmentSubmitLoadingImplCopyWithImpl<$Res>
    extends _$AssessmentStateCopyWithImpl<$Res, _$AssessmentSubmitLoadingImpl>
    implements _$$AssessmentSubmitLoadingImplCopyWith<$Res> {
  __$$AssessmentSubmitLoadingImplCopyWithImpl(
    _$AssessmentSubmitLoadingImpl _value,
    $Res Function(_$AssessmentSubmitLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AssessmentSubmitLoadingImpl implements AssessmentSubmitLoading {
  const _$AssessmentSubmitLoadingImpl();

  @override
  String toString() {
    return 'AssessmentState.submitLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentSubmitLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return submitLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return submitLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (submitLoading != null) {
      return submitLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return submitLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return submitLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (submitLoading != null) {
      return submitLoading(this);
    }
    return orElse();
  }
}

abstract class AssessmentSubmitLoading implements AssessmentState {
  const factory AssessmentSubmitLoading() = _$AssessmentSubmitLoadingImpl;
}

/// @nodoc
abstract class _$$AssessmentSubmitSuccessImplCopyWith<$Res> {
  factory _$$AssessmentSubmitSuccessImplCopyWith(
    _$AssessmentSubmitSuccessImpl value,
    $Res Function(_$AssessmentSubmitSuccessImpl) then,
  ) = __$$AssessmentSubmitSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SubmitQuestionnaireResponse response});
}

/// @nodoc
class __$$AssessmentSubmitSuccessImplCopyWithImpl<$Res>
    extends _$AssessmentStateCopyWithImpl<$Res, _$AssessmentSubmitSuccessImpl>
    implements _$$AssessmentSubmitSuccessImplCopyWith<$Res> {
  __$$AssessmentSubmitSuccessImplCopyWithImpl(
    _$AssessmentSubmitSuccessImpl _value,
    $Res Function(_$AssessmentSubmitSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? response = null}) {
    return _then(
      _$AssessmentSubmitSuccessImpl(
        null == response
            ? _value.response
            : response // ignore: cast_nullable_to_non_nullable
                  as SubmitQuestionnaireResponse,
      ),
    );
  }
}

/// @nodoc

class _$AssessmentSubmitSuccessImpl implements AssessmentSubmitSuccess {
  const _$AssessmentSubmitSuccessImpl(this.response);

  @override
  final SubmitQuestionnaireResponse response;

  @override
  String toString() {
    return 'AssessmentState.submitSuccess(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentSubmitSuccessImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentSubmitSuccessImplCopyWith<_$AssessmentSubmitSuccessImpl>
  get copyWith =>
      __$$AssessmentSubmitSuccessImplCopyWithImpl<
        _$AssessmentSubmitSuccessImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return submitSuccess(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return submitSuccess?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult Function(ApiErrorModel error)? error,
    required TResult orElse(),
  }) {
    if (submitSuccess != null) {
      return submitSuccess(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return submitSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return submitSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (submitSuccess != null) {
      return submitSuccess(this);
    }
    return orElse();
  }
}

abstract class AssessmentSubmitSuccess implements AssessmentState {
  const factory AssessmentSubmitSuccess(
    final SubmitQuestionnaireResponse response,
  ) = _$AssessmentSubmitSuccessImpl;

  SubmitQuestionnaireResponse get response;

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentSubmitSuccessImplCopyWith<_$AssessmentSubmitSuccessImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AssessmentErrorImplCopyWith<$Res> {
  factory _$$AssessmentErrorImplCopyWith(
    _$AssessmentErrorImpl value,
    $Res Function(_$AssessmentErrorImpl) then,
  ) = __$$AssessmentErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ApiErrorModel error});
}

/// @nodoc
class __$$AssessmentErrorImplCopyWithImpl<$Res>
    extends _$AssessmentStateCopyWithImpl<$Res, _$AssessmentErrorImpl>
    implements _$$AssessmentErrorImplCopyWith<$Res> {
  __$$AssessmentErrorImplCopyWithImpl(
    _$AssessmentErrorImpl _value,
    $Res Function(_$AssessmentErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$AssessmentErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as ApiErrorModel,
      ),
    );
  }
}

/// @nodoc

class _$AssessmentErrorImpl implements AssessmentError {
  const _$AssessmentErrorImpl({required this.error});

  @override
  final ApiErrorModel error;

  @override
  String toString() {
    return 'AssessmentState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssessmentErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssessmentErrorImplCopyWith<_$AssessmentErrorImpl> get copyWith =>
      __$$AssessmentErrorImplCopyWithImpl<_$AssessmentErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() fieldsLoading,
    required TResult Function(List<AssessmentFieldModel> fields) fieldsSuccess,
    required TResult Function() questionsLoading,
    required TResult Function(List<AssessmentQuestionModel> questions)
    questionsSuccess,
    required TResult Function() submitLoading,
    required TResult Function(SubmitQuestionnaireResponse response)
    submitSuccess,
    required TResult Function(ApiErrorModel error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? fieldsLoading,
    TResult? Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult? Function()? questionsLoading,
    TResult? Function(List<AssessmentQuestionModel> questions)?
    questionsSuccess,
    TResult? Function()? submitLoading,
    TResult? Function(SubmitQuestionnaireResponse response)? submitSuccess,
    TResult? Function(ApiErrorModel error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? fieldsLoading,
    TResult Function(List<AssessmentFieldModel> fields)? fieldsSuccess,
    TResult Function()? questionsLoading,
    TResult Function(List<AssessmentQuestionModel> questions)? questionsSuccess,
    TResult Function()? submitLoading,
    TResult Function(SubmitQuestionnaireResponse response)? submitSuccess,
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
    required TResult Function(AssessmentFieldsLoading value) fieldsLoading,
    required TResult Function(AssessmentFieldsSuccess value) fieldsSuccess,
    required TResult Function(AssessmentQuestionsLoading value)
    questionsLoading,
    required TResult Function(AssessmentQuestionsSuccess value)
    questionsSuccess,
    required TResult Function(AssessmentSubmitLoading value) submitLoading,
    required TResult Function(AssessmentSubmitSuccess value) submitSuccess,
    required TResult Function(AssessmentError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult? Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult? Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult? Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult? Function(AssessmentSubmitLoading value)? submitLoading,
    TResult? Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult? Function(AssessmentError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(AssessmentFieldsLoading value)? fieldsLoading,
    TResult Function(AssessmentFieldsSuccess value)? fieldsSuccess,
    TResult Function(AssessmentQuestionsLoading value)? questionsLoading,
    TResult Function(AssessmentQuestionsSuccess value)? questionsSuccess,
    TResult Function(AssessmentSubmitLoading value)? submitLoading,
    TResult Function(AssessmentSubmitSuccess value)? submitSuccess,
    TResult Function(AssessmentError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AssessmentError implements AssessmentState {
  const factory AssessmentError({required final ApiErrorModel error}) =
      _$AssessmentErrorImpl;

  ApiErrorModel get error;

  /// Create a copy of AssessmentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssessmentErrorImplCopyWith<_$AssessmentErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
