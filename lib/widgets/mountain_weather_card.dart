import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../providers/gear_provider.dart';

class MountainWeatherCard extends StatelessWidget {
  const MountainWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final gearProvider = Provider.of<GearProvider>(context);

    if (gearProvider.isLoadingWeather) {
      return Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppConstants.primaryGreen),
              ),
              SizedBox(width: 12),
              Text('Mengambil data cuaca live via REST API...', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    }

    if (gearProvider.weatherError != null && gearProvider.weather == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off, color: Colors.redAccent, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                gearProvider.weatherError!,
                style: const TextStyle(fontSize: 12, color: Colors.redAccent),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 18, color: Colors.redAccent),
              onPressed: () => gearProvider.loadWeather(),
            ),
          ],
        ),
      );
    }

    final weather = gearProvider.weather;
    if (weather == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF264653),
            AppConstants.secondaryGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.cloud_outlined, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Info Cuaca Puncak (REST API)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: weather.isSafeForHiking
                      ? Colors.greenAccent.shade700
                      : AppConstants.accentOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  weather.safetyStatus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    weather.condition,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.air, color: Colors.white70, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.windSpeed.toStringAsFixed(1)} km/h',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
