import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case 'Aktif':
        bg = AppConstants.primaryGreen.withValues(alpha: 0.12);
        fg = AppConstants.primaryGreen;
        icon = Icons.timer_outlined;
        break;
      case 'Selesai':
        bg = Colors.blue.withValues(alpha: 0.12);
        fg = Colors.blue.shade700;
        icon = Icons.check_circle_outline;
        break;
      case 'Dibatalkan':
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red.shade700;
        icon = Icons.cancel_outlined;
        break;
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey.shade800;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
