import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

import '../../services/create_post_services.dart';
import '../../utils/utils.dart';
import 'Colors.dart';

class EditPostScreen extends StatefulWidget {
  String postType;
  String id;
  String? imageList;
  String description;
  String? backgroundColor;
  String? type;
  EditPostScreen({
    super.key,
    required this.postType,
    required this.id,
    this.imageList,
    required this.description,
    this.backgroundColor,
    this.type,
  });

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tdes = TextEditingController();

  bool descriptionStatus = false;
  String status = "";
  String type = "";

  String? imagePath;

  VideoPlayerController? _controller;

  List<LinearGradient> gradientList = [
    const LinearGradient(
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF),
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
  bool gradient = false;

  void changeBackgroundColor(int index) {
    setState(() {
      selectedColorIndex = index;
      gradient = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    tdes.text = widget.description.toString();
    type = widget.type ?? "";
    if (widget.postType == 'image' && widget.type == "2") {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.imageList!))
            ..initialize();
    }
    if (widget.postType == "text") {
      for (int i = 0; i < gradientList.length; i++) {
        if (gradientList[i]
                .colors
                .toString()
                .replaceAll("[", "")
                .replaceAll("Color(", "")
                .replaceAll(")", "")
                .replaceAll("]", "") ==
            widget.backgroundColor) {
          selectedColorIndex = i;
          setState(() {});
          break;
        }
      }
    }
  }

  pickImage() async {
    if (_controller != null) {
      _controller!.pause();
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4'],
    );
    if (result != null) {
      var size = ((result.files.first.size) / (1024 * 1024));
      print(size);
      if (size < 10) {
        if (_controller != null) _controller!.dispose();
        type = result.files.first.extension == "mp4" ? "2" : "1";
        imagePath = result.files.first.path;
        if (result.files.first.extension == "mp4") {
          _controller =
              VideoPlayerController.file(File(result.files.first.path!));
          await _controller!.initialize();
          setState(() {});
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

  editPostAPI() async {
    print(widget.postType);
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

    Map<String, String> body = {
      'description': tdes.text,
      'background_color': gradientList[selectedColorIndex]
          .colors
          .toString()
          .replaceAll("[", "")
          .replaceAll("Color(", "")
          .replaceAll(")", "")
          .replaceAll("]", ""),
      'link': '',
      'post_type': widget.postType == 'image' ? '1' : '2',
      if (widget.postType == 'image') "type": type
    };

    print('body::::::::::::$body');
    print(widget.postType);

    var result = await Services().editPostData(context,
        body: body,
        image: widget.postType == 'image' ? imagePath : null,
        postId: widget.id);

    if (result != null) {
      if (result.status) {
        log(result);
        Navigator.pop(context);
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Edit Post',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: widget.postType == 'image'
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
                              'Select Image or Video',
                              style:
                                  TextStyle(fontSize: 18, fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black12),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: SizedBox(
                                      child: imagePath == null
                                          ? type == '1'
                                              ? CachedNetworkImage(
                                                  imageUrl: widget.imageList
                                                      .toString(),
                                                  fit: BoxFit.fill,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Icon(
                                                              Icons.error)),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color: MyColors
                                                        .bacgroundcolors,
                                                  )),
                                                )
                                              : _controller!.value.isInitialized
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        VideoPlayer(
                                                            _controller!),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_controller!
                                                                .value
                                                                .isPlaying) {
                                                              _controller!
                                                                  .pause();
                                                            } else {
                                                              _controller!
                                                                  .play();
                                                            }
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: Icon(
                                                              _controller!.value
                                                                      .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                          : type == '1'
                                              ? Image.file(
                                                  File(imagePath.toString()),
                                                  fit: BoxFit.fill,
                                                )
                                              : _controller!.value.isInitialized
                                                  ? Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        VideoPlayer(
                                                            _controller!),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_controller!
                                                                .value
                                                                .isPlaying) {
                                                              _controller!
                                                                  .pause();
                                                            } else {
                                                              _controller!
                                                                  .play();
                                                            }
                                                            setState(() {});
                                                          },
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: Icon(
                                                              _controller!.value
                                                                      .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                    ),
                                  ),
                                ),
                              ],
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
                                        //   return 'Please enter minimum 500 character';
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
                          minimumSize: const Size(double.infinity, 40)),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          editPostAPI();
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
                              'Save',
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
                    height: height * 0.85,
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
                            // gradient: gradientList[selectedColorIndex],
                            gradient: gradientList[selectedColorIndex],
                            border: Border.all(
                                color: descriptionStatus
                                    ? Colors.red
                                    : Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                descriptionStatus = false;
                              });
                            },
                            maxLength: 100,
                            style: TextStyle(
                                color: selectedColorIndex == 0
                                    ? Colors.black
                                    : Colors.white),
                            maxLines: 5,
                            controller: tdes,
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
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.bacgroundcolors,
                              minimumSize: const Size(double.infinity, 40)),
                          onPressed: () {
                            setState(() {
                              print(gradientList[selectedColorIndex].colors);
                              String description = tdes.text;

                              if (description.isEmpty) {
                                descriptionStatus = true;
                                status = "Please Enter Description";
                              } else {
                                editPostAPI();
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
                                  'Save',
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
            : null,
      ),
    );
  }
}
