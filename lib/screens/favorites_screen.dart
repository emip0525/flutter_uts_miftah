import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../providers/favorite_provider.dart';
import '../providers/gear_provider.dart';
import '../utils/formatters.dart';
import 'gear_detail_screen.dart';
import 'create_rental_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gearProvider = Provider.of<GearProvider>(context);
    final favProvider = Provider.of<FavoriteProvider>(context);
    final favoriteGears = favProvider.filterFavoriteGears(gearProvider.gears);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist & Favorit'),
      ),
      body: favoriteGears.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppConstants.accentOrange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: AppConstants.accentOrange,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Wishlist Anda Masih Kosong',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Simpan peralatan mendaki favorit Anda dengan menekan ikon hati pada katalog agar mudah ditemukan saat siap disewa.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600, height: 1.4),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteGears.length,
              itemBuilder: (context, index) {
                final gear = favoriteGears[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GearDetailScreen(gear: gear),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              gear.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 80,
                                height: 80,
                                color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                                child: const Icon(Icons.terrain, color: AppConstants.primaryGreen),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  gear.brand.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  gear.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${Formatters.formatCurrency(gear.pricePerDay)} / hari',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppConstants.primaryGreen,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CreateRentalScreen(initialGear: gear),
                                          ),
                                        );
                                      },
                                      child: const Text('Sewa Sekarang', style: TextStyle(fontSize: 12)),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                      tooltip: 'Hapus dari wishlist',
                                      onPressed: () {
                                        favProvider.toggleFavorite(gear.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('"${gear.name}" dihapus dari wishlist.'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
