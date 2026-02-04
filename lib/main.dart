import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  DateTime? dob;
  int years = 0, months = 0, days = 0;

  late AnimationController _controller;
  late Animation<double> _fadeScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeScale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  void calculateAge(DateTime birthDate) {
    final today = DateTime.now();

    int y = today.year - birthDate.year;
    int m = today.month - birthDate.month;
    int d = today.day - birthDate.day;

    if (d < 0) {
      m--;
      final prevMonth = DateTime(today.year, today.month, 0);
      d += prevMonth.day; // leap-year safe
    }

    if (m < 0) {
      y--;
      m += 12;
    }

    setState(() {
      years = y;
      months = m;
      days = d;
    });

    _controller.forward(from: 0);
  }

  void showCupertinoPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 45,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: dob ?? DateTime(2000),
                maximumDate: DateTime.now(),
                minimumYear: 1900,
                onDateTimeChanged: (date) {
                  dob = date;
                  calculateAge(date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Age Calculator'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _fadeScale,
              child: FadeTransition(
                opacity: _fadeScale,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Your Age 🎉',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$years years\n$months months\n$days days',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            CupertinoButton.filled(
              child: const Text("Select Date of Birth 🎂"),
              onPressed: showCupertinoPicker,
            ),

            if (dob != null) ...[
              const SizedBox(height: 15),
              Text(
                'DOB: ${dob!.day}-${dob!.month}-${dob!.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
