import 'package:flutter/material.dart';
import 'bill_form_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BillApp());
}

class BillApp extends StatefulWidget {
  const BillApp({super.key});

  @override
  State<BillApp> createState() => _BillAppState();
}

class _BillAppState extends State<BillApp> {
  bool isUrdu = true;

  void toggleLanguage() {
    setState(() {
      isUrdu = !isUrdu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abdul Majeed & Co - Bill',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC0392B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: BillFormScreen(
        isUrdu: isUrdu,
        onToggleLanguage: toggleLanguage,
      ),
    );
  }
}
