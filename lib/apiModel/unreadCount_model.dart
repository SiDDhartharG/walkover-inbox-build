class UserUnreadCountModel {
  String _mailOwner;
  bool _count;

  String get userId => _mailOwner;
  bool get count => _count;

  userEmailAddresses({
    String mailOwner,
    bool count,
  }) {
    _mailOwner = mailOwner;
    _count = count;
  }

  UserUnreadCountModel.fromJson(dynamic json) {
    _mailOwner = json['mail_owner'];
    _count = json['count'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['mail_owner'] = _mailOwner;
    map['count'] = _count;
    return map;
  }
}
