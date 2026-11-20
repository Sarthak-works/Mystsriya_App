import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/common_campaigns_model.dart';
import '../../services/campaigns_services.dart';
import 'CampaignsTaskDetailsScreen.dart';
import 'Colors.dart';

class CampaignDetailsScreenNew extends StatefulWidget {
  final String? id;
  const CampaignDetailsScreenNew({super.key, this.id});

  @override
  State<CampaignDetailsScreenNew> createState() => _CampaignDetailsScreenNewState();
}

class _CampaignDetailsScreenNewState extends State<CampaignDetailsScreenNew> {
  CommonCampaignsDetailsModel? result;
  String campImage="";
  String campTitle="", campDesc="", campLink="", campStatus="", status="", campAmount="";
  double? finalpercent;
  bool isLoading = true;
  bool isAllTaskCompleted = true;
  bool applyButton = false;
  int joinUser = 0;
  int totalUser = 0;

  List<CampaignsDetailsTaskListData> taskDataList=[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1)).then((value) {
      campaignsDetailsAPI();
    });
  }

  campaignsDetailsAPI() async {
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
    result = await CampaignsServices()
        .campaignsDetailsData(context: context, id: widget.id);
    if (result != null) {
      if (result!.status) {
        setState(() {
          finalpercent = double.parse(
              (double.parse(result?.data.totalcompletecampaigns ?? '') /
                  double.parse(result?.data.totaltaskcount ?? ''))
                  .toStringAsFixed(1));
          joinUser = int.parse(result!.data.joinUser);
          totalUser = int.parse(result!.data.totalUser);
          campTitle= result!.data.title.toString();
          campDesc = result!.data.description.toString();
          campLink = result!.data.link.toString();
          campStatus = result!.data.campaignStatus.toString();
          campAmount = result!.data.amount;
          status = result!.data.status.toString();
          taskDataList = result!.data.taskListData;
          result!.data.image.isNotEmpty ? campImage="https://nivethaeacademy.in//mystsriya//public//storage//"+result!.data.image : campImage="";
          if (result!.data.campaignStatus == "2") applyButton = true;
        });
        for (var element in result!.data.taskListData) {
          if (element.usertaskstatus == "1") {
            isAllTaskCompleted = false;
            break;
          }
        }
      }
    }
    isLoading = false;
    setState(() {});
  }

  // finish task API call

  finishTaskApiData(id) async {
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

    var result = await CampaignsServices().finishtask(context: context, id: id);

    if(result != null) {
      campaignsDetailsAPI();
    }
    isLoading = false;
    setState(() {});
  }

  // Campaigns Apply

  campaignsApplyApiData() async {
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

    var result = await CampaignsServices()
        .campaignsApply(context: context, id: widget.id);

    isLoading = false;
    Navigator.pop(context);
    if (result != null) {
      campaignsDetailsAPI();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
        //    height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  GestureDetector(
                    onTap: (){Navigator.pop(context);},
                    child: Container(
                      margin: EdgeInsets.only(top: 50),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.arrow_back_outlined),
                      ),
                    ),
                  ),


                  Container(
                      margin: EdgeInsets.only(top: 10),
                      child: campImage != ''
                          ? Container(
                            padding: EdgeInsets.all(15),
                            child: CachedNetworkImage(
                                                    imageUrl: campImage.toString(),
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.fill,
                                                    errorWidget: (context, url, error) =>
                              Center(
                                  child: Icon(Icons.error, color: MyColors.bacgroundcolors,)),
                                                    placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: MyColors.bacgroundcolors,
                              )),
                                                  ),
                          )
                          : Image.asset(
                        'assets/images/user_profile.png', height: MediaQuery.of(context).size.height*0.25, fit: BoxFit.fitHeight,
                      )
                  ),

                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20)
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            campTitle ?? "Coming Soon",
                            softWrap: true,
                            textAlign: TextAlign.start,
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.black,
                                 fontSize: 20,
                                 fontWeight: FontWeight.w600,

                                 fontFamily: 'Lexend'

                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Container(
                          child: Text(
                            "Short Description",
                            softWrap: true,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Lexend'

                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: Text(
                              "\u{20B9} "+campAmount ?? "",
                              softWrap: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lexend'

                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        GestureDetector(
                          onTap: () async {
                            var url = Uri.parse(result?.data.link ?? "");
                            launchUrl(url);
                          },
                          child: Container(
                            child: Text(
                              campLink ?? "www.amazon.in",
                              softWrap: true,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Lexend'

                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),

                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    width: MediaQuery.of(context).size.width*.75,
                                    child: Html(
                                      data: result?.data.description ?? '',
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
                                  actions: [
                                      TextButton(
                                      child: Text("OK"),
                                      onPressed: () { Navigator.pop(context);},
                                      )
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColors.bacgroundcolors,
                              border: Border.all(
                                color: MyColors.bacgroundcolors,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Text("View Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,

                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: taskDataList.length ?? 0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            // color: colors[index],
                            color: taskDataList[index]
                                .usertaskstatus ==
                                '1'
                                ? const Color(0xffE9ECEA)
                                : taskDataList[index]
                                .usertaskstatus ==
                                '3'
                                ? const Color(0xffFFF6E1)
                                : taskDataList[index]
                                .usertaskstatus ==
                                '4'
                                ? const Color(0xffDDF5F3)
                                : const Color(0xffFDE8EB),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              if (applyButton == false) {
                              } else {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return CampaignsTaskDetailsScreen(
                                      id: taskDataList[index].id,
                                      index: index,
                                    );
                                  },
                                ));
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        index==0 ? taskDataList[index].title.isNotEmpty ? taskDataList[index].title.contains("-") ? taskDataList[index].title : taskDataList[index].title+" - Place the order and send screenshot for the specified product." : ""
                                        : index==3 ? taskDataList[index].title.isNotEmpty ? taskDataList[index].title.contains("-") ? taskDataList[index].title : taskDataList[index].title+" - If approved please proceed with the review on Amazon and share us screenshot and link of the review.\n\nWe will check the review and after 7 days will release the payment to your bank account." : ""
                                        : taskDataList[index].title ?? "",
                                        //taskDataList[index].title ?? "",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: taskDataList[index]
                                                .usertaskstatus ==
                                                '1'
                                                ? const Color(0xff66737C)
                                                : taskDataList[index]
                                                .usertaskstatus ==
                                                '3'
                                                ? const Color(0xffFED36A)
                                                : taskDataList[index]
                                                .usertaskstatus ==
                                                '4'
                                                ? const Color(
                                                0xff2EC4B6)
                                                : const Color(
                                                0xffE71D36),
                                            fontFamily: 'Lexend'),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  width: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // color: backgroundColors[index],
                                      color: taskDataList[index]
                                          .usertaskstatus ==
                                          '1'
                                          ? const Color(0xffB1B9BC)
                                          : taskDataList[index]
                                          .usertaskstatus ==
                                          '3'
                                          ? const Color(0xffFED36A)
                                          : taskDataList[index]
                                          .usertaskstatus ==
                                          '4'
                                          ? const Color(0xff2EC4B6)
                                          : const Color(0xffE71D36),
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: taskDataList[index]
                                          .usertaskstatus ==
                                          '1'
                                          ? Image.asset(
                                          'assets/images/round.png')
                                          : taskDataList[index]
                                          .usertaskstatus ==
                                          '3'
                                          ? Image.asset(
                                          'assets/images/more.png')
                                          : taskDataList[index]
                                          .usertaskstatus ==
                                          '5'
                                          ? Image.asset(
                                          'assets/images/close.png')
                                          : Image.asset(
                                          'assets/images/tickcircle.png')),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 30,),

                  SizedBox(
                    height: 10,
                  ),
                  campStatus == '0' && joinUser >= totalUser?Center(
                    child: Text(
                      'Campaigns user list is full',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  ):
                  campStatus == '0'
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.bacgroundcolors,
                        minimumSize:
                        const Size(double.infinity, 50)),
                    onPressed: () {
                      campaignsApplyApiData();
                    },
                    child: const Text(
                      "Apply",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  )
                      : campStatus == '1'
                      ? Center(
                    child: Text(
                      'Your Application is under Review',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  )
                      : campStatus == '3'
                      ? Center(
                    child: Text(
                      'Your Application is Rejected',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  if (isAllTaskCompleted &&
                      (status ?? "1") != "2")
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.bacgroundcolors,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        // if (result?.data.totaltaskcount ==
                        //     result!.data.totalcompletecampaigns) {
                        //   print(
                        //       'tcheck this :::::: ${result?.data.totaltaskcount == result!.data.totalcompletecampaigns}');

                        finishTaskApiData(result!.data.id);
                        print('Ok');
                        // } else {
                        //   print('comaple All tasks');
                        // }
                      },
                      child: const Text(
                        "Finish Campaign",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                    ),

                ],
              ),
            )
        ),
      ),
    );
  }
}
