abstract class SignupEvent{}
class SignUpButtonPressed extends SignupEvent{
  final String email;
  final String password;
  SignUpButtonPressed(this.email, this.password);
}