import 'package:discordia5/utils/app_colors.dart';
import 'package:flutter/material.dart';

class InputCore extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double? width, height;
  const InputCore({Key? key, this.width, this.height, this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10), required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: GRAY_COLOR
        ),
        color: GRAY_COLOR,
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class InputIconAndText extends StatelessWidget{
  final TextEditingController controller;
  final TextStyle? style, hintStyle;
  final String hintText;
  final Icon icon;
  final double padding;
  final bool secret, isMobile;
  final int? maxLength;
  final void Function() onPressed;
  const InputIconAndText({this.style, this.maxLength, this.secret = false, this.hintStyle, this.padding = 10, required this.isMobile, required this.onPressed, required this.icon, required this.hintText, required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputCore(
      width: (MediaQuery.of(context).size.width / 2) - (isMobile ? 100 : 240),
      child: Row(
        children: [
          IconButton(
            onPressed: onPressed,
            icon: icon
          ),
          const SizedBox(
            width: 10,
          ),
          TextField(
            style: style,
            maxLines: 1,
            maxLength: maxLength ?? 16,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              hintMaxLines: 1,
              counter: Container(),
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            obscureText: secret,
            controller: controller,
          ),
        ],
      )
    );
  }
}

class InputText extends StatelessWidget {
  final TextStyle? style, hintStyle;
  final String hintText;
  final bool secret;
  final int? maxLength;
  final TextEditingController controller;
  const InputText({this.style, this.hintStyle, this.maxLength, this.secret = false, required this.hintText, required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputCore(
      width: MediaQuery.of(context).size.width - 80,
      // height: isMobile ? 60 : 100,
      child: TextField(
        style: style,
        maxLines: 1,
        maxLength: maxLength ?? 16,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: hintStyle,
          hintMaxLines: 1,
          counter: Container(),
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        obscureText: secret,
        controller: controller,
      ),
    );
  }
}