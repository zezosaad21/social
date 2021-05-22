
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/layout/cubit/social_cubit.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/chat/chat_details/chat_details_screen.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialCubit.get(context).users.length > 0,
            builder: (BuildContext context)=> ListView.separated(
            itemBuilder: (context, index)=> _buildChatItems(SocialCubit.get(context).users[index],context),
            separatorBuilder: (context, index)=> SizedBox(height: 5,),
            itemCount: SocialCubit.get(context).users.length,
          ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildChatItems(UserModel model, context) => InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatDetailsScreen(model: model,)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage('${model.image}'),
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );

}
