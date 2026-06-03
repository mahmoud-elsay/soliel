import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/models/doctor_sign_up_request_body.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/repo/doctor_sign_up_repo.dart';
import 'package:soliel/features/auth/doctor_sign_up/logic/doctor_sign_up_cubit/doctor_sign_up_state.dart';

class DoctorSignUpCubit extends Cubit<DoctorSignUpState> {
  final DoctorSignUpRepo _doctorSignUpRepo;

  DoctorSignUpCubit(this._doctorSignUpRepo)
    : super(const DoctorSignUpState.initial());

  Future<void> emitDoctorSignUpStates({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String clinicPhone,
    required String nationalId,
    required int experienceYears,
    required String city,
    required String street,
    required String building,
    required String education,
    required String workingHours,
    required File certificateImage,
  }) async {
    emit(const DoctorSignUpState.loading());

    final result = await _doctorSignUpRepo.registerDoctor(
      DoctorSignUpRequestBody(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        clinicPhone: clinicPhone,
        nationalId: nationalId,
        experienceYears: experienceYears,
        city: city,
        street: street,
        building: building,
        education: education,
        workingHours: workingHours,
        certificateImage: certificateImage,
      ),
    );

    result.when(
      success: (data) => emit(DoctorSignUpState.success(data)),
      failure: (errorHandler) =>
          emit(DoctorSignUpState.error(error: errorHandler.apiErrorModel)),
    );
  }
}
