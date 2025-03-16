import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_project/API/prayer_times_service.dart';
import 'package:quran_project/model/prayer_times_models.dart';
import 'dart:ui' as ui;

class PrayerTimesWidget extends StatefulWidget {
  final String city;
  final String country;

  const PrayerTimesWidget({Key? key, required this.city, required this.country})
      : super(key: key);

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  PrayerTimesResponse? prayerTimes;
  Duration remainingTime = Duration.zero;
  String nextPrayer = "";
  DateTime? nextPrayerDateTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  @override
  void didUpdateWidget(covariant PrayerTimesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("PrayerTimesWidget didUpdateWidget: old key: ${oldWidget.key}, new key: ${widget.key}");
    if (oldWidget.city != widget.city || oldWidget.country != widget.country) {
      _timer?.cancel();
      _fetchPrayerTimes();
    }
  }

  Future<void> _fetchPrayerTimes() async {
    prayerTimes = await fetchPrayerTimes(city: widget.city, country: widget.country);
    if (prayerTimes != null) {
      _updateNextPrayer();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          _timer?.cancel();
          return;
        }
        setState(() {
          _updateNextPrayer();
          if (remainingTime.inSeconds <= 0) {
            _fetchPrayerTimes();
          }
        });
      });
    }
    setState(() {});
  }

  void _updateNextPrayer() {
    if (prayerTimes == null) return;
    final now = DateTime.now();
    final timings = prayerTimes!.timings;
    final prayerSchedule = {
      "Fajr": _parseTime(timings.fajr),
      "Dhuhr": _parseTime(timings.dhuhr),
      "Asr": _parseTime(timings.asr),
      "Maghrib": _parseTime(timings.maghrib),
      "Isha": _parseTime(timings.isha),
    };
    List<MapEntry<String, DateTime>> sortedPrayers = prayerSchedule.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    for (var entry in sortedPrayers) {
      if (now.isBefore(entry.value)) {
        nextPrayer = entry.key;
        remainingTime = entry.value.difference(now);
        nextPrayerDateTime = entry.value;
        return;
      }
    }
    nextPrayer = sortedPrayers.first.key;
    nextPrayerDateTime = sortedPrayers.first.value.add(const Duration(days: 1));
    remainingTime = nextPrayerDateTime!.difference(now);
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final parsedTime = DateFormat("HH:mm").parse(time);
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  }

  String _formatDuration(Duration duration) {
    return "${duration.inHours.toString().padLeft(2, '0')}:"
        "${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:"
        "${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showPrayerTimesDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Prayer times", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildPrayerContainer("Fajr", prayerTimes!.timings.fajr, Icons.wb_twilight),
              _buildPrayerContainer("Dhuhr", prayerTimes!.timings.dhuhr, Icons.wb_sunny),
              _buildPrayerContainer("Asr", prayerTimes!.timings.asr, Icons.wb_cloudy),
              _buildPrayerContainer("Maghrib", prayerTimes!.timings.maghrib, Icons.nights_stay),
              _buildPrayerContainer("Isha", prayerTimes!.timings.isha, Icons.brightness_3),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerContainer(String prayerName, String time, IconData icon) {
    DateTime timeValue = _parseTime(time);
    String formattedTime = DateFormat("hh:mm a").format(timeValue);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(prayerName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          Text(formattedTime, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("PrayerTimesWidget is building with key: ${widget.key}");
    if (prayerTimes == null) {
      return Center(child: Text('No data'));
    }
    if (nextPrayerDateTime == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("images/pexels-a-darmel-8164743.jpg", fit: BoxFit.cover),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: const Icon(Icons.location_on, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.city, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                  IconButton(
                    onPressed: _showPrayerTimesDetails,
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AnalogClock(nextPrayerDateTime: nextPrayerDateTime!),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(nextPrayer, style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(DateFormat("hh:mm a").format(nextPrayerDateTime!), style: const TextStyle(color: Colors.black, fontSize: 22)),
                  Text(_formatDuration(remainingTime), style: const TextStyle(color: Colors.black, fontSize: 22)),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

class AnalogClock extends StatelessWidget {
  final DateTime nextPrayerDateTime;

  const AnalogClock({Key? key, required this.nextPrayerDateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: CustomPaint(
        painter: ClockPainter(nextPrayerDateTime: nextPrayerDateTime),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime nextPrayerDateTime;

  ClockPainter({required this.nextPrayerDateTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final fillPaint = Paint()
      ..shader = ui.Gradient.radial(center, radius, [Colors.black87, Colors.black])
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);
    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30) * pi / 180 - pi / 2;
      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      final offset = Offset(
        center.dx + (radius - 25) * cos(angle) - textPainter.width / 2,
        center.dy + (radius - 25) * sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    }
    final now = DateTime.now();
    double currentAngle = (((now.hour % 12) + now.minute / 60 + now.second / 3600) * 30) * pi / 180 - pi / 2;
    double prayerAngle = (((nextPrayerDateTime.hour % 12) + nextPrayerDateTime.minute / 60 + nextPrayerDateTime.second / 3600) * 30) * pi / 180 - pi / 2;
    if (prayerAngle < currentAngle) {
      prayerAngle += 2 * pi;
    }
    final arcPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius - 10), currentAngle, prayerAngle - currentAngle, false, arcPaint);
    final hourAngle = (((now.hour % 12) + now.minute / 60 + now.second / 3600) * 30) * pi / 180 - pi / 2;
    final hourHandPaint = Paint()..color = Colors.white..strokeWidth = 6..strokeCap = StrokeCap.round;
    final hourHandLength = radius * 0.5;
    canvas.drawLine(center, Offset(center.dx + hourHandLength * cos(hourAngle), center.dy + hourHandLength * sin(hourAngle)), hourHandPaint);
    final minuteAngle = (now.minute * 6 + now.second * 0.1) * pi / 180 - pi / 2;
    final minuteHandPaint = Paint()..color = Colors.white..strokeWidth = 4..strokeCap = StrokeCap.round;
    final minuteHandLength = radius * 0.7;
    canvas.drawLine(center, Offset(center.dx + minuteHandLength * cos(minuteAngle), center.dy + minuteHandLength * sin(minuteAngle)), minuteHandPaint);
    final secondsAngle = (now.second * 6) * pi / 180 - pi / 2;
    final secondsHandPaint = Paint()..color = Colors.red..strokeWidth = 2..strokeCap = StrokeCap.round;
    final secondsHandLength = radius * 0.8;
    canvas.drawLine(center, Offset(center.dx + secondsHandLength * cos(secondsAngle), center.dy + secondsHandLength * sin(secondsAngle)), secondsHandPaint);
    final centerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 5, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) => true;
}
