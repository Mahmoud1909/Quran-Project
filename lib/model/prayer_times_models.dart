
class PrayerTimesResponse {
  final HijriDate hijriDate;
  final PrayerTimings timings;

  // Constructor for PrayerTimesResponse.
  PrayerTimesResponse({
    required this.hijriDate,
    required this.timings,
  });

  // Factory method to create a PrayerTimesResponse instance from JSON.
  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    // The API response contains a "data" field that holds the relevant data.
    final data = json['data'];
    return PrayerTimesResponse(
      hijriDate: HijriDate.fromJson(data['date']['hijri']),
      timings: PrayerTimings.fromJson(data['timings']),
    );
  }
}

// Model class for Hijri Date information.
class HijriDate {
  final String date; // e.g., "04-02-1443"
  final String format;
  final String day;
  final Weekday weekday;
  final Month month;
  final String year;
  final Designation designation;
  final List<String> holidays;

  // Constructor for HijriDate.
  HijriDate({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
  });

  // Factory method to create a HijriDate instance from JSON.
  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date'] as String,
      format: json['format'] as String,
      day: json['day'] as String,
      weekday: Weekday.fromJson(json['weekday']),
      month: Month.fromJson(json['month']),
      year: json['year'] as String,
      designation: Designation.fromJson(json['designation']),
      holidays: List<String>.from(json['holidays'] ?? []),
    );
  }
}

// Model class for Weekday information.
class Weekday {
  final String en; // Weekday in English.
  final String? ar; // Weekday in Arabic (optional).

  // Constructor for Weekday.
  Weekday({
    required this.en,
    this.ar,
  });

  // Factory method to create a Weekday instance from JSON.
  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(
      en: json['en'] as String,
      ar: json['ar'] as String?,
    );
  }
}

// Model class for Month information.
class Month {
  final int number; // The numerical representation of the month.
  final String en; // Month name in English.
  final String? ar; // Month name in Arabic (optional).

  // Constructor for Mo
  // nth.
  Month({
    required this.number,
    required this.en,
    this.ar,
  });

  // Factory method to create a Month instance from JSON.
  factory Month.fromJson(Map<String, dynamic> json) {
    return Month(
      // Convert number to int if necessary.
      number: json['number'] is int
          ? json['number'] as int
          : int.tryParse(json['number'].toString()) ?? 0,
      en: json['en'] as String,
      ar: json['ar'] as String?,
    );
  }
}

// Model class for Designation information (e.g., AD/AH).
class Designation {
  final String abbreviated; // Abbreviated form (e.g., "AH").
  final String expanded;    // Expanded form (e.g., "After Hijrah").

  // Constructor for Designation.
  Designation({
    required this.abbreviated,
    required this.expanded,
  });

  // Factory method to create a Designation instance from JSON.
  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(
      abbreviated: json['abbreviated'] as String,
      expanded: json['expanded'] as String,
    );
  }
}

// Model class for Prayer Timings.
class PrayerTimings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;

  // Constructor for PrayerTimings.
  PrayerTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
  });

  // Factory method to create a PrayerTimings instance from JSON.
  factory PrayerTimings.fromJson(Map<String, dynamic> json) {
    return PrayerTimings(
      fajr: json['Fajr'] as String,
      sunrise: json['Sunrise'] as String,
      dhuhr: json['Dhuhr'] as String,
      asr: json['Asr'] as String,
      sunset: json['Sunset'] as String,
      maghrib: json['Maghrib'] as String,
      isha: json['Isha'] as String,
      imsak: json['Imsak'] as String,
      midnight: json['Midnight'] as String,
    );
  }
}
