part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginErrorState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginSuccessGetUserDataState extends LoginState {
  final UserModel userModel;

  LoginSuccessGetUserDataState(this.userModel);
}

class LoginLoadingState extends LoginState {}

class LoginCreateUserErrorState extends LoginState {}

class LoginCreateUserSuccessState extends LoginState {}
