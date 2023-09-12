part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserSignedIn extends UserState {
  final UserModel userData;

  UserSignedIn({required this.userData});
}

class UserDataLoading extends UserState {
  final LoadingDialog loadingDialog = const LoadingDialog();
}

class UserNotSigned extends UserState {}
