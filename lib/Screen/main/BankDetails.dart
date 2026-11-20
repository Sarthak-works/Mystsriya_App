import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/auth/AddBankAccountScreen.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/models/common_profile_model.dart';

import '../../services/profile_services.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProfile();
    });
  }

  CommonProfileListModel? result;

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

    result = await Services().getProfile(context);
    setState(() {});
    if (result != null) {
      if (result!.status) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Bank Details',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Bank account holder name',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'Lexend'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            // 'Test User',
                            result != null && result!.data.accountname.isNotEmpty ? result!.data.accountname : '-',
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Lexend'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bank name',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'Lexend'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            result != null && result!.data.bankname.isNotEmpty ? result!.data.bankname : '-',
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Lexend'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account number',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'Lexend'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            result != null && result!.data.accountnumber.isNotEmpty ? result!.data.accountnumber : '-',
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Lexend'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IFSC code',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'Lexend'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            result != null && result!.data.ifsccode.isNotEmpty ? result!.data.ifsccode : '-',
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Lexend'),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       'UPI ID',
                      //       style: TextStyle(
                      //           color: Colors.grey.shade400,
                      //           fontFamily: 'Lexend'),
                      //     ),
                      //     const SizedBox(
                      //       height: 5,
                      //     ),
                      //     Text(
                      //       result != null && result!.data.upiid.isNotEmpty ? result!.data.upiid : '-',
                      //       style: const TextStyle(
                      //           fontSize: 18, fontFamily: 'Lexend'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.bacgroundcolors,
                      minimumSize: const Size(double.infinity, 40)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AddBankAccountScreen(
                          type:
                              result?.data.accountname != null ? "edit" : "add",
                        );
                      },
                    ));
                  },
                  child: Text(
                    result?.data.accountname != null ? "Edit" : "Add",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Lexend'),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
