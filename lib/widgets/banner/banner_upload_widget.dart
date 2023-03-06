import 'dart:html';
import 'package:eshop_admin/services/firebase_services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class BannerUploadWidget extends StatefulWidget {
  bool _visible = false;

  BannerUploadWidget(this._visible);

  @override
  _BannerUploadWidgetState createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {
  final FirebaseServices _services = FirebaseServices();
  final _fileNameTextController = TextEditingController();
  bool _imageSelected = true;
  late String _url;

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(
        context: context,
        barrierDimisable:  false,
    );
    /*ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(.3),
        animationDuration: Duration(
          milliseconds: 500,
        ),
    );*/


    return Visibility(
      visible: widget._visible,
      child: Container(
        decoration: ShapeDecoration(
          shadows: [
            const BoxShadow(color: Colors.grey)
          ],
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              AbsorbPointer(
                absorbing: true,
                child: SizedBox(
                    width: 300,
                    height: 30,
                    child: TextField(
                      controller: _fileNameTextController,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black, width: 1),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Không có hình ảnh nào được chọn',
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.only(left: 20)),
                    )
                ),
              ),
              const SizedBox(width: 10,),
              MaterialButton(
                onPressed: () {
                  uploadStorage();
                },
                color: Colors.black54,
                child: const Text(
                  'Tải ảnh lên',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              AbsorbPointer(
                absorbing: _imageSelected,
                child: MaterialButton(
                  onPressed: () {
                    dialog.show(message: 'Loading...');
                    _services.uploadBannerImageToDb(_url).then((downloadUrl) {
                      if(downloadUrl != null){
                        dialog.hide();
                        _services.showMyDialog(
                            title: 'Ảnh quảng cáo mới',
                            message: 'Lưu ảnh quảng cáo thành công',
                            context: context
                        );
                      }
                    });
                  },
                  color: _imageSelected ? Colors.black12 : Colors.black54,
                  child: const Text(
                    'Lưu ảnh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


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
    final path = 'bannerImage/$dateTime';
    uploadImage(onSelected: (file)  {
      setState(() {
        _fileNameTextController.text = file.name;
        _imageSelected=false;
        _url = path;
      });
      FirebaseStorage.instance
          .refFromURL('gs://storeapp-b5b72.appspot.com')
          .child(path).putBlob(file);
    });
  }
  //----------upload selected image to Firebase storage--------------

}
