import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:discordia5/widgets/tiles/duser_tile.dart';
import 'package:flutter/material.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  final List<DUser> _dusers = [];

  @override
  void initState(){
    super.initState();
    Api.usersListenerRegister = _listener;
    _dusers.addAll(Api.getUsers());
  }

  void _listener(){
    setState(() {
      _dusers.clear();
      _dusers.addAll(Api.getUsers());
    });
  }

  @override
  void dispose(){
    super.dispose();
    Api.usersListenerUnregister = _listener;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SECUNDARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: Api.getUsers().length + 1,
          itemBuilder: (context, index) {
            if(index == 0){
              return const Text("Inscritos do canal Luisz576",
                style: TextStyle(
                  color: WHITE_PRIMARY_COLOR,
                  fontSize: 24
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: DUserTile(duser: _dusers[index - 1]),
            );
          },
        ),
      ),
    );
  }
}