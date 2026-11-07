import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_constants.dart';
import '../models/rental_booking.dart';
import '../providers/rental_provider.dart';
import '../utils/formatters.dart';
import '../widgets/custom_text_field.dart';

class EditRentalScreen extends StatefulWidget {
  final RentalBooking booking;

  const EditRentalScreen({super.key, required this.booking});

  @override
  State<EditRentalScreen> createState() => _EditRentalScreenState();
}

class _EditRentalScreenState extends State<EditRentalScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _noteController;

  late int _rentalDays;
  late String _status;
  late double _totalPrice;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.booking.customerName);
    _phoneController = TextEditingController(text: widget.booking.customerPhone);
    _noteController = TextEditingController(text: widget.booking.note);

    _rentalDays = widget.booking.rentalDays;
    _status = widget.booking.status;

    // Hitung tarif per hari dari total awal
    final dailyRate = widget.booking.totalPrice / (widget.booking.rentalDays > 0 ? widget.booking.rentalDays : 1);
    _totalPrice = dailyRate * _rentalDays;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _recalculatePrice() {
    final dailyRate = widget.booking.totalPrice / (widget.booking.rentalDays > 0 ? widget.booking.rentalDays : 1);
    setState(() {
      _totalPrice = dailyRate * _rentalDays;
    });
  }

  Future<void> _updateRental() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final updated = widget.booking.copyWith(
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      rentalDays: _rentalDays,
      totalPrice: _totalPrice,
      note: _noteController.text.trim(),
      status: _status,
    );

    final provider = Provider.of<RentalProvider>(context, listen: false);
    final success = await provider.updateBooking(updated);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data sewa "${updated.gearName}" berhasil diperbarui!'),
          backgroundColor: AppConstants.primaryGreen,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal memperbarui data sewa.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Sewa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gear Summary Info Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.hiking, color: AppConstants.primaryGreen, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.booking.gearName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID Rental: ${widget.booking.id}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Sewa Dropdown
              const Text(
                'Status Rental *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Aktif', child: Text('Aktif (Sedang Berjalan)')),
                  DropdownMenuItem(value: 'Selesai', child: Text('Selesai (Sudah Dikembalikan)')),
                  DropdownMenuItem(value: 'Dibatalkan', child: Text('Dibatalkan')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _status = val;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              // Nama Penyewa
              CustomTextField(
                controller: _nameController,
                label: 'Nama Penyewa *',
                hint: 'Nama lengkap',
                prefixIcon: Icons.person_outline,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nama tidak boleh kosong';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Nomor HP
              CustomTextField(
                controller: _phoneController,
                label: 'Nomor HP / WhatsApp *',
                hint: '081234567890',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Nomor HP tidak boleh kosong';
                  return null;
                },
              ),

              const SizedBox(height: 18),

              // Durasi Sewa
              const Text(
                'Ubah Durasi Sewa *',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              _recalculatePrice();
                            }
                          : null,
                    ),
                    Text(
                      '$_rentalDays Hari',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: AppConstants.primaryGreen),
                      onPressed: () {
                        setState(() {
                          _rentalDays++;
                        });
                        _recalculatePrice();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Catatan
              CustomTextField(
                controller: _noteController,
                label: 'Catatan Sewa',
                hint: 'Kondisi barang, rute pendakian, dll.',
                prefixIcon: Icons.note_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Total Biaya Baru Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppConstants.primaryGreen.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Tarif Penyesuaian',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      Formatters.formatCurrency(_totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppConstants.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _updateRental,
                  icon: _isSaving
                      ? const SizedBox.shrink()
                      : const Icon(Icons.check_circle_outline),
                  label: _isSaving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
