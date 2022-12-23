import 'package:discordia5/services/api.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CallControlls extends StatelessWidget {
  const CallControlls({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DARK_GRAY_COLOR,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Api.getUserImage().isEmpty ? const CircleAvatar(
              radius: 25,
              backgroundColor: LIGHT_GRAY_COLOR,
            ) : CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(Api.getUserImage()),
            ),
            const SizedBox(width: 20,),
            ValueListenableBuilder(
              valueListenable: Api.isConnectedNotifier.notifier,
              builder: (context, value, child){
                if(value){
                  return const IconButton(
                    onPressed: Api.leaveChannel,
                    icon: Icon(Icons.phone_disabled,
                      color: PRIMARY_COLOR,
                      size: 30,
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}