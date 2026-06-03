import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/core/network/dio_factory.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/repo/doctor_sign_up_repo.dart';
import 'package:soliel/features/auth/doctor_sign_up/logic/doctor_sign_up_cubit/doctor_sign_up_cubit.dart';
import 'package:soliel/features/auth/login/data/repo/login_repo.dart';
import 'package:soliel/features/auth/login/logic/login_cubit/login_cubit.dart';
import 'package:soliel/features/auth/parent_sign_up/data/repo/parent_sign_up_repo.dart';
import 'package:soliel/features/auth/parent_sign_up/logic/parent_sign_up_cubit/parent_sign_up_cubit.dart';
import 'package:soliel/features/test/data/repo/eye_scan_repo.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(DioFactory.getDio);
  }

  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));
  }

  if (!getIt.isRegistered<LoginRepo>()) {
    getIt.registerLazySingleton<LoginRepo>(
      () => LoginRepo(getIt<ApiService>()),
    );
  }

  if (!getIt.isRegistered<ParentSignUpRepo>()) {
    getIt.registerLazySingleton<ParentSignUpRepo>(
      () => ParentSignUpRepo(getIt<ApiService>()),
    );
  }

  if (!getIt.isRegistered<DoctorSignUpRepo>()) {
    getIt.registerLazySingleton<DoctorSignUpRepo>(
      () => DoctorSignUpRepo(getIt<ApiService>()),
    );
  }

  if (!getIt.isRegistered<EyeScanRepo>()) {
    getIt.registerLazySingleton<EyeScanRepo>(
      () => EyeScanRepo(getIt<ApiService>()),
    );
  }

  if (!getIt.isRegistered<LoginCubit>()) {
    getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));
  }

  if (!getIt.isRegistered<ParentSignUpCubit>()) {
    getIt.registerFactory<ParentSignUpCubit>(
      () => ParentSignUpCubit(getIt<ParentSignUpRepo>()),
    );
  }

  if (!getIt.isRegistered<DoctorSignUpCubit>()) {
    getIt.registerFactory<DoctorSignUpCubit>(
      () => DoctorSignUpCubit(getIt<DoctorSignUpRepo>()),
    );
  }

  if (!getIt.isRegistered<EyeScanCubit>()) {
    getIt.registerFactory<EyeScanCubit>(
      () => EyeScanCubit(getIt<EyeScanRepo>()),
    );
  }
}
