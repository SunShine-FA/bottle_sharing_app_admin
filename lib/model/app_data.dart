import 'package:flutter/foundation.dart';
import 'package:bottle_sharing_app_admin/model/user_model.dart';
import 'package:bottle_sharing_app_admin/model/subadmin_model.dart';
import 'package:bottle_sharing_app_admin/model/story_model.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String? localImagePath;
  final String date;
  final String targetAudience;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    this.localImagePath,
    required this.date,
    this.targetAudience = "All Users",
  });
}

class AppData extends ChangeNotifier {
  static final AppData instance = AppData._internal();
  AppData._internal() {
    _initializeData();
  }

  // Admin Profile Info
  String adminName = "Alex Rodriguez";
  String adminEmail = "admin@sharebottle.com";

  // Users List
  final List<UserModel> _users = [];
  List<UserModel> get activeUsers =>
      _users.where((u) => !u.isBlocked).toList();
  List<UserModel> get blockedUsers =>
      _users.where((u) => u.isBlocked).toList();
  List<UserModel> get allUsers => List.unmodifiable(_users);

  // SubAdmins List
  final List<SubadminModel> _subadmins = [];
  List<SubadminModel> get subadmins => List.unmodifiable(_subadmins);

  // States List
  final List<StateModel> _states = [];
  List<StateModel> get states => List.unmodifiable(_states);

  // Cities List
  final List<CityModel> _cities = [];
  List<CityModel> get cities => List.unmodifiable(_cities);

  List<CityModel> citiesForState(String stateName) {
    return _cities.where((c) => c.stateName.toLowerCase() == stateName.toLowerCase()).toList();
  }

  // Stories List
  final List<StoryModel> _stories = [];
  List<StoryModel> get stories => List.unmodifiable(_stories);

  List<StoryModel> storiesForCity(String cityName) {
    return _stories.where((s) => s.city.toLowerCase() == cityName.toLowerCase()).toList();
  }

