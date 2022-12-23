import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:discordia5/enums/agora_connection_event.dart';
import 'package:discordia5/exceptions/agora_connection_want_initialized.dart';
import 'package:discordia5/models/d_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:discordia5/utils/agora.io.dart';

class AgoraConnection{
  bool _connected = false, _initialized = false;
  int _remoteUid = -1;
  RtcEngine? _engine;
  final List<DUser> _dusers = [];

  bool get connected => _connected;
  bool get initialized => _initialized;
  int get remoteUid => _remoteUid;
  List<DUser> get dusers => List.unmodifiable(_dusers);

  Function(AgoraConnectionEvent)? listener;
  
  bool requesting = false;
  Future initialize() async{
    if(requesting == false){
      requesting = true;
      await [Permission.microphone].request();
      requesting = false;
    }
    _initialized = true;
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: AGORA_APP_ID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed){
          _connected = true;
          if(listener != null){
            listener!.call(AgoraConnectionEvent.join);
          }
        },
        onLeaveChannel: (connection, stats){
          _connected = false;
          if(listener != null){
            listener!.call(AgoraConnectionEvent.leave);
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
          if(listener != null){
            listener!.call(AgoraConnectionEvent.update);
          }
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          _remoteUid = -1;
          if(listener != null){
            listener!.call(AgoraConnectionEvent.update);
          }
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          // ignore: avoid_print
          print('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      )
    );
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  }

  Future connect(String channelId, String token) async {
    if(_initialized == false){
      throw AgoraConnectionWasntInitialized();
    }
    _engine!.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    await _engine!.setAudioProfile(profile: AudioProfileType.audioProfileMusicHighQuality);
    await _engine!.joinChannel(token: token, channelId: channelId, uid: 0, options: const ChannelMediaOptions());
  }

  Future disconnect() async {
    if(_initialized == false){
      throw AgoraConnectionWasntInitialized();
    }
    await _engine!.leaveChannel();
  }
}