import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/register/cubit/login_cubit.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/network/local/cach_helper.dart';
import 'package:social/shared/style/broken_icons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state is LoginSuccessState) {
            CacheHelper.putData(
              key: 'uId',
              value: state.uId,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login'),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultTextFormField(
                    controller: _emailController,
                    validator: (name) {},
                    labelText: 'Email',
                    prifix: Icon(IconBroken.User1),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultTextFormField(
                    controller: _passwordController,
                    validator: (name) {},
                    labelText: 'Password',
                    isPassword: true,
                    prifix: Icon(IconBroken.Password),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                IconButton(
                    icon: Icon(IconBroken.Shield_Fail),
                    onPressed: () {
                      LoginCubit.get(context).loginWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context,
                      );
                    }),
              ],
            ),
          );
        },
      ),
    );
  }
}
