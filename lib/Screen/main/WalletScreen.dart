import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/wallet_model.dart';
import '../../services/profile_services.dart';

class WalletScreen extends StatefulWidget {
  final refferalCode, referralAmount, isSourceProfile;
  const WalletScreen({super.key, this.isSourceProfile=false, this.referralAmount="", this.refferalCode=""});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tupi = TextEditingController();
  int selectedUpiId = 0;
  List<WalletData> walletHistory = [];
  bool isLoading = true;
  var totalEarning = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
  }

  getHistory() async {
    isLoading = true;
    var result = await Services().getUserWalletHistory();

    isLoading = false;
    if (result != null) {
      double amount = 0;
      walletHistory.addAll(result.data);
      for (var element in walletHistory) {
        amount = amount + double.parse(element.amount);
      }
      totalEarning = amount.toStringAsFixed(0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
            'Earnings',
            style: TextStyle(
                color: MyColors.greyshade600,
                fontSize: 20,
                fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Container(
          color: Colors.white,
          height: height,
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Visibility(
                    visible: widget.isSourceProfile,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(width * 0.05),
                        width: width * 0.9,
                        decoration: BoxDecoration(
                          color: MyColors.bacgroundcolors,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(new ClipboardData(
                                          text: widget.refferalCode));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.03,
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/copy.png',
                                            height: 18,
                                            width: 18,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.refferalCode,
                                            style: const TextStyle(
                                              fontFamily: 'Lexend',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Earn Flat ₹ ${widget.referralAmount != '' ? widget.referralAmount : '0'} for every \nreferral",
                                    style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Share.share(
                                            'Hey!\n\nDownload this app and use my code to earn ₹ ${widget.referralAmount != '' ? widget.referralAmount : '0'} flat instantly.\n\nhttps://play.google.com/store/apps/details?id=com.mystsriya&pcampaignid=web_share\n\nParticipate in any of our campaigns, and upon completion, you\'ll receive the referral bonus.\n\ncode:${widget.refferalCode}');
                                      },
                                      child: Text(
                                        "Refer Now",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: MyColors.bacgroundcolors,
                                            fontFamily: 'Lexend'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                            ),
                            Image.asset(
                              'assets/images/referandearn.png',
                              height: 120,
                              width: width * 0.2,
                              fit: BoxFit.contain,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),

                  Container(
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/income.png', height: 100,),
                            const SizedBox(
                              width: 10,
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Earning',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'Lexend'),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '₹ $totalEarning',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                      color: Colors.white,
                                      fontFamily: 'Lexend'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Earning History',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? SizedBox(
                          height: height * 0.3,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: MyColors.bacgroundcolors)))
                      : walletHistory.isNotEmpty
                          ? ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: walletHistory.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 15),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade400),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 10,
                                          spreadRadius: 2),
                                    ],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Text(
                                                walletHistory[index].title,
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    color: MyColors.greyshade600,
                                                    fontSize: 18,
                                                    fontFamily: 'Lexend'),
                                              ),
                                            ),
                                            // Html(
                                            //   data: walletHistory[index].description  ?? '',
                                            //   style: {
                                            //     'body': Style(
                                            //         color:MyColors.greyshade500,
                                            //         fontFamily: 'Lexend',
                                            //         fontSize: FontSize(18)
                                            //     )
                                            //   },
                                            //   onLinkTap: (url, attributes, element) {
                                            //     if ((url ?? "").isNotEmpty) {
                                            //       launchUrl(Uri.parse(url!));
                                            //     }
                                            //   },
                                            // ),
                                            // Text(
                                            //   walletHistory[index].description,
                                            //   textAlign: TextAlign.justify,
                                            //   style: TextStyle(
                                            //       fontSize: 14,
                                            //       color: MyColors.greyshade500,
                                            //       fontFamily: 'Lexend'),
                                            // )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '₹ ${walletHistory[index].amount}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: MyColors.greyshade600,
                                            fontFamily: 'Lexend'),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : SizedBox(
                              height: height * 0.5,
                              child: Center(
                                  child: Text(
                                "No Earning Found!!",
                                style: TextStyle( color: MyColors.bacgroundcolors,
                                     fontSize: 18, fontWeight: FontWeight.w500),
                              ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
