import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/models/common_comment_model.dart';
import 'package:momworkapp/models/common_dashboard_model.dart';
import 'package:momworkapp/services/comment_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../../services/dashboard_services.dart';
import '../../utils/utils.dart';

class BlogDetailsScreen extends StatefulWidget {
  String? id;
  BlogDetailsScreen({super.key, this.id});

  @override
  State<BlogDetailsScreen> createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tcomment = TextEditingController();
  final ScrollController _controller = ScrollController();
  ScreenshotController screenshotController = ScreenshotController();

  late VideoPlayerController _videoPlayerController;

  List dataList = [];
  String finalDate = '';
  bool isLoading = true;
  bool isCommentLoading = true;
  List<CommentListData> commentList = [];
  CommonHomedetailsModel? commonHomedetailsModel;

  int totalData = 0;
  int loadData = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      commentListAPI(page: 1.toString());
      postDetailsAPI();
    });
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        if (commentList.length != totalData) {
          loadData = loadData + 1;
          print(loadData);
          print('commentList.length ::: ${commentList.length}');
          commentListAPI(page: loadData.toString());
        }
      }
    });
  }

// PostDetails API
  postDetailsAPI() async {
    isLoading = true;
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

    commonHomedetailsModel =
        await Services().homePostDetalis(context, widget.id);
    if (commonHomedetailsModel != null) {
      if (commonHomedetailsModel!.status) {
        setState(() {
          dataList.add(commonHomedetailsModel!.data);
          String text = commonHomedetailsModel!.data.createdat;
          var substrings = text.split("T").first;
          DateTime tempDate = DateFormat('yyyy-MM-dd').parse(substrings);
          finalDate = DateFormat.yMMMMd().format(tempDate);
          if (commonHomedetailsModel!.data.type == '2') initializeVideo();
          // finalDate = finalDate;
        });
      }
    }
    isLoading = false;
    setState(() {});
  }

// Post Like & DisLike API
  Future manageFavoriteApiData() async {
    var manageFavoritearesult =
        await Services().likePostData(context, widget.id);
    if (manageFavoritearesult != null) {
      if (commonHomedetailsModel!.data.likeStatus == "1") {
        commonHomedetailsModel!.data.likeStatus = "0";
        commonHomedetailsModel!.data.totallikes =
            (double.parse(commonHomedetailsModel!.data.totallikes) - 1)
                .toStringAsFixed(0);
      } else {
        commonHomedetailsModel!.data.likeStatus = "1";
        commonHomedetailsModel!.data.totallikes =
            (double.parse(commonHomedetailsModel!.data.totallikes) + 1)
                .toStringAsFixed(0);
      }
      setState(() {});
    }
  }

// comment Add API Call
  Future commentsAddData() async {
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

    String? userid = Utils.prefs!.getString('userid');
    var body = {
      'user_id': userid,
      'comment': tcomment.text,
    };

    print(body);
    var result = await CommentServices()
        .commentAdd(context, body: body, postId: widget.id);
    if (result != null) {
      tcomment.clear();
      FocusScope.of(context).requestFocus(new FocusNode());
      await commentListAPI(page: "1");
      setState(() {});
    }
  }

