import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenciti/features/home/domain/entities/activity.dart';
import 'package:zenciti/features/home/domain/usecase/ativity_use_case.dart';
import 'package:zenciti/features/home/presentation/blocs/activity_event.dart';

part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityUseCase activityUseCase;

  // Define initial state
  ActivityBloc(this.activityUseCase) : super(ActivityInitials()) {
    on<ActivityTypeGet>(_onActivityTypeGet);
  }

  Future<void> _onActivityTypeGet(
    ActivityTypeGet event,
    Emitter<ActivityState> emit,
  ) async {
    // Show loading spinner
    emit(ActivityLoading());

    try {
      // Fetch activities from the use case
      final activities = await activityUseCase.execute();

      // Debug print to verify what we got from backend
      log("Fetched Activities: $activities");

      // Emit success state with the fetched activities
      emit(ActivitySuccess(
        activities
            .map((activity) => TypeActivity(
                  idTypeActivity: activity.idTypeActivity,
                  nameTypeActivity: activity.nameTypeActivity,
                  imageActivity: activity.imageActivity,
                ))
            .toList(),
      ));
    } catch (e, stackTrace) {
      // Log the error for debugging
      log("Error fetching activities", error: e, stackTrace: stackTrace);

      // Emit failure state with error message
      emit(ActivityFailure(e.toString()));
    }
  }

  Future <void> _onActivityPopulaireGet  () async {
      try {
              
            } catch (error) {
              
            }
  }
}


Future <void> _onActivityGetByType () async { 
    try{

    }
    catch (error) {
      
    }
}
//   Future<void> _onSignUpSubmitted(
//     SignUpSubmitted event,
//     Emitter<SignUpState> emit,
//   ) async {
//     emit(SignUpLoading()); // Show loading state
//
//     try {
//       // Create a User entity
//       final user = User(
//         email: event.email,
//         firstName: event.firstName,
//         lastName: event.lastName,
//         address: event.address,
//         phone: event.phone,
//         password: event.password,
//       );
//
//       // Call the use case
//       await registerUseCase.execute(user);
//
//       // If successful, emit SignUpSuccess
//       emit(SignUpSuccess());
//     } catch (e) {
//       // If an error occurs, emit SignUpFailure
//       emit(SignUpFailure(e.toString()));
//     }
//   }
// }
//

// class LoginBloc extends Bloc<LoginEvent, LoginState> {
//   final LoginUseCase loginUseCase; LoginBloc(this.loginUseCase) : super(LoginInitials()) {
//     on<LoginSubmitted>(_onLoginSubmitted);
//   }
//
//   Future<void> _onLoginSubmitted(
//     LoginSubmitted event,
//     Emitter<LoginState> emit,
//   ) async {
//     emit(LoginLoading()); // Show loading state
//
//     try {
//       // Create a User entity
//       final user = LoginUser(
//         email: event.email,
//         password: event.password,
//       );
//       // Call the use case
//       print("message:$user");
//       await loginUseCase.execute(user);
//
//       // If successful, emit LoginSuccess
//       emit(LoginSuccess());
//     } catch (e) {
//       // If an error occurs, emit LoginFailure
//       emit(LoginFailure(e.toString()));
//     }
//   }
