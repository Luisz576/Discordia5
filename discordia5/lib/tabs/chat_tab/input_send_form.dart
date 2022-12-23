import 'package:discordia5/functions/show_snack_bar.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/services/files.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputSendForm extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();
  InputSendForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: (){
                  Files.pickImage().then((xfile){
                    if(xfile == null){
                      return;
                    }
                    Api.sendMessageImage(xfile, (){
                      showSnackBar(context,
                        title: "Erro ao enviar imagem!",
                        titleColor: WHITE_COLOR,
                        backgroundColor: PRIMARY_COLOR
                      );
                    });
                  });
                },
                icon: const Icon(Icons.image_outlined,
                  color: WHITE_COLOR,
                  size: 32,
                )
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  style: const TextStyle(
                    color: WHITE_COLOR
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mensagem aqui",
                    hintStyle: TextStyle(
                      color: LIGHT_GRAY_COLOR
                    ),
                  ),
                  controller: messageController,
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: (){
                  if(messageController.text.isNotEmpty){
                    Api.sendMessage(messageController.text);
                    messageController.text = "";
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: WHITE_COLOR,
                  size: 28,
                )
              ),
            )
          ],
        ),
      )
    );
  }
}