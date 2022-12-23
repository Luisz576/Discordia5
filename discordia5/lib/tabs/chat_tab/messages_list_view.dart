import 'package:discordia5/models/message.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/widgets/tiles/message_tile.dart';
import 'package:flutter/material.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Api.getMessages(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          final List<Message> docs = snapshot.data == null ? []
            : snapshot.data!.docs.map((doc) => Message.fromMap(doc.data())).toList();
          docs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return ListView.builder(
            itemCount: docs.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => MessageTile(message: docs[index]),
          );
        }else if(snapshot.hasError){
          return const Text("Um erro ocorreu!");
        }
        return const Text("carregando...");
      },
    );
  }
}