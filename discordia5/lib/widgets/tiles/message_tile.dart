import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/models/message.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  const MessageTile({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DUser?>(
            future: Api.getUserModelById(message.userId),
            builder: (context, snapshot) {
              if(snapshot.hasData && snapshot.data != null){
                return CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                );
              }
              return const CircleAvatar(
                backgroundColor: LIGHT_GRAY_COLOR,
                radius: 20,
              );
            },
          ),
          const SizedBox(width: 10,),
          message.messageImage.isNotEmpty ? SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Image.network(message.messageImage),
          ) : Text(message.messageContent,
            style: const TextStyle(
              color: WHITE_COLOR,
              fontSize: 16,
            )
          )
        ],
      ),
    );
  }
}