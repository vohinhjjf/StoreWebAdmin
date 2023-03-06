import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/format.dart';
import 'package:eshop_admin/widgets/voucher/voucher_detail_box.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class ListVoucher extends StatefulWidget {
  @override
  _ListVoucherState createState() => _ListVoucherState();
}
enum HeadBase { freeship, coupon }
class _ListVoucherState extends State<ListVoucher> {
  final FirebaseServices _services = FirebaseServices();
  bool status = false;
  HeadBase? _status = HeadBase.coupon;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _services.voucher.snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: ShapeDecoration(
                shadows: const [
                  BoxShadow(color: Colors.grey)
                ],
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[350]),
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 16),
                //table headers
                columns: <DataColumn>[
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width/13,
                      child: const Text('Active/Inactive',textAlign: TextAlign.center),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width/13,
                      child: const Text('Khuyến mãi',textAlign: TextAlign.center),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width/15,
                      child: const Text('Giảm giá',textAlign: TextAlign.center),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width/14,
                      child: const Text('Giảm tối đa',textAlign: TextAlign.center),
                    ),
                  ),
                  const DataColumn(
                    label: Text('Freeship/Coupons'),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width/16,
                      child: const Text('Thời gian',textAlign: TextAlign.center),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: MediaQuery.of(context).size.width/16,
                      child: Text('Chi tiết',textAlign: TextAlign.center),
                    ),
                  ),
                ],
                //details
                rows: _voucherDetailsRows(snapshot.data!, _services),
              ),
            ),
          );
        });
  }

  List<DataRow> _voucherDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(
          onLongPress: (){
            print(document.id);
          },
          cells: [
            DataCell(
              SizedBox(
                width: MediaQuery.of(context).size.width/13,
                child: IconButton(
                  onPressed: () {
                    services.activeVoucher(
                      id: document.id,
                      status: document['active']);
                  },
                  icon: document['active']
                      ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                      : const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            //Name
            DataCell(
              SizedBox(
                width: MediaQuery.of(context).size.width/13,
                child: Text(document['name'],textAlign: TextAlign.center,),
              ),
            ),
            //Discount
            DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width/15,
                  child: Text("${document['discountPercentage'].toString()}%",textAlign: TextAlign.center),
                ),
            ),
            //Max
            DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width/14,
                  child: Text(Format().currency(document['maxDiscount'], decimal: false).replaceAll(RegExp(r','), '.')+"k",textAlign: TextAlign.center),
                ),
            ),
            //Freeship
            DataCell(
              SizedBox(
                width: MediaQuery.of(context).size.width/14,
                child: IconButton(
                  onPressed: () {
                  },
                  icon: document['freeship']
                      ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                      : const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            //Max
            DataCell(
                SizedBox(
                  width: MediaQuery.of(context).size.width/16,
                  child: Text("${document['time']} ngày",textAlign: TextAlign.center),
                ),
            ),
            //Details
            DataCell(
              SizedBox(
                  width: MediaQuery.of(context).size.width/16,
                  child: IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      //will popup vendor details screen
                      _showUpdateDialog(
                          document.id,
                          document["name"].toString(),
                          document["discountPercentage"].toString(),
                          document["maxDiscount"].toString(),
                          document["time"].toString(),
                          document["freeship"]);
                    },
                  )
              ),
            ),
      ]);
    }).toList();
    return newList;
  }

  _showUpdateDialog(String id, String name, String discount, String maxDiscount, String time, bool freeship){
    GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
    var _txtName = TextEditingController();
    var _txtDiscount = TextEditingController();
    var _txtMaxDiscount = TextEditingController();
    var _txtTime = TextEditingController();
    _txtName.text = name;
    _txtDiscount.text = discount;
    _txtMaxDiscount.text = maxDiscount;
    _txtTime.text = time;
    if(freeship){
      _status = HeadBase.freeship;
    } else {
      _status = HeadBase.coupon;
    }
    showDialog(
        context: context,
        builder: (BuildContext context){
          return FutureBuilder(
              future: _services.voucher.doc(id).get(),
              builder:
                  (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData){
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
                                              freeship = !freeship;
                                              Navigator.of(context).pop();
                                              _showUpdateDialog(id,_txtName.text,_txtDiscount.text,_txtMaxDiscount.text,_txtTime.text, freeship);
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
                                              freeship = !freeship;
                                              Navigator.of(context).pop();
                                              _showUpdateDialog(id,_txtName.text,_txtDiscount.text,_txtMaxDiscount.text,_txtTime.text, freeship);
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
                                        onChanged: (value){
                                          _txtName.text = "Giảm ${value}%";
                                        },
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
                                    onChanged: (value){
                                      if(freeship){
                                        _txtName.text = "Giảm ${value}k";
                                      }
                                    },
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
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    _services.voucher.doc(id).update({
                                      'active':true,
                                      'name': _txtName.text,
                                      'discountPercentage': double.parse(_txtDiscount.text),
                                      "freeship":freeship,
                                      "maxDiscount":double.parse(_txtMaxDiscount.text),
                                      "time": int.parse(_txtTime.text)
                                    }).then((value) {
                                      Navigator.of(context).pop();
                                    });
                                  });
                                }
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
    );
  }
}
