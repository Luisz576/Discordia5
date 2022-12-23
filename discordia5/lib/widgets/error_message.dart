import 'package:discordia5/functions/connection_call.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends StatefulWidget {
  final ConnectionCall<String?> connection;
  const ErrorMessage({required this.connection, Key? key}) : super(key: key);

  @override
  State<ErrorMessage> createState() => _ErrorMessageState();
}

class _ErrorMessageState extends State<ErrorMessage> {
  String? message;

  @override
  void initState(){
    super.initState();
    widget.connection.setObserver(_observer);
  }

  void _observer(String? m){
    setState(() {
      message = m;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(message == null ? "" : message!,
      style: const TextStyle(
        color: WHITE_PRIMARY_COLOR,
        fontSize: 12,
        fontWeight: FontWeight.bold
      ),
    );
  }
}