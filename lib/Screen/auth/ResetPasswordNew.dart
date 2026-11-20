import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/auth/AddBankAccountScreen.dart';
import 'package:momworkapp/Screen/auth/LoginHomeScreen.dart';
import 'package:momworkapp/Screen/auth/LoginNewScreen.dart';
import 'package:momworkapp/Screen/main/EditeProfileScreen.dart';
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../main/Colors.dart';

class ResetPasswordNew extends StatefulWidget {
  final email;
  final isGoogleSignin;
  const ResetPasswordNew({Key? key, required this.email, this.isGoogleSignin=false}) : super(key: key);

  @override
  State<ResetPasswordNew> createState() => _ResetPasswordNewState();
}

class _ResetPasswordNewState extends State<ResetPasswordNew> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tnewpassword = TextEditingController();
  TextEditingController tconfirmpassword = TextEditingController();

  bool passHideShow = false;
  bool confirmPassHideShow = false;

  forgotChangePasswordData() async {
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
      'email': widget.email,
      'new_password': tnewpassword.text,
      'confirm_password': tconfirmpassword.text,
    };
    var result = await Services().forgotChangePassword(context, body: body);

    if (result != null) {
      if (result.status) {
        if (widget.isGoogleSignin)
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return EditeProfileScreen(isGooleSignIn: true,);
            },
          ));
          // Navigator.pushReplacement(context, MaterialPageRoute(
          //   builder: (context) {
          //     return AddBankAccountScreen(
          //       type: "add",
          //       fromMain: true,
          //     );
          //   },
          // ));
        else
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const CustomBottomTabBar();
            },
          ));

      } else {
        Navigator.pop(context);
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
            child: Container(
              margin: EdgeInsets.all(25),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: (){
                        widget.isGoogleSignin ? Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const LoginHomeScreen()))  : Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[350],
                          child: Icon(Icons.arrow_back_outlined),
                        ),
                      ),
                    ),

                    SizedBox(height: 25,),

                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'Create New Password',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lexend'

                          ),
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Please enter and confirm your new password. You will need to loin after you reset the password.",
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Lexend'

                          ),
                        ),
                      ),
                    ),

                    SizedBox(height:20,),

                    Text(
                      'New Password',
                      style: TextStyle(
                          color: MyColors.greyshade600,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      validator: (value) {
                        return Utils.passwordValidator(value ?? "");
                      },
                      controller: tnewpassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: passHideShow,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                                  () {
                                passHideShow = !passHideShow;
                              },
                            );
                          },
                          icon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: passHideShow
                                  ? const AssetImage(
                                  'assets/images/pass_show.png')
                                  : const AssetImage(
                                  'assets/images/pass_off.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                        hintText: 'Enter new password',
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
                    SizedBox(height: 15),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                          color: MyColors.greyshade600,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      validator: (value) {
                        if (tnewpassword.text != tconfirmpassword.text) {
                          return 'Password Does Not Match';
                        }
                        return null;
                      },
                      controller: tconfirmpassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: confirmPassHideShow,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                                  () {
                                confirmPassHideShow = !confirmPassHideShow;
                              },
                            );
                          },
                          icon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: confirmPassHideShow
                                  ? const AssetImage(
                                  'assets/images/pass_show.png')
                                  : const AssetImage(
                                  'assets/images/pass_off.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                        hintText: 'Enter new password',
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

                    SizedBox(height: 60,),

                    ElevatedButton(
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
                          forgotChangePasswordData();

                        }
                      },
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                    ),

                    SizedBox(height: 15,),


                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
