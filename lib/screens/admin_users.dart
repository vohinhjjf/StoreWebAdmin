import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/firebase_services.dart';
import 'package:eshop_admin/widgets/admin_users/user_detail_widget.dart';
import 'package:flutter/material.dart';


class AdminUsers extends StatefulWidget {
  static const String id = 'admin-user';
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  final FirebaseServices _services = FirebaseServices();
  String userId="";
  bool show = false;

  @override
  Widget build(BuildContext context) {

    return show==false?DefaultTabController(
        initialIndex: 0,  //optional, starts from 0, select the tab by default
        length:2,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(30),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment : CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quản lý tài khoản',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(height: 25,),
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.black54,
                    tabs: const [
                      Tab(text: 'NGƯỜI DÙNG',),
                      Tab(text: 'ADMIN',),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UserWidget(),
                      const Center(child: Text('Admin Page'),),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    ): UserDetailWidget(userId, () {
      setState(() {
        show = false;
      });
    },);
  }

  Widget UserWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _services.users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            print(snapshot.data!.docs.length);
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
                    borderRadius: BorderRadius.circular(12),
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
                        width: MediaQuery.of(context).size.width/12,
                        child: const Text('Tên',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/12,
                        child: const Text('Số điện thoại',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/9,
                        child: const Text('Address',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/9,
                        child: const Text('Email',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/12,
                        child: const Text('Ngày sinh',textAlign: TextAlign.center),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: MediaQuery.of(context).size.width/12,
                        child: const Text('Chi tiết',textAlign: TextAlign.center),
                      ),
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
        /*DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/11,
            child: document['image']==""
                ?Image(image: AssetImage("images/user.jfif"), width: 60,height: 60)
                :Image.network(document['image'], width: 60,height: 60,),
          ),
        ),*/
        //Name
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/12,
            child: Text(document['name'],textAlign: TextAlign.center,),
          ),
        ),
        //Number
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/12,
            child: Text(document['number'].toString(),textAlign: TextAlign.center,),
          ),
        ),
        //address
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/9,
            child: Text(document['address'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //email
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/9,
            child: Text(document['email'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //birthday
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width/12,
            child: Text(document['birthday'].toString(),textAlign: TextAlign.center),
          ),
        ),
        //Details
        DataCell(
          SizedBox(
              width: MediaQuery.of(context).size.width/12,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  setState(() {
                    userId = document.id;
                    show = true;
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
