import 'dart:io';
import 'dart:typed_data';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momworkapp/Screen/main/BlogDetailsScreen.dart';
import 'package:momworkapp/Screen/main/CampaignScreenNewFilter.dart';
import 'package:momworkapp/Screen/main/CampaignsDetailsScreen.dart';
import 'package:momworkapp/Screen/main/CampaignsScreen.dart';
import 'package:momworkapp/Screen/main/CampaignsScreenNew.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/main/CreatePostScreen.dart';
import 'package:momworkapp/Screen/main/NotificationScreen.dart';
import 'package:momworkapp/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../models/common_dashboard_model.dart';
import '../../services/campaigns_services.dart';
import '../../services/dashboard_services.dart';
import '../auth/LoginHomeScreen.dart';
import 'CampaignDetailsScreenNew.dart';

class DashBoardScreen extends StatefulWidget {
  int? selectedTabIndex;
  DashBoardScreen({super.key, this.selectedTabIndex});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();
  List<VideoPlayerController> _videoPlayerController = [];
  List<ScreenshotController> screenshotController = [ScreenshotController()];

  List<HomeListData> dataList = [];
  List imagelist = [];
  List userData = [];

  List campaignsDataList = [];
  List taskListData = [];
  List userListData = [];

  String? userName;
  String? imagePath;

  int totalData = 0;

  int loadData = 1;
  bool isCampaignLoading = true;
  bool isPostLoading = true;

