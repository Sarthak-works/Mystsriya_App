import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/main/CampaignsDetailsScreen.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../models/common_campaigns_model.dart';
import '../../services/campaigns_services.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int range = 50;
  bool isLoading = true;

  List<CampaignsListData> campaignsDataList = [];
  List taskListData = [];
  List userListData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      campaignsListAPI();
    });
  }

  campaignsListAPI() async {
    isLoading = true;
    var result = await CampaignsServices().campaignsListData(context: context);
    isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Campaign",
              style: TextStyle(
                  fontSize: 18,
                  color: MyColors.greyshade600,
                  fontFamily: 'Lexend')),
          backgroundColor: Colors.white,
          elevation: 1,
        ),


        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomBottomTabBar(),
              ),(route) => false,
            );
            return true;
          },
          child: Container(
            color: Colors.white,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: MyColors.bacgroundcolors,
                    ),
                  )
                : campaignsDataList.isEmpty
                    ? const Center(
                        child: Padding(
                        padding: EdgeInsets.all(50),
                        child: Text(
                          'No Data Found!!',
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                        ),
                      ))
                    : ListView.separated(
                        itemCount: campaignsDataList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 15, left: 15, right: 15, bottom: 15),
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CampaignsDetailsScreen(
                                    id: campaignsDataList[index].id,
                                  );
                                },
                              ));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: MyColors.bacgroundcolors,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2),
                                ],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    campaignsDataList[index].title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Lexend'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      AvatarStack(
                                        height: 30,
                                        width: 100,
                                        avatars: [
                                          for (int i = 0;
                                              i <
                                                  campaignsDataList[index]
                                                      .userListData
                                                      .length;
                                              i++)
                                            NetworkImage(
                                                campaignsDataList[index]
                                                    .userListData[i]
                                                    .image),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 30,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${campaignsDataList[index].totaltaskcount} Task',
                                              style: TextStyle(
                                                  color: MyColors.greyshade600,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Lexend'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '₹ ${campaignsDataList[index].amount}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Lexend',
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  LinearPercentIndicator(
                                    barRadius: const Radius.circular(5),
                                    addAutomaticKeepAlive: true,
                                    padding: const EdgeInsets.only(right: 0),
                                    width: width * 0.82,
                                    animation: true,
                                    animationDuration: 1000,
                                    lineHeight: 5,
                                    percent: double.parse(
                                                campaignsDataList[index]
                                                    .totaltaskcount) ==
                                            0
                                        ? 0
                                        : double.parse(campaignsDataList[index]
                                                .totalcompletecampaigns) /
                                            double.parse(
                                                campaignsDataList[index]
                                                    .totaltaskcount),
                                    progressColor: Colors.white,
                                    backgroundColor: const Color(0xff21B6A8),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      double.parse(campaignsDataList[index]
                                                  .totaltaskcount) ==
                                              0
                                          ? "0 %"
                                          : "${((double.parse(campaignsDataList[index].totalcompletecampaigns) * 100) / double.parse(campaignsDataList[index].totaltaskcount)).toStringAsFixed(0)} %",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Lexend'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
