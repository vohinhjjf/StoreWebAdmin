import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/format.dart';
import 'package:eshop_admin/widgets/product/product_details_box.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductTableState createState() => _ListProductTableState();
}

class _ListProductTableState extends State<ListProduct> {

  final FirebaseServices _services = FirebaseServices();

  int tag = 0;
  List<String> options = [
    'Giảm giá sốc',//0
    'Sản phẩm nổi bật',//1,
    'Điện thoại',//2
    'Laptop', //3
    'Máy tính bảng',//4
    'Đồng hồ thông minh',//5
    'PC - Lắp ráp',//6
    'Tai nghe',//7
  ];

  late var _stream =_services.product.where('discountPercentage',isGreaterThanOrEqualTo: 15)
      .snapshots();

  filter(val){
    if(val==0){
      setState(() {
        _stream = _services.product.where('discountPercentage',isGreaterThanOrEqualTo: 15)
            .snapshots();
      });
    }
    if(val==1){
      setState(() {
        _stream = _services.product.where('collection',isEqualTo: 'Sản phẩm nổi bật')
            .snapshots();
      });
    }
    if(val==2){
      setState(() {
        _stream = _services.product.where('category',isEqualTo: "Điện thoại")
            .snapshots();
      });
    }
    if(val==3){
      setState(() {
        _stream = _services.product.where('category',isEqualTo: "Laptop")
            .snapshots();
      });
    }
    if(val==4){
      setState(() {
        _stream = _services.product.where('category',isEqualTo: "Máy tính bảng")
            .snapshots();
      });
    }
    if(val==5){
      setState(() {
        _stream = _services.product.where('category',isEqualTo: "Đồng hồ thông minh")
            .snapshots();
      });
    }
    if(val==6){
      setState(() {
        _stream = _services.product.where('category',isEqualTo: "PC-Lắp ráp")
            .snapshots();
      });
    }
    if(val==7){
      setState(() {
        _stream = _services.product.where('category',isEqualTo: "Tai nghe")
            .snapshots();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: ShapeDecoration(
            shadows: [
              BoxShadow(color: Colors.grey)
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
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) {
                setState(() {
                  tag = val;
                });
                filter(val);
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
        ),
        SizedBox(height: 25,),
        StreamBuilder(
            stream: _stream,
            builder: (context,AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
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
                      side: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: DataTable(
                    showBottomBorder: true,
                    dataRowHeight: 60,
                    headingRowColor: MaterialStateProperty.all(Colors.grey[350]),
                    headingTextStyle: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 16),
                    //table headers
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Active/Inactive'),
                      ),
                      DataColumn(
                        label: Text('Product Name'),
                      ),
                      DataColumn(
                        label: Text('Sold'),
                      ),
                      DataColumn(
                        label: Text('Price'),
                      ),
                      DataColumn(
                        label: Text('Discount'),
                      ),
                      DataColumn(
                        label: Text('Hot', textAlign: TextAlign.center,),
                      ),
                      DataColumn(
                        label: Text('Freeship'),
                      ),
                      DataColumn(
                        label: Text('Details'),
                      ),
                    ],
                    //details
                    rows: _vendorDetailsRows(snapshot.data!, _services),
                  ),
                ),
              );
            }),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/15,
            child: IconButton(
              onPressed: () {
                services.updateProductStatus(
                  id: document.id,
                  status: document['active']);
              },
              icon: document['active']
                  ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
                  : Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
            ),
          ),
        ),
        //Name
        DataCell(
          SizedBox(
            width: 250,
            child: Text(document['name']),
          ),
        ),
        //sold
        DataCell(
          Text(document['sold'].toString()),
        ),
        //Price
        DataCell(
            Text(Format().currency(document['price'], decimal: false).replaceAll(RegExp(r','), '.'))
        ),
        //Discount
        DataCell(
            Text("${document['discountPercentage']}%")
        ),
        //Hot
        DataCell(
          IconButton(
            onPressed: () {
              services.updateHotProduct(
                  id: document.id,
                  status: document['hot']);
            },
            icon: document['hot']
                ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
                : Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
          ),
        ),
        //Freeship
        DataCell(
          IconButton(
            onPressed: () {
              services.updateFreeshipProduct(
                  id: document.id,
                  status: document['freeship']);
            },
            icon: document['freeship']
                ? Icon(
              Icons.check_circle,
              color: Colors.green,
            )
                : Icon(
              Icons.remove_circle,
              color: Colors.red,
            ),
          ),
        ),
        //Details
        DataCell(IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            //will popup vendor details screen
            showDialog(
                context: context,
                builder: (BuildContext context){
                  return ProductDetailsBox(document.id);
                }
            );
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