// get All Comment List
  commentListAPI({required String page}) async {
    if (page == "1") {
      commentList.clear();
      isCommentLoading = true;
      setState(() {});
    }
    var result = await CommentServices()
        .commentList(context, postId: widget.id, page: page);
    isCommentLoading = false;
    if (result != null) {
      setState(() {
        commentList.addAll(result.data.data ?? []);
        totalData = int.parse(result.data.meta!.total);
      });
    }
  }

  initializeVideo() {
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(commonHomedetailsModel!.data.image))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _takeScreenshotAndShare(BuildContext context) async {
    screenshotController
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
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: Text(
            'Post Details',
            style: TextStyle(
                color: MyColors.greyshade600,
                fontSize: 16,
                fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [
            IconButton(
                onPressed: () async {
                  // Capture screenshot

                  screenshotController.capture().then((Uint8List? image) async {
                    if (image != null) {
                      Uint8List imageInUnit8List =
                          image; // store unit8List image here ;
                      final tempDir = await getTemporaryDirectory();
                      File file =
                          await File('${tempDir.path}/image.png').create();
                      file.writeAsBytesSync(imageInUnit8List);
                      print('image:::: ScreenShort:::$file');
                      await Share.shareFiles([file.path]);
                    }
                  });
                },
                icon: const Icon(Icons.share_outlined))
          ],
        ),
        body: isLoading
            ? Container()
            : SingleChildScrollView(
                controller: _controller,
                physics: const ScrollPhysics(),
                child: SizedBox(
                  child: Column(
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: Column(
                          children: [
                            commonHomedetailsModel!.data.posttype == '2'
                                ? Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: width * 0.02),
                                    margin: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: width * 0.02),
                                    height: height * 0.20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(int.parse(
                                              commonHomedetailsModel!
                                                  .data.backgroundcolor
                                                  .toString()
                                                  .split(",")
                                                  .first)),
                                          Color(int.parse(
                                              commonHomedetailsModel!
                                                  .data.backgroundcolor
                                                  .toString()
                                                  .split(",")
                                                  .last))
                                        ],
                                      ),
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        commonHomedetailsModel!.data.description
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: commonHomedetailsModel!
                                                    .data.backgroundcolor
                                                    .contains('0xffffffff') ||
                                                    commonHomedetailsModel!
                                                    .data.backgroundcolor
                                                    .contains('0xFFFFFFFF')

                                                ? Colors.black
                                                : Colors.white,
                                            fontFamily: 'Lexend',
                                            fontSize: 18),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: width * 0.02),
                                    margin: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: width * 0.02),
                                    child: commonHomedetailsModel!.data.type ==
                                            '2'
                                        ? GestureDetector(
                                            onTap: () {
                                              _videoPlayerController
                                                      .value.isPlaying
                                                  ? _videoPlayerController
                                                      .pause()
                                                  : _videoPlayerController
                                                      .play();
                                              setState(() {});
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: SizedBox(
                                                      // height: height * 0.28,
                                                      width: double.infinity,
                                                      child:
                                                          _videoPlayerController
                                                                  .value
                                                                  .isInitialized
                                                              ? AspectRatio(
                                                                  aspectRatio:
                                                                      _videoPlayerController
                                                                          .value
                                                                          .aspectRatio,
                                                                  child: VideoPlayer(
                                                                      _videoPlayerController),
                                                                )
                                                              : const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                )),
                                                ),
                                                AnimatedSwitcher(
                                                  duration: const Duration(
                                                      milliseconds: 50),
                                                  reverseDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  child: _videoPlayerController
                                                          .value.isPlaying
                                                      ? const SizedBox.shrink()
                                                      : Center(
                                                          child: Icon(
                                                            Icons.play_arrow,
                                                            color: Colors.white,
                                                            size: 30,
                                                            semanticLabel:
                                                                'Play',
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : commonHomedetailsModel!
                                                .data.image.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    commonHomedetailsModel!
                                                        .data.image,
                                                // imageBuilder:
                                                //     (context, imageProvider) {
                                                //   return Container(
                                                //     width: double.infinity,
                                                //     decoration: BoxDecoration(
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(10),
                                                //         image: DecorationImage(
                                                //             image:
                                                //                 imageProvider,
                                                //             fit: BoxFit.fill)),
                                                //   );
                                                // },
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child:
                                                            Icon(Icons.account_circle)),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                  color:
                                                      MyColors.bacgroundcolors,
                                                )),
                                              )
                                            : Container(
                                                height: height * 0.25,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/post.png'),
                                                        fit: BoxFit.fill)),
                                              ),
                                  ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            if (commonHomedetailsModel!.data.posttype == '1')
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                      horizontal: width * 0.05),
                                  child: Text(
                                    commonHomedetailsModel!.data.description ??
                                        '',
                                    style:
                                        const TextStyle(fontFamily: 'Lexend'),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                manageFavoriteApiData();
                              },
                              child: Image.asset(
                                commonHomedetailsModel!.data.likeStatus == "1"
                                    ? 'assets/images/like.png'
                                    : 'assets/images/unlike.png',
                                height: 30,
                                width: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              commonHomedetailsModel?.data.totallikes ?? "0",
                              style: const TextStyle(
                                  color: Colors.grey, fontFamily: 'Lexend'),
                            ),
                            const Spacer(),
                            Text(
                              'Posted on $finalDate.',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Row(
                          children: [
                            commonHomedetailsModel!
                                    .data.userData!.image.isNotEmpty
                                ? SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: CachedNetworkImage(
                                        imageUrl: commonHomedetailsModel!
                                            .data.userData!.image,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Icon(Icons.account_circle)),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                          color: MyColors.bacgroundcolors,
                                        )),
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/user_profile.png',
                                    height: 50,
                                    width: 50,
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commonHomedetailsModel?.data.userData!.name ??
                                      '',
                                  style: TextStyle(
                                      color: MyColors.greyshade600,
                                      fontSize: 16,
                                      fontFamily: 'Lexend'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${commonHomedetailsModel?.data.userData!.totalPost} Posts',
                                  style: const TextStyle(
                                      color: Colors.grey, fontFamily: 'Lexend'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.01, horizontal: width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comments',
                              style: TextStyle(
                                  color: MyColors.greyshade600,
                                  fontSize: 16,
                                  fontFamily: 'Lexend'),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Form(
                                    key: formKey,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Add Comment';
                                        }
                                        return null;
                                      },
                                      controller: tcomment,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: 'Write a comment...',
                                        hintStyle: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: textFieldBorder(),
                                        focusedBorder: textFieldBorder(),
                                        enabledBorder: textFieldBorder(),
                                        disabledBorder: textFieldBorder(),
                                        contentPadding:
                                            const EdgeInsets.all(15),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      commentsAddData();
                                    }
                                  },
                                  child: Image.asset(
                                    'assets/images/send.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                                horizontal: width * 0.05),
                            child: Text(
                              'Recent comments',
                              style: TextStyle(
                                  color: MyColors.greyshade600,
                                  fontSize: 16,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          isCommentLoading
                              ? SizedBox(
                                  height: height * 0.3,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : commentList.isEmpty
                                  ? const Center(
                                      child: Padding(
                                      padding: EdgeInsets.all(50),
                                      child: Text(
                                        'No Comments Found!!',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ))
                                  : ListView.builder(
                                      // reverse: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: commentList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: height * 0.001,
                                                    horizontal: width * 0.05),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {},
                                                        child: commentList[
                                                                    index]
                                                                .commenruserData!
                                                                .image
                                                                .isNotEmpty
                                                            ? SizedBox(
                                                                height: 40,
                                                                width: 40,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              200),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: commentList[
                                                                            index]
                                                                        .commenruserData!
                                                                        .image,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Center(
                                                                            child:
                                                                                Icon(Icons.account_circle)),
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
                                                                height: 40,
                                                                width: 40)),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            commentList[index]
                                                                    .commenruserData!
                                                                    .name ??
                                                                '',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    'Lexend'),
                                                          ),
                                                          SizedBox(height: 5,),
                                                          Text(
                                                            textAlign: TextAlign
                                                                .justify,
                                                            commentList[index]
                                                                    .comment ??
                                                                '',
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xffB1B9BC),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    'Lexend'),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                height: 20,
                                                color: Colors.grey.shade300,
                                                thickness: 1,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
