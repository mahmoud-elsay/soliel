import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:soliel/features/home/data/repos/doctors_repo.dart';

import 'package:soliel/features/home/logic/doctors_cubit/doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final DoctorsRepo _doctorsRepo;

  DoctorsCubit(this._doctorsRepo) : super(const DoctorsState.initial());

  Future<void> getDoctors() async {
    emit(const DoctorsState.loading());

    final result = await _doctorsRepo.getDoctors();

    result.when(
      success: (doctors) => emit(DoctorsState.success(doctors)),
      failure: (errorHandler) =>
          emit(DoctorsState.error(error: errorHandler.apiErrorModel)),
    );
  }
}
