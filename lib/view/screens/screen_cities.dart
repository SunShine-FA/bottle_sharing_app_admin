import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/model/story_model.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_city_stories.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_create_story.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenCities extends StatefulWidget {
  final String stateName;

  const ScreenCities({
    super.key,
    this.stateName = "Hawaii",
  });

  @override
  State<ScreenCities> createState() => _ScreenCitiesState();
}

class _ScreenCitiesState extends State<ScreenCities> {
  final AppData appData = AppData.instance;

  final List<Map<String, String>> presetCities = [
    {'name': 'Honolulu', 'image': 'assets/images/Honolulu.png'},
    {'name': 'Lahaina', 'image': 'assets/images/Lahaina.png'},
    {'name': 'Kahului', 'image': 'assets/images/Kahului.png'},
    {'name': 'Volcano', 'image': 'assets/images/Volcano.png'},
    {'name': 'Kailua', 'image': 'assets/images/Kailua.png'},
    {'name': 'Hilo', 'image': 'assets/images/Hilo.png'},
  ];

  @override
  void initState() {
    super.initState();
    appData.addListener(_onAppDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(_onAppDataChanged);
    super.dispose();
  }

  void _onAppDataChanged() {
    if (mounted) setState(() {});
  }

  void _showAddCityDialog(BuildContext context) {
    Map<String, String>? selectedPreset = presetCities.first;
    final customNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add City to ${widget.stateName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Map<String, String>>(
                          isExpanded: true,
                          value: selectedPreset,
                          items: presetCities.map((city) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: city,
                              child: Text(city['name']!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              selectedPreset = value;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: customNameController,
                      decoration: const InputDecoration(
                        hintText: "Or type a custom city name",
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = customNameController.text.trim().isNotEmpty
                              ? customNameController.text.trim()
                              : selectedPreset?['name'] ?? 'New City';
                          final image = selectedPreset?['image'] ??
                              'assets/images/Honolulu.png';

                          appData.addCity(CityModel(
                            name: name,
                            image: image,
                            stateName: widget.stateName,
                          ));

                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$name added to ${widget.stateName}."),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Add City'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cities = appData.citiesForState(widget.stateName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButton(
        titleWidget: Text(
          "${widget.stateName} Cities",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddCityDialog(context),
            icon: const Icon(Icons.add_circle, color: Colors.black, size: 20),
            label: const Text(
              "Add City",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: cities.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Add Story For All
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScreenCreateStory(
                      defaultCity: cities.isNotEmpty ? cities.first.name : "Honolulu",
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(blurRadius: 6, color: Colors.black12),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
                    SizedBox(height: 8),
                    Text(
                      "Add Story\nFor All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final city = cities[index - 1];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScreenCityStories(cityName: city.name),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: const [
                  BoxShadow(blurRadius: 6, color: Colors.black12, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            city.image,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.location_city, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: Text(
                      city.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
