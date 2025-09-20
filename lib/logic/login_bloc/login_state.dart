abstract class LoginState{}
class InitialLoginState extends LoginState{}
class LoginStateLoading extends LoginState{}
class LoginStateLoaded extends LoginState{}
class LoginStateError extends LoginState{
  final String message;
  LoginStateError(this.message);
}