import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../providers/gear_provider.dart';
import '../providers/rental_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showDatabaseSchemaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.storage, color: AppConstants.primaryGreen),
            SizedBox(width: 8),
            Text('Skema Database Supabase', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Tabel: rental_bookings (PostgreSQL)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• id (UUID, PK)\n'
                '• student_id (VARCHAR: 2415051011)\n'
                '• customer_name (VARCHAR)\n'
                '• customer_phone (VARCHAR)\n'
                '• gear_id (VARCHAR)\n'
                '• gear_name (VARCHAR)\n'
                '• rental_days (INTEGER)\n'
                '• start_date (VARCHAR)\n'
                '• return_date (VARCHAR)\n'
                '• total_price (NUMERIC)\n'
                '• note (TEXT)\n'
                '• status (VARCHAR: Aktif/Selesai/Dibatalkan)\n'
                '• created_at (TIMESTAMP WITH TIMEZONE)',
                style: TextStyle(fontSize: 12, height: 1.5, fontFamily: 'monospace'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang UTS'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Student Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppConstants.primaryGreen, AppConstants.secondaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: AppConstants.primaryGreen.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    AppConstants.studentName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: ${AppConstants.studentNim} • Kelas ${AppConstants.studentClass}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pendidikan Teknik Informatika - Undiksha',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Course & Lecturer Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Akademik Project',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('Mata Kuliah', AppConstants.courseName),
                    _buildInfoRow('Dosen Pengampu', AppConstants.lecturerName),
                    _buildInfoRow('Teaching Assistant', AppConstants.teachingAssistant),
                    _buildInfoRow('Tema Project', AppConstants.appTagline),
                    _buildInfoRow('Sifat Tugas', 'Individual Project (UTS)'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Architecture & Tech Stack Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spesifikasi Teknis Aplikasi',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 20),
                    _buildInfoRow('State Management', 'Provider + ChangeNotifier'),
                    _buildInfoRow('Arsitektur', 'Layered Architecture (UI-State-Repo-Service)'),
                    _buildInfoRow('REST API', 'Open-Meteo Summit Weather & Gear Catalog API'),
                    _buildInfoRow('Database Backend', 'Supabase PostgreSQL + Local Storage Fallback'),
                    _buildInfoRow('Responsive Mode', 'MediaQuery & LayoutBuilder (Compact & Wide)'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.table_chart_outlined, size: 18),
                    label: const Text('Skema DB', style: TextStyle(fontSize: 13)),
                    onPressed: () => _showDatabaseSchemaDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.sync, size: 18),
                    label: const Text('Segarkan API', style: TextStyle(fontSize: 13)),
                    onPressed: () async {
                      final gear = Provider.of<GearProvider>(context, listen: false);
                      final rent = Provider.of<RentalProvider>(context, listen: false);
                      await gear.loadGears();
                      await gear.loadWeather();
                      await rent.fetchBookings();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Seluruh data API dan Database berhasil disinkronkan!'),
                            backgroundColor: AppConstants.primaryGreen,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
