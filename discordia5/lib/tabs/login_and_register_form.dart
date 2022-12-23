import 'package:discordia5/functions/connection_call.dart';
import 'package:discordia5/functions/immutable_but_variable.dart';
import 'package:discordia5/functions/show_snack_bar.dart';
import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/screens/main_screen.dart';
import 'package:discordia5/services/api.dart';
// import 'package:discordia5/tabs/login_and_register/input_file_form.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:discordia5/widgets/big_button.dart';
import 'package:discordia5/widgets/app_inputs.dart';
import 'package:flutter/material.dart';

class LoginAndRegisterForm extends StatelessWidget {
  const LoginAndRegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: SECUNDARY_COLOR
              ),
              color: SECUNDARY_COLOR,
              borderRadius: const BorderRadius.all(Radius.circular(50))
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  LoginTab(),
                  const SizedBox(height: 20,),
                  RegisterTab()
                ]
              ),
            ),
          ),
        )
      ],
    );
  }
}

class LoginTab extends StatelessWidget {
  final ImmutableButVariable<bool> _loading = ImmutableButVariable(false);
  final TextEditingController _username = TextEditingController(),
    _password = TextEditingController();
  final ConnectionCall<bool> btConnection = ConnectionCall();
  LoginTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        const Text("Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WHITE_PRIMARY_COLOR,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 12),
        InputText(
          style: const TextStyle(
            color: WHITE_COLOR,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: LIGHT_GRAY_COLOR,
            fontSize: 14
          ),
          hintText: "Usuário",
          controller: _username,
        ),
        const SizedBox(height: 12),
        InputText(
          style: const TextStyle(
            color: WHITE_COLOR,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: LIGHT_GRAY_COLOR,
            fontSize: 14
          ),
          hintText: "Senha",
          secret: true,
          maxLength: 20,
          controller: _password,
        ),
        const SizedBox(height: 10),
        BigButton(
          connection: btConnection,
          expanded: true,
          text: "Login", 
          onPressed: () async{
            if(_loading.value == false){
              showSnackBar(context,
                title: "Logando...",
                titleColor: WHITE_COLOR,
                backgroundColor: PRIMARY_COLOR
              );
              _loading.value = true;
              btConnection.notify(true);
              if((await Api.login(_username.text.trim(), _password.text.trim())) == null){
                showSnackBar(context,
                  title: "Senha ou usuário incorreto(s)!",
                  titleColor: WHITE_COLOR,
                  backgroundColor: PRIMARY_COLOR
                );
                _loading.value = false;
                btConnection.notify(false);
              }else{
                Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ), (route) => false);
                _loading.value = false;
                btConnection.notify(false);
                showSnackBar(context,
                  title: "Logado",
                  titleColor: WHITE_COLOR,
                  backgroundColor: PRIMARY_COLOR
                );
              }
            }
          }
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}

class RegisterTab extends StatelessWidget {
  final ConnectionCall<String> imageUrlConnection = ConnectionCall();
  final ImmutableButVariable<bool> _loading = ImmutableButVariable(false);
  final DUser duser = DUser.empty();
  final TextEditingController _username = TextEditingController(),
    _password = TextEditingController(),
    _passwordConfirm = TextEditingController();
  final ConnectionCall<bool> btConnection = ConnectionCall();
  RegisterTab({Key? key}) : super(key: key){
    imageUrlConnection.setObserver(observer);
  }

  void observer(String imageUrl){
    duser.imageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
        const Text("Cadastrar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: WHITE_PRIMARY_COLOR,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 12),
        InputText(
          style: const TextStyle(
            color: WHITE_COLOR,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: LIGHT_GRAY_COLOR,
            fontSize: 14,
          ),
          hintText: "Usuário",
          controller: _username,
        ),
        const SizedBox(height: 8),
        InputText(
          style: const TextStyle(
            color: WHITE_COLOR,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: LIGHT_GRAY_COLOR,
            fontSize: 14,
          ),
          hintText: "Senha",
          secret: true,
          maxLength: 20,
          controller: _password
        ),
        const SizedBox(height: 8),
        InputText(
          style: const TextStyle(
            color: WHITE_COLOR,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(
            color: LIGHT_GRAY_COLOR,
            fontSize: 14,
          ),
          hintText: "Confirmação de senha",
          secret: true,
          maxLength: 20,
          controller: _passwordConfirm,
        ),
        // const SizedBox(height: 12),
        // InputFileForm(
        //   connection: imageUrlConnection,
        // ),
        const SizedBox(height: 10),
        BigButton(
          connection: btConnection,
          text: "Cadastrar",
          expanded: true,
          onPressed: () async{
            if(_password.text.trim() == _passwordConfirm.text.trim()){
              if(_password.text.trim().length > 7){
                if(_username.text.trim().length > 3){
                  if(_username.text.trim().length < 12){
                    if(_loading.value == false){
                      _loading.value = true;
                      btConnection.notify(true);
                      if((await Api.register(_username.text.trim(), _password.text.trim(), duser.imageUrl))){
                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false
                        );
                        _loading.value = false;
                        btConnection.notify(false);
                        showSnackBar(context,
                          title: "Cadastro realizado!",
                          titleColor: WHITE_COLOR,
                          backgroundColor: PRIMARY_COLOR
                        );
                      }else{
                        showSnackBar(context,
                          title: "Erro ao cadastrar",
                          titleColor: WHITE_COLOR,
                          backgroundColor: PRIMARY_COLOR
                        );
                        _loading.value = false;
                        btConnection.notify(false);
                        showSnackBar(context,
                          title: "Erro ao cadastrar!",
                          titleColor: WHITE_COLOR,
                          backgroundColor: PRIMARY_COLOR
                        );
                      }
                    }
                  }else{
                    showSnackBar(context,
                      title: "O usuário deve ter no máximo 12 letras!",
                      titleColor: WHITE_COLOR,
                      backgroundColor: PRIMARY_COLOR
                    );
                  }
                }else{
                  showSnackBar(context,
                    title: "O usuário deve ter no mínimo 4 letras!",
                    titleColor: WHITE_COLOR,
                    backgroundColor: PRIMARY_COLOR
                  );
                }
              }else{
                showSnackBar(context,
                  title: "A senha deve ter no mínimo 8 letras!",
                  titleColor: WHITE_COLOR,
                  backgroundColor: PRIMARY_COLOR
                );
              }
            }else{
              showSnackBar(context,
                title: "As senhas devem ser iguais!",
                titleColor: WHITE_COLOR,
                backgroundColor: PRIMARY_COLOR
              );
            }
          }
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}