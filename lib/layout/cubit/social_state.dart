part of 'social_cubit.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialGetUserLoadingState extends SocialState {}
class SocialGetUserSuccessState extends SocialState {}
class SocialGetUserErrorState extends SocialState {}

class SocialGetPostLoadingState extends SocialState {}
class SocialGetPostSuccessState extends SocialState {}
class SocialGetPostErrorState extends SocialState {}

class SocialGetAllUserLoadingState extends SocialState {}
class SocialGetAllUserSuccessState extends SocialState {}
class SocialGetAllUserErrorState extends SocialState {}

class SocilaChangeButtomNav extends SocialState {}

class SocilaUploadpost extends SocialState {}

class SocialProfileImagePickedSuccessState extends SocialState {}
class SocialProfileImagePickedErrorState extends SocialState {}

class SocialCoverImagePickedSuccessState extends SocialState {}
class SocialCoverImagePickedEerrorState extends SocialState {}

class SocialCoverImageUploadSuccessState extends SocialState {}
class SocialCoverImageUploadEerrorState extends SocialState {}

class SocialProfileImageUploadSuccessState extends SocialState {}
class SocialProfileImageUploadEerrorState extends SocialState {}

class SocialUserUpdateloadingState extends SocialState {}
class SocialUserUpdateEerrorState extends SocialState {}

class SocialLikesPostSuccessState extends SocialState {}
class SocialLikesPostErrorState extends SocialState {}

class SocialCreatePostLoadingState extends SocialState {}
class SocialCreatePostSuccessState extends SocialState {}
class SocialCreatePostErrorState extends SocialState {}

class SocialPostImagePickedSuccessState extends SocialState {}
class SocialPostImagePickedErrorState extends SocialState {}
class SocialPostImageRemoveState extends SocialState {}

// chat

class SocialSendMessageSuccessState extends SocialState {}
class SocialSendMessageErrorState extends SocialState {}

class SocialGetMessageSuccessState extends SocialState {}
class SocialPositionState extends SocialState {}