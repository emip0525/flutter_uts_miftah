import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../providers/gear_provider.dart';
import '../widgets/gear_card.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/loading_state.dart';
import '../widgets/error_state.dart';
import '../widgets/empty_state.dart';
import 'create_rental_screen.dart';
import 'add_gear_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gearProvider = Provider.of<GearProvider>(context);
    final columns = ResponsiveLayout.getGridCrossAxisCount(
      context,
      compactCount: 2,
      wideCount: 3,
      desktopCount: 4,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Alat Outdoor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            tooltip: 'Tambah Alat Baru ke Katalog',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddGearScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            tooltip: 'Sewa Baru',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateRentalScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Alat', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddGearScreen()),
          );
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => gearProvider.loadGears(),
        color: AppConstants.primaryGreen,
        child: CustomScrollView(
          slivers: [
            // Search Bar & Sort Dropdown
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => gearProvider.setSearchQuery(value),
                      decoration: InputDecoration(
                        hintText: 'Cari tenda, carrier, kompor, merk...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  gearProvider.setSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Menampilkan ${gearProvider.filteredGears.length} alat',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.sort, size: 18, color: AppConstants.primaryGreen),
                            const SizedBox(width: 4),
                            DropdownButton<String>(
                              value: gearProvider.sortBy,
                              underline: const SizedBox.shrink(),
                              icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.primaryGreen,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'popular', child: Text('Terpopuler')),
                                DropdownMenuItem(value: 'rating', child: Text('Rating Tertinggi')),
                                DropdownMenuItem(value: 'price_asc', child: Text('Harga Terendah')),
                                DropdownMenuItem(value: 'price_desc', child: Text('Harga Tertinggi')),
                              ],
                              onChanged: (val) {
                                if (val != null) gearProvider.setSortBy(val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Category Chips Row
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: gearProvider.categories.map((cat) {
                    final isSelected = gearProvider.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppConstants.primaryGreen,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) gearProvider.setCategory(cat);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // State Handling: Loading, Error, Empty, or Grid
            if (gearProvider.isLoading && gearProvider.gears.isEmpty)
              const SliverFillRemaining(
                child: LoadingState(message: 'Memuat katalog alat outdoor via REST API...'),
              )
            else if (gearProvider.errorMessage != null && gearProvider.gears.isEmpty)
              SliverFillRemaining(
                child: ErrorState(
                  message: gearProvider.errorMessage!,
                  onRetry: () => gearProvider.loadGears(),
                ),
              )
            else if (gearProvider.filteredGears.isEmpty)
              SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.search_off,
                  title: 'Alat Tidak Ditemukan',
                  message: 'Tidak ada alat outdoor yang cocok dengan kriteria pencarian atau kategori ini.',
                  actionLabel: 'Tampilkan Semua Alat',
                  onAction: () {
                    _searchController.clear();
                    gearProvider.setSearchQuery('');
                    gearProvider.setCategory('Semua');
                  },
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final gear = gearProvider.filteredGears[index];
                      return GearCard(gear: gear);
                    },
                    childCount: gearProvider.filteredGears.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
