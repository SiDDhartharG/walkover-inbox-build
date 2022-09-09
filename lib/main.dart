import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/constants/app_colors.dart';
import 'package:inbox/constants/network_url.dart';
import 'package:inbox/screens/dashboard.dart';
import 'package:inbox/screens/login.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//List<Box> boxList = [];
Future _openBox() async {
  await Hive.initFlutter();
  await Hive.openBox<String>("accessToken");
  await Hive.openBox<String>("activeOrgId");
  await Hive.openBox<String>("activeUserId");
  Hive.registerAdapter(UserEmailAddressModelAdapter());
  Hive.registerAdapter(UserEmailAddressAdapter());
  Hive.registerAdapter(EmailaddressAdapter());
  Hive.registerAdapter(UnreadCountAdapter());
  Hive.registerAdapter(EmaildomainorgAdapter());
  Hive.registerAdapter(UseremailaddressesAdapter());
  Hive.registerAdapter(AllMailModelAdapter());
  Hive.registerAdapter(MailAdapter());
  Hive.registerAdapter(BodyAdapter());
  Hive.registerAdapter(BccAdapter());
  Hive.registerAdapter(CcAdapter());
  Hive.registerAdapter(FromAdapter());
  Hive.registerAdapter(ToAdapter());
  Hive.registerAdapter(AttachmentAdapter());
  await Hive.openBox<UserEmailAddressModel>("userEmailAddresses");
  await Hive.openBox<Map<dynamic, dynamic>>("allEmails");
  await Hive.openBox<List<String>>("allEmailAddress");
  await Hive.openBox<UserEmailAddressModel>("userEmailAddressModel");
  await Hive.openBox<String>("deviceToken");
  // boxList.add(accessToken);
  // boxList.add(orgId);
  // return boxList;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> getPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

void fcmConfigs() async {
  String token;
  print(kIsWeb);
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDnIbtZBkaqAJLsrBuZcMXE7qSUHrWnXkA",
            authDomain: "kiss-16325.firebaseapp.com",
            databaseURL: "https://kiss-16325.firebaseio.com",
            projectId: "kiss-16325",
            storageBucket: "kiss-16325.appspot.com",
            messagingSenderId: "118321990441",
            appId: "1:118321990441:web:ea498d1f142241237d0538"));
    await getPermission();
    token = await FirebaseMessaging.instance.getToken(
            vapidKey:
                "BPvGgCPFx2ur_sqn_YZeCCZs-hIgnyiohuqDskjay5kophTypfMwJV-MBsZEomZqtly0NXaNjA-wOTclPgf1K5A") ??
        "";
  } else {
    print("1");
    await Firebase.initializeApp();
    print("2");

    token = await FirebaseMessaging.instance.getToken() ?? "";
    print("3");
  }
  print("token");
  print(token);
  Box<String> deviceToken = Hive.box<String>("deviceToken");
  await deviceToken.put("deviceToken", token);
}

void main() async {
  await dotenv.load(fileName: ".env_dev");
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();
  try {
    fcmConfigs();
  } catch (e) {
    print(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Inbox',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Box<String> currentTokenBox;
  late Box<String> activeOrgIdBox;
  final url = NetworkUrl.publicKey;
  String? publicKey;
  bool isLinkPresent = false;
  String? fetchedToken;

  @override
  void initState() {
    super.initState();
    currentTokenBox = Hive.box("accessToken");
    fetchPublickey();
    Timer(
        const Duration(seconds: 2),
        () => {
              fetchedToken == null || fetchedToken == ''
                  ? Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyLogin()))
                  : Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DashBoardPage()))
            });
  }

  void fetchPublickey() async {
    try {
      dynamic token = currentTokenBox.get('currentToken');
      if (token != null && token != '') {
        setState(() {
          fetchedToken = token;
        });
        return;
      }
      final response = await get(Uri.parse(url));
      setState(() {
        publicKey = response.body;
      });
    } catch (err) {
      log(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SpinKitFadingCube(
      color: AppColor.colorLoadingindicator,
      size: 60.0,
      duration: Duration(milliseconds: 3000),
    );
  }
}
