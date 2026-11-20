import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/main/Colors.dart';

import '../../models/common_campaigns_model.dart';
import '../../services/campaigns_services.dart';
import '../widgets/custom_bottom_tab_bar.dart';
import 'CampaignDetailsScreenNew.dart';

class MyCampaigns extends StatefulWidget {
  const MyCampaigns({Key? key}) : super(key: key);

  @override
  State<MyCampaigns> createState() => _MyCampaignsState();
}

class _MyCampaignsState extends State<MyCampaigns> {
  TextEditingController searchController = TextEditingController();

  List<CampaignsListData> campaignsDataList = [];
  List<CampaignsListData> searchResultDataList = [];
  List taskListData = [];
  List userListData = [];

  // sravzzsravani7@gmail.com   Sravzz_123 Boys

  int range = 50;
  bool isLoading = true;
  bool isAmazon=false, isFlipkart=false, isAjio=false, isInsta=false, isFB=false, isMeesho=false, isMyntra=false;
  var searchText="";

  showCustomAlertDialog(BuildContext context) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Container(
                  height: MediaQuery.of(context).size.height/1.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Center(
                        child: Text(
                          'Filter',
                          style: TextStyle(
                              color: MyColors.bacgroundcolors,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lexend'

                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isAmazon,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isAmazon=newValue!;
                              });

                            },
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Amazon ',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isFlipkart,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isFlipkart=newValue!;

                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Flipkart',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isAjio,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isAjio=newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Ajio',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isInsta,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isInsta=newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Instagram',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isFB,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isFB=newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Facebook',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isMeesho,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isMeesho=newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Meesho',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: isMyntra,
                            onChanged: (bool? newValue) {
                              setState(() {
                                isMyntra=newValue!;
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Myntra',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lexend'
                            ),
                          ),
                        ],
                      ),
                      // ekasjot@gmail.com test@123
                      SizedBox(height: 10,),
                      Container(
                        width:250,
                        height:60,
                        padding: EdgeInsets.all(10),
                        child: OutlinedButton(
                          onPressed: (){
                            Navigator.pop(context);
                            onSearchTextChanged(searchText);
                          },
                          child: Text("Ok", style: TextStyle(fontSize: 18),),
                          style: OutlinedButton.styleFrom(backgroundColor: MyColors.bacgroundcolors, foregroundColor: Colors.white,side: BorderSide(color: MyColors.bacgroundcolors)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );

  }

  onSearchTextChanged(String text) async {
    searchText="";
    searchResultDataList.clear();
    List<CampaignsListData> tempSearchResultDataList = [];

    text="";

    if (searchController.text.toString().isNotEmpty)
      searchText += searchController.text.toString();

    if (isAmazon)
      searchText +="####Amazon";
    if (isFB)
      searchText +="####Facebook";
    if (isInsta)
      searchText +="####Instagram";
    if (isMeesho)
      searchText +="####Meesho";
    if (isFlipkart)
      searchText +="####Flipkart";
    if (isAjio)
      searchText +="####Ajio";
    if (isMyntra)
      searchText +="####Myntra";

    print("burr ${searchText}"); //panda

    var searchList = searchText.split("####");
    searchList = searchList.where((element) => element != null && element.trim().isNotEmpty).toList();


    campaignsDataList.forEach((campaignDetail) {

      var searchResult = searchList.every((element) => campaignDetail.title.toUpperCase().contains(element.toUpperCase()) || campaignDetail.description.toUpperCase().contains(element.toUpperCase()));

      if (searchResult)
        searchResultDataList.add(campaignDetail);

    });

    if (searchController.text.toString().isNotEmpty) {
      for (var item in tempSearchResultDataList) {
        if (item.description.toUpperCase().contains(searchController.text.toUpperCase())) {
          searchResultDataList.add(item);
        }
      }
    } else {
      searchResultDataList.addAll(tempSearchResultDataList);
    }

    setState(() {
      // print("Search List ${searchResultDataList.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      campaignsListAPI(type: "ongoing");
    });
  }

  campaignsListAPI({type}) async {
    isLoading = true;
    campaignsDataList.clear();
    var result = await CampaignsServices().campaignsListData(context: context, type: type);
    isLoading = false;
    if (result != null) {
      if (result.status) {
        setState(() {
          campaignsDataList.addAll(result.data ?? []);
        //  campaignsDataList.removeWhere((element) => element.status == "2");
          for (var element in (campaignsDataList)) {
            userListData.addAll(element.userListData ?? []);
            taskListData.addAll(element.taskListData ?? []);
          }
        });
      }
    }

  }


  Widget CampaignWidget(List<CampaignsListData> campaignsDataList, int index) {

    var campImage="";
    if (campaignsDataList.length!=0 && campaignsDataList[index].image.toString().isNotEmpty)
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
              width: MediaQuery.of(context).size.width * 0.70,
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
                                campaignsDataList.length!=0 ? "Slots: "+campaignsDataList[index].total_join_users+"/"+campaignsDataList[index].total_users+" " : "",
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
                                    campaignsDataList.length!=0 ? campaignsDataList[index].status=="0" ? " Total Tasks: "+campaignsDataList[index].totaltaskcount+" " : "":
                                    campaignsDataList.length!=0 ? campaignsDataList[index].status=="1" ?" Task Rem. "+(int.parse(campaignsDataList[index].totaltaskcount)-(int.parse(campaignsDataList[index].total_user_task_count))).toString()+"/"+campaignsDataList[index].totaltaskcount+" ":
                                    "Completed" : "",
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
                                  campaignsDataList.length!=0 ? campaignsDataList[index].title : "",
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
                                  campaignsDataList.length!=0 ? "Price: \u{20B9}"+campaignsDataList[index].amount : "",
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


  Widget onGoingWidget() {

    return Column(
      children: [

        SizedBox(height: 10,),

        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Card(
                    child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: searchController,
                          decoration: new InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: GestureDetector(
                            onTap: () {
                              searchController.clear();
                              onSearchTextChanged(searchText);
                            },
                            child: Icon(Icons.cancel)
                        )
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              child: GestureDetector(
                onTap: (){
                  showCustomAlertDialog(context);
                },
                child: Container(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.asset("assets/images/filter.png", height: 60, color: MyColors.bacgroundcolors,),
                  ),
                ),
              ),
            )
          ],
        ),

        SizedBox(height: 10,),

        Expanded(
          child: Container(
            color: Colors.white,
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: MyColors.bacgroundcolors,
              ),
            )
                : campaignsDataList.isEmpty || (searchResultDataList.isEmpty && searchText.isNotEmpty)
                ?  Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    'No Ongoing Campaigns.',
                    style: TextStyle(color: MyColors.bacgroundcolors, fontSize: 16,fontWeight: FontWeight.w500),
                  ),
                ))
                : searchResultDataList.length != 0 || searchController.text.isNotEmpty || searchText.isNotEmpty ? ListView.builder(
              itemCount: searchResultDataList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 75),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CampaignWidget(searchResultDataList, index);
              },
            ) : ListView.builder(
              itemCount: campaignsDataList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 75),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CampaignWidget(campaignsDataList, index);
              },
            ),
          ),
        )

      ],
    );

  }

  Widget pendingWidget() {
    return Column(
      children: [

        SizedBox(height: 10,),

        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Card(
                    child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: searchController,
                          decoration: new InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: GestureDetector(
                            onTap: () {
                              searchController.clear();
                              onSearchTextChanged(searchText);
                            },
                            child: Icon(Icons.cancel)
                        )
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              child: GestureDetector(
                onTap: (){
                  showCustomAlertDialog(context);
                },
                child: Container(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.asset("assets/images/filter.png", height: 60, color: MyColors.bacgroundcolors,),
                  ),
                ),
              ),
            )
          ],
        ),

        SizedBox(height: 10,),

        Expanded(
          child: Container(
            color: Colors.white,
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: MyColors.bacgroundcolors,
              ),
            )
                : campaignsDataList.isEmpty || (searchResultDataList.isEmpty && searchText.isNotEmpty)
                ?  Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    'No Pending Campaigns.',
                    style: TextStyle(color: MyColors.bacgroundcolors, fontSize: 16,fontWeight: FontWeight.w500),
                  ),
                ))
                : searchResultDataList.length != 0 || searchController.text.isNotEmpty || searchText.isNotEmpty ? ListView.builder(
              itemCount: searchResultDataList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 75),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CampaignWidget(searchResultDataList, index);
              },
            ) : ListView.builder(
              itemCount: campaignsDataList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 75),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CampaignWidget(campaignsDataList, index);
              },
            ),
          ),
        )

      ],
    );
  }

  Widget completedWidget() {



    return Column(
      children: [

        SizedBox(height: 10,),

        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Card(
                    child: new ListTile(
                        leading: new Icon(Icons.search),
                        title: new TextField(
                          controller: searchController,
                          decoration: new InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: GestureDetector(
                            onTap: () {
                              searchController.clear();
                              onSearchTextChanged(searchText);
                            },
                            child: Icon(Icons.cancel)
                        )
                    ),
                  ),
                ),
              ),
            ),


            Expanded(
              child: GestureDetector(
                onTap: (){
                  showCustomAlertDialog(context);
                },
                child: Container(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.asset("assets/images/filter.png", height: 60, color: MyColors.bacgroundcolors,),
                  ),
                ),
              ),
            )
          ],
        ),

        // Container(
        //   child: new Padding(
        //     padding: const EdgeInsets.all(5.0),
        //     child: new Card(
        //       child: new ListTile(
        //         leading: new Icon(Icons.search),
        //         title: new TextField(
        //           controller: searchController,
        //           decoration: new InputDecoration(
        //               hintText: 'Search', border: InputBorder.none),
        //           onChanged: onSearchTextChanged,
        //         ),
        //         trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
        //           searchController.clear();
        //           onSearchTextChanged('');
        //         },),
        //       ),
        //     ),
        //   ),
        // ),

        SizedBox(height: 10,),

        Expanded(
          child: Container(
            color: Colors.white,
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: MyColors.bacgroundcolors,
              ),
            )
                : campaignsDataList.isEmpty || (searchResultDataList.isEmpty && searchText.isNotEmpty)
                ?  Center(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(
                    'No Completed Campaigns.',
                    style: TextStyle(color: MyColors.bacgroundcolors, fontSize: 16,fontWeight: FontWeight.w500),
                  ),
                ))
                : searchResultDataList.length != 0 || searchController.text.isNotEmpty || searchText.isNotEmpty ? ListView.builder(
              itemCount: searchResultDataList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 75),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CampaignWidget(searchResultDataList, index);
              },
            ) : ListView.builder(
              itemCount: campaignsDataList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(
                  top: 15, left: 15, right: 15, bottom: 75),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CampaignWidget(campaignsDataList, index);
              },
            ),
          ),
        )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: InkWell(
              onTap: (){
                print("ddfgdfgdfg");
                Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CustomBottomTabBar();
                  },
                ),
                    (route) => false,
              );
            }, child: Icon(Icons.arrow_back_outlined, color: Colors.white,)),
          backgroundColor: MyColors.bacgroundcolors,
          centerTitle: false,
          title: Text("My Campaigns", softWrap: true, style: TextStyle(color: Colors.white),),
          actions: [
            Container(
              margin: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset(
                      'assets/images/user_profile.png',)),
              ),
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
            onTap: (value){
              searchController.text="";
              setState(() {
                searchText="";
                isAmazon=false;
                isAjio=false;
                isFlipkart=false;
                isMeesho=false;
                isInsta=false;
                isFB=false;
              });
              if (value==0)
                campaignsListAPI(type: "ongoing");
              else if (value == 1)
                campaignsListAPI(type: "pending");
              else
                campaignsListAPI(type: "completed");
            },
            tabs: [
              Tab(text: "Ongoing",),
              Tab(text: "Pending Request",),
              Tab(text: "Completed",),

            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            onGoingWidget(),
            pendingWidget(),
            completedWidget()

          ],
        ),
      ),
    );
  }
}
