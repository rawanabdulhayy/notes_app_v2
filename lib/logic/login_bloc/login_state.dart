import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable{
  @override
  List<Object?> get props => [];
}
class InitialLoginState extends LoginState{}
class LoginStateLoading extends LoginState{}
class LoginStateLoaded extends LoginState{}
class LoginStateError extends LoginState{
  final String message;
  LoginStateError(this.message);
  @override
  List<Object?> get props => [message];
}