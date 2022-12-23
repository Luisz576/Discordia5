import 'package:discordia5/enums/channel_type.dart';
import 'package:discordia5/models/channel.dart';
import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/models/notifiers/connection_notifier.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChannelTile extends StatefulWidget {
  final Channel channel;
  const ChannelTile({required this.channel, super.key});

  @override
  State<ChannelTile> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<ChannelTile> {
  final ConnectionNotifier notifier = ConnectionNotifier();
  @override
  void initState(){
    super.initState();
    Api.addChannelListener(notifier.updateConnections);
  }

  @override
  void dispose(){
    Api.removeChannelListener(notifier.updateConnections);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.channel.type == ChannelType.chat ? Row(
      children: [
        const Icon(Icons.tag,
          color: WHITE_PRIMARY_COLOR,
          size: 26,
        ),
        Text(widget.channel.name,
          style: const TextStyle(
            color: WHITE_PRIMARY_COLOR,
            fontSize: 18,
          ),
        )
      ],
    ) : Column(
      children: [
        GestureDetector(
          onTap: (){
            Api.connectChannel(widget.channel.channel, widget.channel.token).then((_){});
          },
          child: Row(
            children: [
              const Icon(Icons.volume_mute_rounded,
                color: WHITE_PRIMARY_COLOR,
                size: 26,
              ),
              Text(widget.channel.name,
                style: const TextStyle(
                  color: WHITE_PRIMARY_COLOR,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
        ValueListenableBuilder<List<DUser>>(
          valueListenable: notifier.listenable,
          builder: (context, value, child) => Column(
            children: value.map((duser) => DUserTileToChannelTile(duser: duser,)).toList(),
          ),
        )
      ],
    );
  }
}

class DUserTileToChannelTile extends StatelessWidget {
  final DUser duser;
  const DUserTileToChannelTile({required this.duser, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        duser.imageUrl.isEmpty ? const CircleAvatar(
          radius: 8,
          backgroundColor: LIGHT_GRAY_COLOR,
        ) : CircleAvatar(
          backgroundImage: NetworkImage(duser.imageUrl),
          radius: 8,
        ),
        const SizedBox(width: 5,),
        Text(duser.nickname,
          style: const TextStyle(
            color: WHITE_COLOR,
            fontSize: 12
          ),
        )
      ],
    );
  }
}