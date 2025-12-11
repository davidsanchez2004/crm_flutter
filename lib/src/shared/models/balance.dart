class Balance {
  final double ventasTotal;
  final double gastosTotal;

  Balance({
    required this.ventasTotal,
    required this.gastosTotal,
  });

  double get total => ventasTotal - gastosTotal;

  factory Balance.fromMap(Map<String, dynamic> map) {
    return Balance(
      ventasTotal: (map['total_ventas'] as num?)?.toDouble() ?? 0,
      gastosTotal: (map['total_gastos'] as num?)?.toDouble() ?? 0,
    );
  }
}
