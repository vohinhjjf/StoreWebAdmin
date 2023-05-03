import 'dart:html';
import 'dart:typed_data';

import 'package:eshop_admin/screens/blog_editor.dart';
import 'package:eshop_admin/services/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

import '../widgets/blog/list_blogs_widget.dart';

class BlogScrren extends StatefulWidget {
  static const String id = 'product-screen';
  @override
  _BlogScreen createState() => _BlogScreen();
}

class _BlogScreen extends State<BlogScrren> {
  final FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  String ddCategory = "-- Chọn danh mục --";
  final _fileNameTextController = TextEditingController();
  TextEditingController nameText = TextEditingController();
  TextEditingController percentText = TextEditingController();
  TextEditingController discountText = TextEditingController();
  TextEditingController shortText = TextEditingController();
  TextEditingController contentText = TextEditingController();

  late String _url = "";
  late File _cloudFile;
  var _fileBytes;
  late Image _imageWidget;
  String formattedDate = '';
  String downloadUrl = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(30),
        child: _visible
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Thêm Blog',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  createProduct(),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Danh sách Blog',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 36,
                        ),
                      ),
                      SizedBox(
                        height: 35,
                        child: MaterialButton(
                          color: Colors.lightBlue,
                          onPressed: () {
                            setState(() {
                              _visible = !_visible;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                // <-- Icon
                                Icons.add,
                                size: 12.0,
                                color: Colors.white,
                              ),
                              Text(
                                'Thêm Blog',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ), // <-- Text
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListBlog(),
                ],
              ),
      ),
    );
  }

  Widget createProduct() {
    DateTime now = DateTime.now();
    String date = DateFormat('dd').format(now);
    String moyear = DateFormat('MMM yyyy').format(now);
    String time = DateFormat('kk:mm a').format(now);
    formattedDate = "${date}th $moyear\nTime: $time";
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Container(
      decoration: ShapeDecoration(
        shadows: const [BoxShadow(color: Colors.grey)],
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, top: 30, right: 40),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 600,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Danh mục",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                                width: 380,
                                child: DropdownButton(
                                  value: ddCategory,
                                  items: const [
                                    //add items in the dropdown
                                    DropdownMenuItem(
                                      value: "-- Chọn danh mục --",
                                      child: Text("-- Chọn danh mục --"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Đồ công nghệ",
                                      child: Text("Đồ công nghệ"),
                                    ),
                                    DropdownMenuItem(
                                        value: "Game", child: Text("Game")),
                                    DropdownMenuItem(
                                      value: "Thủ thuật - Hướng dẫn",
                                      child: Text("Thủ thuật - Hướng dẫn"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Giải trí",
                                      child: Text("Giải trí"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Coding",
                                      child: Text("Coding"),
                                    ),
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      ddCategory = value!;
                                    });
                                  },
                                  isExpanded: true,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Tiêu đề",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 380,
                              height: 45,
                              child: TextFormField(
                                controller: nameText,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightBlue,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Ngày đăng",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 380,
                              height: 40,
                              child: TextFormField(
                                initialValue: formattedDate,
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightBlue,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 20),
                                ),
                              ), //thăm quan
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Tác giả",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 380,
                              height: 40,
                              child: TextFormField(
                                initialValue: "Admin (Tự động điền)",
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                      width: 1,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue.shade50,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.lightBlue,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Row(
                        //   children: [
                        //     const Text(
                        //       "Hình ảnh",
                        //       style: TextStyle(
                        //           fontSize: 20, fontWeight: FontWeight.bold),
                        //     ),
                        //     const Spacer(),
                        //     AbsorbPointer(
                        //       absorbing: true,
                        //       child: SizedBox(
                        //           width: 380,
                        //           height: 40,
                        //           child: TextField(
                        //             controller: _fileNameTextController,
                        //             decoration: InputDecoration(
                        //                 focusedBorder: const OutlineInputBorder(
                        //                   borderSide: BorderSide(
                        //                     color: Colors.blue,
                        //                     width: 1,
                        //                   ),
                        //                 ),
                        //                 filled: true,
                        //                 fillColor: Colors.blue.shade50,
                        //                 enabledBorder: const OutlineInputBorder(
                        //                   borderSide: BorderSide(
                        //                     color: Colors.lightBlue,
                        //                     width: 1,
                        //                   ),
                        //                 ),
                        //                 hintText:
                        //                     'Không có hình ảnh nào được chọn',
                        //                 border: const OutlineInputBorder(),
                        //                 contentPadding:
                        //                     const EdgeInsets.only(left: 20)),
                        //           )),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tóm tắt blog",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 380,
                              height: 150,
                              child: TextFormField(
                                controller: shortText,
                                decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.blue.shade50,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.lightBlue,
                                        width: 1,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, top: 20)),
                                maxLines: 100,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Vui lòng nhập tóm tắt blog';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 400,
                        width: 400,
                        decoration: ShapeDecoration(
                          shadows: const [BoxShadow(color: Colors.grey)],
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _url == ""
                            ? const Image(
                                image: AssetImage("images/add-image.png"),
                              )
                            : _imageWidget = Image.network(downloadUrl),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        height: 45,
                        onPressed: () {
                          //uploadStorage();
                          uploadStorage();
                          setState(() async {
                            downloadUrl = await _services.storage
                                .ref(_url)
                                .getDownloadURL();
                          });
                        },
                        color: Colors.black54,
                        child: const Text(
                          'Tải ảnh lên',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: BlogEditor(
                    editorController: contentText,
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: MaterialButton(
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          _visible = false;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            // <-- Icon
                            Icons.arrow_back_ios,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Quay lại',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ), // <-- Text
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: MaterialButton(
                      color: Colors.lightBlue,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (ddCategory == "-- Chọn danh mục --") {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: const [
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          'Vui lòng chọn danh mục',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Đóng',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          } else if (_url == "") {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: const [
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          'Vui lòng chọn hình ảnh!',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Đóng',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                });
                          } else {
                            if (downloadUrl != null) {
                              _services.blogs.add({
                                'active': true,
                                'name': nameText.text,
                                'image': downloadUrl,
                                'short': shortText.text,
                                'collection': "",
                                'category': ddCategory,
                                'time': formattedDate,
                                'Author': 'Admin',
                                'hot': false,
                                'content': contentText.text,
                              });
                            }
                            setState(() {
                              _visible = false;
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Thêm',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ), // <
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> getMultipleImageInfos() async {
  //   var mediaData = await ImagePickerWeb.getImageInfo;

  //   String? mimeType = mime(Path.basename(mediaData!.fileName!));
  //   File mediaFile =
  //       File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

  //   setState(() {
  //     _cloudFile = mediaFile;
  //     _fileBytes = mediaData.data;
  //     _imageWidget = Image.memory(mediaData.data!);
  //   });
  // }

  //----------------upload image form device---------------------
  void uploadImage({required Function(File file) onSelected}) {
    FileUploadInputElement uploadInput = FileUploadInputElement()
      ..accept = 'image/*'; //Chỉ tải ảnh lên
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }
  //----------------upload image form device---------------------

  //----------upload selected image to Firebase storage--------------
  void uploadStorage() {
    final dateTime = DateTime.now();
    final path = 'blog/$dateTime';
    uploadImage(onSelected: (file) {
      setState(() {
        _fileNameTextController.text = file.name;
        _url = path;
      });

      FirebaseStorage.instance
          .refFromURL('gs://storeapp-b5b72.appspot.com')
          .child(path)
          .putBlob(file);
    });
  }
  //----------upload selected image to Firebase storage--------------
}
