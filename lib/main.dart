import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inbox/apiModel/userEmailAddress.dart';
import 'package:inbox/constants/network_url.dart';
import 'package:inbox/screens/dashboard.dart';
import 'package:inbox/screens/login.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken() ?? "";
  }
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
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box<String> currentTokenBox;
  Box<String> activeOrgIdBox;
  @override
  void initState() {
    currentTokenBox = Hive.box("accessToken");
    activeOrgIdBox = Hive.box("activeOrgId");
    super.initState();
  }

  Future<Route> checkIfLoginAndSetToken(Uri uri) async {
    Map<String, String> params = uri.queryParameters;
    if (uri.path.toString().contains("login")) {
      String orgId = params['org'] ?? "";
      String tokenId = params['token'] ?? '';
      await currentTokenBox.put("currentToken", tokenId);
      await activeOrgIdBox.put("orgId", orgId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inbox',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // home: const SplashScreen(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        // When navigating to the "/" route, build the HomeScreen widget.
        '/': (context) => const SplashScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
      // onUnknownRoute: ((settings) {
      //   Uri uri = Uri.dataFromString(settings.name.toString());
      //   checkIfLoginAndSetToken(uri).then((_) {
      //     return MaterialPageRoute(
      //       builder: (context) => DashBoardPage(),
      //     );
      //   }).catchError((onError) {
      //     // ignore: invalid_return_type_for_catch_error
      //     return null;
      //   });
      // }),
      // onGenerateRoute: ((settings) {
      //   Uri uri = Uri.dataFromString(settings.name.toString());
      //   checkIfLoginAndSetToken(uri).then((_) {
      //     return MaterialPageRoute(builder: (_) => DashBoardPage());
      //   }).catchError((onError) {
      //     // ignore: invalid_return_type_for_catch_error
      //     return null;
      //   });
      // }),
    );
  }

  // Route? function(settings) {
  //   Uri uri = Uri.dataFromString(settings.name.toString());
  //   checkIfLoginAndSetToken(uri).then((value) {
  //     return MaterialPageRoute(builder: (_) => DashBoardPage());
  //   }).catchError((onError) {
  //     print(onError);
  //     return null;
  //   });
  // }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Box<String> currentTokenBox;
  Box<String> activeOrgIdBox;
  final url = NetworkUrl.publicKey;
  String publicKey;
  bool isLinkPresent = false;
  String fetchedToken;

  @override
  void initState() {
    super.initState();

    if (dotenv.env["MODE"] == "development") {
      currentTokenBox = Hive.box("accessToken");
      activeOrgIdBox = Hive.box("activeOrgId");
      currentTokenBox.put("currentToken", '${dotenv.env["PERSONAL_TOKEN"]}');
      activeOrgIdBox.put("orgId", '${dotenv.env["ORG_ID"]}');
    }
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
    return Center(
      heightFactor: 2.5,
      child: Image.asset(
        'splashScreen.png',
        height: 100,
        width: 100,
      ),
    );
  }
}
