# Soliel Auth Feature Agent

## Purpose

This agent implements any auth feature in the `soliel` Flutter project following the exact architecture from `tranquilo`. Given a feature name and its backend contract, it produces all files end-to-end: models → repo → cubit state → cubit → DI registration → route wiring → screen → widgets.

---

## Project Context

**App:** `soliel` — Flutter, feature-first structure.  
**Architecture:** `data → logic → ui` vertical slice per feature.  
**Dependency direction:** `UI → Cubit → Repo → ApiService → Backend`  
**Result direction:** `Backend → ApiService → Repo(ApiResult<T>) → Cubit(State) → UI`

**Key shared infrastructure (never recreate, only import):**

| File | Purpose |
|---|---|
| `core/network/api_service.dart` | Retrofit interface — add one method per endpoint |
| `core/network/api_constants.dart` | All endpoint string constants |
| `core/network/api_result.dart` | `ApiResult<T>` (success/failure union) |
| `core/network/api_error_handler.dart` | Converts `DioException` → `ApiErrorModel` |
| `core/di/dependency_injection.dart` | `get_it` registrations |
| `core/routing/routes.dart` | Route name constants |
| `core/routing/app_router.dart` | `generateRoute` switch cases |
| `core/widgets/app_text_form_field.dart` | Shared styled text field |
| `core/widgets/app_text_button.dart` | Shared styled button |
| `core/helpers/app_validation.dart` | Shared field validators |
| `core/helpers/shared_pref_helper.dart` | SharedPreferences wrapper |
| `core/helpers/extensions.dart` | `BuildContext` navigation extensions |
| `core/helpers/show_dialog.dart` | Loading / success dialog helpers |

**Existing `ApiService` methods (already implemented — do not duplicate):**

```dart
@POST(ApiConstants.login)
Future<LoginResponseBody> login(@Body() LoginRequestBody loginRequestBody);

@POST(ApiConstants.registerParent)
Future<ParentSignUpResponseBody> registerParent(
  @Body() ParentSignUpRequestBody parentSignUpRequestBody,
);
```

**Existing registered auth features in DI:**
- `LoginRepo` + `LoginCubit`
- `ParentSignUpRepo` + `ParentSignUpCubit`

---

## Folder Structure Per Feature

```
lib/features/auth/<feature_name>/
  data/
    models/
      <feature>_request_body.dart         # json_annotation, @JsonSerializable
      <feature>_request_body.g.dart       # generated
      <feature>_response_body.dart        # json_annotation, @JsonSerializable
      <feature>_response_body.g.dart      # generated
    repo/
      <feature>_repo.dart                 # thin transport wrapper
  logic/
    <feature>_cubit/
      <feature>_cubit.dart               # Cubit — state mapping + persistence
      <feature>_state.dart               # Freezed state definition
      <feature>_state.freezed.dart       # generated
  ui/
    screens/
      <feature>_screen.dart              # BlocConsumer/BlocListener, navigation
    widgets/
      <feature>_header.dart              # static header/title area
      <feature>_form.dart               # TextFormFields + local controllers
      <feature>_form_with_button.dart   # wraps form + submit logic
```

---

## Implementation Steps (always in this order)

### Step 1 — `api_constants.dart`

Add the endpoint constant:

```dart
static const String featureName = 'account/feature-endpoint';
```

### Step 2 — `api_service.dart`

Add one Retrofit method:

```dart
@POST(ApiConstants.featureName)
Future<FeatureResponseBody> featureMethod(
  @Body() FeatureRequestBody featureRequestBody,
);
```

Run `build_runner` after editing `api_service.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 3 — Request model

```dart
// data/models/<feature>_request_body.dart
import 'package:json_annotation/json_annotation.dart';
part '<feature>_request_body.g.dart';

@JsonSerializable()
class FeatureRequestBody {
  final String fieldOne;
  final String fieldTwo;

  const FeatureRequestBody({required this.fieldOne, required this.fieldTwo});

