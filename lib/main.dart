import 'package:flutter/material.dart';
import 'config/app_constants.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuncakGearApp());
}

class MuncakGearApp extends StatelessWidget {
  const MuncakGearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const InitialHomeScreen(),
    );
  }
}

class InitialHomeScreen extends StatelessWidget {
  const InitialHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.terrain, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(AppConstants.appName, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  AppConstants.appTagline,
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hiking_rounded,
                  size: 72,
                  color: AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang di MuncakGear',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Aplikasi Rental Perlengkapan Mendaki Gunung & Alat Outdoor.\nUTS Pemrograman Mobile oleh ${AppConstants.studentName} (${AppConstants.studentNim})',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
