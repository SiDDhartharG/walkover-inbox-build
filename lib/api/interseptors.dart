import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:inbox_flutter_app/utils/logout.dart';

class ProtectedApiInterceptor implements InterceptorContract {
  Box<String> currentTokenBox = Hive.box("accessToken");
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String token = await Logout.checkForLogout();
    try {
      data.headers["Authorization"] = token;
      data.headers['Content-Type'] = 'application/json; charset=UTF-8';
    } catch (e) {
      log(e.toString());
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      Logout.logout();
    }
    return data;
  }
}
