import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/models/common_auth_model.dart';

import '../../services/profile_services.dart';
import '../../utils/utils.dart';
import '../widgets/custom_bottom_tab_bar.dart';

class AddBankAccountScreen extends StatefulWidget {
  String? type;
  bool fromMain = false;
  AddBankAccountScreen({super.key, this.type, this.fromMain = false});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController taccountHolderName = TextEditingController();
  TextEditingController tbankName = TextEditingController();
  TextEditingController taccountNumber = TextEditingController();
  TextEditingController tconfirmAccountNumber = TextEditingController();
  TextEditingController tifscCode = TextEditingController();
  TextEditingController tlast4Digit = TextEditingController();
  TextEditingController tupi = TextEditingController();

  bool confirmAccountNumber = true;

  CommonBankDeatilsModel? result;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.type == "edit") getProfile();
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
        setState(() {
          taccountNumber.text = result.data.accountnumber;
          tconfirmAccountNumber.text = result.data.accountnumber;
          taccountHolderName.text = result.data.accountname;
          tifscCode.text = result.data.ifsccode;
          tbankName.text = result.data.bankname;
          tupi.text = result.data.upiid;
          selectedOption = result.data.bankname;

          if (!bankList.contains(selectedOption)) {
            selectedOption = "";
            if(result.data.bankname.isNotEmpty) {
              tbankName.text = result.data.bankname;
              selectedOption = "Other";
            }
          }
        });
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  BankAccountAPI() async {
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
      'account_number': taccountNumber.text,
      'account_name': taccountHolderName.text,
      'ifsc_code': tifscCode.text,
      'bank_name': selectedOption=="Other"?tbankName.text:selectedOption,
      'upi_id': tupi.text,
    };

    result = await Services().bankDetailsUpdate(context, body: body);

    if (result != null) {
      if (result!.status) {
        Utils.prefs!.setBool('loginStatus', true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomTabBar()),
          (route) => false,
        );
      }
    }
  }

  List<String> bankList = [
    "State Bank of India",
    "Axis Bank",
    "RBL Bank",
    "ICICI Bank",
    "HDFC Bank",
    "IDBI Bank",
    "Yes Bank",
    "IDFC First Bank",
    "Indusland Bank",
    "Kotak Mahindra Bank",
    "Bank of Baroda",
    "Bank of India",
    "Bank of maharashtra",
    "Canara Bank",
    "Central Bank of India",
    "Indian Bank",
    "Indian Overseas Bank",
    "Punjab and sind Bank",
    "Punjab National Bank",
    "UCO Bank",
    "Union Bank of India",
    "Bandhan Bank",
    "CSB Bank",
    "City union Bank",
    "DCB Bank",
    "Dhanlaxmi Bank",
    "Federal Bank",
    "Jammu & Kashmir Bank",
    "Karnataka Bank",
    "Karur Vysya Bank",
    "Nainital Bank",
    "South Indian Bank",
    "Tamilnad Mercantile Bank",
    "Abhyudaya Co-operative Bank Ltd.",
    "Thane Janata Sahakari Bank",
    "The Akola Janata Commercial Co-operative Bank Ltd.",
    "The Akola Urban Co-operative Bank Ltd.",
    "The Panipat Urban Co-operative Bank Ltd.",
    "The Kapol Co-operative Bank Ltd.",
    "The Khamgaon Urban Co-operative Bank Ltd.",
    "Vasavi Coop Urban Bank Limited.",
    "Vidyasagar cooperative bank limited, midnapore.",
    "Zoroastrian Co-operative Bank Ltd.",
    "Other"
  ];
  String selectedOption = '';
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
            '${widget.type == 'add' ? 'Add' : 'Edit'} Bank Details',
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.020,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank account holder name',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.01),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Account Holder Name';
                          }
                          return null;
                        },
                        controller: taccountHolderName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/user.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          hintText: 'Account Holder Name',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: textFieldBorder(),
                          focusedBorder: textFieldBorder(),
                          enabledBorder: textFieldBorder(),
                          disabledBorder: textFieldBorder(),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Bank name',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      const SizedBox(height: 10),
                      // TextFormField(
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Enter Your Bank Name';
                      //     }
                      //     return null;
                      //   },
                      //   controller: tbankName,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   decoration: InputDecoration(
                      //     prefixIcon: const Align(
                      //       widthFactor: 1.0,
                      //       heightFactor: 1.0,
                      //       child: Image(
                      //         image: AssetImage('assets/images/bank.png'),
                      //         height: 25,
                      //         width: 25,
                      //       ),
                      //     ),
                      //     hintText: 'Bank Name',
                      //     hintStyle: const TextStyle(
                      //       color: Colors.grey,
                      //     ),
                      //     border: textFieldBorder(),
                      //     focusedBorder: textFieldBorder(),
                      //     enabledBorder: textFieldBorder(),
                      //     disabledBorder: textFieldBorder(),
                      //     contentPadding: const EdgeInsets.all(15),
                      //   ),
                      // ),
                      SizedBox(
                        width: width,
                        child: DropdownButtonFormField(
                          itemHeight: 55,
                          borderRadius: BorderRadius.circular(10),
                          menuMaxHeight: height * 0.5,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/bank.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: "Bank Name",
                            border: textFieldBorder(),
                            enabledBorder: textFieldBorder(),
                            focusedBorder: textFieldBorder(),
                            contentPadding: const EdgeInsets.all(5),
                          ),
                          dropdownColor: Colors.white,
                          value: selectedOption.isEmpty ? null : selectedOption,
                          validator: (value) =>
                              value == '' ? 'Please select Bank Name' : null,
                          onChanged: (newValue) {
                            setState(() {
                              selectedOption = newValue;
                            });
                          },
                          items: bankList.map<DropdownMenuItem>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Container(
                                  height: 40,
                                  width: width * 0.7,
                                  alignment: Alignment.centerLeft,
                                  child: Text(value)),
                            );
                          }).toList(),
                        ),
                      ),
                      if (selectedOption == "Other")
                        const SizedBox(
                          height: 10,
                        ),
                      if (selectedOption == "Other")
                        TextFormField(
                          validator: (value) {
                            if (selectedOption == "Other" && value!.isEmpty) {
                              return 'Enter Your Bank Name';
                            }
                            return null;
                          },
                          controller: tbankName,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: 16,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/bank.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
                            counterText: '',
                            hintText: 'Bank Name',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            border: textFieldBorder(),
                            focusedBorder: textFieldBorder(),
                            enabledBorder: textFieldBorder(),
                            disabledBorder: textFieldBorder(),
                            contentPadding: const EdgeInsets.all(15),
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Account number',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Your Account Number';
                          } else if (value.length < 9) {
                            return 'Enter Valid Account Number';
                          }
                          return null;
                        },
                        controller: taccountNumber,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        maxLength: 18,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/card.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          counterText: '',
                          hintText: 'Account Number',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: textFieldBorder(),
                          focusedBorder: textFieldBorder(),
                          enabledBorder: textFieldBorder(),
                          disabledBorder: textFieldBorder(),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Confirm Account number',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Confirm Account Number';
                          } else if (taccountNumber.text !=
                              tconfirmAccountNumber.text) {
                            return 'Account Number Does Not Match';
                          }
                          return null;
                        },
                        controller: tconfirmAccountNumber,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        maxLength: 18,
                        obscureText: confirmAccountNumber,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/card.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          counterText: '',
                          hintText: 'Confirm Account Number',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: textFieldBorder(),
                          focusedBorder: textFieldBorder(),
                          enabledBorder: textFieldBorder(),
                          disabledBorder: textFieldBorder(),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'IFSC code',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter IFSC Code';
                          } else if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
                              .hasMatch(value)) {
                            return 'Please Enter Valid IFSC Code';
                          }
                          return null;
                        },
                        controller: tifscCode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 11,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/card.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          counterText: '',
                          hintText: 'IFSC Code',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: textFieldBorder(),
                          focusedBorder: textFieldBorder(),
                          enabledBorder: textFieldBorder(),
                          disabledBorder: textFieldBorder(),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   'UPI ID',
                      //   style: TextStyle(
                      //       color: MyColors.greyshade600,
                      //       fontSize: 16,
                      //       fontFamily: 'Lexend'),
                      // ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // TextFormField(
                      //   // validator: (value) {
                      //   //   if (value!.isEmpty) {
                      //   //     return 'Please Enter Your UPI ID';
                      //   //   } else if (!RegExp(
                      //   //           r'^[0-9A-Za-z.-]{2,256}@[A-Za-z]{2,64}$')
                      //   //       .hasMatch(value)) {
                      //   //     return 'Please Enter Valid UPI ID';
                      //   //   }
                      //   //   return null;
                      //   // },
                      //   controller: tupi,
                      //   autovalidateMode: AutovalidateMode.onUserInteraction,
                      //   decoration: InputDecoration(
                      //     prefixIcon: const Align(
                      //       widthFactor: 1.0,
                      //       heightFactor: 1.0,
                      //       child: Image(
                      //         image: AssetImage('assets/images/at_sign.png'),
                      //         height: 25,
                      //         width: 25,
                      //       ),
                      //     ),
                      //     hintText: 'Enter UPI ID',
                      //     hintStyle: const TextStyle(
                      //       color: Colors.grey,
                      //     ),
                      //     border: textFieldBorder(),
                      //     focusedBorder: textFieldBorder(),
                      //     enabledBorder: textFieldBorder(),
                      //     disabledBorder: textFieldBorder(),
                      //     contentPadding: const EdgeInsets.all(15),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.030),
                (widget.fromMain)
                    ? Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Utils.prefs!.setBool('loginStatus', true);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const CustomBottomTabBar();
                                    },
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: MyColors.bacgroundcolors),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Skip',
                                    style: TextStyle(
                                        color: MyColors.bacgroundcolors,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Lexend'),
                                  )),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  BankAccountAPI();
                                }
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: MyColors.bacgroundcolors,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    widget.type == 'add' ? 'Add' : 'Save',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        fontFamily: 'Lexend'),
                                  )),
                            ),
                          ),
                        ],
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.bacgroundcolors,
                            minimumSize: const Size(double.infinity, 40)),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (context) {
                            //     return const CustomBottomTabBar();
                            //   },
                            // ));
                            BankAccountAPI();
                          }
                        },
                        child: Text(
                          widget.type == 'add' ? 'Add' : 'Save',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18,
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
