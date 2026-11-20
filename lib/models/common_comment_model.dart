class CommonCommentListModel {
  bool status;
  CommonGetCommentListData data;
  String message;

  CommonCommentListModel(
      {required this.status, required this.data, required this.message});

  factory CommonCommentListModel.fromJson(Map<dynamic, dynamic> map) {
    return CommonCommentListModel(
      status: (map['success']) ?? false,
      data: CommonGetCommentListData.fromJson(map['data']),
      message: map['message'] ?? " ",
    );
  }
}

class CommonGetCommentListData {
  List<CommentListData>? data;
  Meta? meta;

  CommonGetCommentListData({this.data, this.meta});

  factory CommonGetCommentListData.fromJson(Map<dynamic, dynamic> map) {
    List datalist = map['data'] ?? [];
    List<CommentListData> datas =
        datalist.map((e) => CommentListData.fromJson(e)).toList();

    return CommonGetCommentListData(
        data: datas, meta: Meta.fromJson(map["meta"]));
  }
}

class CommentListData {
  String id;
  String comment;
  CommentUserDate? commenruserData;

  CommentListData({
    required this.id,
    required this.comment,
    required this.commenruserData,
  });

  factory CommentListData.fromJson(Map<dynamic, dynamic> map) {
    return CommentListData(
      id: (map['id'] ?? 0).toString(),
      comment: (map['comment'] ?? '').toString(),
      commenruserData:
          map["user"] == null ? null : CommentUserDate.fromJson(map["user"]),
    );
  }
}

class CommentUserDate {
  String id;
  String name;
  String image;
  String totalPost;

  CommentUserDate({
    required this.id,
    required this.name,
    required this.image,
    required this.totalPost,
  });

  factory CommentUserDate.fromJson(Map<dynamic, dynamic> map) {
    return CommentUserDate(
      id: (map['id'] ?? 0).toString(),
      name: (map['name'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      totalPost: (map['total_posts'] ?? '').toString(),
    );
  }

  fromJson(map) {}
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