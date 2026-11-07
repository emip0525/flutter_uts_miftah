class RentalBooking {
  final String id;
  final String studentId;
  final String customerName;
  final String customerPhone;
  final String gearId;
  final String gearName;
  final int rentalDays;
  final String startDate;
  final String returnDate;
  final double totalPrice;
  final String note;
  final String status; // 'Aktif', 'Selesai', 'Dibatalkan'
  final String createdAt;

  RentalBooking({
    required this.id,
    this.studentId = '2415051011',
    required this.customerName,
    required this.customerPhone,
    required this.gearId,
    required this.gearName,
    required this.rentalDays,
    required this.startDate,
    required this.returnDate,
    required this.totalPrice,
    this.note = '',
    this.status = 'Aktif',
    String? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  factory RentalBooking.fromJson(Map<String, dynamic> json) {
    return RentalBooking(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '2415051011',
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      gearId: json['gear_id']?.toString() ?? '',
      gearName: json['gear_name'] as String? ?? '',
      rentalDays: (json['rental_days'] ?? 1).toInt(),
      startDate: json['start_date'] as String? ?? '',
      returnDate: json['return_date'] as String? ?? '',
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      note: json['note'] as String? ?? '',
      status: json['status'] as String? ?? 'Aktif',
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'gear_id': gearId,
      'gear_name': gearName,
      'rental_days': rentalDays,
      'start_date': startDate,
      'return_date': returnDate,
      'total_price': totalPrice,
      'note': note,
      'status': status,
      'created_at': createdAt,
    };
  }

  RentalBooking copyWith({
    String? id,
    String? studentId,
    String? customerName,
    String? customerPhone,
    String? gearId,
    String? gearName,
    int? rentalDays,
    String? startDate,
    String? returnDate,
    double? totalPrice,
    String? note,
    String? status,
    String? createdAt,
  }) {
    return RentalBooking(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      gearId: gearId ?? this.gearId,
      gearName: gearName ?? this.gearName,
      rentalDays: rentalDays ?? this.rentalDays,
      startDate: startDate ?? this.startDate,
      returnDate: returnDate ?? this.returnDate,
      totalPrice: totalPrice ?? this.totalPrice,
      note: note ?? this.note,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
