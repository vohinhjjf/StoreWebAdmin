import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class VoucherDetailsBox extends StatefulWidget {
  final String uid;

  const VoucherDetailsBox(this.uid);

  @override
  _VoucherDetailsBoxState createState() => _VoucherDetailsBoxState();
}
enum HeadBase { freeship, coupon }
class _VoucherDetailsBoxState extends State<VoucherDetailsBox> {
  final FirebaseServices _services = FirebaseServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HeadBase? _status = HeadBase.coupon;
  var _txtName = TextEditingController();
  var _txtDiscount = TextEditingController();
  var _txtMaxDiscount = TextEditingController();
  var _txtTime = TextEditingController();

  getValue(DocumentSnapshot documentSnapshot){
    _txtName.text = documentSnapshot["name"].toString();
    _txtDiscount.text = documentSnapshot["discountPercentage"].toString();
    _txtMaxDiscount.text = documentSnapshot["maxDiscount"].toString();
    _txtTime.text = documentSnapshot["time"].toString();
    if(documentSnapshot["freeship"]){
      _status = HeadBase.freeship;
    } else {
      _status = HeadBase.coupon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _services.voucher.doc(widget.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData){
            getValue(snapshot.data!);
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height-140,
                        width: MediaQuery.of(context).size.width * .3,
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            const Text(
                              "Loại khuyến mãi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  child: ListTile(
                                    title: Text(
                                      "Coupon",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,),
                                      textAlign: TextAlign.start,
                                    ),
                                    leading: Radio<HeadBase>(
                                      value: HeadBase.coupon,
                                      groupValue: _status,
                                      onChanged: (HeadBase? value) {
                                          _status = value;
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: ListTile(
                                    title: const Text(
                                      "Freeship",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,),
                                      textAlign: TextAlign.start,
                                    ),
                                    leading: Radio<HeadBase>(
                                      value: HeadBase.freeship,
                                      groupValue: _status,
                                      onChanged: (HeadBase? value) {
                                          _status = value;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Tên voucher: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _txtName,
                              readOnly: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _status==HeadBase.coupon?Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Tỷ lệ giảm giá(%)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _txtDiscount,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ):Container(),
                            const Text(
                              "Giảm giá tối đa(nghìn)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _txtMaxDiscount,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Thời gian khuyến mãi(ngày)",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _txtTime,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Container(
                          alignment: AlignmentDirectional.bottomCenter,
                          width: MediaQuery.of(context).size.width * .3,
                          height: 56,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(28) //
                              ),
                              gradient: LinearGradient(colors: [
                                Colors.lightBlue,
                                Colors.lightBlueAccent,
                              ])
                          ),
                          child: const Center(
                            child: Text(
                              'Cập nhật',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          return const Center(
              child: CircularProgressIndicator(),
            );
          //getValue(snapshot.data!);
        });
  }
}