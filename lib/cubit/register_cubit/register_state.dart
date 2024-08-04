


 class RegisterState {}

 class RegisterInitialState extends RegisterState {}

 class RegisterLoadingState extends RegisterState {}

 class RegisterScucessState extends RegisterState {}

 class RegisterFailedState extends RegisterState {
 String errormsg;
 RegisterFailedState({required this.errormsg});
 }
