import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../services/create_post_services.dart';
import '../../utils/utils.dart';
import 'Colors.dart';

class FileData {
  String path;
  String type;
  String source;

  FileData({required this.path, required this.type, required this.source});
}

class CreatePostScreen extends StatefulWidget {
  String? type;
  CreatePostScreen({super.key, this.type});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tdes = TextEditingController();

  bool descriptionStatus = false;
  String status = "";
  String type = '';

  String? imagePath;

  VideoPlayerController? _controller;

  var colorList = [
    "0xFFFFFFFF,0xFFFFFFFF", "0xffE71D36,0xffE71D7E",
    "0xffFF810D,0xffFBBC67", "0xff1C77FF,0xff801CFF",
    "0xffFF2A1C,0xffFF7B1C", "0xff559701,0xff87F885",
    "0xff0094FF,0x0ffc92ff", "0xff651CFF,0xff1C77FF"
  ];

  @override
  void initState() {
    super.initState();
  }

  pickImage() async {
    if(_controller != null) {
      _controller!.pause();
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4'],
    );
    if(result != null) {
      var size = ((result.files.first.size) / (1024 * 1024));
      print(size);
      if (size < 10) {
        type = result.files.first.extension == "mp4"?"2":"1";
        imagePath = result.files.first.path;
        if(result.files.first.extension == "mp4") {
          _controller = VideoPlayerController.file(File(result.files.first.path!))..initialize();
        }
        setState(() {});
      } else {
              Fluttertoast.showToast(
                msg:
                    'The selected file is too large. Please select a file less than or equal to 10 MB.',
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

  List<LinearGradient> gradientList = [
    const LinearGradient(
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xffE71D36), Color(0xffE71D7E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xffFF810D), Color(0xffFBBC67)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xff1C77FF), Color(0xff801CFF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xffFF2A1C), Color(0xffFF7B1C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xff559701), Color(0xff87F885)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xff0094FF), Color(0x0ffc92ff)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xff651CFF), Color(0xff1C77FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  int selectedColorIndex = 0;

  void changeBackgroundColor(int index) {
    setState(() {
      selectedColorIndex = index;
    });
  }

  createNewPostData() async {
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
      'description': tdes.text,
      'background_color': colorList[selectedColorIndex],
      'link': '',
      'post_type': widget.type == 'image' ? '1' : '2',
      if(widget.type == 'image') "type": type
    };

    print(body);

    var result =
        await Services().createPostData(context, body: body, image: imagePath);

    if (result != null) {
      if (result.status) {
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.bacgroundcolors,
                minimumSize: const Size(double.infinity, 40)),
            onPressed: () {
              setState(() {
                print(gradientList[selectedColorIndex].colors);
                String description = tdes.text;
                // var colorSelected = gradientList[selectedColorIndex].colors.toString();
                // colorSelected = colorSelected.replaceAll("[", "");
                // colorSelected = colorSelected.replaceAll("]", "");
                print("bcgh ${colorList[selectedColorIndex]}");

                if (description.isEmpty) {
                  descriptionStatus = true;
                  status = "Please Enter Description";
                } else {
                  createNewPostData();
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Lexend'),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: Text(
            widget.type == 'image' ? 'Create Post' : 'Create Story',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
          
        ),
        body: widget.type == 'image'
            ? Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            const Text(
                              'Select Image or Video ',
                              style:
                                  TextStyle(fontSize: 18, fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     pickImage();
                            //   },
                            //   child: Container(
                            //     width: double.infinity,
                            //     height: 150,
                            //     decoration: BoxDecoration(
                            //         border: Border.all(
                            //             width: 1, color: Colors.black12),
                            //         borderRadius: BorderRadius.circular(8)),
                            //     child: SizedBox(
                            //       child: imageStatus
                            //           ? imagePath!.contains('jpg') ||
                            //                   imagePath!.contains('png')
                            //               ? Image.file(
                            //                   File(imagePath.toString()),
                            //                   fit: BoxFit.fill,
                            //                 )
                            //               : Column(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.center,
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment.center,
                            //                   children: [
                            //                     Icon(Icons.play_arrow,
                            //                         color:
                            //                             MyColors.greyshade500),
                            //                     const SizedBox(
                            //                       height: 10,
                            //                     ),
                            //                   ],
                            //                 )
                            //           : Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.center,
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               children: [
                            //                 Icon(Icons.camera_alt_rounded,
                            //                     color: MyColors.greyshade500),
                            //                 const SizedBox(
                            //                   height: 10,
                            //                 ),
                            //               ],
                            //             ),
                            //     ),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                pickImage();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(10)),
                                child: SizedBox(
                                  child: imagePath != null
                                      ? type == "1"?
                                  ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: Image.file(
                                            File(imagePath.toString()),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: double.infinity,
                                                    child: AspectRatio(
                                                      aspectRatio: _controller!
                                                          .value.aspectRatio,
                                                      child: VideoPlayer(
                                                          _controller!),
                                                    ),
                                                  ),
                                                  Positioned(
                                                      top: 50,
                                                      left: width * 0.4,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              if (_controller!.value.isPlaying) {
                                                                _controller!
                                                                    .pause();
                                                              } else {
                                                                _controller!
                                                                    .play();
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: Icon(
                                                              _controller!.value.isPlaying
                                                                  ? Icons.pause
                                                                  : Icons.play_arrow,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.camera_alt_rounded,
                                                    color:
                                                        MyColors.greyshade500),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                        fontSize: 18, fontFamily: 'Lexend'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Enter Description';
                                      // } else if (value.length < 500) {
                                      //   return 'Please enter minimum 500 words';
                                      }
                                      return null;
                                    },
                                    controller: tdes,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      hintText: 'Add description...',
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
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.bacgroundcolors,
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        if (imagePath != null) {
                          if (formKey.currentState!.validate()) {
                            createNewPostData();
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Please Select Image Or Video',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Post',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Lexend'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            : Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: height * 0.88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        const Text(
                          'Text',
                          style: TextStyle(fontSize: 18, fontFamily: 'Lexend'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: gradientList[selectedColorIndex],
                            border: Border.all(
                                color: descriptionStatus
                                    ? Colors.red
                                    : Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                descriptionStatus = false;
                              });
                            },
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Please Enter Description";
                              }
                              return null;
                            },
                            maxLength: 100,
                            maxLines: 5,
                            controller: tdes,
                            textInputAction: TextInputAction.done,
                            style: TextStyle(
                                color: selectedColorIndex == 0
                                    ? Colors.black
                                    : Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter text",
                              hintStyle:
                                  TextStyle(color: MyColors.greyshade600),
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: descriptionStatus ? 20 : 0,
                            child: descriptionStatus
                                ? Text(
                                    status,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontFamily: 'Lexend'),
                                  )
                                : null),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: gradientList.length,
                            itemBuilder: (context, index) {
                              return ColorButton(
                                gradientList[index],
                                index,
                                selectedColorIndex,
                                changeBackgroundColor,
                              );
                            },
                          ),
                        ),
                    //    SizedBox(height: 150,),
                    //     ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor: MyColors.bacgroundcolors,
                    //           minimumSize: const Size(double.infinity, 40)),
                    //       onPressed: () {
                    //         setState(() {
                    //           print(gradientList[selectedColorIndex].colors);
                    //           String description = tdes.text;
                    //           // var colorSelected = gradientList[selectedColorIndex].colors.toString();
                    //           // colorSelected = colorSelected.replaceAll("[", "");
                    //           // colorSelected = colorSelected.replaceAll("]", "");
                    //            print("bcgh ${colorList[selectedColorIndex]}");
                    //
                    //           if (description.isEmpty) {
                    //             descriptionStatus = true;
                    //             status = "Please Enter Description";
                    //           } else {
                    //             createNewPostData();
                    //           }
                    //         });
                    //       },
                    //       child: Container(
                    //         padding: const EdgeInsets.all(12),
                    //         decoration: const BoxDecoration(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(10))),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: const [
                    //             SizedBox(
                    //               width: 10,
                    //             ),
                    //             Text(
                    //               'Post',
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 14,
                    //                   fontFamily: 'Lexend'),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final LinearGradient gradient;
  final int index;
  final int selectedIndex;
  final Function(int) onPressed;

  const ColorButton(
      this.gradient, this.index, this.selectedIndex, this.onPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(index);
        print('index $index');
      },
      child: Container(
          width: 50,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                // color:
                //     index == selectedIndex ? Colors.grey : Colors.transparent
                color: index == 0 ? Colors.grey : Colors.transparent
                // color: Colors.grey,
                ),
          ),
          child: index == selectedIndex
              ? Center(
                  child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: index == 0 ? Colors.black : Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.done,
                        size: 18,
                        color: index == 0 ? Colors.black : Colors.white,
                      )),
                )
              : null),
    );
  }
}
