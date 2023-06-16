import 'dart:html';

import 'package:eshop_admin/services/firebase_services.dart';
import 'package:eshop_admin/widgets/product/list_product_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as Path;

class ProductScreen extends StatefulWidget {
  static const String id = 'product-screen';

  const ProductScreen({super.key});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  String ddCategory = "-- Chọn loại sản phẩm --";
  final _fileNameTextController = TextEditingController();
  var nameText = TextEditingController();
  var percentText = TextEditingController();
  var discountText = TextEditingController();
  var detailText = TextEditingController();

  late String _url = "";
  late File _cloudFile;
  var _fileBytes;
  late Image _imageWidget;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(30),
        child: _visible ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Thêm sản phẩm',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            const SizedBox(height: 25,),
            createProduct(),
          ],
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách sản phẩm',
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
                          'Thêm sản phẩm',
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
            const SizedBox(height: 25,),
            ListProduct(),
          ],
        ),
      ),
    );
  }

  Widget createProduct() {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Container(
      decoration: ShapeDecoration(
        shadows: const [
          BoxShadow(color: Colors.grey)
        ],
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      alignment: Alignment.center,
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height * .75,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, top: 30, right: 40),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Text("Loại sản phẩm"
                            , style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          const SizedBox(
                            width: 50,
                          ),
                          SizedBox(
                              width: 380,
                              child: DropdownButton(
                                value: ddCategory,
                                items: const [ //add items in the dropdown
                                  DropdownMenuItem(
                                    value: "-- Chọn loại sản phẩm --",
                                    child: Text("-- Chọn loại sản phẩm --"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Điện thoại",
                                    child: Text("Điện thoại"),
                                  ),
                                  DropdownMenuItem(
                                      value: "Laptop",
                                      child: Text("Laptop")
                                  ),
                                  DropdownMenuItem(
                                    value: "PC-Lắp ráp",
                                    child: Text("PC - Lắp ráp"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Máy tính bảng",
                                    child: Text("Máy tính bảng"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Đồng hồ thông minh",
                                    child: Text("Đồng hồ thông minh"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Tai nghe",
                                    child: Text("Tai nghe"),
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
                          const Text("Tên sản phẩm"
                            , style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          const SizedBox(
                            width: 50,
                          ),
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
                                const EdgeInsets.only(left: 20),),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text("Giá gốc (VNĐ)"
                            , style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          const SizedBox(
                            width: 48,
                          ),
                          SizedBox(
                            width: 380,
                            height: 40,
                            child: TextFormField(
                              controller: percentText,
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
                                const EdgeInsets.only(left: 20),),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: const TextInputType.numberWithOptions(signed: true),// Only numbers can be entered
                              onChanged: (value){
                                  percentText.value = TextEditingValue(
                                    text: MoneyFormatter(
                                        amount: double.parse(value.replaceAll(RegExp(r','), ''))
                                    ).output.withoutFractionDigits,
                                    selection: TextSelection.collapsed(
                                      offset: MoneyFormatter(
                                          amount: double.parse(value.replaceAll(RegExp(r','), ''))
                                      ).output.withoutFractionDigits.length,
                                    ),
                                  );
                              },
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vui lòng nhập số tiền';
                                }
                                return null;
                              },
                            ), //thăm quan
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text("Giảm giá(%)"
                            , style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          const SizedBox(
                            width: 65,
                          ),
                          SizedBox(
                            width: 380,
                            height: 40,
                            child: TextFormField(
                              controller: discountText,
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
                                const EdgeInsets.only(left: 20),),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập mức giảm giá';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const Text("Hình ảnh"
                            , style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          const SizedBox(
                            width: 95,
                          ),
                          AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                                width: 380,
                                height: 40,
                                child: TextField(
                                  controller: _fileNameTextController,
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
                                      hintText: 'Không có hình ảnh nào được chọn',
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                      const EdgeInsets.only(left: 20)),
                                )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Chi tiết sản phẩm"
                            , style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 380,
                            height: 150,
                            child: TextFormField(
                              controller: detailText,
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
                                const EdgeInsets.only(left: 20,top: 20)),
                              maxLines: 100,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập chi tiết sản phẩm';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
                        child:_url==""?
                        const Image(
                          image: AssetImage("images/add-image.png"),
                        ):
                        _imageWidget,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        height: 45,
                        onPressed: () {
                          //uploadStorage();
                          getMultipleImageInfos();
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
                          SizedBox(width: 20,),
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
                  const SizedBox(width: 50,),
                  SizedBox(
                    height: 45,
                    width: 200,
                    child: MaterialButton(
                      color: Colors.lightBlue,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if(ddCategory == "-- Chọn loại sản phẩm --"){
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
                                        'Vui lòng chọn loại sản phẩm!',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Đóng',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }
                            );
                          }else if(_url == ""){
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
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Đóng',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }
                            );
                          } else{
                            await FirebaseStorage.instance
                                .refFromURL('gs://storeapp-b5b72.appspot.com')
                                .child(_url).putBlob(_cloudFile);
                            String downloadUrl = await _services.storage.ref(_url).getDownloadURL();
                            if (downloadUrl != null) {
                              String value = ddCategory=="PC-Lắp ráp"?"":ddCategory;
                              _services.product.add({
                                'name': "$value ${nameText.text}",
                                'image': downloadUrl,
                                'details': detailText.text,
                                'collection': "",
                                'category': ddCategory,
                                'price': double.parse(percentText.text),
                                'discountPercentage': double.parse(discountText.text),
                                'sold' : 0,
                                "freeship":false,
                                "hot":false,
                                "amount":1,
                                "checkBuy":false,
                              });
                            }
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

  Future<void> getMultipleImageInfos() async {
    var mediaData = await ImagePickerWeb.getImageInfo;

    String? mimeType = mime(Path.basename(mediaData!.fileName!));
    File mediaFile =
    File(mediaData.data!, mediaData.fileName!, {'type': mimeType});

    if (mediaFile != null) {
      setState(() {
        _cloudFile = mediaFile;
        _fileBytes = mediaData.data;
        _imageWidget = Image.memory(mediaData.data!);
        _url = 'product/${ddCategory}/${DateTime.now()}';
        _fileNameTextController.text = mediaData.fileName!;
      });
    }
  }
}
