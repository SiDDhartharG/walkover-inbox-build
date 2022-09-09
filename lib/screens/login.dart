import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feathersjs/flutter_feathersjs.dart';
import 'package:hive/hive.dart';
import 'package:inbox/constants/network_url.dart';
import 'package:inbox/screens/dashboard.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inbox/constants/app_colors.dart';

class MyLogin extends StatefulWidget {
  dynamic publicKey;
  MyLogin({Key? key, this.publicKey}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late Box<String> currentTokenBox;
  late Box<String> activeOrgIdBox;
  FlutterFeathersjs? flutterFeathersjs;

  void navigateToDashboard(link) async {
    dynamic currentToken = currentTokenBox.get('currentToken');
    if (currentToken != null && currentToken != "") {
      return;
    }
    dynamic token = link.toString().split('&token=');
    dynamic defaultOrgId = token[0].toString().split('?org=');
    //saving token in DB
    activeOrgIdBox.put("orgId", defaultOrgId[1]);
    currentTokenBox.put("currentToken", token[1]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DashBoardPage();
        },
      ),
    );
  }

  void fetchTokenViaLogin() async {
    String url = NetworkUrl.login;
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    currentTokenBox = Hive.box("accessToken");
    activeOrgIdBox = Hive.box("activeOrgId");
    dynamic token = currentTokenBox.get('currentToken');
    if (token != null && token != '') {
      //redirect to DashboardPage
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashBoardPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.colorLoginBackg,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('space.jpg'), fit: BoxFit.contain),
              ),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        StreamBuilder<Uri?>(
                            stream: uriLinkStream,
                            builder: (context, snapshot) {
                              final link = snapshot.data ?? '';
                              if (link.toString() != "") {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  navigateToDashboard(link);
                                  // Your Code
                                });
                              }
                              return ElevatedButton(
                                onPressed: () {
                                  fetchTokenViaLogin();
                                },
                                child: const Center(
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: AppColor.colorLoginButtonText,
                                        fontSize: 18),
                                  ),
                                ),
                                style: const ButtonStyle(),
                              );
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
