import 'package:bloc/bloc.dart';
import 'package:ritchat/cubit/register_cubit/register_state.dart';

import '../../firebase/firebase.dart';
import '../../modal/user_modal.dart';




class RegisterCubit extends Cubit<RegisterState> {
  Firebaseintialize firebaseintialize;
  RegisterCubit({required this.firebaseintialize}) : super(RegisterInitialState());

  registerUser(UserModal username,String pass) async {
    emit(RegisterLoadingState());
    try{
     await firebaseintialize.createUser(user: username, password: pass);
      emit(RegisterScucessState());

    }catch(e){
      emit(RegisterFailedState(errormsg: e.toString()));

    }
  }


}
