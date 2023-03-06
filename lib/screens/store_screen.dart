import 'package:eshop_admin/services/firebase_services.dart';
import 'package:eshop_admin/widgets/store/list_store_widget.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class StoreScreen extends StatefulWidget {
  static const String id = 'store-screen';
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final FirebaseServices _services = FirebaseServices();
  bool _visible = false;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(30),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _visible
                ?Container(
              alignment: Alignment.center,
              child: const Text(
                'Thêm địa chỉ',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            )
                :Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách địa chỉ cửa hàng',
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
                          'Thêm địa chỉ',
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
            addLocation(),
            const SizedBox(height: 25,),
            Visibility(
                visible: !_visible,
                child: ListStoreWidget()
            )
          ],
        ),
      ),
    );
  }

  Widget addLocation(){
    GlobalKey<FormState>  formKey = GlobalKey<FormState>();
    var nameText = TextEditingController();
    var addressText = TextEditingController();
    var longitudeText = TextEditingController();
    var latitudeText = TextEditingController();
    return Visibility(
      visible: _visible,
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
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width/2,
        height: MediaQuery.of(context).size.height*.65,
        child: Padding(
          padding: const EdgeInsets.only(left: 40,top: 30),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Tên cửa hàng"
                      ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 550,
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
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập tên cửa hàng';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text("Địa chỉ"
                      ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      width: 68,
                    ),
                    SizedBox(
                      width: 550,
                      child: TextFormField(
                        controller: addressText,
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
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập địa chỉ';
                          }
                          else if(value.length <= 3){
                            return 'Vui lòng nhập trên 3 kí tự';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text("Kinh độ"
                      ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      width: 60,
                    ),
                    SizedBox(
                      width: 550,
                      child: TextFormField(
                        controller: longitudeText,
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
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập kinh độ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text("Vĩ độ"
                      ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      width: 78,
                    ),
                    SizedBox(
                      width: 550,
                      child: TextFormField(
                        controller: latitudeText,
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
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vui lòng nhập kinh độ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            _visible = false;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              // <-- Icon
                              Icons.arrow_back_ios,
                              size: 12.0,
                              color: Colors.white,
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
                    const SizedBox(width: 50,),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: MaterialButton(
                        color: Colors.lightBlue,
                        onPressed: () {
                          if(formKey.currentState!.validate()) {
                            setState(() async {
                              _services.addStore(
                                  addressText.text,
                                  longitudeText.text,
                                  latitudeText.text,
                                  nameText.text);
                              await showDialog(
                                context: context,
                                builder: (context) =>
                                    FutureProgressDialog(
                                        Future.delayed(Duration(seconds: 3)),
                                        message: Text('Loading...')
                                    ),
                              );
                              _visible = false;
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              // <-- Icon
                              Icons.add,
                              size: 12.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              'Thêm',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
