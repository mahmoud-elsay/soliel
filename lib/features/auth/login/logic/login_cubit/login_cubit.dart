import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/core/helpers/app_role.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/features/auth/login/data/models/login_request_body.dart';
import 'package:soliel/features/auth/login/data/models/login_response_body.dart';
import 'package:soliel/features/auth/login/data/repo/login_repo.dart';
import 'package:soliel/features/auth/login/logic/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginState.initial());

  Future<void> emitLoginStates({
    required String email,
    required String password,
  }) async {
    emit(const LoginState.loading());

    final result = await _loginRepo.login(
      LoginRequestBody(
        email: email,
        password: password,
      ),
    );

    await result.when(
      success: (data) async {
        await _persistUserSession(
          email: email,
          loginResponseBody: data,
        );
        emit(LoginState.success(data));
      },
      failure: (errorHandler) async {
        emit(LoginState.error(error: errorHandler.apiErrorModel));
      },
    );
  }

  Future<void> _persistUserSession({
    required String email,
    required LoginResponseBody loginResponseBody,
  }) async {
    await StorageHelper.saveAccessToken(loginResponseBody.token);
    await StorageHelper.saveEmail(email);
    await StorageHelper.saveUserName(loginResponseBody.userName);

    final role = AppRoleFactory.fromStorageKey(loginResponseBody.role);
    if (role != null) {
      await AppRoleFactory.saveRole(role);
    }
  }
}
