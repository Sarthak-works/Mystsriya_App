// 1. Campaigns List Data

class CommonCampaignsListModel {
  bool status;
  List<CampaignsListData> data;
  String message;

  CommonCampaignsListModel(
      {required this.status, required this.data, required this.message});

  factory CommonCampaignsListModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonCampaignsListModel(
      status: (map['success']) ?? false,
      data: map["data"] == null
          ? []
          : List<CampaignsListData>.from(
              map["data"]!.map((x) => CampaignsListData.fromJson(x))),
      message: map['message'] ?? " ",
    );
  }
}

class CampaignsListData {
  String id;
  String title;
  String description;
  String link;
  String image;
  String total_task_count;
  String total_users;
  String totaltaskcount;
  String total_user_task_count;
  String total_join_users;
  String amount;
  String taskStatus;
  String totalcompletecampaigns;
  String status;

  List<CampaignsFourUserListData> userListData;
  List<CampaignsTaskListData> taskListData;

  CampaignsListData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.total_task_count,
    required this.total_users,
    required this.total_user_task_count,
    required this.total_join_users,
    required this.link,
    required this.totaltaskcount,
    required this.totalcompletecampaigns,
    required this.userListData,
    required this.taskListData,
    required this.amount,
    required this.taskStatus,
    required this.status,
  });

  factory CampaignsListData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsListData(
      id: (map['id'] ?? 0).toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      total_task_count: (map['total_task_count'] ?? '').toString(),
      total_user_task_count: (map['total_user_task_count'] ?? '').toString(),
      total_users: (map['total_users'] ?? '').toString(),
      total_join_users: (map['total_join_users'] ?? '').toString(),
      link: (map['link'] ?? '').toString(),
      totaltaskcount: (map['total_task_count'] ?? '').toString(),
      amount: (map['amount'] ?? '').toString(),
      status: (map['status'] ?? '0').toString(),
      taskStatus: (map['task_status'] ?? '0').toString(),
      totalcompletecampaigns:
          (map['total_complete_campaigns'] ?? '').toString(),
      userListData: map["latest_four_user"] == null
          ? []
          : List<CampaignsFourUserListData>.from(map["latest_four_user"]!
              .map((x) => CampaignsFourUserListData.fromJson(x))),
      taskListData: map["tasks"] == null
          ? []
          : List<CampaignsTaskListData>.from(
              map["tasks"]!.map((x) => CampaignsTaskListData.fromJson(x))),
    );
  }
}

class CampaignsFourUserListData {
  String id;
  String name;
  String email;
  String mobilenumber;
  String address;
  String image;

  CampaignsFourUserListData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobilenumber,
    required this.address,
    required this.image,
  });

  factory CampaignsFourUserListData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsFourUserListData(
      id: (map['id'] ?? 0).toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      mobilenumber: (map['mobile_number'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
    );
  }
}

class CampaignsTaskListData {
  String id;
  String campaignid;
  String title;
  String description;
  String amount;
  String usertaskstatus;

  CampaignsTaskListData({
    required this.id,
    required this.campaignid,
    required this.title,
    required this.description,
    required this.amount,
    required this.usertaskstatus,
  });

  factory CampaignsTaskListData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsTaskListData(
      id: (map['id'] ?? 0).toString(),
      campaignid: (map['campaign_id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      amount: (map['amount'] ?? '').toString(),
      usertaskstatus: (map['user_task_status'] ?? '').toString(),
    );
  }
}

// CampaignDetails Data

class CommonCampaignsDetailsModel {
  bool status;
  CampaignsDeatilsData data;
  String message;

  CommonCampaignsDetailsModel(
      {required this.status, required this.data, required this.message});

  factory CommonCampaignsDetailsModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonCampaignsDetailsModel(
      status: (map['success']) ?? false,
      data: CampaignsDeatilsData.fromJson(map['data']),
      message: map['message'] ?? "",
    );
  }
}

class CampaignsDeatilsData {
  String id;
  String title;
  String description;
  String link;
  String image;
  String amount;
  String totaltaskcount;
  String totalcompletecampaigns;
  String status;
  String campaignStatus;
  String totalUser;
  String joinUser;
  List<CampaignsDeatilsFourUserListData> userListData;
  List<CampaignsDetailsTaskListData> taskListData;

  CampaignsDeatilsData({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.image,
    required this.totaltaskcount,
    required this.totalcompletecampaigns,
    required this.status,
    required this.userListData,
    required this.taskListData,
    required this.amount,
    required this.campaignStatus,
    required this.totalUser,
    required this.joinUser,
  });

