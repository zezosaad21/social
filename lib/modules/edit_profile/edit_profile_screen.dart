import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/style/broken_icons.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _bioController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();

    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var userModel = SocialCubit.get(context).model;

        _nameController.text = userModel.name;
        _bioController.text = userModel.dio;
        _phoneController.text = userModel.phone;
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;

        return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: 'Edit Profile',
                actions: [
                  TextButton(
                      onPressed: () {
                        SocialCubit.get(context).updateUser(
                          name: _nameController.text,
                          bio: _bioController.text,
                          phone: _phoneController.text,
                        );
                      },
                      child: Text('UPDATE')),
                  SizedBox(
                    width: 15.0,
                  )
                ]),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is SocialUserUpdateloadingState)
                      LinearProgressIndicator(),
                    if (state is SocialUserUpdateloadingState)
                      SizedBox(
                        height: 15.0,
                      ),
                    // image cover and personal photo
                    Container(
                      height: 190,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topCenter,
                                child: Container(
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                      image: DecorationImage(
                                        image: coverImage == null
                                            ? NetworkImage("${userModel.cover}")
                                            : FileImage(coverImage),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                child: IconButton(
                                  icon: Icon(IconBroken.Camera),
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImage == null
                                      ? NetworkImage("${userModel.image}")
                                      : FileImage(profileImage),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                child: IconButton(
                                  icon: Icon(IconBroken.Camera),
                                  onPressed: () {
                                    SocialCubit.get(context).getProfileImage();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    if (SocialCubit.get(context).coverImage != null ||
                        SocialCubit.get(context).profileImage != null)
                      Row(
                        children: [
                          if (SocialCubit.get(context).coverImage != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  SocialCubit.get(context).upoadCoverImage(
                                    name: _nameController.text,
                                    bio: _bioController.text,
                                    phone: _phoneController.text,
                                  );
                                  SocialCubit.get(context).coverImage = null;
                                },
                                child: Text('UPLOAD COVER '),
                              ),
                            ),
                          if (SocialCubit.get(context).coverImage != null)
                            SizedBox(
                              width: 20,
                            ),
                          if (SocialCubit.get(context).profileImage != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  SocialCubit.get(context).upoadProfileImage(
                                    name: _nameController.text,
                                    bio: _bioController.text,
                                    phone: _phoneController.text,
                                  );
                                  SocialCubit.get(context).profileImage = null;
                                },
                                child: Text('UPLOAD PROFILE'),
                              ),
                            ),
                        ],
                      ),
                    if (SocialCubit.get(context).coverImage != null ||
                        SocialCubit.get(context).profileImage != null)
                      SizedBox(
                        height: 10,
                      ),
                    defaultTextFormField(
                      controller: _nameController,
                      prifix: Icon(IconBroken.Profile),
                      labelText: 'Name',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'name must be not empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    defaultTextFormField(
                      controller: _bioController,
                      prifix: Icon(IconBroken.Info_Circle),
                      labelText: 'Bio',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'bio must be not empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.0),
                    defaultTextFormField(
                      controller: _phoneController,
                      prifix: Icon(IconBroken.Call),
                      keyboardType: TextInputType.phone,
                      labelText: 'Phone',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'phone must be not empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
