import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  BlinkingText(this.text, this.style);
  @override
  BlinkingTextState createState() => BlinkingTextState();
}

class BlinkingTextState extends State<BlinkingText> {
  bool _show = true;
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 700), (_) {
      setState(() => _show = !_show);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Text(widget.text,
      style: _show
          ? widget.style
          : TextStyle(color: Colors.transparent));

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}