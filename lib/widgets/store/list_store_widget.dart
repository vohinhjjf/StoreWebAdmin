import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class ListStoreWidget extends StatefulWidget {
  @override
  _ListStoreWidgetState createState() => _ListStoreWidgetState();
}

class _ListStoreWidgetState extends State<ListStoreWidget> {
  final FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _services.location.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
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
                    borderRadius: BorderRadius.circular(13),
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
                      label: Text('Active/Inactive',textAlign: TextAlign.center),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/13,
                        child: Text('Name',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/4.8,
                        child: Text('Address',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/14,
                        child: Text('Longitude',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/14,
                        child: Text('Latitude',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: Text('Details'),
                    ),
                  ],
                  //details
                  rows: _storeDetailsRows(snapshot.data!, _services, context),
                ),
              ),
            );
          }
          else if(snapshot.hasError){
            return const Center (child: Text('Đã xảy ra sự cố'),);
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }

  List<DataRow> _storeDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services, BuildContext context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/14,
            child: IconButton(
              onPressed: () {
                services.activeStore(
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
            width: MediaQuery.of(context).size.width/13,
            child: Text(document['name'],textAlign: TextAlign.center,),
          ),
        ),
        //address
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/4.8,
            child: Text(document['address'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //longitude
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/14,
            child: Text(document['longitude'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //latitude
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/14,
            child: Text(document['latitude'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //Details
        DataCell(IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            //will popup vendor details screen
            /*showDialog(
                context: context,
                builder: (BuildContext context){
                  return ProductDetailsBox(document.id);
                }
            );*/
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
