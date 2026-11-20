import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/widgets/complet_task_dialog.dart';
import 'package:momworkapp/models/common_campaigns_model.dart';
import 'package:momworkapp/services/campaigns_services.dart';
import 'package:momworkapp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignsTaskDetailsScreen extends StatefulWidget {
  String? id;
  int? index;
  CampaignsTaskDetailsScreen({super.key, this.id, this.index});

  @override
  State<CampaignsTaskDetailsScreen> createState() =>
      _CampaignsTaskDetailsScreenState();
}

class _CampaignsTaskDetailsScreenState
    extends State<CampaignsTaskDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tdes = TextEditingController();

  String? imagePath;
  bool imageStatus = false;
  File? proImage;
  final ImagePicker _picker = ImagePicker();

  CommonCampaignsTaskDetailsModel? result;

  @override
  void initState() {
    super.initState();
    print("fdgfd ${widget.index}");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      campaignsDetailsAPI();
    });
  }

  campaignsDetailsAPI() async {
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
    result = await CampaignsServices()
        .campaignsTaskDetailsData(context: context, id: widget.id);
    setState(() {});
    if (result != null) {
      if (result!.status) {}
    }
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
            'Task Details',
            style: TextStyle(
                color: MyColors.greyshade600,
                fontSize: 18,
                fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      result?.data.taskDetails.title ?? '',
                      style: TextStyle(
                          fontSize: 22,
                          color: MyColors.greyshade600,
                          fontFamily: 'Lexend'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: MyColors.bacgroundcolors,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/tickcircle.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Task Status',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: MyColors.greyshade500,
                                        fontFamily: 'Lexend'),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    result?.data.taskDetails.usertaskstatus ==
                                            '1'
                                        ? 'New'
                                        : result?.data.taskDetails
                                                    .usertaskstatus ==
                                                '3'
                                            ? 'In Review'
                                            : result?.data.taskDetails
                                                        .usertaskstatus ==
                                                    '5'
                                                ? 'Rejected'
                                                : 'Accepted',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: MyColors.greyshade600,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Text(
                  'Task Details',
                  style: TextStyle(
                      color: MyColors.greyshade600,
                      fontSize: 16,
                      fontFamily: 'Lexend'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Html(
                  data: Utils.prefs!.getString("userName")=="Test Ekas" ? result?.data.taskDetails.description.replaceAll("We will check the&nbsp;review and after 7 days will release the payment to your bank account.", "") : result?.data.taskDetails.description ?? '',
                  style: {
                    'body': Style(
                        color: MyColors.greyshade500,
                        fontFamily: 'Lexend',
                        fontSize: FontSize(13)
                    )
                  },
                  onLinkTap: (url, attributes, element) {
                    if ((url ?? "").isNotEmpty) {
                      launchUrl(Uri.parse(url!));
                    }
                  },
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              //   child: Text(
              //     textAlign: TextAlign.justify,
              //     result?.data.taskDetails.description ?? '',
              //     style: TextStyle(
              //         color: MyColors.greyshade500,
              //         fontSize: 13,
              //         fontFamily: 'Lexend'),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: Utils.prefs!.getString('userName')!="Test Ekas",
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  color: MyColors.bacgroundcolors,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Campaign Name',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Lexend'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        result?.data.campaignDetails.title ?? '',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        'Campaign Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Lexend'),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Html(
                        data: result?.data.campaignDetails.description  ?? '',
                        style: {
                          'body': Style(
                              color: Colors.white,
                              fontFamily: 'Lexend',
                              fontSize: FontSize(16)
                          )
                        },
                        onLinkTap: (url, attributes, element) {
                          if ((url ?? "").isNotEmpty) {
                            launchUrl(Uri.parse(url!));
                          }
                        },
                      ),
                      // Text(
                      //   result?.data.campaignDetails.description ?? '',
                      //   style: const TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 13,
                      //       fontFamily: 'Lexend'),
                      // ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
              if(result?.data.taskDetails.usertaskstatus == '5' && (result?.data.taskDetails.comments ?? "").isNotEmpty)const SizedBox(
                height: 20,
              ),
              if(result?.data.taskDetails.usertaskstatus == '5' && (result?.data.taskDetails.comments ?? "").isNotEmpty) Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Reject Reason : ",style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Lexend', color: MyColors.greyshade600,)),
                      TextSpan(text: result?.data.taskDetails.comments ?? "",style: TextStyle(fontFamily: 'Lexend',color: MyColors.greyshade600,)),
                    ]
                  )
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // if (widget.index==0 && (result?.data.taskDetails.usertaskstatus == '1' || result?.data.taskDetails.usertaskstatus == '5') )
              //   Padding(
              //     padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: MyColors.bacgroundcolors,
              //           minimumSize: const Size(double.infinity, 50)),
              //       onPressed: () {
              //         showDialog(
              //             barrierDismissible: false,
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 backgroundColor: Colors.transparent,
              //                 contentPadding: const EdgeInsets.all(0),
              //                 content: Stack(
              //                   alignment: Alignment.topCenter,
              //                   clipBehavior: Clip.none,
              //                   children: [
              //                     CompletTaskDialog(
              //                         taskId: result!.data.taskDetails.id,
              //                         campaignId:
              //                             result!.data.campaignDetails.id),
              //                     Positioned(
              //                       top: -20,
              //                       child: InkResponse(
              //                         onTap: () {
              //                           Navigator.of(context).pop();
              //                         },
              //                         child: CircleAvatar(
              //                           backgroundColor:
              //                               MyColors.bacgroundcolors,
              //                           child: const Icon(
              //                             Icons.close,
              //                             color: Colors.white,
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             });
              //       },
              //       child: Text(
              //         result?.data.taskDetails.usertaskstatus == '1'?"Complete Task":"Resubmit Task",
              //         style: TextStyle(fontSize: 16,color: Colors.white,),
              //       ),
              //     ),
              //   ),

              widget.index==0 ? result?.data.taskDetails.usertaskstatus == '1' || result?.data.taskDetails.usertaskstatus == '5' ? Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.bacgroundcolors,
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            contentPadding: const EdgeInsets.all(0),
                            content: Stack(
                              alignment: Alignment.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                CompletTaskDialog(
                                    taskId: result!.data.taskDetails.id,
                                    campaignId:
                                    result!.data.campaignDetails.id),
                                Positioned(
                                  top: -20,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                      MyColors.bacgroundcolors,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text(
                    result?.data.taskDetails.usertaskstatus == '1'?"Complete Task":"Resubmit Task",
                    style: TextStyle(fontSize: 16,color: Colors.white,),
                  ),
                ),
              ) : Container()

              : widget.index!=0 ?
              (result?.data.campaignDetails.taskDataList[widget.index!-1].usertaskstatus!="1" ) && (result?.data.taskDetails.usertaskstatus == '1' || result?.data.taskDetails.usertaskstatus == '5') ? Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.bacgroundcolors,
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    print("gdffdg ${result?.data.campaignDetails.taskDataList[widget.index!-1].usertaskstatus}");
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            contentPadding: const EdgeInsets.all(0),
                            content: Stack(
                              alignment: Alignment.topCenter,
                              clipBehavior: Clip.none,
                              children: [
                                CompletTaskDialog(
                                    taskId: result!.data.taskDetails.id,
                                    campaignId:
                                    result!.data.campaignDetails.id),
                                Positioned(
                                  top: -20,
                                  child: InkResponse(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                      MyColors.bacgroundcolors,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Text(
                    result?.data.taskDetails.usertaskstatus == '1'?"Complete Task":"Resubmit Task",
                    style: TextStyle(fontSize: 16,color: Colors.white,),
                  ),
                ),
              ) : Container()  : Container()

            ],
          ),
        ),
      ),
    );
  }
}
