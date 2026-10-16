class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String avatar;
  final String dateOfBirth;
  final String followers;
  final String following;
  final String totalPosts;
  bool isBlocked;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.avatar,
    this.dateOfBirth = "16 Jan, 2002",
    this.followers = "196",
    this.following = "17",
    this.totalPosts = "23",
    this.isBlocked = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? avatar,
    String? dateOfBirth,
    String? followers,
    String? following,
    String? totalPosts,
    bool? isBlocked,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      totalPosts: totalPosts ?? this.totalPosts,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
