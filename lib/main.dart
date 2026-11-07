import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_constants.dart';
import 'theme/app_theme.dart';
import 'providers/gear_provider.dart';
import 'providers/rental_provider.dart';
import 'providers/favorite_provider.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MuncakGearApp());
}

class MuncakGearApp extends StatelessWidget {
  const MuncakGearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GearProvider()),
        ChangeNotifierProvider(create: (_) => RentalProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
