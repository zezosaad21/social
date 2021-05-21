import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social/layout/social_layout_screen.dart';
import 'package:social/models/user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  // UserModel model;

  void loginWithEmailAndPassword(
      {@required String email, @required String password, context}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      emit(LoginSuccessState(value.user.uid));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SocialLayoutScreen()));
    }).catchError((error) {
      emit(LoginErrorState());
      print(error.toString());
    });
  }

  void createUserWithEmailAndPassword({
    String email,
    String name,
    String password,
    String phone,
    context,
  }) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await createUser(
              name: name, uId: value.user.uid, email: email, phone: phone)
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SocialLayoutScreen(),
          ),
        );
      });
    }).catchError((error) {
      emit(LoginErrorState());
      print(error.toString());
    });
  }

  Future<void> createUser({
    @required String name,
    @required String uId,
    @required String email,
    @required String phone,
  }) async {
    UserModel model = UserModel(
      name: name,
      uId: uId,
      email: email,
      phone: phone,
      dio: 'write your dio here',
      image:
          "https://image.freepik.com/free-photo/cheerful-young-sports-man-posing-showing-thumbs-up-gesture_171337-8194.jpg",
      cover:
          "https://image.freepik.com/free-photo/vegetables-set-left-black-slate_1220-685.jpg",
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toJson())
        .then((value) {
      emit(LoginCreateUserSuccessState());
    }).catchError((error) {
      emit(LoginCreateUserErrorState());
    });
  }
}
