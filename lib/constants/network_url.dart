import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkUrl {
  static final BaseUrl = dotenv.env['AUTH_SERVER_URL'];
  static final InboxUrl = dotenv.env['INBOX_UI_URL'];
  static final AuthUrl = dotenv.env['AUTH_UI_URL'];
  static final RenderUrl = dotenv.env['INBOX_RENDER_URL'];
  static final fileupload = '$BaseUrl/chat/fileUpload';

  static final String AllMAil =
      '$BaseUrl/inbox/email-sender-receiver/?mail_owner=:mail-owner&current_tag=:currentTag&\$limit=100&\$skip=:skip';
  static final String defaultUserEmailAddress =
      '$BaseUrl/inbox/user-email-address?orgId=:orgId&user_id=:userId&status=active&default=true';
  static final String AllUserEmailAddress =
      '$BaseUrl/inbox/user-email-address?orgId=:orgId&user_id=:userId&status=active';
  static final String ChangeMailCurrentTag =
      '$BaseUrl/inbox/email-sender-receiver/';
  static final String fetchCurrentUser = '$BaseUrl/users?getCurrentUser=true';
  static final String creatMail = '$BaseUrl/inbox/mail';
  static final String publicKey = '$BaseUrl/public-key';
  static final String fetchTokenViaLogin = '$BaseUrl/login';
  static final String sendResetPasswordEmail = '$BaseUrl/user-reset-password';
  static final String allOrgList = '$BaseUrl/users?followedOrgs=true';
  // static final String signOut =
  //     '$AuthUrl?action=signout';
  // static final String login =
  //     '$AuthUrl/?redirect_to=spaceinbox://$InboxUrl&skipURLProtocol=true';
  // static final String signOut = '$AuthUrl?action=signout';
  static final String signOut =
      '$AuthUrl/?redirect_to=spaceinbox:%2F%2Finbox.intospace.io&skipURLProtocol=true';
  static final String login =
      '$AuthUrl/?redirect_to=spaceinbox:%2F%2Finbox.intospace.io&skipURLProtocol=true';
  static final String searchMailById =
      '$BaseUrl/inbox/email-sender-receiver/:id';
  static final String deviceTokenRegistrationURL =
      '$BaseUrl/users/deviceGroups';
  static final String searchMailDelveUrl =
      '$BaseUrl/inbox/email-search?query=:query&orgId=:orgId&size=100&page=1&mail_owner=:mail-owner-name';
}
