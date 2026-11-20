import 'package:flutter/material.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../main/Colors.dart';

class ResetPassword extends StatefulWidget {
  String? email;
  ResetPassword({super.key, this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
        var email = result.data.email;
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Reset Password',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'New Password',
                            style: TextStyle(
                                color: MyColors.greyshade600,
                                fontSize: 16,
                                fontFamily: 'Lexend'),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              return Utils.passwordValidator(value ?? "");
                            },
                            controller: tnewpassword,
                            obscureText: passHideShow,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              prefixIcon: const Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image(
                                  image: AssetImage('assets/images/lock.png'),
                                  height: 25,
                                  width: 25,
                                ),
                              ),
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
                              hintText: 'Password',
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
                            'Confirm Password',
                            style: TextStyle(
                                color: MyColors.greyshade600,
                                fontSize: 16,
                                fontFamily: 'Lexend'),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (tnewpassword.text !=
                                  tconfirmpassword.text) {
                                return 'Password Does Not Match';
                              }
                              return null;
                            },
                            controller: tconfirmpassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: confirmPassHideShow,
                            decoration: InputDecoration(
                              prefixIcon: const Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image(
                                  image: AssetImage('assets/images/lock.png'),
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      confirmPassHideShow =
                                          !confirmPassHideShow;
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
                                // Icon(
                                //     confirmPassHideShow
                                //         ? Icons.visibility
                                //         : Icons.visibility_off,
                                //     color: Colors.grey),
                              ),
                              hintText: 'Confirm Password',
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
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.bacgroundcolors,
                      minimumSize: const Size(double.infinity, 40)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      forgotChangePasswordData();
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) {
                      //     return const LoginScreen();
                      //   },
                      // ));
                    }
                  },
                  child: const Text(
                    "Change",
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
