import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:momworkapp/Screen/main/CampaignsTaskDetailsScreen.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/models/common_campaigns_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/campaigns_services.dart';

class CampaignsDetailsScreen extends StatefulWidget {
  final String? id;
  CampaignsDetailsScreen({super.key, this.id});

  @override
  State<CampaignsDetailsScreen> createState() => _CampaignsDetailsScreenState();
}

class _CampaignsDetailsScreenState extends State<CampaignsDetailsScreen> {
  CommonCampaignsDetailsModel? result;
  double? finalpercent;
  bool isLoading = true;
  bool isAllTaskCompleted = true;
  bool applyButton = false;
  int joinUser = 0;
  int totalUser = 0;

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
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: Text(
            'Campaigns Details',
            style: TextStyle(
                color: MyColors.greyshade600,
                fontSize: 18,
                fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: isLoading
            ? Container()
            : SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        result?.data.title ?? "",
                        style: TextStyle(
                            fontSize: 18,
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
                                      'Total Task',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: MyColors.greyshade500,
                                          fontFamily: 'Lexend'),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      result?.data.totaltaskcount ?? "",
                                      style: TextStyle(
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
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
                                      'assets/images/wallet.png',
                                      height: 25,
                                      width: 25,
                                      color: Colors.white,
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
                                      'Total Amount',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: MyColors.greyshade500,
                                          fontFamily: 'Lexend'),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '₹ ${result?.data.amount ?? ''}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Lexend',
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Campaign Details',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Html(
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
                      GestureDetector(
                        onTap: () async {
                          var url = Uri.parse(result?.data.link ?? "");
                          launchUrl(url);
                        },
                        child: Text(
                          result?.data.link ?? '',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 13,
                              fontFamily: 'Lexend'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Campaign Progress',
                            style: TextStyle(
                                color: MyColors.greyshade600,
                                fontSize: 16,
                                fontFamily: 'Lexend'),
                          ),
                          const Spacer(),
                          CircularPercentIndicator(
                            animation: true,
                            animationDuration: 2000,
                            radius: 30,
                            lineWidth: 5.0,
                            percent: double.parse(
                                        result!.data.totaltaskcount) ==
                                    0
                                ? 0
                                : double.parse(
                                        result!.data.totalcompletecampaigns) /
                                    double.parse(result!.data.totaltaskcount),
                            center: Text(
                              double.parse(result!.data.totaltaskcount) == 0
                                  ? "0"
                                  : "${((double.parse(result!.data.totalcompletecampaigns) * 100) / double.parse(result!.data.totaltaskcount)).toStringAsFixed(0)} %",
                              style: TextStyle(
                                  color: MyColors.bacgroundcolors,
                                  fontFamily: 'Lexend'),
                            ),
                            progressColor: MyColors.bacgroundcolors,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'All Tasks',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result?.data.taskListData.length ?? 0,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              // color: colors[index],
                              color: result?.data.taskListData[index]
                                          .usertaskstatus ==
                                      '1'
                                  ? const Color(0xffE9ECEA)
                                  : result?.data.taskListData[index]
                                              .usertaskstatus ==
                                          '3'
                                      ? const Color(0xffFFF6E1)
                                      : result?.data.taskListData[index]
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
                                        id: result?.data.taskListData[index].id,
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
                                          result?.data.taskListData[index]
                                                  .title ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: result
                                                          ?.data
                                                          .taskListData[index]
                                                          .usertaskstatus ==
                                                      '1'
                                                  ? const Color(0xff66737C)
                                                  : result
                                                              ?.data
                                                              .taskListData[
                                                                  index]
                                                              .usertaskstatus ==
                                                          '3'
                                                      ? const Color(0xffFED36A)
                                                      : result
                                                                  ?.data
                                                                  .taskListData[
                                                                      index]
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
                                        color: result?.data.taskListData[index]
                                                    .usertaskstatus ==
                                                '1'
                                            ? const Color(0xffB1B9BC)
                                            : result?.data.taskListData[index]
                                                        .usertaskstatus ==
                                                    '3'
                                                ? const Color(0xffFED36A)
                                                : result
                                                            ?.data
                                                            .taskListData[index]
                                                            .usertaskstatus ==
                                                        '4'
                                                    ? const Color(0xff2EC4B6)
                                                    : const Color(0xffE71D36),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: result?.data.taskListData[index]
                                                    .usertaskstatus ==
                                                '1'
                                            ? Image.asset(
                                                'assets/images/round.png')
                                            : result?.data.taskListData[index]
                                                        .usertaskstatus ==
                                                    '3'
                                                ? Image.asset(
                                                    'assets/images/more.png')
                                                : result
                                                            ?.data
                                                            .taskListData[index]
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
                      SizedBox(
                        height: height * 0.02,
                      ),
                      result!.data.campaignStatus == '0' && joinUser >= totalUser?Center(
                        child: Text(
                          'Campaigns user list is full',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                      ):
                          result!.data.campaignStatus == '0'
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
                              : result!.data.campaignStatus == '1'
                                  ? Center(
                                      child: Text(
                                        'Your Application is under Review',
                                        style: TextStyle(
                                            color: Colors.yellow,
                                            fontSize: 16,
                                            fontFamily: 'Lexend'),
                                      ),
                                    )
                                  : result!.data.campaignStatus == '3'
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
                        height: height * 0.01,
                      ),
                      if (isAllTaskCompleted &&
                          (result?.data.status ?? "1") != "2")
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
                ),
              ),
      ),
    );
  }
}
