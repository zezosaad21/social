import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/components/constant.dart';
import 'package:social/shared/my_provider.dart';
import 'package:social/shared/network/local/cach_helper.dart';
import 'layout/cubit/social_cubit.dart';
import 'layout/social_layout_screen.dart';
import 'modules/login/login_screen.dart';
import 'modules/register/cubit/login_cubit.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  
  FirebaseMessaging.onMessage.listen((event) { 
    print(event.data.toString());
  });


  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
  });
  
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Widget widget;

  uId = CacheHelper.getData(key: "uId");

  if (uId != null) {
    widget = SocialLayoutScreen();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({Key key, this.startWidget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => SocialCubit()..getUserData()..getAllUser()..getPosts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: startWidget,
      ),
    );
  }
}
