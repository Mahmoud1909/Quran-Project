import 'package:flutter/material.dart';
import 'dart:async';


Future<Map<String, List<String>>> fetchLocations() async {
  await Future.delayed(const Duration(seconds: 1));
  return {
    "United Kingdom": ["London", "Manchester", "Birmingham"],
    "Germany": ["Berlin", "Munich", "Frankfurt"],
    "France": ["Paris", "Lyon", "Marseille"],
    "Italy": ["Rome", "Milan", "Naples"],
    "Spain": ["Madrid", "Barcelona", "Valencia"],
    "Japan": ["Tokyo", "Osaka", "Kyoto"],
    "South Korea": ["Seoul", "Busan", "Incheon"],
    "India": ["Mumbai", "Delhi", "Bangalore"],
    "China": ["Beijing", "Shanghai", "Guangzhou"],
    "Singapore": ["Singapore", "Jurong", "Toa Payoh"],
    "United States": ["New York", "Los Angeles", "Chicago"],
    "Brazil": ["São Paulo", "Rio de Janeiro", "Brasília"],
    "Egypt": ["Cairo", "Alexandria", "Giza"],
    "Saudi Arabia": ["Riyadh", "Jeddah", "Mecca"],
    "United Arab Emirates": ["Dubai", "Abu Dhabi", "Sharjah"],
    "Jordan": ["Amman", "Irbid", "Zarqa"],
    "Lebanon": ["Beirut", "Tripoli", "Sidon"],
    "Kuwait": ["Kuwait City", "Salmiya", "Fahaheel"],
    "Oman": ["Muscat", "Salalah", "Sohar"],
    "Qatar": ["Doha", "Al Rayyan", "Al Wakrah"],
  };
}

class LocationDrawer extends StatefulWidget {
  final Function(String) onCountrySelected;
  final Function(String) onCitySelected;

  const LocationDrawer({
    Key? key,
    required this.onCountrySelected,
    required this.onCitySelected,
  }) : super(key: key);

  @override
  _LocationDrawerState createState() => _LocationDrawerState();
}

class _LocationDrawerState extends State<LocationDrawer> {
  @override
  Widget build(BuildContext context) {
    // استخدام SafeArea لتفادي المناطق المحجوزة
    return SafeArea(
      child: Drawer(
        child: FutureBuilder<Map<String, List<String>>>(
          future: fetchLocations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('no data'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('no data'));
            }
            final locations = snapshot.data!;
            return ListView(
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(color: Colors.brown),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Select Location",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                ExpansionPanelList.radio(
                  children: locations.entries.map((entry) {
                    return ExpansionPanelRadio(
                      value: entry.key,
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(entry.key),
                        );
                      },
                      body: Column(
                        children: entry.value.map((city) {
                          return ListTile(
                            title: Text(city),
                            onTap: () {
                              widget.onCountrySelected(entry.key);
                              widget.onCitySelected(city);
                              Navigator.of(context).pop();
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
