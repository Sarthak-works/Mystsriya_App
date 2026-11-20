class WalletModel {
  bool status;
  List<WalletData> data;
  String message;

  WalletModel(
      {required this.status, required this.data, required this.message});

  factory WalletModel.fromJson(Map<dynamic, dynamic> map) {
    return WalletModel(
      status: (map['success']) ?? false,
      data: map['data'] == null
          ? []
          : List<WalletData>.from(
              map['data']!.map((x) => WalletData.fromJson(x))),
      message: map['message'] ?? " ",
    );
  }
}

class WalletData {
  String title;
  String description;
  String amount;

  WalletData({
    required this.title,
    required this.description,
    required this.amount,
  });

  factory WalletData.fromJson(Map<dynamic, dynamic> map) {
    return WalletData(
      title: (map['title'] ?? "").toString(),
      description: (map['description'] ?? '').toString(),
      amount: (map['earning'] ?? '0').toString(),
    );
  }
}
