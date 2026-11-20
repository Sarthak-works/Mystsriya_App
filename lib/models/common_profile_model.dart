class CommonProfileListModel {
  bool status;
  CommonProfileDetailsData data;
  String message;

  CommonProfileListModel(
      {required this.status, required this.data, required this.message});

  factory CommonProfileListModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonProfileListModel(
      status: (map['success']) ?? false,
      data: CommonProfileDetailsData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonProfileDetailsData {
  String id;
  String name;
  String email;
  String mobileno;
  String image;
  String lat;
  String long;
  String instagramLink;
  String facebookLink;
  String youtubeLink;
  String address;
  String totalPosts;
  String totalTasks;
  String totalCampaigns;
  String earning;
  String accountnumber;
  String accountname;
  String ifsccode;
  String bankname;
  String upiid;
  String referralCode;
  String totalApprovedTask;
  String totalRejectedTask;
  String totalReviewTask;
  String referralAmount;

  CommonProfileDetailsData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileno,
    required this.image,
    required this.lat,
    required this.long,
    required this.facebookLink,
    required this.youtubeLink,
    required this.instagramLink,
    required this.address,
    required this.totalPosts,
    required this.totalTasks,
    required this.totalCampaigns,
    required this.earning,
    required this.accountname,
    required this.accountnumber,
    required this.bankname,
    required this.ifsccode,
    required this.upiid,
    required this.referralCode,
    required this.totalApprovedTask,
    required this.totalRejectedTask,
    required this.totalReviewTask,
    required this.referralAmount,
  });

  factory CommonProfileDetailsData.fromJson(Map<dynamic, dynamic> map) {
    return CommonProfileDetailsData(
      id: (map['id'] ?? 0).toString(),
      name: (map["name"] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      mobileno: (map['mobile_number'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      lat: (map['lat'] ?? '').toString(),
      long: (map['long'] ?? '').toString(),
      facebookLink: (map['facebook_link'] ?? '').toString(),
      youtubeLink: (map['youtube_link'] ?? '').toString(),
      instagramLink: (map['instagram_link'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      totalPosts: (map['total_posts'] ?? '').toString(),
      totalTasks: (map['total_tasks'] ?? '').toString(),
      totalCampaigns: (map['total_campaigns'] ?? '').toString(),
      earning: (map['earning'] ?? '').toString(),
      accountname: (map['account_name'] ?? '').toString(),
      accountnumber: (map['account_number'] ?? '').toString(),
      bankname: (map['bank_name'] ?? '').toString(),
      ifsccode: (map['ifsc_code'] ?? '').toString(),
      upiid: (map['upi_id'] ?? '').toString(),
      referralCode: (map['referral_code'] ?? '').toString(),
      totalApprovedTask: (map['total_approved_task'] ?? '').toString(),
      totalRejectedTask: (map['total_rejected_task'] ?? '').toString(),
      totalReviewTask: (map['total_review_task'] ?? '').toString(),
      referralAmount: (map['referral_amount'] ?? '0').toString(),
    );
  }
}

// Edite Profile
class CommonEditeProfileListModel {
  bool status;
  CommonEditeProfileDetailsData data;
  String message;

  CommonEditeProfileListModel(
      {required this.status, required this.data, required this.message});

  factory CommonEditeProfileListModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonEditeProfileListModel(
      status: (map['success']) ?? false,
      data: CommonEditeProfileDetailsData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonEditeProfileDetailsData {
  String id;
  String name;
  String email;
  String mobileno;
  String image;
  String address;

  CommonEditeProfileDetailsData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileno,
    required this.image,
    required this.address,
  });

  factory CommonEditeProfileDetailsData.fromJson(Map<dynamic, dynamic> map) {
    return CommonEditeProfileDetailsData(
      id: (map['id'] ?? 0).toString(),
      name: (map["name"] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      mobileno: (map['mobile_number'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
    );
  }
}
