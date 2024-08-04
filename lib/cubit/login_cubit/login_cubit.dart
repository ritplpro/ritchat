import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../firebase/firebase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  Firebaseintialize firebaseintialize;
  LoginCubit({required this.firebaseintialize}) : super(LoginInitialState());

  loginUser({required String email, required String password}) async {
    emit(LoginLoadingState());
    try{
      await firebaseintialize.LoginUser(email: email, password: password);
      emit(LoginSucessState());

    }catch(e){
      emit(LoginFailedState(errormsg: e.toString()));

    }


  }


}
