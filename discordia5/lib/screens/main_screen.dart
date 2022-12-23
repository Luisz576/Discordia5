import 'package:discordia5/screens/login_screen.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/tabs/channels_tab.dart';
import 'package:discordia5/tabs/chat_tab.dart';
import 'package:discordia5/tabs/users_tab.dart';
import 'package:discordia5/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState(){
    super.initState();
    Api.logoutCallback = _logoutCallback;
    Api.initUsersListenerIfNot();
    Api.initializeAgoraIfNot();
  }

  @override
  void dispose(){
    Api.leaveChannel();
    Api.logoutCallback = null;
    super.dispose();
  }

  void _logoutCallback(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      logged: true,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const ChatTab(),
      ),
      drawerBody: const ChannelTab(),
      endDrawerBody: const UsersTab()
    );
  }
}