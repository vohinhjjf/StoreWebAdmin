import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/firebase_services.dart';
import 'package:eshop_admin/services/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListDataOrderWidget extends StatefulWidget {
  final String uid;

  ListDataOrderWidget(this.uid,{super.key});
  @override
  _ListDataOrderWidgetState createState() => _ListDataOrderWidgetState();
}

class _ListDataOrderWidgetState extends State<ListDataOrderWidget> {
  final FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _services.users.doc(widget.uid).collection("purchase history").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            print(snapshot.data!.docs.length);
            return buildTableData(snapshot.data!);
          }
          else if(snapshot.hasError){
            return const Center (child: Text('Đã xảy ra sự cố'),);
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  Widget buildTableData(QuerySnapshot snapshot){
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
            borderRadius: BorderRadius.circular(13.5),
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
                width: MediaQuery.of(context).size.width/17,
                child: const Text('Tình trạng',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/9,
                child: const Text('Mã đơn hàng',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/13,
                child: const Text('Người nhận',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/18,
                child: const Text('Số lượng',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/13.5,
                child: const Text('Tổng tiền',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/13.5,
                child: const Text('Thời gian',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/13.5,
                child: const Text('Chi tiết',textAlign: TextAlign.center),
              ),
            ),
          ],
          //details
          rows: _storeDetailsRows(snapshot, _services, context),
        ),
      ),
    );
  }

  List<DataRow> _storeDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services, BuildContext context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/17,
            child: IconButton(
              onPressed: () {
                /*if(document['orderStatus']=="Đang xử lý")
                services.activePuschase(
                    uid: widget.uid,
                    id: document.id,
                    status: document['active']);*/
              },
              icon: document['orderStatus']=="Đang xử lý"
                  ? const Icon(
                Icons.remove_circle,
                color: Colors.grey,
              )
                  : document['orderStatus']=="Đơn đã hủy"
              ?const Icon(
                Icons.cancel,
                color: Colors.red,
              ):const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ),
        ),
        //Name
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/9,
            child: Text(document.id,textAlign: TextAlign.center,),
          ),
        ),
        //Number
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/13,
            child: Text(document['nameRecipient'].toString(),textAlign: TextAlign.center,),
          ),
        ),
        //address
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/18,
            child: FutureBuilder(
              future: _services.users.doc(widget.uid).collection("purchase history").doc(document.id).collection("products").get(),
              builder: (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                if(snapshot.hasData){
                  return Text(snapshot.data!.docs.length.toString(),textAlign: TextAlign.center);
                } else if(snapshot.hasError){
                  return Container();
                }
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
        //
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/13.5,
            child: Text(Format().currency(document['total'], decimal: false).replaceAll(RegExp(r','), '.'),textAlign: TextAlign.center),
          ),
        ),
        //
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/13.5,
            child: Text(document['orderDate'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //Details
        DataCell(
          SizedBox(
              width: MediaQuery.of(context).size.width/13.5,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  setState(() {
                    
                  });
                },
              )
          ),
        ),
      ]);
    }).toList();
    return newList;
  }
}