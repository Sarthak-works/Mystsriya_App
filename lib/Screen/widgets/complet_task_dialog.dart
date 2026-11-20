import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/services/campaigns_services.dart';
import 'package:momworkapp/utils/utils.dart';

class CompletTaskDialog extends StatefulWidget {
  String? taskId;
  String? campaignId;
  CompletTaskDialog(
      {super.key, required this.taskId, required this.campaignId});

  @override
  State<CompletTaskDialog> createState() => _CompletTaskDialogState();
}

class _CompletTaskDialogState extends State<CompletTaskDialog> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tlink = TextEditingController();
  String? imagePath;
  bool imageStatus = false;
  File? proImage;
  final ImagePicker _picker = ImagePicker();

  bool linkStatus = false;
  String status = "";

  taskCompleteData() async {
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
      'task_id': widget.taskId.toString(),
      'status': '3',
      'campaign_id': widget.campaignId.toString(),
      'link': tlink.text,
    };
    var result = await CampaignsServices()
        .taskCompleteAPI(context, body: body, imagePath: imagePath);

    if (result != null) {
      if (result.status) {
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 380,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Link',
              style: TextStyle(fontSize: 16, fontFamily: 'Lexend'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
                onChanged: (value) {
                  setState(() {
                    linkStatus = false;
                  });
                },
                controller: tlink,
                decoration: InputDecoration(
                  hintText: 'Add Link',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: textFieldBorder(),
                  focusedBorder: textFieldBorder(),
                  enabledBorder: textFieldBorder(),
                  disabledBorder: textFieldBorder(),
                  contentPadding: const EdgeInsets.all(15),
                )),
            const SizedBox(
              height: 10,
            ),
            // SizedBox(
            //     height: 20,
            //     child: linkStatus
            //         ? Text(
            //             status,
            //             style: TextStyle(
            //                 color: Colors.red,
            //                 fontSize: 12,
            //                 fontFamily: 'Lexend'),
            //           )
            //         : null),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Or',
                style: TextStyle(fontSize: 16, fontFamily: 'Lexend'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Select Image',
              style: TextStyle(fontSize: 16, fontFamily: 'Lexend'),
            ),
            const SizedBox(
              height: 10,
            ),
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
                                    style: TextStyle(fontFamily: 'Lexend'),
                                  ),
                                  leading:
                                      const Icon(Icons.camera_alt_outlined),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final XFile? photo = await _picker
                                        .pickImage(source: ImageSource.camera);
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
                                    style: TextStyle(fontFamily: 'Lexend'),
                                  ),
                                  leading: const Icon(Icons.photo),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
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
                                    style: TextStyle(fontFamily: 'Lexend'),
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
                                    style: TextStyle(fontFamily: 'Lexend'),
                                  ),
                                  leading:
                                      const Icon(Icons.camera_alt_outlined),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final XFile? photo = await _picker
                                        .pickImage(source: ImageSource.camera);
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
                                    style: TextStyle(fontFamily: 'Lexend'),
                                  ),
                                  leading: const Icon(Icons.photo),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
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
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12)),
                child: SizedBox(
                  child: imageStatus
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imagePath.toString()),
                            fit: BoxFit.fill,
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded,
                                color: MyColors.greyshade500),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.bacgroundcolors,
                  minimumSize: const Size(double.infinity, 40)),
              onPressed: () {
                // if (formKey.currentState!.validate()) {
                if (imageStatus == true || tlink.text.isNotEmpty) {
                  if (tlink.text.isNotEmpty) {
                    if(Uri.tryParse(tlink.text)?.hasAbsolutePath ?? false) {
                      taskCompleteData();
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Please Enter Valid Link..',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black54,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  } else {
                    taskCompleteData();
                  }
                  // Navigator.pushReplacement(context, MaterialPageRoute(
                  //   builder: (context) {
                  //     return CampaignsTaskDetailsScreen();
                  //   },
                  // ));
                } else {
                  Fluttertoast.showToast(
                    msg: 'Please Select Image or add link',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
                // }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Lexend'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