  Widget CampaignWidget(int index) {
    var campImage="";
    if (campaignsDataList[index].image.toString().isNotEmpty)
      campImage = "https://nivethaeacademy.in//mystsriya//public//storage//"+ campaignsDataList[index].image.toString();
    else
      campImage="";
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) {
                return CampaignDetailsScreenNew(
                  id: campaignsDataList[index].id,
                );
              },
            ));
      },
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 7,
        child: Container(
          // padding: const EdgeInsets.symmetric(
          //     vertical: 10, horizontal: 10),
          // margin: const EdgeInsets.symmetric(
          //     vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(20)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              children: [

                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.bacgroundcolors,
                        border: Border.all(
                          color: MyColors.bacgroundcolors,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.all(5),
                              child: campImage != ''
                                  ? ClipRRect(borderRadius: BorderRadius.circular(10.0),
                                    child: CachedNetworkImage(
                                            imageUrl: campImage.toString(),
                                            height: MediaQuery.of(context).size.height*0.25,
                                            fit: BoxFit.fitHeight,
                                            errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Icon(Icons.account_circle, color: Colors.white,)),
                                                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                                color: MyColors.bacgroundcolors,
                                              )),
                                                                  ),
                                  )
                                  : ClipRRect(borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                  //margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  height: MediaQuery.of(context).size.height*0.30,
                                  color: Colors.white,
                                  child: Image.asset(
                                    'assets/images/no-photo.png', color: MyColors.bacgroundcolors, height: MediaQuery.of(context).size.height*0.20, fit: BoxFit.contain,
                                  ),
                                ),
                              )
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.bacgroundcolors,
                              border: Border.all(
                                color: MyColors.bacgroundcolors,
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            padding: EdgeInsets.all(0),
                            child: Text(
                              "Slots: "+campaignsDataList[index].total_join_users+"/"+campaignsDataList[index].total_users+" ",
                              style: TextStyle(
                                  color: Colors.white,
                                   fontSize: 12,
                                  // fontWeight: FontWeight.w600,
                                  fontFamily: 'Lexend'

                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ),

                Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.topRight,
                              child: Container(

                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.only(
                                //    topRight: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  " Total Tasks: "+campaignsDataList[index].totaltaskcount+" ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontSize: 26,
                                      // fontWeight: FontWeight.w600,
                                      fontFamily: 'Lexend'

                                  ),
                                ),
                              )
                          ),

                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Text(
                                campaignsDataList[index].title,
                                style: TextStyle(
                                    color: MyColors.bacgroundcolors,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lexend'

                                ),
                              ),
                            ),
                          ),


                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                              child: Text(
                                "Price: \u{20B9}"+campaignsDataList[index].amount,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lexend'

                                ),
                              ),
                            ),
                          ),

                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  width: 150,
                                  margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                                  padding: EdgeInsets.all(7),

                                  decoration: BoxDecoration(
                                    color: MyColors.bacgroundcolors,
                                    border: Border.all(
                                      color: MyColors.bacgroundcolors,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text("View Details",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,

                                    ),
                                  ),
                                ),
                              )
                          )

                        ],
                      ),
                    )
                )

              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      dashboardAPi(page: 1.toString());
      campaignsListAPI();
      setState(() {
        userName = Utils.prefs!.getString('userName');
        imagePath = Utils.prefs!.getString('userImage');
      });
    });

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (dataList.length != totalData) {
          loadData = loadData + 1;
          dashboardAPi(page: loadData.toString());
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

  dashboardAPi({required String page}) async {
    if (page == "1") {
      dataList.clear();
      isPostLoading = true;
      setState(() {});
    }
    var result = await Services().homePostList(context: context, page: page);
    isPostLoading = false;

    if (result != null) {
      if (result.status) {
        setState(() {
          dataList.addAll(result.data.data ?? []);
          totalData = int.parse(result.data.meta!.total);
          _videoPlayerController = List.generate(
              dataList.length,
              (index) => VideoPlayerController.networkUrl(
                  Uri.parse(dataList[index].image)));
          screenshotController =
              List.generate(dataList.length, (index) => ScreenshotController());
          for(int i = 0; i<dataList.length; i++) {
            if(dataList[i].type == "2") {
              print("index : $i");
              _videoPlayerController[i].initialize().whenComplete(() {
              setState(() {});
              });
            }
          }
        });
         
      }
    } else {
      Fluttertoast.showToast(
        msg: "Session Expired! Please Login Again..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginHomeScreen();
      },));
    }
  }

  campaignsListAPI() async {
    isCampaignLoading = true;
    var result = await CampaignsServices().campaignsListData(context: context);
    isCampaignLoading = false;
    if (result != null) {
      if (result.status) {
        setState(() {
          campaignsDataList.addAll(result.data ?? []);
          campaignsDataList.removeWhere((element) => element.status == "2");
          for (var element in (campaignsDataList)) {
            userListData.addAll(element.userListData ?? []);
            taskListData.addAll(element.taskListData ?? []);
          }
        });
      }
    }
  }

  void _takeScreenshotAndShare(BuildContext context, int index) async {
    screenshotController[index]
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? image) {
      if (image != null) {
        Share.shareFiles(['screenshot.png'], text: 'Check out my screenshot!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              controller: _controller,
              physics: const ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: MyColors.bacgroundcolors,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              userName ?? '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontFamily: 'Lexend'),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(onTap:(){Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const NotificationScreen();
                            },
                          ),);
                          }, child: Icon(Icons.notifications, color: Colors.white,)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: SizedBox(
                              height: 60,
                              width: 60,
                              child: imagePath != ''
                                  ? CachedNetworkImage(
                                      imageUrl: imagePath.toString(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.account_circle, color: Colors.white,)),
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                        color: MyColors.bacgroundcolors,
                                      )),
                                    )
                                  : Image.asset(
                                      'assets/images/user_profile.png', color: Colors.white,)),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  if (campaignsDataList.isNotEmpty && Utils.prefs!.getString("userName")!="Test Ekas")
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            'Latest campaigns',
                            style: TextStyle(
                                color: MyColors.greyshade600,
                                fontFamily: 'Lexend',
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const CampaignScreenNewFilter();
                                },
                              ));
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                  color: MyColors.bacgroundcolors,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (campaignsDataList.isNotEmpty && Utils.prefs!.getString("userName")!="Test Ekas")
                    SizedBox(
                      height: height * 0.28,
                      child: isCampaignLoading
                          ? Center(
                              child: CircularProgressIndicator(
                              color: MyColors.bacgroundcolors,
                            ))
                          : campaignsDataList.isEmpty
                              ? const Center(
                                  child: Text(
                                  'No Data Found!!',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: campaignsDataList.length,
                                  itemBuilder: (context, index) {
                                    return CampaignWidget(index);
                                  },
                                ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Discover post',
                      style: TextStyle(
                          color: MyColors.greyshade600,
                          fontSize: 20,
                          fontFamily: 'Lexend'),
                    ),
                  ),
                  isPostLoading
                      ? SizedBox(
                          height: height * 0.3,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: MyColors.bacgroundcolors,
                          )))
                      : dataList.isEmpty
                          ? SizedBox(
                              height: height * 0.4,
                              child: const Center(
                                  child: Text(
                                'No Data Found!!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userName=="Test Ekas" ? 2 : dataList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    loadData = 1;
                                    print("1");
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BlogDetailsScreen(
                                            id: dataList[index].id,
                                          );
                                        },
                                      ),
                                    );
                                    dashboardAPi(page: loadData.toString());
                                  },
                                  child: Container(
                                    width: width,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              child: dataList[index]
                                                      .userData!
                                                      .image
                                                      .isNotEmpty
                                                  ? SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(200),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              dataList[index]
                                                                  .userData!
                                                                  .image,
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Center(
                                                                  child: Icon(Icons
                                                                      .account_circle)),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                            color: MyColors
                                                                .bacgroundcolors,
                                                          )),
                                                        ),
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'assets/images/user_profile.png',
                                                      height: 50,
                                                      width: 50),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        constraints: BoxConstraints(
                                                          maxWidth:  dataList[index]
                                                              .isEdited ==
                                                              '1'?width * 0.43:width * 0.5,
                                                        ),
                                                        child: Text(
                                                          dataList[index]
                                                                  .userData
                                                                  ?.name ??
                                                              "",
                                                          // "8745125346541587",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      'Lexend'),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.02,
                                                      ),
                                                      dataList[index]
                                                                  .isEdited ==
                                                              '1'.toString()
                                                          ? Row(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.005,
                                                                  width:
                                                                      height *
                                                                          0.005,
                                                                  decoration: BoxDecoration(
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
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
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
                                                          creteTime: DateTime
                                                              .parse(dataList[
                                                                      index]
                                                                  .createdat)),
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
                                            // Like
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    manageFavoriteApiData(
                                                        dataList[index].id,
                                                        index);
                                                  },
                                                  child: dataList[index]
                                                              .likestatus ==
                                                          '1'
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
                                                  dataList[index]
                                                      .totallikes
                                                      .toString(),
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
                                                  dataList[index]
                                                      .totalcomment
                                                      .toString(),
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
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    screenshotController[index]
                                                        .capture()
                                                        .then((Uint8List?
                                                            image) async {
                                                      if (image != null) {
                                                        Uint8List
                                                            imageInUnit8List =
                                                            image; // store unit8List image here ;
                                                        final tempDir =
                                                            await getTemporaryDirectory();
                                                        File file = await File(
                                                                '${tempDir.path}/image.png')
                                                            .create();
                                                        file.writeAsBytesSync(
                                                            imageInUnit8List);
                                                        print(
                                                            'image:::: ScreenShort:::$file');
                                                        await Share.shareFiles(
                                                            [file.path]);
                                                      }
                                                    });
                                                  },
                                                  child: Image.asset(
                                                    'assets/images/share_icon.png',
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  '',
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: 'Lexend'),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              (dataList[index].image).isNotEmpty
                                                  ? height * 0.025
                                                  : height * 0,
                                        ),
                                        Screenshot(
                                          controller:
                                              screenshotController[index],
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              (dataList[index].image).isNotEmpty
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Container(
                                                        color: Colors.white,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    height *
                                                                        0.01,
                                                                horizontal:
                                                                    width *
                                                                        0.05),
                                                        child: Text(
                                                          dataList[index]
                                                              .description
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontFamily:
                                                                      'Lexend'),
                                                        ),
                                                      ),
                                                    )
                                                  : const Text(''),
                                              SizedBox(
                                                height: (dataList[index].image)
                                                        .isNotEmpty
                                                    ? height * 0.015
                                                    : height * 0.01,
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: (dataList[index]
                                                              .posttype ==
                                                          "1")
                                                      ? dataList[index].type ==
                                                              "1"
                                                          ? CachedNetworkImage(
                                                              imageUrl:
                                                                  dataList[
                                                                          index]
                                                                      .image,
                                                              fit: BoxFit.fill,
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Center(
                                                                      child: Icon(
                                                                          Icons
                                                                              .error)),
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: MyColors
                                                                      .bacgroundcolors,
                                                                ),
                                                              ),
                                                            )
                                                          : Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: _videoPlayerController[index]
                                                                        .value
                                                                        .isInitialized?null:height * 0.25,
                                                                    width: double
                                                                        .infinity,
                                                                    child: _videoPlayerController[index]
                                                                            .value
                                                                            .isInitialized
                                                                        ? AspectRatio(
                                                                            aspectRatio:
                                                                                _videoPlayerController[index].value.aspectRatio,
                                                                            child:
                                                                                VideoPlayer(_videoPlayerController[index]),
                                                                          )
                                                                        : const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          )),
                                                                Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    size: 20,
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                      : Container(
                                                    height: height * 0.25,
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                Color(int.parse(dataList[
                                                                        index]
                                                                    .backgroundcolor
                                                                    .toString()
                                                                    .split(",")
                                                                    .first)),
                                                                Color(int.parse(dataList[
                                                                        index]
                                                                    .backgroundcolor
                                                                    .toString()
                                                                    .split(",")
                                                                    .last))
                                                              ],
                                                            ),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black12),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Text(
                                                            dataList[index]
                                                                .description
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: dataList[
                                                                            index]
                                                                        .backgroundcolor
                                                                        .contains(
                                                                            '0xffffffff') ||
                                                                        dataList[
                                                                            index]
                                                                        .backgroundcolor
                                                                        .contains(
                                                                            '0xFFFFFFFF')

                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                fontFamily:
                                                                    'Lexend'),
                                                          ),
                                                        ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'What would you like to post?',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: MyColors.greyshade600,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              textAlign: TextAlign.center,
                              'Would you like to post your Image or \n own Text?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Lexend',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            MyColors.bacgroundcolors,
                                        minimumSize:
                                            const Size(double.infinity, 40)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return CreatePostScreen(
                                            type: 'image',
                                          );
                                        },
                                      ));
                                    },
                                    child: const Text(
                                      "Post",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16, fontFamily: 'Lexend'),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            MyColors.bacgroundcolors,
                                        minimumSize:
                                            const Size(double.infinity, 40)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return CreatePostScreen(
                                            type: 'text',
                                          );
                                        },
                                      ));
                                    },
                                    child: const Text(
                                      "Story",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16, fontFamily: 'Lexend'),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            backgroundColor: MyColors.bacgroundcolors,
            foregroundColor: Colors.white,
            child: const Icon(
              Icons.add,
              size: 25,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
