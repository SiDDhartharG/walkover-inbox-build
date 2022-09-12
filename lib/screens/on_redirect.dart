import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnRedirect extends StatefulWidget {
  const OnRedirect({Key key}) : super(key: key);

  @override
  State<OnRedirect> createState() => _OnRedirectState();
}

class _OnRedirectState extends State<OnRedirect> {
  @override
  String text = "GG";
  void initState() {
    super.initState();
    setState(() {
      text = Uri.base.queryParameters['orgId'] ?? "NOT HERE";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(text),
    );
  }
}