  factory CampaignsDeatilsData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsDeatilsData(
      id: (map['id'] ?? 0).toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      link: (map['link'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      totaltaskcount: (map['total_task_count'] ?? '').toString(),
      amount: (map['amount'] ?? '').toString(),
      status: (map['status'] ?? '1').toString(),
      totalcompletecampaigns:
          (map['total_complete_campaigns'] ?? '').toString(),
      campaignStatus: (map['campaign_status'] ?? '0').toString(),
      totalUser: (map['total_users'] ?? '0').toString(),
      joinUser: (map['total_join_users'] ?? '0').toString(),
      userListData: map["latest_four_user"] == null
          ? []
          : List<CampaignsDeatilsFourUserListData>.from(map["latest_four_user"]!
              .map((x) => CampaignsDeatilsFourUserListData.fromJson(x))),
      taskListData: map["tasks"] == null
          ? []
          : List<CampaignsDetailsTaskListData>.from(map["tasks"]!
              .map((x) => CampaignsDetailsTaskListData.fromJson(x))),
    );
  }
}

class CampaignsDeatilsFourUserListData {
  String id;
  String name;
  String email;
  String mobilenumber;
  String address;
  String image;

  CampaignsDeatilsFourUserListData({
    required this.id,
    required this.name,
    required this.email,
    required this.mobilenumber,
    required this.address,
    required this.image,
  });

  factory CampaignsDeatilsFourUserListData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsDeatilsFourUserListData(
      id: (map['id'] ?? 0).toString(),
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      mobilenumber: (map['mobile_number'] ?? '').toString(),
      address: (map['address'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
    );
  }
}

class CampaignsDetailsTaskListData {
  String id;
  String campaignid;
  String title;
  String description;
  String amount;
  String usertaskstatus;

  CampaignsDetailsTaskListData({
    required this.id,
    required this.campaignid,
    required this.title,
    required this.description,
    required this.amount,
    required this.usertaskstatus,
  });

  factory CampaignsDetailsTaskListData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsDetailsTaskListData(
      id: (map['id'] ?? 0).toString(),
      campaignid: (map['campaign_id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      amount: (map['amount'] ?? '').toString(),
      usertaskstatus: (map['user_task_status'] ?? '').toString(),
    );
  }
}

// Campaign Task Details Data

class CommonCampaignsTaskDetailsModel {
  bool status;
  CampaignsTaskDeatilsData data;
  String message;

  CommonCampaignsTaskDetailsModel(
      {required this.status, required this.data, required this.message});

  factory CommonCampaignsTaskDetailsModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonCampaignsTaskDetailsModel(
      status: (map['success']) ?? false,
      data: CampaignsTaskDeatilsData.fromJson(map['data']),
      message: map['message'] ?? "",
    );
  }
}

class CampaignsTaskDeatilsData {
  // String id;
  // String title;
  // String description;
  // String amount;
  // String usertaskstatus;
  CampaignTaskDetails taskDetails;
  CampaignDetails campaignDetails;

  CampaignsTaskDeatilsData({
    // required this.id,
    // required this.title,
    // required this.description,
    // required this.amount,
    // required this.usertaskstatus,
    required this.taskDetails,
    required this.campaignDetails,
  });

  factory CampaignsTaskDeatilsData.fromJson(Map<dynamic, dynamic> map) {
    return CampaignsTaskDeatilsData(
      // id: (map['id'] ?? 0).toString(),
      // title: (map['title'] ?? '').toString(),
      // description: (map['description'] ?? '').toString(),
      // amount: (map['amount'] ?? '').toString(),
      // usertaskstatus: (map['user_task_status'] ?? '').toString(),
      campaignDetails: CampaignDetails.fromJson(map["campaign"]),
      taskDetails: CampaignTaskDetails.fromJson(map["task"]),
    );
  }
}

class CampaignDetails {
  String id;
  String title;
  String description;
  String link;
  String totaltaskcount;
  String totalcompletecampaigns;
  List<CampaignTaskDetails> taskDataList;

  CampaignDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.totaltaskcount,
    required this.totalcompletecampaigns,
    required this.taskDataList
  });

  factory CampaignDetails.fromJson(Map<dynamic, dynamic> map) {
    var list = (map['tasks'] ?? []) as List;
    List<CampaignTaskDetails> tasksDataList = list.map((i) => CampaignTaskDetails.fromJson(i)).toList();

    return CampaignDetails(
      id: (map['id'] ?? 0).toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      link: (map['link'] ?? '').toString(),
      totaltaskcount: (map['total_task_count'] ?? '').toString(),
      totalcompletecampaigns: (map['total_complete_campaigns'] ?? '').toString(),
      taskDataList: tasksDataList
    );
  }
}

class CampaignTaskDetails {
  String id;
  String title;
  String description;
  String amount;
  String usertaskstatus;
  String comments;

  CampaignTaskDetails({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.usertaskstatus,
    required this.comments,
  });

  factory CampaignTaskDetails.fromJson(Map<dynamic, dynamic> map) {
    return CampaignTaskDetails(
      id: (map['id'] ?? 0).toString(),
      title: (map['title'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      amount: (map['amount'] ?? '').toString(),
      usertaskstatus: (map['user_task_status'] ?? '').toString(),
      comments: (map['comments'] ?? '').toString(),
    );
  }
}
