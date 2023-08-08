import 'package:flutter/material.dart';


class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.text,
    required this.size,
    required this.maxLineSize,
    required this.textController,
  });
  final String text;
  final double size;
  final int maxLineSize;
  // ignore: prefer_typing_uninitialized_variables
  final textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        controller: textController,
        style: TextStyle(
          fontSize: size,
        ),
        maxLines: maxLineSize,
        cursorHeight: size,
        cursorColor: Colors.amber[800],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          hintStyle: TextStyle(fontSize: size, color: Colors.black26),
        ),
      ),
    );
  }
}
