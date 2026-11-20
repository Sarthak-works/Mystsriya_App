import 'package:avatar_stack/avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/main/MyCampaigns.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../models/common_campaigns_model.dart';
import '../../services/campaigns_services.dart';
import 'CampaignDetailsScreenNew.dart';
import 'CampaignsDetailsScreen.dart';
import 'CampaignsScreen.dart';
import 'Colors.dart';
import 'DashBoardScreen.dart';

class CampaignsScreenNew extends StatefulWidget {
  const CampaignsScreenNew({Key? key}) : super(key: key);

  @override
  State<CampaignsScreenNew> createState() => _CampaignsScreenNewState();
}

class _CampaignsScreenNewState extends State<CampaignsScreenNew> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int range = 50;
  bool isLoading = true;

  List<CampaignsListData> campaignsDataList = [];
  List taskListData = [];
  List userListData = [];

  late TabController tabController;

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
      child: Container(
        height: MediaQuery.of(context).size.height*0.30,
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 7,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(20)),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
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
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitHeight,
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            child: Icon(Icons.error, color: MyColors.bacgroundcolors,)),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          color: MyColors.bacgroundcolors,
                                        )),
                                  ),
                                )
                                    : ClipRRect(borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                  //  margin: EdgeInsets.all(10),
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
                                      campaignsDataList[index].status=="0" ? " Total Tasks: "+campaignsDataList[index].totaltaskcount+" ":
                                      campaignsDataList[index].status=="1" ?" Task Rem. "+(int.parse(campaignsDataList[index].totaltaskcount)-(int.parse(campaignsDataList[index].total_user_task_count))).toString()+"/"+campaignsDataList[index].totaltaskcount+" ":
                                      "Completed",
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
                              flex: 2,
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
                                    padding: EdgeInsets.all(10),

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
      ),
    );
  }
  

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // GestureDetector(
                //   onTap: (){Navigator.pop(context);},
                //   child: Container(
                //     margin: EdgeInsets.only(top: 50),
                //     child: CircleAvatar(
                //       backgroundColor: Colors.grey[350],
                //       child: Icon(Icons.arrow_back_outlined),
                //     ),
                //   ),
                // ),

                SizedBox(height: 70,),

                TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    labelColor: MyColors.bacgroundcolors,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: MyColors.bacgroundcolors,
                    controller: tabController,
                    onTap: (value){
                      if (value == 1) {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyCampaigns())
                        );
                      }
                    },
                    tabs: [
                      Tab(text: "All Campaigns",),
                      Tab(text: "My Campaigns",),
                    ]
                ),

                SizedBox(height: 15,),

                Expanded(
                    child: Container(
                      child: TabBarView(
                          controller: tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
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
                                  : ListView.builder(
                                itemCount: campaignsDataList.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    top: 15, left: 15, right: 15, bottom: 75),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return CampaignWidget(index);
                                },
                              ),
                            ),

                            Container()

                          ],
                      ),
                    )
                )


              ],
            )
        ),
      ),
    );
  }
}
