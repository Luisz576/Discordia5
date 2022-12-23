import 'package:discordia5/tabs/chat_tab/input_send_form.dart';
import 'package:discordia5/tabs/chat_tab/messages_list_view.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Expanded(
          flex: 8,
          child: MessagesListView()
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: SECUNDARY_COLOR,
            child: InputSendForm()
          ),
        )
      ],
    );
  }
}