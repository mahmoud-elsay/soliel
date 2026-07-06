import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/features/profile/data/models/add_child_request.dart';
import 'package:soliel/features/profile/data/repo/child_repo.dart';
import 'child_state.dart';

class ChildCubit extends Cubit<ChildState> {
  final ChildRepo _childRepo;

  ChildCubit(this._childRepo) : super(const ChildState.initial());

  Future<void> addChild(AddChildRequest request) async {
    emit(const ChildState.loading());
    final result = await _childRepo.addChild(request);
    result.when(
      success: (response) => emit(ChildState.success(response)),
      failure: (errorHandler) =>
          emit(ChildState.error(error: errorHandler.apiErrorModel)),
    );
  }
}
