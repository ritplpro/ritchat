part of 'login_cubit.dart';

 class LoginState {}
 class LoginInitialState extends LoginState {}
class LoginLoadingState extends LoginState {}
class LoginSucessState extends LoginState {}
class LoginFailedState extends LoginState {
   String errormsg;
   LoginFailedState({required this.errormsg});
}

