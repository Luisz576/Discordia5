import 'package:discordia5/functions/connection_call.dart';
import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BigButton extends StatefulWidget {
  final ConnectionCall<bool>? connection;
  final void Function() onPressed;
  final String text;
  final bool expanded;
  const BigButton({Key? key, this.expanded = false, this.connection, required this.text, required this.onPressed}) : super(key: key);

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
  bool _loading = false;

  @override
  void initState(){
    super.initState();
    if(widget.connection != null){
      widget.connection!.setObserver(observer);
    }
  }

  void observer(bool v){
    setState(() {
      _loading = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all<Size>(widget.expanded ? Size(MediaQuery.of(context).size.width, 0) : const Size(0, 0)),
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
        backgroundColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR),
      ),
      onPressed: _loading ? (){} : widget.onPressed,
      child: _loading ? const CircularProgressIndicator(
        color: WHITE_COLOR,
      ) : Text(widget.text,
        style: const TextStyle(
          color: WHITE_COLOR,
          fontSize: 18,
        ),
      ),
    );
  }
}