import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../models/outdoor_gear.dart';
import '../providers/gear_provider.dart';
import '../widgets/custom_text_field.dart';

class EditGearScreen extends StatefulWidget {
  final OutdoorGear gear;

  const EditGearScreen({super.key, required this.gear});

  @override
  State<EditGearScreen> createState() => _EditGearScreenState();
}

class _EditGearScreenState extends State<EditGearScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _priceController;
  late TextEditingController _depositController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descController;
  late TextEditingController _capacityController;
  late TextEditingController _weightController;

  late String _selectedCategory;
  late bool _inStock;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.gear.name);
    _brandController = TextEditingController(text: widget.gear.brand);
    _priceController = TextEditingController(text: widget.gear.pricePerDay.toInt().toString());
    _depositController = TextEditingController(text: widget.gear.securityDeposit.toInt().toString());
    _stockController = TextEditingController(text: widget.gear.stockCount.toString());
    _imageUrlController = TextEditingController(text: widget.gear.imageUrl);
    _descController = TextEditingController(text: widget.gear.description);
    _capacityController = TextEditingController(
      text: widget.gear.specifications['Kapasitas'] ?? '4 Orang',
    );
    _weightController = TextEditingController(
      text: widget.gear.specifications['Berat'] ?? '2 kg',
    );

    _selectedCategory = widget.gear.category;
    _inStock = widget.gear.inStock;
  }

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

  void _updateGear() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final price = double.tryParse(_priceController.text.trim()) ?? widget.gear.pricePerDay;
    final deposit = double.tryParse(_depositController.text.trim()) ?? widget.gear.securityDeposit;
    final stock = int.tryParse(_stockController.text.trim()) ?? widget.gear.stockCount;

    final updatedSpecs = Map<String, String>.from(widget.gear.specifications);
    updatedSpecs['Kapasitas'] = _capacityController.text.trim();
    updatedSpecs['Berat'] = _weightController.text.trim();

    final updatedGear = widget.gear.copyWith(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      category: _selectedCategory,
      pricePerDay: price,
      securityDeposit: deposit,
      stockCount: stock,
      inStock: _inStock && stock > 0,
      imageUrl: _imageUrlController.text.trim(),
      description: _descController.text.trim(),
      specifications: updatedSpecs,
    );

    final gearProvider = Provider.of<GearProvider>(context, listen: false);
    gearProvider.updateGear(updatedGear);

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data alat "${updatedGear.name}" berhasil diperbarui!'),
        backgroundColor: AppConstants.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, updatedGear);
  }

  @override
  Widget build(BuildContext context) {
    final gearProvider = Provider.of<GearProvider>(context, listen: false);
    final categoryOptions = gearProvider.categories.where((c) => c != 'Semua').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Alat Outdoor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.gear.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
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
                            widget.gear.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${widget.gear.id} • ${widget.gear.brand}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Ketersediaan Switch
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Status Ketersediaan Alat', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(_inStock ? 'Tersedia untuk disewa' : 'Stok habis / sedang dirawat'),
                  value: _inStock,
                  activeThumbColor: AppConstants.primaryGreen,
                  onChanged: (val) {
                    setState(() {
                      _inStock = val;
                    });
                  },
                ),
              ),

              const SizedBox(height: 18),

              // Nama Alat
              CustomTextField(
                controller: _nameController,
                label: 'Nama Peralatan *',
                hint: 'Nama lengkap alat',
                prefixIcon: Icons.backpack_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama alat wajib diisi';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Brand
              CustomTextField(
                controller: _brandController,
                label: 'Merk / Brand *',
                hint: 'Merk alat',
                prefixIcon: Icons.branding_watermark_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Merk wajib diisi';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Kategori
              const Text(
                'Kategori Perlengkapan *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: categoryOptions.contains(_selectedCategory) ? _selectedCategory : categoryOptions.first,
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

              // Tarif Sewa & Deposit
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'Tarif Sewa/Hari (Rp) *',
                      hint: '50000',
                      prefixIcon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Tarif sewa wajib diisi';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomTextField(
                      controller: _depositController,
                      label: 'Uang Jaminan (Rp) *',
                      hint: '100000',
                      prefixIcon: Icons.security_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Stok & Kapasitas
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _stockController,
                      label: 'Jumlah Stok *',
                      hint: '5',
                      prefixIcon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomTextField(
                      controller: _capacityController,
                      label: 'Kapasitas',
                      hint: '4 Orang / 60L',
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
                hint: '2.5 kg',
                prefixIcon: Icons.scale_outlined,
              ),

              const SizedBox(height: 18),

              // Image URL
              CustomTextField(
                controller: _imageUrlController,
                label: 'URL Gambar Alat',
                hint: 'https://...',
                prefixIcon: Icons.image_outlined,
              ),

              const SizedBox(height: 18),

              // Deskripsi
              CustomTextField(
                controller: _descController,
                label: 'Deskripsi Perlengkapan',
                hint: 'Deskripsi alat...',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 28),

              // Simpan Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _updateGear,
                  icon: _isSaving
                      ? const SizedBox.shrink()
                      : const Icon(Icons.check_circle_outline),
                  label: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan Perubahan Alat',
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
