class CommonHomeListModel {
  bool status;
  CommonDashboardListData data;
  String message;

  CommonHomeListModel(
      {required this.status, required this.data, required this.message});

  factory CommonHomeListModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonHomeListModel(
      status: (map['success']) ?? false,
      data: CommonDashboardListData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonDashboardListData {
  List<HomeListData>? data;
  Meta? meta;

  CommonDashboardListData({this.data, this.meta});

  factory CommonDashboardListData.fromJson(Map<dynamic, dynamic> map) {
    List datalist = map['data'] ?? [];
    List<HomeListData> datas =
        datalist.map((e) => HomeListData.fromJson(e)).toList();

    return CommonDashboardListData(
        data: datas, meta: Meta.fromJson(map["meta"]));
  }
}

class Meta {
  String currentPage;
  String from;
  String lastPage;
  String path;
  String perPage;
  String to;
  String total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<dynamic, dynamic> map) {
    return Meta(
      currentPage: (map['current_page'] ?? 0).toString(),
      from: (map['from'] ?? '').toString(),
      lastPage: (map['last_page'] ?? '').toString(),
      path: (map['path'] ?? '').toString(),
      perPage: (map['per_page'] ?? '').toString(),
      to: (map['to'] ?? '').toString(),
      total: (map['total'] ?? '').toString(),
    );
  }
}

class HomeListData {
  String id;
  String description;
  String backgroundcolor;
  String link;
  String createdat;
  String totallikes;
  String totalcomment;
  String likestatus;
  String type;
  String posttype;
  String image;
  String isEdited;
  HomeuserDate? userData;

  HomeListData({
    required this.id,
    required this.description,
    required this.backgroundcolor,
    required this.link,
    required this.createdat,
    required this.totallikes,
    required this.totalcomment,
    required this.userData,
    required this.likestatus,
    required this.type,
    required this.posttype,
    required this.image,
    required this.isEdited,
  });

  factory HomeListData.fromJson(Map<dynamic, dynamic> map) {
    return HomeListData(
      id: (map['id'] ?? 0).toString(),
      description: (map['description'] ?? '').toString(),
      backgroundcolor: (map['background_color'] ?? '').toString(),
      link: (map['link'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      posttype: (map['post_type'] ?? '').toString(),
      createdat: (map['created_at'] ?? '').toString(),
      totallikes: (map['total_likes'] ?? '').toString(),
      totalcomment: (map['total_comment'] ?? '').toString(),
      likestatus: (map['like_status'] ?? '').toString(),
      isEdited: (map['is_edited'] ?? '').toString(),
      userData: map["user"] == null ? null : HomeuserDate.fromJson(map["user"]),
    );
  }
}

class HomeuserDate {
  String id;
  String name;
  String image;
  String totalposts;

  HomeuserDate(
      {required this.id,
      required this.name,
      required this.image,
      required this.totalposts});

  factory HomeuserDate.fromJson(Map<dynamic, dynamic> map) {
    return HomeuserDate(
      id: (map['id'] ?? 0).toString(),
      name: (map['name'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      totalposts: (map['total_posts'] ?? '').toString(),
    );
  }

  fromJson(map) {}
}

/// post Details Data  Modal

class CommonHomedetailsModel {
  bool status;
  HomePostDetailsData data;
  String message;

  CommonHomedetailsModel(
      {required this.status, required this.data, required this.message});

  factory CommonHomedetailsModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonHomedetailsModel(
      status: (map['success']) ?? false,
      data: HomePostDetailsData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonPostDetailsData {
  List<HomePostDetailsData>? data;

  CommonPostDetailsData({
    this.data,
  });

  factory CommonPostDetailsData.fromJson(Map<dynamic, dynamic> map) {
    List datalist = map['data'] ?? [];
    List<HomePostDetailsData> datas =
        datalist.map((e) => HomePostDetailsData.fromJson(e)).toList();

    return CommonPostDetailsData(
      data: datas,
    );
  }
}

class HomePostDetailsData {
  String id;
  String description;
  String backgroundcolor;
  String link;
  String createdat;
  String totallikes;
  String likeStatus;
  String type;
  String posttype;
  String image;
  HomePostUserDate? userData;

  HomePostDetailsData({
    required this.id,
    required this.description,
    required this.backgroundcolor,
    required this.link,
    required this.createdat,
    required this.totallikes,
    required this.userData,
    required this.likeStatus,
    required this.type,
    required this.posttype,
    required this.image,
  });

  factory HomePostDetailsData.fromJson(Map<dynamic, dynamic> map) {
    return HomePostDetailsData(
      id: (map['id'] ?? 0).toString(),
      description: (map['description'] ?? '').toString(),
      backgroundcolor: (map['background_color'] ?? '').toString(),
      link: (map['link'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      posttype: (map['post_type'] ?? '').toString(),
      createdat: (map['created_at'] ?? '').toString(),
      totallikes: (map['total_likes'] ?? '').toString(),
      likeStatus: (map['like_status'] ?? '').toString(),
      userData:
          map["user"] == null ? null : HomePostUserDate.fromJson(map["user"]),
    );
  }
}

class HomePostUserDate {
  String id;
  String name;
  String image;
  String totalPost;

  HomePostUserDate({
    required this.id,
    required this.name,
    required this.image,
    required this.totalPost,
  });

  factory HomePostUserDate.fromJson(Map<dynamic, dynamic> map) {
    return HomePostUserDate(
      id: (map['id'] ?? 0).toString(),
      name: (map['name'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      totalPost: (map['total_posts'] ?? '').toString(),
    );
  }

  fromJson(map) {}
}

// Like Post

class CommonLikePostModel {
  bool status;
  CommonLikePostData data;
  String message;

  CommonLikePostModel(
      {required this.status, required this.data, required this.message});

  factory CommonLikePostModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonLikePostModel(
      status: (map['success']) ?? false,
      data: CommonLikePostData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonLikePostData {
  String isfavorite;

  CommonLikePostData({
    required this.isfavorite,
  });

  factory CommonLikePostData.fromJson(Map<dynamic, dynamic> map) {
    return CommonLikePostData(
      isfavorite: (map['is_favorite'] ?? 0).toString(),
    );
  }
}