  // Notifications List
  final List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  void _initializeData() {
    // Initial users
    _users.addAll([
      UserModel(
        id: "u1",
        name: "Jacob Jones",
        phone: "(219) 555-0114",
        email: "jacob.jones@example.com",
        avatar: "assets/images/JacobJones.png",
        followers: "196",
        following: "17",
        totalPosts: "23",
      ),
      UserModel(
        id: "u2",
        name: "Cody Fisher",
        phone: "(239) 555-0108",
        email: "cody.fisher@example.com",
        avatar: "assets/images/CodyFisher.png",
        followers: "420",
        following: "88",
        totalPosts: "15",
      ),
      UserModel(
        id: "u3",
        name: "Leslie Alexander",
        phone: "(480) 555-0103",
        email: "leslie.alexander@example.com",
        avatar: "assets/images/LeslieAlexander.png",
        followers: "1.2k",
        following: "340",
        totalPosts: "42",
      ),
      UserModel(
        id: "u4",
        name: "Floyd Miles",
        phone: "(312) 555-0199",
        email: "floyd.miles@example.com",
        avatar: "assets/images/FloydMiles.png",
        followers: "512",
        following: "64",
        totalPosts: "19",
      ),
      UserModel(
        id: "u5",
        name: "Robert Fox",
        phone: "(602) 555-0177",
        email: "robert.fox@example.com",
        avatar: "assets/images/RobertFox.png",
        followers: "305",
        following: "45",
        totalPosts: "8",
      ),
      UserModel(
        id: "u6",
        name: "Darrell Steward",
        phone: "(702) 555-0144",
        email: "darrell.steward@example.com",
        avatar: "assets/images/DarrellSteward.png",
        followers: "880",
        following: "120",
        totalPosts: "31",
      ),
      UserModel(
        id: "u7",
        name: "Annette Black",
        phone: "(515) 555-0166",
        email: "annette.black@example.com",
        avatar: "assets/images/AnnetteBlack.png",
        followers: "640",
        following: "95",
        totalPosts: "14",
      ),
      UserModel(
        id: "u8",
        name: "Savannah Nguyen",
        phone: "(818) 555-0133",
        email: "savannah.nguyen@example.com",
        avatar: "assets/images/SavannahNguyen.png",
        followers: "990",
        following: "210",
        totalPosts: "27",
      ),
      // Blocked users
      UserModel(
        id: "u9",
        name: "John Doe",
        phone: "(219) 555-0114",
        email: "john.doe@example.com",
        avatar: "assets/images/JhoneDoe.jpg",
        isBlocked: true,
      ),
      UserModel(
        id: "u10",
        name: "Alex Jack",
        phone: "(239) 555-0108",
        email: "alex.jack@example.com",
        avatar: "assets/images/AlexJack.jpg",
        isBlocked: true,
      ),
      UserModel(
        id: "u11",
        name: "Sara Johnson",
        phone: "(480) 555-0103",
        email: "sara.johnson@example.com",
        avatar: "assets/images/SaraJohnson.jpg",
        isBlocked: true,
      ),
    ]);

    // Initial SubAdmins
    _subadmins.addAll([
      SubadminModel(
        id: "sa1",
        name: "Jacob Jones",
        email: "jacob.admin@sharebottle.com",
        permissions: SubadminPermissions(
          shareStory: true,
          seeUser: true,
          sendNotification: true,
          blockUser: true,
          deleteUserPost: true,
        ),
      ),
      SubadminModel(
        id: "sa2",
        name: "Cody Fisher",
        email: "cody.fisher@sharebottle.com",
        permissions: SubadminPermissions(
          shareStory: false,
          seeUser: true,
          sendNotification: false,
          blockUser: true,
          deleteUserPost: true,
        ),
      ),
      SubadminModel(
        id: "sa3",
        name: "Leslie Alexander",
        email: "leslie.alexander@sharebottle.com",
        permissions: SubadminPermissions(
          shareStory: true,
          seeUser: true,
          sendNotification: true,
          blockUser: false,
          deleteUserPost: false,
        ),
      ),
      SubadminModel(
        id: "sa4",
        name: "Floyd Miles",
        email: "floyd.miles@sharebottle.com",
        permissions: SubadminPermissions(
          shareStory: false,
          seeUser: true,
          sendNotification: false,
          blockUser: false,
          deleteUserPost: true,
        ),
      ),
    ]);

    // Initial States
    _states.addAll([
      StateModel(name: "Hawaii", image: "assets/images/Hawaii.png"),
      StateModel(name: "California", image: "assets/images/California.png"),
      StateModel(name: "Texas", image: "assets/images/Texas.png"),
      StateModel(name: "Florida", image: "assets/images/Florida.png"),
      StateModel(name: "Virginia", image: "assets/images/Virginia.png"),
      StateModel(name: "Alaska", image: "assets/images/Alaska.png"),
      StateModel(name: "Georgia", image: "assets/images/Georgia.png"),
      StateModel(name: "Washington", image: "assets/images/Washington.png"),
    ]);

    // Initial Cities (for Hawaii & others)
    _cities.addAll([
      CityModel(name: "Honolulu", image: "assets/images/Honolulu.png", stateName: "Hawaii"),
      CityModel(name: "Kailua-Kona", image: "assets/images/KailuaKona.png", stateName: "Hawaii"),
      CityModel(name: "Hilo", image: "assets/images/Hilo.png", stateName: "Hawaii"),
      CityModel(name: "Hawi", image: "assets/images/Hawi.png", stateName: "Hawaii"),
      CityModel(name: "Lahaina", image: "assets/images/Lahaina.png", stateName: "Hawaii"),
      CityModel(name: "Kailua", image: "assets/images/Kailua.png", stateName: "Hawaii"),
      CityModel(name: "Volcano", image: "assets/images/Volcano.png", stateName: "Hawaii"),
      CityModel(name: "Kahului", image: "assets/images/Kahului.png", stateName: "Hawaii"),

      // Other states default cities
      CityModel(name: "Los Angeles", image: "assets/images/California.png", stateName: "California"),
      CityModel(name: "San Francisco", image: "assets/images/California.png", stateName: "California"),
      CityModel(name: "Austin", image: "assets/images/Texas.png", stateName: "Texas"),
      CityModel(name: "Miami", image: "assets/images/Florida.png", stateName: "Florida"),
    ]);

    // Initial Stories
    _stories.addAll([
      StoryModel(
        id: "s1",
        title: "Drink Bar Club",
        date: "02 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub.png",
        city: "Hawi",
      ),
      StoryModel(
        id: "s2",
        title: "Sunset VIP Lounge",
        date: "02 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub1.png",
        city: "Hawi",
      ),
      StoryModel(
        id: "s3",
        title: "Neon Nights Bistro",
        date: "03 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub2.png",
        city: "Hawi",
      ),
      StoryModel(
        id: "s4",
        title: "Oceanview Terrace",
        date: "04 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub3.png",
        city: "Hawi",
      ),
      StoryModel(
        id: "s5",
        title: "Velvet Room Lounge",
        date: "05 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub4.png",
        city: "Hawi",
      ),
      StoryModel(
        id: "s6",
        title: "Paradise Club & Bar",
        date: "06 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub5.png",
        city: "Hawi",
      ),
      StoryModel(
        id: "s7",
        title: "Moonlight Party",
        date: "07 Sep, 2021",
        assetImage: "assets/images/DrinkBarClub6.png",
        city: "Hawi",
      ),
    ]);

    // Initial Notifications
    _notifications.addAll([
      NotificationItem(
        id: "n1",
        title: "New Club Partnership",
        description:
            "We have partnered with 5 premier rooftop lounges across Honolulu. Check the Stories tab!",
        date: "14/10/2026",
        targetAudience: "All Users",
      ),
      NotificationItem(
        id: "n2",
        title: "Bottle Sharing Guidelines",
        description:
            "Updated community safety policies and table sharing rules are now active.",
        date: "10/10/2026",
        targetAudience: "All Users",
      ),
      NotificationItem(
        id: "n3",
        title: "Weekend VIP Bottle Offer",
        description:
            "Exclusive 25% off champagne & craft spirits reservations this Saturday night.",
        date: "04/10/2026",
        targetAudience: "SubAdmins",
      ),
    ]);
  }

