import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_using_firebase/logic/sign_up_bloc/signup_event.dart';
import 'package:notes_app_using_firebase/logic/sign_up_bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  final FirebaseAuth auth;
  SignupBloc(this.auth) : super(InitialSignUpState()) {
    on<SignUpButtonPressed>((event, emit) async {
      emit(SignUpStateLoading());
      try {
        await auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(SignUpStateLoaded());
      } on FirebaseAuthException catch (e) {
        emit(SignUpStateError(e.message ?? "An Error has occurred"));
      } catch (e) {
        emit(SignUpStateError("Something went wrong"));
      }
    });
  }
}
