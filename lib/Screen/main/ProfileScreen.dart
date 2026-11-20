import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momworkapp/Screen/auth/ChangePasswordScreen.dart';
import 'package:momworkapp/Screen/auth/LoginHomeScreen.dart';
import 'package:momworkapp/Screen/auth/LoginScreen.dart';
import 'package:momworkapp/Screen/main/BankDetails.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/main/EditeProfileScreen.dart';
import 'package:momworkapp/Screen/main/PastCampaignsScreen.dart';
import 'package:momworkapp/Screen/main/UserAllPostScreen.dart';
import 'package:momworkapp/Screen/main/WalletScreen.dart';
import 'package:momworkapp/Screen/main/deleteAccountScreen.dart';
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/profile_services.dart';
import '../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String name = '';
  String temail = '';
  String tmobileno = '';
  String? imagePath;
  String post = '';
  String campaigns = '';
  String task = '';
  String earning = '';
  String refferalCode = '';
  String totalApprovedTask = '';
  String totalRejectedTask = '';
  String totalReviewTask = '';
  String referralAmount = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProfile();
    });
  }

  getProfile() async {
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

    var result = await Services().getProfile(context);
    if (result != null) {
      if (result.status) {
        Navigator.pop(context);

        Utils.prefs!.setString('userName', result.data.name);
        Utils.prefs!.setString('userImage', result.data.image);

        setState(() {
          name = result.data.name;
          temail = result.data.email;
          tmobileno = result.data.mobileno;
          imagePath = result.data.image;
          post = result.data.totalPosts;
          campaigns = result.data.totalCampaigns;
          task = result.data.totalTasks;
          earning = result.data.earning;
          refferalCode = result.data.referralCode;
          totalApprovedTask = result.data.totalApprovedTask;
          totalRejectedTask = result.data.totalRejectedTask;
          totalReviewTask = result.data.totalReviewTask;
          referralAmount = result.data.referralAmount;
        });
      }
    } else {
    //  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile",
              style: TextStyle(
                  fontSize: 20,
                  color: MyColors.greyshade600,
                  fontFamily: 'Lexend')),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        // drawer: Drawer(
        //   backgroundColor: Colors.white,
        //   child: ListView(
        //     children: [
        //       Container(
        //         height: 150,
        //         decoration: BoxDecoration(
        //             color: MyColors.primarycolors,
        //             borderRadius: const BorderRadius.vertical(
        //                 bottom: Radius.circular(25))),
        //         child: Center(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: const [
        //               SizedBox(
        //                 height: 50,
        //                 width: 50,
        //                 child: CircleAvatar(
        //                   backgroundImage:
        //                       AssetImage('assets/images/myprofile.png'),
        //                 ),
        //               ),
        //               SizedBox(
        //                 height: 5,
        //               ),
        //               Text(
        //                 "MOM",
        //                 maxLines: 1,
        //                 overflow: TextOverflow.ellipsis,
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontSize: 20,
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white),
        //               ),
        //               SizedBox(
        //                 height: 5,
        //               ),
        //               Text(
        //                 'View Profile',
        //                 maxLines: 1,
        //                 overflow: TextOverflow.ellipsis,
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w500,
        //                     color: Colors.white),
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         onTap: () {
        //           Navigator.pop(context);
        //         },
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.home,
        //               color: MyColors.primarycolors,
        //               size: 25,
        //             ),
        //             title: const Text("BLOGS",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.library_books_outlined,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("100 WORD STORY",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.videocam_outlined,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("MOMSPRESSO TV",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.group,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("SUPPORT GROUPS",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.language_sharp,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("LANGUAGE",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.leaderboard,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("LEADERBOARD",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       const Divider(
        //         height: 30,
        //         color: Colors.grey,
        //         thickness: 1,
        //         indent: 30,
        //         endIndent: 30,
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.share,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("SHARE APP",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       const Divider(
        //         height: 30,
        //         color: Colors.grey,
        //         thickness: 1,
        //         indent: 30,
        //         endIndent: 30,
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.map,
        //               color: MyColors.primarycolors,
        //             ),
        //             title: const Text("TAKE THE TOUR",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //       InkWell(
        //         child: Container(
        //           height: 50,
        //           margin: const EdgeInsets.symmetric(
        //             horizontal: 10,
        //           ),
        //           child: ListTile(
        //             leading: Icon(
        //               Icons.help,
        //               color: MyColors.primarycolors,
        //               size: 25,
        //             ),
        //             title: const Text("NEED HELP ?",
        //                 style: TextStyle(
        //                     fontFamily: 'Harmonia',
        //                     fontWeight: FontWeight.w700)),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomBottomTabBar(),
              ),
              (route) => false,
            );
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: SizedBox(
                              height: 130,
                              width: 130,
                              child: CachedNetworkImage(
                                imageUrl: imagePath.toString(),
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: imageProvider),
                                        shape: BoxShape.circle),
                                  );
                                },
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  color: MyColors.bacgroundcolors,
                                )),
                                errorWidget: (context, url, error) {
                                  return Container(
                                    height: 80,
                                    width: 80,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/user_profile.png')),
                                        shape: BoxShape.circle),
                                  );
                                },
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 22,
                            color: MyColors.greyshade600,
                            fontFamily: 'Lexend'),
                      )),
                      const SizedBox(
                        height: 30,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Post',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    post,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MyColors.greyshade600,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                            ),
                            Utils.prefs!.getString("userName")=="Test Ekas" ? Container() :  VerticalDivider(
                              indent: 8,
                              endIndent: 8,
                              thickness: 1,
                            ),
                            Visibility(
                              visible: Utils.prefs!.getString("userName")!="Test Ekas",
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Campaigns',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: MyColors.greyshade600,
                                            fontFamily: 'Lexend')),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      campaigns,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Utils.prefs!.getString("userName")=="Test Ekas" ? Container() :  VerticalDivider(
                              indent: 8,
                              endIndent: 8,
                              thickness: 1,
                            ),
                            Visibility(
                              visible: Utils.prefs!.getString("userName")!="Test Ekas",
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Earning',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: MyColors.greyshade600,
                                            fontFamily: 'Lexend')),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Utils.prefs!.getString("userName")=="Test Ekas" ? "0" : ' ₹ $earning',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 30,
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                      Utils.prefs!.getString("userName")=="Test Ekas" ? Container() : IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Task',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    task,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MyColors.greyshade600,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              indent: 8,
                              endIndent: 8,
                              thickness: 1,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Approved',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    totalApprovedTask,
                                    // campaigns,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MyColors.greyshade600,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              indent: 8,
                              endIndent: 8,
                              thickness: 1,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Rejected',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    totalRejectedTask,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MyColors.greyshade600,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              indent: 8,
                              endIndent: 8,
                              thickness: 1,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('In Review',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: MyColors.greyshade600,
                                          fontFamily: 'Lexend')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    totalReviewTask,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MyColors.greyshade600,
                                        fontFamily: 'Lexend'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'Email',
                              style: TextStyle(
                                  color: Color(0xffB1B9BC),
                                  fontSize: 13,
                                  fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              temail,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Phone Number',
                              style: TextStyle(
                                  color: Color(0xffB1B9BC),
                                  fontSize: 13,
                                  fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              tmobileno,
                              style: const TextStyle(
                                  fontSize: 18, fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      // Center(
                      //   child: Container(
                      //     padding: EdgeInsets.all(width * 0.05),
                      //     width: width * 0.9,
                      //     decoration: BoxDecoration(
                      //       color: MyColors.bacgroundcolors,
                      //       borderRadius: BorderRadius.circular(10),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             color: Colors.grey.withOpacity(0.3),
                      //             blurRadius: 10,
                      //             spreadRadius: 1),
                      //       ],
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               InkWell(
                      //                 onTap: () {
                      //                   Clipboard.setData(new ClipboardData(
                      //                       text: refferalCode));
                      //                 },
                      //                 child: Container(
                      //                   padding: EdgeInsets.symmetric(
                      //                       horizontal: width * 0.03,
                      //                       vertical: 5),
                      //                   decoration: BoxDecoration(
                      //                     border: Border.all(
                      //                         width: 1, color: Colors.white),
                      //                     borderRadius:
                      //                         BorderRadius.circular(20),
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     children: [
                      //                       Image.asset(
                      //                         'assets/images/copy.png',
                      //                         height: 18,
                      //                         width: 18,
                      //                       ),
                      //                       const SizedBox(
                      //                         width: 10,
                      //                       ),
                      //                       Text(
                      //                         refferalCode,
                      //                         style: const TextStyle(
                      //                           fontFamily: 'Lexend',
                      //                           fontWeight: FontWeight.bold,
                      //                           fontSize: 16,
                      //                           color: Colors.white,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(
                      //                 height: 20,
                      //               ),
                      //               Text(
                      //                 "Earn Flat ₹ ${referralAmount != '' ? referralAmount : '0'} for every \nreferral",
                      //                 style: TextStyle(
                      //                     fontFamily: 'Lexend',
                      //                     fontSize: 16,
                      //                     color: Colors.white),
                      //               ),
                      //               const SizedBox(
                      //                 height: 20,
                      //               ),
                      //               SizedBox(
                      //                 height: 35,
                      //                 child: ElevatedButton(
                      //                   style: ElevatedButton.styleFrom(
                      //                     shape: const RoundedRectangleBorder(
                      //                         borderRadius: BorderRadius.all(
                      //                             Radius.circular(10))),
                      //                     backgroundColor: Colors.white,
                      //                   ),
                      //                   onPressed: () {
                      //                     Share.share(
                      //                         'Hey!\n\nDownload this app and use my code to earn ₹ ${referralAmount != '' ? referralAmount : '0'} flat instantly.\n\nhttps://play.google.com/store/apps/details?id=com.mystsriya&pcampaignid=web_share\n\nParticipate in any of our campaigns, and upon completion, you\'ll receive the referral bonus.\n\ncode:$refferalCode');
                      //                   },
                      //                   child: Text(
                      //                     "Refer Now",
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold,
                      //                         fontSize: 13,
                      //                         color: MyColors.bacgroundcolors,
                      //                         fontFamily: 'Lexend'),
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(
                      //                 width: 10,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //         Image.asset(
                      //           'assets/images/referandearn.png',
                      //           height: 120,
                      //           width: width * 0.2,
                      //           fit: BoxFit.contain,
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  //// All Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserAllPostScreen(),
                        ),
                      ).then((value) => getProfile());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Posts',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  Utils.prefs!.getString("userName")=="Test Ekas" ? Container() : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletScreen(isSourceProfile: true, referralAmount: referralAmount, refferalCode: refferalCode,),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Earnings',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditeProfileScreen(),
                        ),
                      ).then((value) {
                        getProfile();
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  Utils.prefs!.getString("userName")=="Test Ekas" ? Container() : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BankDetailsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Bank Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Utils.prefs!.getString("userName")=="Test Ekas" ? Container() : Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  Utils.prefs!.getString("userName")=="Test Ekas" ? Container() : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PastCampaignsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Past Campaigns',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      logOutAlertDialog(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const deleteAccountScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: MyColors.greyshade500,
                                  fontFamily: 'Lexend'),
                            ),
                          ),
                          Icon(Icons.navigate_next,
                              color: MyColors.greyshade500)
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future logOutAlertDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Logout'),
          content: const SingleChildScrollView(
            child: Text('Are you sure want to logout?'),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Utils.prefs!.setBool('loginStatus', false);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginHomeScreen()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
