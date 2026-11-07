import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../models/outdoor_gear.dart';
import '../providers/gear_provider.dart';
import '../widgets/custom_text_field.dart';

class AddGearScreen extends StatefulWidget {
  const AddGearScreen({super.key});

  @override
  State<AddGearScreen> createState() => _AddGearScreenState();
}

class _AddGearScreenState extends State<AddGearScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _stockController = TextEditingController(text: '5');
  final _imageUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800',
  );
  final _descController = TextEditingController();
  final _capacityController = TextEditingController(text: '4 Orang');
  final _weightController = TextEditingController(text: '2.5 kg');

  String _selectedCategory = 'Tenda & Shelter';
  bool _isSaving = false;

  // Galeri foto outdoor berkualitas tinggi
  static const List<Map<String, String>> photoPresets = [
    {
      'title': 'Tenda Dome',
      'url': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800',
    },
    {
      'title': 'Tenda Camp',
      'url': 'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=800',
    },
    {
      'title': 'Carrier Deuter',
      'url': 'https://images.unsplash.com/photo-1622260614153-03223fb72052?w=800',
    },
    {
      'title': 'Carrier Merah',
      'url': 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
    },
    {
      'title': 'Sleeping Bag',
      'url': 'https://images.unsplash.com/photo-1517824806704-9040b037703b?w=800',
    },
    {
      'title': 'Kompor & Nesting',
      'url': 'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=800',
    },
    {
      'title': 'Headlamp Senter',
      'url': 'https://images.unsplash.com/photo-1510312305653-8ed496efae75?w=800',
    },
    {
      'title': 'Sepatu Daki',
      'url': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    },
    {
      'title': 'Trekking Pole',
      'url': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800',
    },
    {
      'title': 'Matras Tiup',
      'url': 'https://images.unsplash.com/photo-1504851149312-7a075b496cc7?w=800',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    _descController.dispose();
    _capacityController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveGear() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final price = double.tryParse(_priceController.text.trim()) ?? 50000;
    final deposit = double.tryParse(_depositController.text.trim()) ?? (price * 2);
    final stock = int.tryParse(_stockController.text.trim()) ?? 5;

    final newGear = OutdoorGear(
      id: 'gear_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      category: _selectedCategory,
      pricePerDay: price,
      securityDeposit: deposit,
      rating: 5.0,
      reviewsCount: 1,
      imageUrl: _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800',
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : 'Peralatan mendaki dan outdoor berkualitas standar ekspedisi.',
      specifications: {
        'Kapasitas': _capacityController.text.trim(),
        'Berat': _weightController.text.trim(),
        'Kondisi': 'Sangat Baik (Siap Pakai)',
      },
      features: [
        'Kondisi bersih dan terawat',
        'Lolos pengecekan standar keamanan',
        'Mudah digunakan dan praktis',
      ],
      inStock: stock > 0,
      stockCount: stock,
    );

    final gearProvider = Provider.of<GearProvider>(context, listen: false);
    gearProvider.addGear(newGear);

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alat baru "${newGear.name}" berhasil ditambahkan ke katalog!'),
        backgroundColor: AppConstants.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final gearProvider = Provider.of<GearProvider>(context, listen: false);
    final categoryOptions = gearProvider.categories.where((c) => c != 'Semua').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Alat Outdoor Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppConstants.primaryGreen, AppConstants.secondaryGreen],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_box_outlined, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Formulir Tambah Alat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tambahkan perlengkapan mendaki baru ke katalog aplikasi',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Live Image Preview Box
              const Text(
                'Foto / Gambar Alat *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppConstants.primaryGreen.withValues(alpha: 0.3)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _imageUrlController.text.trim(),
                      key: ValueKey(_imageUrlController.text.trim()),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              'Gambar belum termuat / URL tidak valid',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.remove_red_eye, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Live Preview',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Preset Photo Gallery Selector
              const Text(
                'Pilih Cepat dari Galeri Outdoor:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: photoPresets.length,
                  itemBuilder: (context, index) {
                    final item = photoPresets[index];
                    final isSelected = _imageUrlController.text.trim() == item['url'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _imageUrlController.text = item['url']!;
                        });
                      },
                      child: Container(
                        width: 75,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppConstants.primaryGreen : Colors.grey.shade300,
                            width: isSelected ? 2.5 : 1.0,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              item['url']!,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                            Center(
                              child: Text(
                                item['title']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 4,
                                right: 4,
                                child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // URL Input
              CustomTextField(
                controller: _imageUrlController,
                label: 'Atau Masukkan Tautan (URL) Gambar Kustom',
                hint: 'https://...',
                prefixIcon: Icons.link,
                onChanged: (_) => setState(() {}),
                suffixIcon: _imageUrlController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _imageUrlController.clear();
                          });
                        },
                      )
                    : null,
              ),

              const SizedBox(height: 18),

              // Nama Alat
              CustomTextField(
                controller: _nameController,
                label: 'Nama Peralatan *',
                hint: 'Contoh: Tenda Dome 4P Naturehike',
                prefixIcon: Icons.backpack_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama alat wajib diisi';
                  if (val.trim().length < 3) return 'Nama alat minimal 3 karakter';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Brand / Merk
              CustomTextField(
                controller: _brandController,
                label: 'Merk / Brand *',
                hint: 'Contoh: Eiger, Deuter, Naturehike, Consina',
                prefixIcon: Icons.branding_watermark_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Merk alat wajib diisi';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Kategori Dropdown
              const Text(
                'Kategori Perlengkapan *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: categoryOptions.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              // Tarif Sewa & Uang Jaminan
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Tarif Sewa/Hari (Rp) *',
                      hint: 'Contoh: 50000',
                      prefixIcon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Tarif sewa wajib diisi';
                        final num = double.tryParse(val.trim());
                        if (num == null || num <= 0) return 'Masukkan angka valid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomTextField(
                      controller: _depositController,
                      label: 'Uang Jaminan (Rp) *',
                      hint: 'Contoh: 100000',
                      prefixIcon: Icons.security_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Stok & Spesifikasi
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _stockController,
                      label: 'Jumlah Stok Unit *',
                      hint: '5',
                      prefixIcon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Stok wajib diisi';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomTextField(
                      controller: _capacityController,
                      label: 'Kapasitas',
                      hint: 'Contoh: 4 Orang / 60L',
                      prefixIcon: Icons.people_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Berat
              CustomTextField(
                controller: _weightController,
                label: 'Estimasi Berat',
                hint: 'Contoh: 1.8 kg',
                prefixIcon: Icons.scale_outlined,
              ),

              const SizedBox(height: 18),

              // Deskripsi
              CustomTextField(
                controller: _descController,
                label: 'Deskripsi Perlengkapan',
                hint: 'Jelaskan kondisi alat, bahan, dan peruntukan mendaki...',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveGear,
                  icon: _isSaving
                      ? const SizedBox.shrink()
                      : const Icon(Icons.add_circle_outline),
                  label: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan Alat ke Katalog',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
