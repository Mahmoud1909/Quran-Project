import 'package:flutter/material.dart';
import 'package:quran_project/data/location_drawer.dart';
import 'package:quran_project/widgets/azkar_widget.dart';
import 'package:quran_project/widgets/prayer_times_widget.dart';
import 'package:quran_project/widgets/quran_widget.dart';
import 'package:quran_project/widgets/tasks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int current = 0;
  String selectedCountry = "Egypt";
  String selectedCity = "Cairo";

  final List<String> titles = [
    "Prayer Times",
    "Quran",
    "Tasks",
    "Azkar",
  ];

  @override
  Widget build(BuildContext context) {
    print("DEBUG: HomeScreen build -> selectedCity: $selectedCity, selectedCountry: $selectedCountry, current: $current");
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[current]),
        backgroundColor: Colors.brown,
      ),
      drawer: current == 0
          ? LocationDrawer(
        onCountrySelected: (country) {
          setState(() {
            selectedCountry = country;
          });
        },
        onCitySelected: (city) {
          setState(() {
            selectedCity = city;
            current = 0;
          });
          Navigator.of(context).pop();
        },
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFFD7DCDF),
        onTap: (int index) {
          print("DEBUG: BottomNavigationBar tapped -> index: $index");
          setState(() {
            current = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.brown,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Prayer Times",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Quran",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: "Azkar",
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          print("DEBUG: Building body for tab index: $current");
          switch (current) {
            case 0:
              print("DEBUG: Displaying PrayerTimesWidget with city: $selectedCity, country: $selectedCountry");
              return PrayerTimesWidget(
                key: ValueKey("$selectedCity-$selectedCountry"),
                city: selectedCity,
                country: selectedCountry,
              );
            case 1:
              print("DEBUG: Displaying QuranWidget");
              return const QuranWidget();
            case 2:
              print("DEBUG: Displaying TasksWidget");
              return const TasksWidget();
            case 3:
              print("DEBUG: Displaying AzkarWidget");
              return const AzkarWidget();
            default:
              print("DEBUG: Displaying Default Container");
              return Container();
          }
        },
      ),
    );
  }
}
