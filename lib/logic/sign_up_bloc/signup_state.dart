abstract class SignUpState{}
class InitialSignUpState extends SignUpState{}
class SignUpStateLoading extends SignUpState{}
class SignUpStateLoaded extends SignUpState{}
class SignUpStateError extends SignUpState{
  final String message;
  SignUpStateError(this.message);
}