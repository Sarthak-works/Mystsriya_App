import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/main/BlogDetailsScreen.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/main/EditPostScreen.dart';
import 'package:momworkapp/models/common_dashboard_model.dart';
import 'package:momworkapp/services/user_post_services.dart';
import 'package:momworkapp/utils/utils.dart';
import 'package:video_player/video_player.dart';

import '../../services/dashboard_services.dart';

class UserAllPostScreen extends StatefulWidget {
  const UserAllPostScreen({super.key});

  @override
  State<UserAllPostScreen> createState() => _UserAllPostScreenState();
}

class _UserAllPostScreenState extends State<UserAllPostScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();
  List<VideoPlayerController> _videoPlayerController = [];

  List<HomeListData> dataList = [];
  List imagelist = [];
  List userData = [];
  List paginationData = [];

  int totalData = 0;

  int loadData = 1;
  bool isCampaignLoading = true;
  bool isPostLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      userPostListAPI(page: 1.toString());
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (dataList.length != totalData) {
          loadData = loadData + 1;
          userPostListAPI(page: loadData.toString());
        }
      }
    });
  }

  Future manageFavoriteApiData(id, index) async {
    var manageFavoritearesult = await Services().likePostData(context, id);
    if (manageFavoritearesult != null) {
      if (dataList[index].likestatus == '1') {
        dataList[index].likestatus = "0";
        dataList[index].totallikes =
            (double.parse(dataList[index].totallikes) - 1).toStringAsFixed(0);
      } else {
        dataList[index].likestatus = "1";
        dataList[index].totallikes =
            (double.parse(dataList[index].totallikes) + 1).toStringAsFixed(0);
      }
      setState(() {});
    }
  }

  userPostListAPI({required String page}) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.41,
              vertical: MediaQuery.of(context).size.height * 0.44,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: CircularProgressIndicator(
              color: MyColors.bacgroundcolors,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );

    var result = await UserPostServices().userPostList(
        context: context, page: page, userid: Utils.prefs!.getString('userid'));
    isPostLoading = false;
    if (result != null) {
      if (result.status) {
        Navigator.pop(context);

        dataList.clear();
        setState(() {
          dataList.addAll(result.data.data ?? []);
          print(dataList.length);
          totalData = int.parse(result.data.meta!.total);
          _videoPlayerController = List.generate(
              dataList.length,
              (index) => VideoPlayerController.networkUrl(
                  Uri.parse(dataList[index].image)));
        });
        print(_videoPlayerController.length);
        for (var controller in _videoPlayerController) {
          controller.initialize().then((_) {
            // Ensure the first video is visible when initialized
            if (mounted) {
              setState(() {});
            }
          });
        }
      }
    } else {
      Navigator.pop(context);
    }
  }

  userDeletePost(postId) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.41,
              vertical: MediaQuery.of(context).size.height * 0.44,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: CircularProgressIndicator(
              color: MyColors.bacgroundcolors,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
    print(postId);
    var result = await UserPostServices()
        .userDeletePost(context: context, postId: postId);
    isPostLoading = false;
    if (result != null) {
      if (result.status) {
        print('1212121212121212121212');
        Navigator.pop(context);
        setState(() {});
        userPostListAPI(page: 1.toString());
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Post',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: isPostLoading
            ? Center(child: CircularProgressIndicator())
            : dataList.isEmpty
                ? const Center(
                    child: Text(
                    'No Data Found!!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return BlogDetailsScreen(
                                id: dataList[index].id,
                              );
                            },
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: dataList[index]
                                            .userData!
                                            .image
                                            .isNotEmpty
                                        ? SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              child: CachedNetworkImage(
                                                imageUrl: dataList[index]
                                                    .userData!
                                                    .image,
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child:
                                                            Icon(Icons.error)),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                  color:
                                                      MyColors.bacgroundcolors,
                                                )),
                                              ),
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/user_profile.png',
                                            height: 50,
                                            width: 50,
                                          ),
                                  ),
                                  const SizedBox(width: 10),
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text(
                                  //       dataList[index].userData?.name ?? "",
                                  //       style: const TextStyle(
                                  //           color: Colors.black,
                                  //           fontSize: 18,
                                  //           fontWeight: FontWeight.w500,
                                  //           fontFamily: 'Lexend'),
                                  //     ),
                                  //     const SizedBox(
                                  //       height: 2,
                                  //     ),
                                  //     Text(
                                  //         timeAgo(
                                  //             creteTime: DateTime.parse(
                                  //                 dataList[index].createdat)),
                                  //         style: const TextStyle(
                                  //             fontSize: 12,
                                  //             color: Colors.black38,
                                  //             fontFamily: 'Lexend'))
                                  //   ],
                                  // ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: dataList[index]
                                                    .isEdited ==
                                                    '1'?width * 0.4:width * 0.48,
                                              ),
                                              child: Text(
                                                dataList[index]
                                                        .userData
                                                        ?.name ??
                                                    "",
                                                style: const TextStyle(
                                                    overflow: TextOverflow.clip,
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Lexend'),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            dataList[index].isEdited ==
                                                    '1'.toString()
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        height: height * 0.005,
                                                        width: height * 0.005,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                shape: BoxShape
                                                                    .circle),
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        'Edited',
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontFamily:
                                                                'Lexend'),
                                                      ),
                                                    ],
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                            timeAgo(
                                                creteTime: DateTime.parse(
                                                    dataList[index].createdat)),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black38,
                                                fontFamily: 'Lexend'))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  // const Spacer(),
                                  // Like
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          manageFavoriteApiData(
                                              dataList[index].id, index);
                                        },
                                        child: dataList[index].likestatus == '1'
                                            ? Image.asset(
                                                'assets/images/like.png',
                                                height: 30,
                                                width: 30,
                                              )
                                            : Image.asset(
                                                'assets/images/unlike.png',
                                                height: 30,
                                                width: 30,
                                              ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        dataList[index].totallikes.toString(),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Lexend'),
                                      )
                                    ],
                                  ),
                                  // comment
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/comments_icon.png',
                                        height: 30,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        dataList[index].totalcomment.toString(),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Lexend'),
                                      )
                                    ],
                                  ),
                                  //share
                                  SizedBox(
                                    width: width * 0.02,
                                  ),

                                  PopupMenuButton<int>(
                                    itemBuilder: (context) => [
                                      // PopupMenuItem 1
                                      PopupMenuItem(
                                        value: 1,
                                        // row with 2 children
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.edit_outlined,
                                              size: 18,
                                            ),
                                            // SizedBox(
                                            //   width: 10,
                                            // ),
                                            Text("Edit")
                                          ],
                                        ),
                                      ),
                                      // PopupMenuItem 2
                                      PopupMenuItem(
                                        value: 2,
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Delete")
                                          ],
                                        ),
                                      ),
                                    ],
                                    elevation: 5,
                                    onSelected: (value) {
                                      if (value == 1) {
                                        print('Click Edit');
                                        if (dataList[index].image.isEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPostScreen(
                                                postType: "text",
                                                backgroundColor: dataList[index]
                                                    .backgroundcolor,
                                                id: dataList[index].id,
                                                description:
                                                    dataList[index].description,
                                              ),
                                            ),
                                          ).then((value) {
                                            setState(() {
                                              userPostListAPI(
                                                  page: 1.toString());
                                            });
                                          });
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPostScreen(
                                                      postType: 'image',
                                                      id: dataList[index].id,
                                                      imageList:
                                                          dataList[index].image,
                                                      description:
                                                          dataList[index]
                                                              .description,
                                                      type:
                                                          dataList[index].type),
                                            ),
                                          ).then((value) {
                                            setState(() {
                                              userPostListAPI(
                                                  page: 1.toString());
                                            });
                                          });
                                        }
                                      } else if (value == 2) {
                                        print('Click Dlete');
                                        userDeletePost(dataList[index].id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: (dataList[index].image).isNotEmpty
                                    ? height * 0.015
                                    : height * 0,
                              ),
                              (dataList[index].image).isNotEmpty
                                  ? Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      dataList[index].description.toString(),
                                      style:
                                          const TextStyle(fontFamily: 'Lexend'),
                                    )
                                  : const Text(''),
                              SizedBox(
                                height: (dataList[index].image).isNotEmpty
                                    ? height * 0.015
                                    : height * 0.01,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: (dataList[index].posttype == "1")
                                      ? dataList[index].type == "1"
                                          ? CachedNetworkImage(
                                              imageUrl: dataList[index].image,
                                              fit: BoxFit.fill,
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Center(
                                                      child: Icon(Icons.error)),
                                              placeholder: (context, url) =>
                                                  Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      MyColors.bacgroundcolors,
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                    height: _videoPlayerController[
                                                    index]
                                                        .value
                                                        .isInitialized?null:height * 0.25,
                                                    width: double.infinity,
                                                    child:
                                                        _videoPlayerController[
                                                                    index]
                                                                .value
                                                                .isInitialized
                                                            ? AspectRatio(
                                                                aspectRatio:
                                                                    _videoPlayerController[
                                                                            index]
                                                                        .value
                                                                        .aspectRatio,
                                                                child: VideoPlayer(
                                                                    _videoPlayerController[
                                                                        index]),
                                                              )
                                                            : const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )),
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: const Icon(
                                                    Icons.play_arrow,
                                                    size: 20,
                                                  ),
                                                )
                                              ],
                                            )
                                      : Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(int.parse(dataList[index]
                                                    .backgroundcolor
                                                    .toString()
                                                    .split(",")
                                                    .first)),
                                                Color(int.parse(dataList[index]
                                                    .backgroundcolor
                                                    .toString()
                                                    .split(",")
                                                    .last))
                                              ],
                                            ),
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            dataList[index]
                                                .description
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: dataList[index]
                                                        .backgroundcolor
                                                        .contains('0xffffffff')
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontFamily: 'Lexend'),
                                          ),
                                        ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
