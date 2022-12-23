import 'package:discordia5/models/channel.dart';
import 'package:discordia5/services/api.dart';
import 'package:discordia5/tabs/chat_tab/call_controlls.dart';
import 'package:discordia5/widgets/tiles/channel_tile.dart';
import 'package:flutter/material.dart';

class ChannelTab extends StatefulWidget {
  const ChannelTab({Key? key}) : super(key: key);

  @override
  State<ChannelTab> createState() => _ChannelTabState();
}

class _ChannelTabState extends State<ChannelTab> {
  final List<Channel> _channels = [];

  @override
  void initState(){
    super.initState();
    Api.channelsListenerRegister = _listener;
    _channels.addAll(Api.getChannels());
  }

  void _listener(){
    setState(() {
      _channels.clear();
      _channels.addAll(Api.getChannels());
    });
  }

  @override
  void dispose(){
    super.dispose();
    Api.channelsListenerUnregister = _listener;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _channels.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: ChannelTile(
                  channel: _channels[index],
                ),
              ),
            ),
          ),
        ),
        const Expanded(
          flex: 1,
          child: CallControlls(),
        )
      ],
    );
  }
}