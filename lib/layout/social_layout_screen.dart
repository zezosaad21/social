import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/upload_post/upload_post.dart';
import 'package:social/shared/style/broken_icons.dart';
import 'cubit/social_cubit.dart';

class SocialLayoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocilaUploadpost) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadPost(),
            ),
          );
        }
      },
      builder: (context, state) {
        var cuibt = SocialCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            // centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text(
              cuibt.titles[cuibt.currentIndex],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  IconBroken.Notification,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  IconBroken.Search,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: cuibt.screens[cuibt.currentIndex],
          bottomNavigationBar: _buttomNavBar(context),
        );
      },
    );
  }

  Widget _buttomNavBar(context) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: SocialCubit.get(context).currentIndex,
        onTap: (index) {
          SocialCubit.get(context).changeCurrentState(index);
          print(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(
              IconBroken.Home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Chate',
            icon: Icon(
              IconBroken.Chat,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Upload',
            icon: Icon(
              IconBroken.Paper_Upload,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(
              IconBroken.Location,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              IconBroken.Setting,
            ),
          ),
        ],
      );
}
