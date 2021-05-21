import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/style/broken_icons.dart';

import 'cubit/login_cubit.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultTextFormField(
                    controller: _nameController,
                    validator: (name) {},
                    labelText: 'Name',
                    prifix: Icon(IconBroken.Profile),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultTextFormField(
                    controller: _phoneController,
                    validator: (name) {},
                    labelText: 'Phone',
                    prifix: Icon(IconBroken.Calling),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                IconButton(
                    icon: Icon(IconBroken.Add_User),
                    onPressed: () {
                      LoginCubit.get(context).createUserWithEmailAndPassword(
                        email: _emailController.text,
                        name: _nameController.text,
                        password: _passwordController.text,
                        phone: _phoneController.text,
                        context: context,
                      );
                    })
              ],
            ),
          ),
        );
      },
    );
  }
}
