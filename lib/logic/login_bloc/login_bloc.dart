import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth auth;
  LoginBloc(this.auth) : super(InitialLoginState()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginStateLoading());
      try {
        await auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(LoginStateLoaded());
      } on FirebaseAuthException catch (e) {
        emit(LoginStateError(e.message ?? "An Error has occurred"));
      } catch (e) {
        emit(LoginStateError("Something went wrong"));
      }
    });
  }
}
