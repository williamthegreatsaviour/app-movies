

class RentalHistoryModel {
  final bool status;
  final List<RentalHistoryItem> data;

  RentalHistoryModel({
    required this.status,
    required this.data,
  });

  factory RentalHistoryModel.fromJson(Map<String, dynamic> json) {
    return RentalHistoryModel(
      status: json['status'] ?? false,
      data: json['data'] != null ? List<RentalHistoryItem>.from(json['data'].map((item) => RentalHistoryItem.fromJson(item))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class RentalHistoryItem {
  final String date;
  final String name;
  final String type;
  final String expireDate;
  final num amount;
  final num discount;
  final num total;

  RentalHistoryItem({
    this.date = '',
    this.name = '',
    this.type = '',
    this.expireDate = '',
    this.amount = 0,
    this.discount = 0,
    this.total = 0,
  });

  factory RentalHistoryItem.fromJson(Map<String, dynamic> json) {
    return RentalHistoryItem(
      date: json['date'] is String ? json['date'] : '',
      name: json['name'] is String ? json['name'] : "",
      type:json['type'] is String ? json['type'] : "",
      expireDate: json['expire_date'] is String ? json['expire_date'] : '',
      amount:json['amount'] is num ? json['amount'] : -1,
      discount: json['discount'] is num ? json['discount'] : -1,
      total: json['total'] is num ? json['total'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'name': name,
      'type': type,
      'expire_date': expireDate,
      'amount': amount.toStringAsFixed(2),
      'discount': discount.toStringAsFixed(2),
      'total': total,
    };
  }
}