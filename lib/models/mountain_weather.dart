class MountainWeather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String condition;
  final String safetyStatus;
  final bool isSafeForHiking;

  MountainWeather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.condition,
    required this.safetyStatus,
    required this.isSafeForHiking,
  });

  factory MountainWeather.fromOpenMeteoJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'] as Map<String, dynamic>? ?? {};
    final temp = (currentWeather['temperature'] ?? 20.0).toDouble();
    final wind = (currentWeather['windspeed'] ?? 5.0).toDouble();
    final code = (currentWeather['weathercode'] ?? 0).toInt();

    String conditionDesc = 'Cerah';
    String safety = 'Aman Mendaki';
    bool safe = true;

    if (code == 0) {
      conditionDesc = 'Cerah Berawan';
    } else if (code <= 3) {
      conditionDesc = 'Sebagian Berawan';
    } else if (code <= 48) {
      conditionDesc = 'Berkabut Tebal';
      safety = 'Waspada Kabut & Jalur';
    } else if (code <= 65) {
      conditionDesc = 'Hujan Ringan';
      safety = 'Gunakan Raincoat';
    } else if (code <= 82) {
      conditionDesc = 'Hujan Deras';
      safety = 'Hindari Jalur Terjal';
      safe = false;
    } else {
      conditionDesc = 'Badai Petir';
      safety = 'Bahaya! Dilarang Mendaki';
      safe = false;
    }

    if (wind > 30.0) {
      safety = 'Angin Kencang di Puncak';
      safe = false;
    }

    return MountainWeather(
      temperature: temp,
      windSpeed: wind,
      weatherCode: code,
      condition: conditionDesc,
      safetyStatus: safety,
      isSafeForHiking: safe,
    );
  }
}
