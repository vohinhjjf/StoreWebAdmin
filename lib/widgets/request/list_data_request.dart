import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/firebase_services.dart';
import 'package:eshop_admin/widgets/request/request_detail_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListDataRequestWidget extends StatefulWidget {
  String select;

  ListDataRequestWidget(this.select,{super.key});
  @override
  _ListDataRequestWidgetState createState() => _ListDataRequestWidgetState();
}

class _ListDataRequestWidgetState extends State<ListDataRequestWidget> {
  final FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: widget.select=="all"
            ?_services.request.snapshots()
            :_services.request.where("senderId",isEqualTo: widget.select).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            print(snapshot.data!.docs.length);
            return buildTableData(snapshot.data!);
          }
          else if(snapshot.hasError){
            return Center (child: Text('Đã xảy ra sự cố'),);
          }
          return Center(child: CircularProgressIndicator(),);
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
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: DataTable(
          showBottomBorder: true,
          dataRowHeight: 60,
          headingRowColor: MaterialStateProperty.all(Colors.grey[350]),
          headingTextStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black, fontSize: 16),
          //table headers
          columns: <DataColumn>[
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/8.5,
                child: Text('ID',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/8.5,
                child: Text('Người gửi',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/8.5,
                child: Text('Vấn đề',textAlign: TextAlign.center),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/8.5,
                child: Text('Thời gian',textAlign: TextAlign.center),
              ),

            ),
            DataColumn(
              label: SizedBox(
                width: MediaQuery.of(context).size.width/8.5,
                child: Text('Chi tiết',textAlign: TextAlign.center),
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
        //ID
        DataCell(
          Text(document.id,textAlign: TextAlign.center,),
        ),
        //Name
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/8.5,
            child: Text(document['senderName'].toString(),textAlign: TextAlign.center,),
          ),
        ),
        //problem
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/8.5,
            child: Text(document['problemType'],textAlign: TextAlign.center,),
          ),
        ),
        //address
        DataCell(
          Text(document['timestamp'].toString(),textAlign: TextAlign.center,),
        ),
        //Details
        DataCell(
            SizedBox(
              width: MediaQuery.of(context).size.width/8.5,
              child: IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  //will popup vendor details screen
                  showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return RequestDetailsBox(document.id);
                    }
                  );
                },
              )
            ),
          ),
      ]);
    }).toList();
    return newList;
  }
}