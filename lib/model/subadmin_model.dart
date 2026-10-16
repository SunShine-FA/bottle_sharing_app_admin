class SubadminPermissions {
  bool shareStory;
  bool seeUser;
  bool sendNotification;
  bool blockUser;
  bool deleteUserPost;

  SubadminPermissions({
    this.shareStory = false,
    this.seeUser = true,
    this.sendNotification = false,
    this.blockUser = true,
    this.deleteUserPost = true,
  });

  SubadminPermissions copyWith({
    bool? shareStory,
    bool? seeUser,
    bool? sendNotification,
    bool? blockUser,
    bool? deleteUserPost,
  }) {
    return SubadminPermissions(
      shareStory: shareStory ?? this.shareStory,
      seeUser: seeUser ?? this.seeUser,
      sendNotification: sendNotification ?? this.sendNotification,
      blockUser: blockUser ?? this.blockUser,
      deleteUserPost: deleteUserPost ?? this.deleteUserPost,
    );
  }
}

class SubadminModel {
  final String id;
  String name;
  String email;
  SubadminPermissions permissions;

  SubadminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.permissions,
  });
}
