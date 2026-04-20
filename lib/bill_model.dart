class BillItem {
  String description;
  double quantity;
  double rate;

  BillItem({
    required this.description,
    required this.quantity,
    required this.rate,
  });

  double get amount => quantity * rate;

  Map<String, dynamic> toJson() => {
    'description': description,
    'quantity': quantity,
    'rate': rate,
  };

  factory BillItem.fromJson(Map<String, dynamic> json) => BillItem(
    description: json['description'] ?? '',
    quantity: (json['quantity'] ?? 0).toDouble(),
    rate: (json['rate'] ?? 0).toDouble(),
  );
}

class Bill {
  String customerName;
  String billNumber;
  DateTime date;
  List<BillItem> items;
  bool isUrdu;
  String? id; // unique id for history

  Bill({
    required this.customerName,
    required this.billNumber,
    required this.date,
    required this.items,
    required this.isUrdu,
    this.id,
  });

  double get total => items.fold(0, (sum, item) => sum + item.amount);

  Map<String, dynamic> toJson() => {
    'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
    'customerName': customerName,
    'billNumber': billNumber,
    'date': date.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
    'isUrdu': isUrdu,
  };

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    id: json['id'],
    customerName: json['customerName'] ?? '',
    billNumber: json['billNumber'] ?? '',
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    items: (json['items'] as List<dynamic>? ?? [])
        .map((e) => BillItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    isUrdu: json['isUrdu'] ?? true,
  );
}

class CompanyInfo {
  static const String nameUrdu = 'عبدالمجید اینڈ کمپنی';
  static const String addressUrdu = 'غلہ منڈی حسن خان والا\nتحصیل کلورکوٹ ضلع بھکر';
  static const String proprietorUrdu = 'پروپرائٹر: عبدالمجید خان';
  static const String nameEnglish = 'Abdul Majeed & Company';
  static const String addressEnglish = 'Ghalla Mandi Hassan Khan Wala\nTehsil Kallur Kot, District Bhakkar';
  static const String proprietorEnglish = 'Proprietor: Abdul Majeed Khan';
  static const List<String> phones = [
    '0301-7951073',
    '0317-7951073',
    '0345-7951073',
    '0453-451373',
  ];
  static const String hamzaName = 'حمزہ بلوچ';
  static const String hamzaNameEn = 'Hamza Baloch';
  static const String hamzaNumber = '0301-4321673';
  static const String hamzaPhone = '0301-4321673 :حمزہ بلوچ';
  static const String hamzaPhoneEn = 'Hamza Baloch: 0301-4321673';
}