  factory FeatureRequestBody.fromJson(Map<String, dynamic> json) =>
      _$FeatureRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$FeatureRequestBodyToJson(this);
}
```

Use `@JsonKey(name: 'snake_case_key')` when backend field names differ.

### Step 4 — Response model

Same pattern as request model. Only include fields the backend actually returns.

### Step 5 — Repository

```dart
// data/repo/<feature>_repo.dart
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_service.dart';
import '../models/<feature>_request_body.dart';
import '../models/<feature>_response_body.dart';

class FeatureRepo {
  final ApiService _apiService;
  FeatureRepo(this._apiService);

  Future<ApiResult<FeatureResponseBody>> call(
    FeatureRequestBody request,
  ) async {
    try {
      final response = await _apiService.featureMethod(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
```

The repo is intentionally thin. No business logic here.

### Step 6 — Freezed state

```dart
// logic/<feature>_cubit/<feature>_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
part '<feature>_state.freezed.dart';

@freezed
class FeatureState<T> with _$FeatureState<T> {
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.success(T data) = _Success<T>;
  const factory FeatureState.error({required ApiErrorModel error}) = _Error;
}
```

Use a consistent naming pattern — do not prefix states with feature names (unlike some tranquilo inconsistencies).

### Step 7 — Cubit

```dart
// logic/<feature>_cubit/<feature>_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '<feature>_state.dart';
import '../../data/repo/<feature>_repo.dart';
import '../../data/models/<feature>_request_body.dart';
import '../../data/models/<feature>_response_body.dart';

class FeatureCubit extends Cubit<FeatureState<FeatureResponseBody>> {
  final FeatureRepo _repo;
  FeatureCubit(this._repo) : super(const FeatureState.initial());

  Future<void> emitFeatureStates(String fieldOne, String fieldTwo) async {
    emit(const FeatureState.loading());
    final result = await _repo(FeatureRequestBody(
      fieldOne: fieldOne,
      fieldTwo: fieldTwo,
    ));
    result.when(
      success: (data) => emit(FeatureState.success(data)),
      failure: (error) => emit(FeatureState.error(error: error)),
    );
  }
}
```

If the feature stores auth data locally after success, do it here inside the `success` branch using `SharedPrefHelper` or `FlutterSecureStorage`. Never store data in the repo or screen.

### Step 8 — Dependency injection

Add to `core/di/dependency_injection.dart`:

```dart
// Repo
getIt.registerLazySingleton<FeatureRepo>(
  () => FeatureRepo(getIt<ApiService>()),
);

// Cubit
getIt.registerFactory<FeatureCubit>(
  () => FeatureCubit(getIt<FeatureRepo>()),
);
```

Always use `registerLazySingleton` for repos and `registerFactory` for cubits.  
Always resolve through `getIt` — never instantiate manually in the router.

### Step 9 — Route constant

Add to `core/routing/routes.dart`:

```dart
static const String featureScreen = '/featureScreen';
```

### Step 10 — Router case

Add to `core/routing/app_router.dart` inside `generateRoute`:

```dart
case Routes.featureScreen:
  return MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => getIt<FeatureCubit>(),
      child: const FeatureScreen(),
    ),
  );
```

### Step 11 — Screen

```dart
// ui/screens/<feature>_screen.dart
class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<FeatureCubit, FeatureState>(
          listener: (context, state) {
            state.whenOrNull(
              loading: () => showLoadingDialog(context),
              success: (data) {
                context.pop();                          // always dismiss dialog explicitly
                context.pushNamed(Routes.nextScreen);
              },
              error: (error) {
                context.pop();                          // always dismiss dialog explicitly
                showErrorSnackBar(context, error.message);
              },
            );
          },
          builder: (context, state) {
            return Column(
              children: [
                const FeatureHeader(),
                FeatureFormWithButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

**Rule:** Always call `context.pop()` to dismiss loading dialogs before navigating or showing errors. Never rely on route replacement to close dialogs.

### Step 12 — Widgets

**Header widget** — static, no logic:

```dart
class FeatureHeader extends StatelessWidget {
  const FeatureHeader({super.key});
  @override
  Widget build(BuildContext context) {
    // Title, subtitle, decorative image
  }
}
```

**Form widget** — owns `TextEditingController`s, `FocusNode`s, `GlobalKey<FormState>`, and local UI state (e.g. password visibility):

```dart
class FeatureForm extends StatefulWidget { ... }
class _FeatureFormState extends State<FeatureForm> {
  final _formKey = GlobalKey<FormState>();
  final _fieldOneController = TextEditingController();
  // Use AppTextFormField from core/widgets/
  // Use validators from AppValidation in core/helpers/app_validation.dart
}
```

**FormWithButton widget** — owns the submit action, calls Cubit:

```dart
class FeatureFormWithButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeatureForm(key: _formKey),
        AppTextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<FeatureCubit>().emitFeatureStates(...);
            }
          },
        ),
      ],
    );
  }
}
```

Local UI concerns (controller state, focus, visibility toggles) stay in widgets. Cubits must remain free of widget concerns.

---

## Code Generation

After creating or modifying any `@JsonSerializable`, `@freezed`, or `@RestApi` file, always run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Files that require generation:

| Annotation | Output file |
|---|---|
| `@JsonSerializable` | `*.g.dart` |
| `@freezed` | `*.freezed.dart` |
| `@RestApi` | `api_service.g.dart` |

---

## Existing Auth Features (reference — do not recreate)

### Login
- Endpoint: `ApiConstants.login`
- Models: `LoginRequestBody`, `LoginResponseBody`
- Repo: `LoginRepo` / Cubit: `LoginCubit`
- On success: stores `userToken` (secure storage), `email` + `userName` (shared prefs)
- Navigates to: home / main layout

### Parent Sign Up
- Endpoint: `ApiConstants.registerParent`
- Models: `ParentSignUpRequestBody`, `ParentSignUpResponseBody`
- Repo: `ParentSignUpRepo` / Cubit: `ParentSignUpCubit`

---

## Remaining Auth Features To Implement

| Feature | Folder | Status |
|---|---|---|
| Doctor Sign Up | `auth/doctor_sign_up` | UI shell exists, `data/` and `logic/` are empty |
| Reset Password | `auth/reset_password` | UI shell exists, `data/` and `logic/` are empty |
| OTP Verification | `auth/otp` | not yet created |
| Forget Password | `auth/forget_password` | not yet created |

For each: follow Steps 1–12 above in order.

---

## Cross-Screen Data Passing

When a value (e.g. email, OTP) must survive navigation across multiple screens, choose one strategy and apply it consistently throughout the flow.

**Option A — Shared Preferences / Secure Storage:**
- Store in Cubit on success, or in screen before `pushNamed`
- Use `FlutterSecureStorage` for OTP; `SharedPreferences` for email
- Read from storage in the receiving screen/widget

**Option B — Route arguments:**
- Pass via `settings.arguments` in `generateRoute`
- Cast in receiving screen: `final args = ModalRoute.of(context)!.settings.arguments as MyType;`

**Known gap from tranquilo to fix in soliel:** `ResetPasswordScreen` reads stored OTP but nothing in the OTP flow actually saves it. In `soliel`, explicitly save the OTP in `VerifyOtpCubit` on success, or pass it as a route argument. Do not leave this implicit.

---

## Invariants — Never Break These

1. Repo always returns `ApiResult<T>` — never throws, never returns nullable.
2. Cubit is the only layer that calls the repo.
3. Screen is the only place that handles navigation, dialogs, and snackbars.
4. Widgets handle only local UI state (controllers, focus nodes, visibility).
5. Every repo registered as `registerLazySingleton`, every cubit as `registerFactory`.
6. Every screen wrapped in `BlocProvider` in the router and resolved via `getIt`.
7. Shared widgets from `core/widgets/` are reused — never duplicated per feature.
8. Validators from `core/helpers/app_validation.dart` are reused — never duplicated.
9. Loading dialogs are always explicitly dismissed before navigation or error display.
10. `build_runner` is always run after any model, state, or service file is created or changed.