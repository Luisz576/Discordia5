import 'package:discordia5/services/api.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? drawerBody, endDrawerBody;
  final bool logged;
  const AppScaffold({required this.body, required this.logged, this.drawerBody, this.endDrawerBody, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: drawerBody == null ? null : Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: WHITE_PRIMARY_COLOR,),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          backgroundColor: BLACK_COLOR,
          title: const Text("Discordia5",
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontWeight: FontWeight.bold
            ),
          ),
          actions: logged ?
            [
              IconButton(
                icon: const Icon(
                  Icons.logout_outlined,
                  color: PRIMARY_COLOR,
                ),
                onPressed: () {
                  Api.logout();
                },
              ),
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: WHITE_PRIMARY_COLOR,),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              )
            ]
          : [],
        ),
        backgroundColor: GRAY_COLOR,
        body: body,
        drawer: drawerBody == null ? null : Drawer(
          backgroundColor: SECUNDARY_COLOR,
          child: drawerBody,
        ),
        endDrawer: endDrawerBody == null ? null : Drawer(
          backgroundColor: SECUNDARY_COLOR,
          child: endDrawerBody,
        ),
      ),
    );
  }
}