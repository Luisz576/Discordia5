import 'package:discordia5/functions/show_snack_bar.dart';
import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/services/files.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:discordia5/widgets/big_button.dart';
import 'package:flutter/material.dart';

class DUserTile extends StatelessWidget {
  final DUser duser;
  final TextEditingController nicknameController = TextEditingController();
  DUserTile({required this.duser, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Files.pickImage().then((xfile){
              if(xfile != null){
                Api.changeUserImage(duser.id, xfile);
              }else{
                showSnackBar(context,
                  title: "Nenhum imagem selecionada!",
                  backgroundColor: PRIMARY_COLOR,
                  titleColor: WHITE_COLOR,
                );
              }
            });
          },
          child: CircleAvatar(
            backgroundImage: duser.imageUrl.isEmpty ? null : NetworkImage(duser.imageUrl),
            backgroundColor: LIGHT_GRAY_COLOR,
            radius: 25,
          ),
        ),
        const SizedBox(width: 14,),
        GestureDetector(
          onTap: (){
            showDialog(context: context, builder: (context) => AlertDialog(
              backgroundColor: SECUNDARY_COLOR,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: duser.nickname,
                      hintStyle: const TextStyle(
                        color: LIGHT_GRAY_COLOR,
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: WHITE_COLOR,
                    ),
                    controller: nicknameController,
                  ),
                  const SizedBox(height: 20,),
                  BigButton(
                    text: "Save",
                    onPressed: (){
                      if(nicknameController.text.isEmpty || nicknameController.text.trim().length > 12){
                        showSnackBar(context,
                          title: "Apelido inválido!",
                          titleColor: WHITE_COLOR,
                          backgroundColor: PRIMARY_COLOR
                        );
                        return;
                      }
                      Api.renameUser(duser.id, nicknameController.text);
                      Navigator.pop(context);
                    },
                    expanded: true,
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ));
            nicknameController.text = duser.nickname;
          },
          child: Text(duser.nickname,
            style: const TextStyle(
              fontSize: 18,
              color: WHITE_COLOR,
            ),
          ),
        ),
        const SizedBox(width: 14,),
        Container(
          color: PRIMARY_COLOR,
          width: 40,
          height: 40,
          padding: EdgeInsets.zero,
          child: IconButton(
            color: WHITE_COLOR,
            onPressed: (){
              Api.deleteUser(duser.id);
            },
            icon: const Icon(Icons.delete, size: 24,)
          ),
        )
      ],
    );
  }
}