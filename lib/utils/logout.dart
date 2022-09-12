import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inbox/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/network_url.dart';
import '../screens/login.dart';

class Logout {
  static Box<String> currentTokenBox = Hive.box("accessToken");
  static String signOutUrl = NetworkUrl.login ?? "";

  static Future checkForLogout() async {
    dynamic token = currentTokenBox.get('currentToken');
    if (token == null || token == '') {
      logout();
    }
    return token;
  }

  static void logout() async {
    try {
      await currentTokenBox.delete('currentToken');
      if (await canLaunch(signOutUrl)) {
        await launch(signOutUrl, forceSafariVC: false);
      } else {
        throw 'Could not launch $signOutUrl';
      }

      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) {
          return MyLogin();
        },
      ));
    } catch (e) {
      log("ERROR IN logout.dart => " + e.toString());
    }
  }
}
