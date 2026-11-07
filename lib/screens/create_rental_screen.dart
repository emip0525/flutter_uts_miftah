import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../models/outdoor_gear.dart';
import '../models/rental_booking.dart';
import '../providers/gear_provider.dart';
import '../providers/rental_provider.dart';
import '../utils/formatters.dart';
import '../widgets/custom_text_field.dart';

class CreateRentalScreen extends StatefulWidget {
  final OutdoorGear? initialGear;

  const CreateRentalScreen({super.key, this.initialGear});

  @override
  State<CreateRentalScreen> createState() => _CreateRentalScreenState();
}

class _CreateRentalScreenState extends State<CreateRentalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();

  OutdoorGear? _selectedGear;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  int _rentalDays = 3;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedGear = widget.initialGear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedGear == null) {
        final gears = Provider.of<GearProvider>(context, listen: false).gears;
        if (gears.isNotEmpty) {
          setState(() {
            _selectedGear = gears.first;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  DateTime get _returnDate => _startDate.add(Duration(days: _rentalDays));

  double get _totalPrice {
    if (_selectedGear == null) return 0.0;
    return _selectedGear!.pricePerDay * _rentalDays;
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _submitRental() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih alat outdoor yang akan disewa.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final newBooking = RentalBooking(
      id: 'rent_${DateTime.now().millisecondsSinceEpoch}',
      studentId: AppConstants.studentNim,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      gearId: _selectedGear!.id,
      gearName: _selectedGear!.name,
      rentalDays: _rentalDays,
      startDate: Formatters.formatShortDate(_startDate),
      returnDate: Formatters.formatShortDate(_returnDate),
      totalPrice: _totalPrice,
      note: _noteController.text.trim(),
      status: 'Aktif',
    );

    final rentalProvider = Provider.of<RentalProvider>(context, listen: false);
    final success = await rentalProvider.createBooking(newBooking);

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sewa "${newBooking.gearName}" berhasil dibuat!'),
          backgroundColor: AppConstants.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(rentalProvider.errorMessage ?? 'Gagal membuat reservasi sewa.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gearProvider = Provider.of<GearProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Sewa Alat'),
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
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.primaryGreen,
                      AppConstants.secondaryGreen,
                    ],
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
                      child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reservasi Sewa Baru',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Lengkapi formulir untuk menyewa peralatan gunung pilihan Anda',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Pilih Alat Dropdown
              const Text(
                'Pilih Alat Outdoor *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<OutdoorGear>(
                initialValue: _selectedGear,
                isExpanded: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.backpack_outlined),
                ),
                items: gearProvider.gears.map((gear) {
                  return DropdownMenuItem<OutdoorGear>(
                    value: gear,
                    child: Text(
                      '${gear.name} (${Formatters.formatCurrency(gear.pricePerDay)}/hari)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (gear) {
                  setState(() {
                    _selectedGear = gear;
                  });
                },
                validator: (val) => val == null ? 'Silakan pilih alat' : null,
              ),

              const SizedBox(height: 18),

              // Nama Penyewa
              CustomTextField(
                controller: _nameController,
                label: 'Nama Lengkap Penyewa *',
                hint: 'Masukkan nama sesuai KTP / identitas',
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama penyewa wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Nomor HP
              CustomTextField(
                controller: _phoneController,
                label: 'Nomor WhatsApp / HP Aktif *',
                hint: 'Contoh: 081234567890',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nomor HP wajib diisi untuk konfirmasi sewa';
                  }
                  if (value.trim().length < 9) {
                    return 'Nomor HP minimal 9 digit';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Tanggal Mulai & Durasi Sewa
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal Mulai *',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: _selectStartDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18, color: AppConstants.primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    Formatters.formatShortDate(_startDate),
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Durasi Sewa *',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                                onPressed: _rentalDays > 1
                                    ? () {
                                        setState(() {
                                          _rentalDays--;
                                        });
                                      }
                                    : null,
                              ),
                              Text(
                                '$_rentalDays Hari',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: AppConstants.primaryGreen),
                                onPressed: () {
                                  setState(() {
                                    _rentalDays++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Catatan / Tujuan Pendakian
              CustomTextField(
                controller: _noteController,
                label: 'Catatan / Lokasi Pendakian (Opsional)',
                hint: 'Contoh: Pendakian Gn. Rinjani 4 hari 3 malam',
                prefixIcon: Icons.notes_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Rincian Biaya Sewa
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Biaya Sewa',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tarif Sewa per Hari', style: TextStyle(color: Colors.grey.shade600)),
                        Text(
                          _selectedGear != null
                              ? Formatters.formatCurrency(_selectedGear!.pricePerDay)
                              : 'Rp 0',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Lama Sewa', style: TextStyle(color: Colors.grey.shade600)),
                        Text('$_rentalDays Hari', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal Pengembalian', style: TextStyle(color: Colors.grey.shade600)),
                        Text(
                          Formatters.formatShortDate(_returnDate),
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppConstants.accentOrange),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Formatters.formatCurrency(_totalPrice),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRental,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Text(
                          'Konfirmasi & Buat Sewa',
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
