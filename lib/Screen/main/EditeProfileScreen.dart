import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';

import '../../services/profile_services.dart';
import '../../utils/utils.dart';
import '../auth/AddBankAccountScreen.dart';

class EditeProfileScreen extends StatefulWidget {
  final isGooleSignIn;
  const EditeProfileScreen({super.key, this.isGooleSignIn=false});

  @override
  State<EditeProfileScreen> createState() => _EditeProfileScreenState();
}

class _EditeProfileScreenState extends State<EditeProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final formKey = GlobalKey<FormState>();

  TextEditingController tname = TextEditingController();
  TextEditingController taddress = TextEditingController();
  TextEditingController tmobileno = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
  TextEditingController tconfirmpassword = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController tinstgram = TextEditingController();
  TextEditingController tfacebook = TextEditingController();
  TextEditingController tyoutube = TextEditingController();
//mystsriya973@gmail.com Mystsriya@#2024
  String? imagePath;
  bool imageStatus = false;
  File? proImage;
  final ImagePicker _picker = ImagePicker();
  String? profileImage;

  String lat = '';
  String long = '';

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
        setState(() {
          tname.text = result.data.name;
          temail.text = result.data.email;
          tmobileno.text = result.data.mobileno;
          profileImage = result.data.image;
          taddress.text = result.data.address;
          lat = result.data.lat;
          long = result.data.long;
          tinstgram.text = result.data.instagramLink;
          tfacebook.text = result.data.facebookLink;
          tyoutube.text = result.data.youtubeLink;
        });
      }
    } else {
      Navigator.pop(context);
    }
  }

  updateProfileData() async {
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
      'name': tname.text,
      'address': taddress.text,
      'email': temail.text,
      'mobile_number': tmobileno.text,
      'long': long,
      'lat': lat,
      'instagram_link': tinstgram.text,
      'youtube_link': tyoutube.text,
      'facebook_link': tfacebook.text,
    };
    var result = await Services()
        .updateProfile(context, body: body, imagePath: imagePath);

    if (result != null) {

        if (result.status) {
          print("status is ${result.status} ${widget.isGooleSignIn}");
          if (widget.isGooleSignIn) {

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return AddBankAccountScreen(
                  type: "add",
                  fromMain: true,
                );
              },
            ));
          } else{
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return CustomBottomTabBar();
              },
            ));
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Something went wrong. Please try again later.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }


    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Edit Profile',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return imageStatus
                                ? SimpleDialog(
                                    children: [
                                      ListTile(
                                        title: const Text(
                                          "Camera",
                                          style:
                                              TextStyle(fontFamily: 'Lexend'),
                                        ),
                                        leading: const Icon(
                                            Icons.camera_alt_outlined),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final XFile? photo =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);
                                          if (photo != null) {
                                            proImage = File(photo.path);
                                            imagePath = photo.path;
                                            imageStatus = true;
                                          } else {
                                            imageStatus = false;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      ListTile(
                                        title: const Text(
                                          "Gallery",
                                          style:
                                              TextStyle(fontFamily: 'Lexend'),
                                        ),
                                        leading: const Icon(Icons.photo),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          imagePath = image!.path;
                                          if (imagePath!.isNotEmpty) {
                                            imageStatus = true;
                                            setState(() {});
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.close),
                                        title: const Text(
                                          "Remove Image",
                                          style:
                                              TextStyle(fontFamily: 'Lexend'),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            imagePath = null;
                                            imageStatus = false;
                                          });
                                        },
                                      )
                                    ],
                                  )
                                : SimpleDialog(
                                    children: [
                                      ListTile(
                                        title: const Text(
                                          "Camera",
                                          style:
                                              TextStyle(fontFamily: 'Lexend'),
                                        ),
                                        leading: const Icon(
                                            Icons.camera_alt_outlined),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final XFile? photo =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);
                                          if (photo != null) {
                                            proImage = File(photo.path);

                                            imagePath = photo.path;
                                            imageStatus = true;
                                          } else {
                                            imageStatus = false;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      ListTile(
                                        title: const Text(
                                          "Gallery",
                                          style:
                                              TextStyle(fontFamily: 'Lexend'),
                                        ),
                                        leading: const Icon(Icons.photo),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);
                                          imagePath = image!.path;
                                          if (imagePath!.isNotEmpty) {
                                            imageStatus = true;
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    ],
                                  );
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 150,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 140,
                              width: 140,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: SizedBox(
                                    child: imageStatus
                                        ? Image.file(
                                            File(imagePath.toString()),
                                            fit: BoxFit.cover,
                                          )
                                        : profileImage != ''
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    profileImage.toString(),
                                                fit: BoxFit.cover,
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child:
                                                            Icon(Icons.error)),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                  color:
                                                      MyColors.bacgroundcolors,
                                                )),
                                              )
                                            : Image.asset(
                                                'assets/images/user_profile.png')),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              right: 1,
                              child: GestureDetector(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: MyColors.bacgroundcolors,
                                      shape: BoxShape.circle),
                                  child: const Center(
                                      child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            return null;
                          },
                          controller: tname,
                          enabled: Utils.prefs!.getString("userName")=="Test Ekas" ? false : true,
                          inputFormatters: [ FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))],
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            hintText: 'Name',
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
                          'Email Address',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
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
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/email.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
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
                        const SizedBox(height: 20),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Mobile No';
                            } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
                              return 'Please Enter Valid Mobile No';
                            }
                            return null;
                          },
                          controller: tmobileno,
                          maxLength: 12,
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image:
                                    AssetImage('assets/images/smartphone.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
                            counterText: "",
                            hintText: 'Phone Number',
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
                        const SizedBox(height: 20),
                        Text(
                          'Address',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        const SizedBox(height: 10),

                        GooglePlaceAutoCompleteTextField(
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          textEditingController: taddress,
                          googleAPIKey:
                              "AIzaSyCziqe1Q-d4HMC3D9ZyYDFkBtx8ZHrzGzM",
                          inputDecoration: InputDecoration(
                            hintText: 'Address',
                            contentPadding: EdgeInsets.symmetric(horizontal: width * 0.03),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          showError: false,
                          debounceTime: 800, // default 600 ms,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (prediction) {
                            setState(() {
                              lat = prediction.lat.toString();
                              long = prediction.lng.toString();
                            });
                            log("placeDetails lat is : ${prediction.lat}");
                            log("placeDetails lng is : ${prediction.lng}");
                          }, // this callback is called when isLatLngRequired is true
                          itemClick: (prediction) {
                            taddress.text = prediction.description!;
                            taddress.selection;
                          },

                          seperatedBuilder: const Divider(),
                          isCrossBtnShown: false,
                        ),
                        // TextFormField(
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return 'Please Enter Your Address';
                        //     }
                        //     return null;
                        //   },
                        //   maxLines: 5,
                        //   controller: taddress,
                        //   keyboardType: TextInputType.emailAddress,
                        //   autovalidateMode: AutovalidateMode.onUserInteraction,
                        //   decoration: InputDecoration(
                        //     hintText: 'Address',
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
                          height: height * 0.025,
                        ),
                        Text(
                          'Instagram',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        SizedBox(height: height * 0.015),
                        TextFormField(
                          controller: tinstgram,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/inst.png'),
                                height: 25,
                                width: 25,
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'Instagram',
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

                        // facebook
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'Facebook',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        SizedBox(height: height * 0.015),
                        TextFormField(
                          controller: tfacebook,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/facebook.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
                            hintText: 'Facebook',
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

                        // youtube
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'YouTube',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        SizedBox(height: height * 0.015),
                        TextFormField(
                          controller: tyoutube,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/youtube.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
                            hintText: 'YouTube',
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
                  SizedBox(
                    height: height * 0.11,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.bacgroundcolors,
                        minimumSize: const Size(double.infinity, 40)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (tinstgram.text.isEmpty &&
                            tfacebook.text.isEmpty &&
                            tyoutube.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: 'Please enter any one social media account',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          updateProfileData();
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, fontFamily: 'Lexend',color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
