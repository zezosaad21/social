import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social/models/message_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/chat/chat_screen.dart';
import 'package:social/modules/feeds/feeds_screen.dart';
import 'package:social/modules/settings/settings_screen.dart';
import 'package:social/modules/upload_post/upload_post.dart';
import 'package:social/modules/users/users_screen.dart';
import 'package:social/shared/components/constant.dart';
part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());
  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel model;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      print(value.data());
      model = UserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState());
      print(error.toString());
    });
  }

  int currentIndex = 0;

  List<String> titles = [
    'News Feeds',
    'Chats',
    '',
    'Locations',
    'Settings',
  ];

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    UploadPost(),
    UsersScreen(),
    SettingsScreen(),
  ];

  void changeCurrentState(index) {
    if (index == 2)
      emit(SocilaUploadpost());
    else {
      currentIndex = index;
      emit(SocilaChangeButtomNav());
    }
  }

  File profileImage;
  var picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File coverImage;
  Future getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedEerrorState());
    }
  }

  void upoadProfileImage({
    @required String name,
    @required String bio,
    @required String phone,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone, image: value);
        emit(SocialProfileImageUploadSuccessState());
      }).catchError((error) {
        emit(SocialProfileImageUploadEerrorState());
        print(error.toString());
      });
    }).catchError((error) {
      print(error.toString());
      emit(SocialProfileImageUploadEerrorState());
    });
  }

  void upoadCoverImage({
    @required String name,
    @required String bio,
    @required String phone,
  }) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone, cover: value);
        emit(SocialCoverImageUploadSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialCoverImageUploadEerrorState());
      });
    }).catchError((error) {
      emit(SocialCoverImageUploadEerrorState());
      print(error.toString());
    });
  }

  // void updateUserImage({
  //   @required String name,
  //   @required String bio,
  //   @required String phone,
  // }) {
  //   emit(SocialUserUpdateloadingState());
  //   if (coverImage != null) {
  //     //upoadCoverImage();
  //   } else if (profileImage != null) {
  //    // upoadProfileImage();
  //   } else if (coverImage != null && profileImage != null) {
  //   } else {
  //     updateUser(name: name, bio: bio, phone: phone);
  //   }
  // }

  void updateUser({
    @required String name,
    @required String bio,
    @required String phone,
    String cover,
    String image,
  }) {
    UserModel usModel = UserModel(
      name: name,
      dio: bio,
      phone: phone,
      cover: cover ?? model.cover,
      email: model.email,
      image: image ?? model.image,
      uId: model.uId,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(usModel.toJson())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateEerrorState());
      print(error.toString());
    });
  }

  File postImage;
  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void createPostImage({
    @required String date,
    @required String text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          date: date,
          text: text,
          postImage: value,
        );
        emit(SocialCreatePostSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
      print(error.toString());
    });
  }

  void createPost({
    @required String date,
    @required String text,
    String postImage,
  }) {
    PostModel usModel = PostModel(
      name: model.name,
      image: model.image,
      uId: model.uId,
      date: date,
      text: text,
      postImages: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(usModel.toJson())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
      print(error.toString());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialPostImageRemoveState());
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> postLikes = [];

  Future<void> getPosts() {
    posts = [];
    postId = [];
    postLikes = [];
    emit(SocialGetPostLoadingState());
   return FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          postLikes.add(value.docs.length);
        }).catchError((error) {
          print(error.toString());
        });
      });
      emit(SocialGetPostSuccessState());
    }).catchError((error) {
      emit(SocialGetPostErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection('likes')
        .doc(model.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikesPostSuccessState());
    }).catchError((error) {
      emit(SocialLikesPostErrorState());
    });
  }

  List<UserModel> users = [];
  void getAllUser() {
    emit(SocialGetAllUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        element.reference.collection('users').get().then((value) {
          if (element.data()['uId'] != model.uId)
            users.add(UserModel.fromJson(element.data()));
        }).catchError((error) {});
      });
      emit(SocialGetAllUserSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUserErrorState());
    });
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel mModel = MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: model.uId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(mModel.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model.uId)
        .collection('messages')
        .add(mModel.toJson())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
