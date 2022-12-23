import 'package:discordia5/functions/connection_call.dart';
import 'package:discordia5/functions/show_snack_bar.dart';
import 'package:discordia5/services/files.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputFileForm extends StatefulWidget {
  final ConnectionCall<String>? connection;
  const InputFileForm({Key? key, this.connection}) : super(key: key);

  @override
  State<InputFileForm> createState() => _InputFileFormState();
}

class _InputFileFormState extends State<InputFileForm> {
  String? urlImageLoaded;
  bool isUploadingSomething = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(isUploadingSomething){ return; }
        setState(() {
          isUploadingSomething = true;
        });
        Files.pickImage().then((file) {
          if(file != null){
            // Api.uploadImage(file,
            //   (String imageUrl){
            //     if(widget.connection != null){
            //       widget.connection!.notify(imageUrl);
            //     }
            //     setState(() {
            //       urlImageLoaded = imageUrl;
            //       isUploadingSomething = false;
            //     });
            //   },
            //   (){
            //     showSnackBar(context,
            //       title: "Não foi possível enviar a imagem!",
            //       backgroundColor: PRIMARY_COLOR,
            //       titleColor: WHITE_COLOR
            //     );
            //     setState(() {
            //       isUploadingSomething = false;
            //     });
            //   }
            // );
          }else{
            showSnackBar(context,
              title: "Nenhum imagem selecionada!",
              backgroundColor: PRIMARY_COLOR,
              titleColor: WHITE_COLOR,
            );
            setState(() {
              isUploadingSomething = false;
            });
          }
        });
      },
      child: Row(
        children: [
          isUploadingSomething ? Container(
            width: 120,
            height: 120,
            color: GRAY_COLOR,
            child: const CircularProgressIndicator(
              color: PRIMARY_COLOR,
            ),
          ) : urlImageLoaded == null ? Container(
            width: 120,
            height: 120,
            color: GRAY_COLOR,
          ) : Container(
            width: 120,
            height: 120,
            color: GRAY_COLOR,
            child: Image.network(
              urlImageLoaded!,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(width: 10),
          const Text("Imagem de perfil",
            style: TextStyle(
              color: WHITE_PRIMARY_COLOR,
              fontSize: 16
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.file_present_rounded, color: WHITE_PRIMARY_COLOR, size: 48)
        ],
      ),
    );
  }
}