import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/style/broken_icons.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel model;

  const ChatDetailsScreen({Key key, this.model}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var _messageTextController = TextEditingController();
    ScrollController _controller;
  return Builder(
    builder: (BuildContext context) {

      SocialCubit.get(context).getMessages(receiverId: model.uId);
      return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(model.image),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Text(
                    model.name,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.length > 0,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(

                    children: [
                      Expanded(
                        child: ListView.separated(
                          //controller:_controller,

                          scrollDirection: Axis.vertical,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                            itemBuilder: (context , index){
                              var message = SocialCubit.get(context).messages[index];
                              if(SocialCubit.get(context).model.uId == message.senderId){
                                return _buildMyMessage(message);
                              }
                              return _buildMessage(message);
                            },
                            separatorBuilder: (context , index) => SizedBox(height: 15.0,),
                            itemCount: SocialCubit.get(context).messages.length,),
                      ),
                      //Spacer(),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300],
                            width: 1.0,

                          ),
                          borderRadius: BorderRadius.circular(15.0),

                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _messageTextController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your massage here ...',
                                ),
                              ),
                            ),
                            Container(
                              height: 50.0,
                              color: Colors.blue[700],
                              child: Center(
                                child: MaterialButton(onPressed: (){
                                  if(_messageTextController.text != ''){
                                    SocialCubit.get(context).sendMessage(
                                      receiverId: model.uId,
                                      dateTime: DateTime.now().toString(),
                                      text: _messageTextController.text,
                                    );
                                    _messageTextController.text = '';
                                  }
                                },
                                  minWidth: 1.0,
                                  child: Icon(
                                    IconBroken.Send,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              fallback:(context) => Center(child: CircularProgressIndicator(),),
            )
          );
        },
      );
    },
  );
  }

  Widget _buildMessage(MessageModel messageModel) =>  Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(

      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10.0),
          )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: Text(messageModel.text, style: TextStyle(
        color: Colors.black87,
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),),
      ),
    ),
  );
  Widget _buildMyMessage(MessageModel messageModel) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      margin: EdgeInsets.only(left: 70.0),
      decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadiusDirectional.only(
            bottomStart: Radius.circular(10),
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10.0),
          )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: Text(messageModel.text,style: TextStyle(
          color: Colors.grey[200],
          fontWeight: FontWeight.w400,
          fontSize: 18.0,
        ),),
      ),
    ),
  );
}
