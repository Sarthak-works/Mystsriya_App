class googleLoginModel {
  bool? status;
  String? message;

  googleLoginModel(
      { this.status,  this.message});

  factory googleLoginModel.fromJson(Map<dynamic, dynamic>? map) {
    return googleLoginModel(
      status: (map!['success']) ?? false,
      message: map!['message'] ?? " ",
    );
  }
}

class CommonLoginModel {
  bool status;
  CommonLoginData data;
  String message;

  CommonLoginModel(
      {required this.status, required this.data, required this.message});

  factory CommonLoginModel.fromJson(Map<dynamic, dynamic>? map) {
    return CommonLoginModel(
      status: (map!['success']) ?? false,
      data: CommonLoginData.fromJson(map!['data'] ?? null),
      message: map['message'] ?? " ",
    );
  }
}

class CommonLoginData {
  String id;
  String token;
  String name;
  String image;

  CommonLoginData(
      {this.id="",
       this.token="",
       this.name="",
       this.image=""
      });

  factory CommonLoginData.fromJson(Map<dynamic, dynamic?> map) {
    return CommonLoginData(
      id: (map['id'] ?? 0).toString(),
      token: (map['token'] ?? ''),
      name: (map['name'] ?? ''),
      image: (map['image'] ?? ''),
    );
  }
}

// Register

class CommonRegisterModel {
  bool status;
  CommonRegisterData data;
  String message;

  CommonRegisterModel(
      {required this.status, required this.data, required this.message});

  factory CommonRegisterModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonRegisterModel(
      status: (map['success']) ?? false,
      data: CommonRegisterData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonRegisterData {
  String id;
  String name;
  String image;
  String token;

  CommonRegisterData({required this.id, required this.name, required this.image, required this.token});

  factory CommonRegisterData.fromJson(Map<dynamic, dynamic> map) {
    return CommonRegisterData(
      id: (map['id'] ?? 0).toString(),
      name: (map['name'] ?? "").toString(),
      image: (map['image'] ?? "").toString(),
      token: (map['token'] ?? "").toString(),
    );
  }
}

// ForgotPassWord Flow

// 1. verfiy Email

class CommonVerifyEmailModel {
  bool status;
  CommonVerifyEmaiData data;
  String message;

  CommonVerifyEmailModel(
      {required this.status, required this.data, required this.message});

  factory CommonVerifyEmailModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonVerifyEmailModel(
      status: (map['success']) ?? false,
      data: CommonVerifyEmaiData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonVerifyEmaiData {
  String email;
  String otp;

  CommonVerifyEmaiData({required this.email, required this.otp});

  factory CommonVerifyEmaiData.fromJson(Map<dynamic, dynamic> map) {
    return CommonVerifyEmaiData(
      email: (map['email'] ?? '').toString(),
      otp: (map['otp'] ?? '').toString(),
    );
  }
}

// 2. verfiy OTP

class CommonVerifyOTPModel {
  bool status;
  CommonVerifyOTPData data;
  String message;

  CommonVerifyOTPModel(
      {required this.status, required this.data, required this.message});

  factory CommonVerifyOTPModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonVerifyOTPModel(
      status: (map['success']) ?? false,
      data: CommonVerifyOTPData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonVerifyOTPData {
  String email;

  CommonVerifyOTPData({required this.email});

  factory CommonVerifyOTPData.fromJson(Map<dynamic, dynamic> map) {
    return CommonVerifyOTPData(
      email: (map['email'] ?? 0).toString(),
    );
  }
}

// Bank Details

class CommonBankDeatilsModel {
  bool status;
  CommonBankDeatilsData data;
  String message;

  CommonBankDeatilsModel(
      {required this.status, required this.data, required this.message});

  factory CommonBankDeatilsModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonBankDeatilsModel(
      status: (map['success']) ?? false,
      data: CommonBankDeatilsData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonBankDeatilsData {
  String accountnumber;
  String accountname;
  String ifsccode;
  String bankname;
  String upiid;

  CommonBankDeatilsData({
    required this.accountname,
    required this.accountnumber,
    required this.bankname,
    required this.ifsccode,
    required this.upiid,
  });

  factory CommonBankDeatilsData.fromJson(Map<dynamic, dynamic> map) {
    return CommonBankDeatilsData(
      accountname: (map['account_name'] ?? '').toString(),
      accountnumber: (map['account_number'] ?? '').toString(),
      bankname: (map['bank_name'] ?? '').toString(),
      ifsccode: (map['ifsc_code'] ?? '').toString(),
      upiid: (map['upi_id'] ?? '').toString(),
    );
  }
}