  // User Actions
  void blockUser(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index].isBlocked = true;
      notifyListeners();
    }
  }

  void unblockUser(String userId) {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index].isBlocked = false;
      notifyListeners();
    }
  }

  // Subadmin Actions
  void addSubadmin(SubadminModel subadmin) {
    _subadmins.add(subadmin);
    notifyListeners();
  }

  void removeSubadmin(String id) {
    _subadmins.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void updateSubadminPermissions(String id, SubadminPermissions permissions) {
    final index = _subadmins.indexWhere((s) => s.id == id);
    if (index != -1) {
      _subadmins[index].permissions = permissions;
      notifyListeners();
    }
  }

  // States & Cities Actions
  void addState(StateModel state) {
    _states.add(state);
    notifyListeners();
  }

  void addCity(CityModel city) {
    _cities.add(city);
    notifyListeners();
  }

  // Stories Actions
  void addStory(StoryModel story) {
    _stories.insert(0, story);
    notifyListeners();
  }

  void deleteStory(String id) {
    _stories.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void editStory(String id, String newTitle, String newDate) {
    final index = _stories.indexWhere((s) => s.id == id);
    if (index != -1) {
      _stories[index].title = newTitle;
      _stories[index].date = newDate;
      notifyListeners();
    }
  }

  // Notifications Actions
  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  // Admin Profile Update
  void updateAdminProfile(String name, String email) {
    adminName = name;
    adminEmail = email;
    notifyListeners();
  }
}
