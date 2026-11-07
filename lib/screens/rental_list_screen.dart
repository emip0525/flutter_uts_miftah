import 'package:flutter/material.dart';

class RentalListScreen extends StatelessWidget {
  const RentalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Sewa Alat')),
      body: const Center(child: Text('Rental List Screen')),
    );
  }
}
