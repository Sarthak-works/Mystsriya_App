import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:momworkapp/Screen/auth/LoginHomeScreen.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import 'Colors.dart';

class deleteAccountScreen extends StatefulWidget {
  const deleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<deleteAccountScreen> createState() => _deleteAccountScreenState();
}

class _deleteAccountScreenState extends State<deleteAccountScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
  bool passHideShow = true;
  bool loading = false;

  loginAPI() async {
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

    var body = {
      "email": temail.text.toString(),
      "address": "Y"
    };
    var result = await Services().gLogin(context, body: body, deleteAccount: true);

    if (result != null) {
      if (result.status) {
        Navigator.pop(context);

        Utils.prefs!.setBool('loginStatus', false);



        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const LoginHomeScreen();
            },
          ),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.grey[300],
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GestureDetector(
                  onTap: (){Navigator.pop(context);},
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 70),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[350],
                      child: Icon(Icons.arrow_back_outlined),
                    ),
                  ),
                ),

                SizedBox(height: 40,),

                Center(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Delete Account',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lexend'

                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10,),

                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      'Please enter your email address to proceed with account deletion.',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Lexend'

                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    'Email',
                    style: TextStyle(
                        color: MyColors.greyshade600,
                        fontSize: 16,
                        fontFamily: 'Lexend'),
                  ),
                ),
                SizedBox(height: 8),
                Form(
                  key: formKey,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email Address';
                        } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please Enter Valid Email Address';
                        }
                        return null;
                      },
                      controller: temail,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Email Address',
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
                  ),
                ),

                SizedBox(height: 40,),

                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(MyColors.bacgroundcolors),
                        minimumSize: WidgetStatePropertyAll(const Size(double.infinity, 40)),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                side: BorderSide(color: MyColors.bacgroundcolors)
                            )
                        )
                    ),
                    onPressed: () {
                       if (formKey.currentState!.validate()) {
                         loginAPI();
                       }
                    },
                    child: const Text(
                      "Proceed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  ),
                ),

              ],
            )
        ),
      ),
    );
  }
}
