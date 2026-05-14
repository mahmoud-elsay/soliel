import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_request_body.dart';
import 'package:soliel/features/auth/parent_sign_up/data/repo/parent_sign_up_repo.dart';
import 'package:soliel/features/auth/parent_sign_up/logic/parent_sign_up_cubit/parent_sign_up_state.dart';

class ParentSignUpCubit extends Cubit<ParentSignUpState> {
  final ParentSignUpRepo _parentSignUpRepo;

  ParentSignUpCubit(this._parentSignUpRepo)
    : super(const ParentSignUpState.initial());

  Future<void> emitParentSignUpStates({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String relation,
  }) async {
    emit(const ParentSignUpState.loading());

    final result = await _parentSignUpRepo.registerParent(
      ParentSignUpRequestBody(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        relation: relation,
      ),
    );

    result.when(
      success: (data) => emit(ParentSignUpState.success(data)),
      failure: (errorHandler) => emit(
        ParentSignUpState.error(error: errorHandler.apiErrorModel),
      ),
    );
  }
}
