import 'package:eshop_admin/services/firebase_services.dart';
import 'package:eshop_admin/widgets/voucher/list_voucher.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class VoucherScreen extends StatefulWidget {
  static const String id = 'voucher-screen';
  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  final FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  bool ischeck = true;


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
                'Thêm khuyến mãi',
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
                  'Danh sách khuyến mãi',
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
                          'Thêm voucher',
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
            createVoucher(),
            const SizedBox(height: 25,),
            Visibility(
                visible: !_visible,
                child: ListVoucher()
            )
          ],
        ),
      ),
    );
  }

  Widget createVoucher(){
    GlobalKey<FormState>  formKey = GlobalKey<FormState>();
    var nameText = TextEditingController();
    var percentText = TextEditingController();
    var discountText = TextEditingController();
    var timeText = TextEditingController();
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
        height: MediaQuery.of(context).size.height*.75,
        child: Padding(
          padding: const EdgeInsets.only(left: 40,top: 30),
          child: Form(
            key: formKey,
            child: Column(
            children: [
              Row(
                children: [
                  const Text("Loại Voucher"
                    ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 30,
                  ),
                  RoundCheckBox(
                    isChecked: ischeck,
                    onTap: (selected) {
                      setState(() => {
                        ischeck=selected!,
                      });
                    },
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    checkedColor: Colors.white,
                    checkedWidget: const Icon(Icons.check, color: Colors.lightBlue),
                    uncheckedWidget: null,
                    animationDuration: const Duration(
                      seconds: 1,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Text("Freeship",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 30,),
                  RoundCheckBox(
                    isChecked: !ischeck,
                    onTap: (selected) {
                      setState(() => {
                        ischeck= !selected!,
                      });
                    },
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                    checkedColor: Colors.white,
                    checkedWidget: const Icon(Icons.check, color: Colors.lightBlue),
                    uncheckedWidget: null,
                    animationDuration: const Duration(
                      seconds: 1,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  const Text("Giảm giá",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Text("Tên item"
                    ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 45,
                  ),
                  SizedBox(
                    width: 550,
                    child: TextFormField(
                      controller: nameText,
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
                        const EdgeInsets.only(left: 20),),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ischeck==false?Row(
                children: [
                  const Text("Giảm giá(%)"
                    ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 550,
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
                      onChanged: (value){
                        nameText.text = "Giảm ${value}%";
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Vui lòng nhập thông tin giảm giá';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ):Container(),
              ischeck==false?const SizedBox(
                height: 30,
              ):Container(),
              Row(
                children: [
                  const Text("Giảm tối đa"
                    ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 550,
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
                      onChanged: (value){
                        if(ischeck) {
                          nameText.text = "Giảm ${value}k";
                        }
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Vui lòng nhập mức giảm tối đa';
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
                  const Text("Thời gian"
                    ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(
                    width: 35,
                  ),
                  SizedBox(
                    width: 550,
                    child: TextFormField(
                      controller: timeText,
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
                        contentPadding: const EdgeInsets.only(left: 20),),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Vui lòng nhập hạn sử dụng';
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
                    width: 100,
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
                    width: 100,
                    child: MaterialButton(
                      color: Colors.lightBlue,
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                            _services.addVoucher(
                                ischeck==false?percentText.text:"0",
                                discountText.text,
                                nameText.text,
                                timeText.text,
                                ischeck).then((value) async {
                              await showDialog(
                                context: context,
                                builder: (context) =>
                                    FutureProgressDialog(
                                        Future.delayed(Duration(seconds: 3)),
                                        message: const Text('Loading...')
                                    ),
                              );
                              setState(() {
                                _visible = false;
                              });
                            });
                        }
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
