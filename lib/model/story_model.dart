class StoryModel {
  final String id;
  String title;
  String date;
  final String? assetImage;
  final String? localImagePath;
  final String city;

  StoryModel({
    required this.id,
    required this.title,
    required this.date,
    this.assetImage,
    this.localImagePath,
    required this.city,
  });
}

class CityModel {
  final String name;
  final String image;
  final String stateName;

  CityModel({
    required this.name,
    required this.image,
    required this.stateName,
  });
}

class StateModel {
  final String name;
  final String image;

  StateModel({
    required this.name,
    required this.image,
  });
}
