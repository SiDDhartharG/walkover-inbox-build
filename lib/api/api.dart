import 'dart:convert';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:inbox/api/interseptors.dart';
import 'package:inbox/constants/network_url.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class APICalls {
  static Client protectedClient = InterceptedClient.build(interceptors: [
    ProtectedApiInterceptor(),
  ]);

  static Future<List<dynamic>> getAllEmails(
      currentUserEmailAddressId, currentTag, skipMail) async {
    String url = NetworkUrl.AllMAil;

    var replaceUrl = url
        .replaceFirst(':mail-owner', currentUserEmailAddressId)
        .replaceFirst(':currentTag', currentTag)
        .replaceFirst(':skip', skipMail.toString());

    return jsonDecode((await protectedClient.get(Uri.parse(replaceUrl))).body);
  }

  static Future<Response> sendComposedEmail(model) {
    String creatMailUrl = NetworkUrl.creatMail;
    return protectedClient.post(Uri.parse(creatMailUrl),
        body: json.encode(model));
  }

  static Future<Map<String, dynamic>> sendFCMToken(String token) async {
    print(token);
    return jsonDecode((await protectedClient.post(
            Uri.parse(NetworkUrl.deviceTokenRegistrationURL),
            body: json.encode({
              "deviceId": {"inbox": token}
            })))
        .body);
  }

  static Future<Map<String, dynamic>> getAllUserEmailAddress(
      activeOrgId, activeUserId) async {
    String allUserEmailAddressAPI = NetworkUrl.AllUserEmailAddress;
    dynamic replaceUrl = allUserEmailAddressAPI
        .replaceFirst(':orgId', activeOrgId!)
        .replaceFirst(':userId', activeUserId!);
    return jsonDecode((await protectedClient.get(Uri.parse(replaceUrl))).body);
  }

  static Future<Map<String, dynamic>> getDefaultUserEmailAddress(
      activeOrgId, activeUserId) async {
    String allUserEmailAddressAPI = NetworkUrl.defaultUserEmailAddress;
    dynamic replaceUrl = allUserEmailAddressAPI
        .replaceFirst(':orgId', activeOrgId)
        .replaceFirst(':userId', activeUserId!);
    return jsonDecode((await protectedClient.get(Uri.parse(replaceUrl))).body);
  }

  static Future<Map<String, dynamic>> getCurretUser() async {
    return jsonDecode(
        (await protectedClient.get(Uri.parse(NetworkUrl.fetchCurrentUser)))
            .body);
  }

  static Future<Map<String, dynamic>> fetchOrgList() async {
    return jsonDecode(
        (await protectedClient.get(Uri.parse(NetworkUrl.allOrgList))).body);
  }

  static Future<Map<String, dynamic>> searchMailDelveUrl(
      query, mailOwnerName, activeOrgId) async {
    String mailurl = NetworkUrl.searchMailDelveUrl;
    dynamic replaceOrgUrl = mailurl
        .replaceFirst(':query', query)
        .replaceFirst(':mail-owner-name', mailOwnerName)
        .replaceFirst(':orgId', activeOrgId!);
    return jsonDecode(
        (await protectedClient.get(Uri.parse(replaceOrgUrl))).body);
  }

  static Future<Map<String, dynamic>> getMailViaId(mailId) async {
    String getMailViaIdUrl = NetworkUrl.searchMailById;
    dynamic replaceUrl = getMailViaIdUrl.replaceFirst(':id', mailId);
    return jsonDecode((await protectedClient.get(Uri.parse(replaceUrl))).body);
  }

  static Future<Response> changeMailCurrentTagAPI(mailId, model) {
    String changeMailCurrentTagURL = NetworkUrl.ChangeMailCurrentTag;
    return protectedClient.patch(Uri.parse(changeMailCurrentTagURL + mailId),
        body: json.encode(model));
  }

  static Future<Map<String, dynamic>> fileupload(String fileNames) async {
    String fileName = const Uuid().v1() + "-";
    fileName += fileNames;
    String upload = NetworkUrl.fileupload;
    return jsonDecode((await protectedClient.post(Uri.parse(upload),
            body: json.encode({
              "fileNames": [fileName]
            })))
        .body);
  }

  static Future<int> uploadFileInAWSWeb(
      String urlString, List<int> bytesList, String headerContentType) async {
    try {
      var res = await http.put(Uri.parse(urlString),
          body: bytesList, headers: {"Content-Type": headerContentType});
      return res.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
