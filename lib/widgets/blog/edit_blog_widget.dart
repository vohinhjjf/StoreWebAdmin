import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:eshop_admin/services/firebase_services.dart';

import '../../screens/blog_editor.dart';

class EditBlogBox extends StatefulWidget {
  final String uid;

  const EditBlogBox(this.uid, {super.key});

  @override
  _EditBlogBoxState createState() => _EditBlogBoxState();
}

class _EditBlogBoxState extends State<EditBlogBox> {
  final FirebaseServices _services = FirebaseServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameText = TextEditingController();
  TextEditingController shortText = TextEditingController();
  TextEditingController contentText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _services.blogs.doc(widget.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          nameText.text = snapshot.data!['name'];
          shortText.text = snapshot.data!['short'];
          contentText.text = snapshot.data!['content'];
          return Dialog(
            child: Container(
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
                  key: _formKey,
                  child: SingleChildScrollView(
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 380,
                                        child: Text(snapshot.data!['category']),
                                      ),
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 380,
                                        height: 45,
                                        child: TextFormField(
                                          controller: nameText,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.blue.shade50,
                                            enabledBorder:
                                                const OutlineInputBorder(
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 380,
                                        height: 40,
                                        child: TextFormField(
                                          initialValue: snapshot.data!['time'],
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.blue.shade50,
                                            enabledBorder:
                                                const OutlineInputBorder(
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 380,
                                        height: 40,
                                        child: TextFormField(
                                          initialValue: "Admin (Tự động điền)",
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.blue.shade50,
                                            enabledBorder:
                                                const OutlineInputBorder(
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
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: 380,
                                        height: 150,
                                        child: TextFormField(
                                          controller: shortText,
                                          decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.blue,
                                                  width: 1,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.blue.shade50,
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.lightBlue,
                                                  width: 1,
                                                ),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
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
                                    shadows: const [
                                      BoxShadow(color: Colors.grey)
                                    ],
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Image.network(snapshot.data!['image']),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                MaterialButton(
                                  height: 45,
                                  onPressed: () {},
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
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
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
                                  if (_formKey.currentState!.validate()) {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => FutureProgressDialog(
                                          _services.updateContentBlog(
                                              id: snapshot.data!.id,
                                              name: nameText.text,
                                              short: shortText.text,
                                              content: contentText.text),
                                          message: const Text('Loading...')),
                                    );
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
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
              ),
            ),
          );
        });
  }
}
