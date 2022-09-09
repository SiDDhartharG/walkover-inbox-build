class MailItem {
  String title, description, content, time, currentTag;
  bool isRead, showDateHeader;
  MailItem({
    required this.title,
    required this.currentTag,
    required this.description,
    required this.content,
    required this.isRead,
    required this.time,
    required this.showDateHeader,
  });
}

double mySize = 0.0;
double kPadding = mySize * 0.025;
List<MailItem> mailList = [
  MailItem(
    title: 'Google',
    description: 'This mail is from Google',
    content: 'Dummy content for the mail App!',
    currentTag: 'YOURS',
    time: 'Today',
    isRead: true,
    showDateHeader: true,
  ),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'YOURS',
      time: 'Today',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'YOURS',
      time: 'Yesterday',
      isRead: false,
      showDateHeader: true),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'YOURS',
      time: 'Yesterday',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: true),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Jugnoo',
      description: 'This mail is from Jugnoo',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Ninza',
      description: 'This mail is from Ninza',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Ninza',
      description: 'This mail is from Ninza',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
  MailItem(
      title: 'Google',
      description: 'This mail is from Google',
      content: 'Dummy content for the mail App!',
      currentTag: 'ALL',
      time: 'Previous',
      isRead: false,
      showDateHeader: false),
];
