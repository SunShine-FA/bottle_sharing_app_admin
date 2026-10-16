import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/model/story_model.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_cities.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_create_story.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenStories extends StatefulWidget {
  const ScreenStories({super.key});

  @override
  State<ScreenStories> createState() => _ScreenStoriesState();
}

class _ScreenStoriesState extends State<ScreenStories> {
  final AppData appData = AppData.instance;

  final List<Map<String, String>> presetStates = [
    {'name': 'New York', 'image': 'assets/images/California.png'},
    {'name': 'Nevada', 'image': 'assets/images/Texas.png'},
    {'name': 'Illinois', 'image': 'assets/images/Florida.png'},
    {'name': 'Colorado', 'image': 'assets/images/Washington.png'},
    {'name': 'Arizona', 'image': 'assets/images/Georgia.png'},
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

  void _showAddStateDialog(BuildContext context) {
    Map<String, String>? selectedPreset = presetStates.first;
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
                    const Text(
                      'Add New State',
                      style: TextStyle(
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
                          items: presetStates.map((state) {
                            return DropdownMenuItem<Map<String, String>>(
                              value: state,
                              child: Text(state['name']!),
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
                        hintText: "Or type a custom state name",
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
                              : selectedPreset?['name'] ?? 'New State';
                          final image = selectedPreset?['image'] ??
                              'assets/images/California.png';

                          appData.addState(StateModel(
                            name: name,
                            image: image,
                          ));

                          // Also create a default capital city for this state
                          appData.addCity(CityModel(
                            name: "$name Metro",
                            image: image,
                            stateName: name,
                          ));

                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$name added to available regions."),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Add State'),
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
    final states = appData.states;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButton(
        titleWidget: const Text(
          "My Stories",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddStateDialog(context),
            icon: const Icon(Icons.add_circle, color: Colors.black, size: 20),
            label: const Text(
              "Add State",
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
        itemCount: states.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Add Story For All Card
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ScreenCreateStory(
                      defaultCity: "Honolulu",
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

          final state = states[index - 1];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ScreenCities(stateName: state.name),
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
                            state.image,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.map, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
                    child: Text(
                      state.name,
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
