import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/constants.dart';
import 'package:eshop_admin/widgets/order/list_data_order.dart';
import 'package:eshop_admin/widgets/request/list_data_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class UserDetailWidget extends StatefulWidget {
  final String uid;
  void Function()? onPressed;

  UserDetailWidget(this.uid, this.onPressed,{super.key});

  @override
  _UserDetailWidgetState createState() => _UserDetailWidgetState();
}

class _UserDetailWidgetState extends State<UserDetailWidget> with SingleTickerProviderStateMixin{
  FirebaseServices _services = FirebaseServices();
  late TabController _tabController;

  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  final _tabs = const [
    Tab(text: 'Thông tin cá nhân', icon: Icon(Icons.perm_contact_cal_rounded),iconMargin: EdgeInsets.zero,),
    Tab(text: 'Đơn hàng', icon: Icon(Icons.shopping_cart),iconMargin: EdgeInsets.zero),
    Tab(text: 'Yêu cầu', icon: Icon(Icons.request_page),iconMargin: EdgeInsets.zero),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _services.users.doc(widget.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: buildDetail(snapshot.data!)),
                  Expanded(
                    flex: 2,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/3,
                              child: Card(
                                shadowColor: Colors.grey,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10,),
                                      const Text("Thông tin cá nhân", style: TextStyle(color: mText, fontSize: 18, fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 10,),
                                      const Text("Hi, I’m Alec Thompson, Decisions: If you can’t decide, the answer is no. If two equally difficult paths, choose the one more painful in the short term (pain avoidance is creating an illusion of equality)."),
                                      const SizedBox(height: 20,),
                                      Row(
                                        children: [
                                          const Text("Họ và tên: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!["name"], style: const TextStyle( fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          const Text("Ngày sinh: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!["birthday"], style: const TextStyle( fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          const Text("Số điện thoại: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!["number"], style: const TextStyle( fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          const Text("Email: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!["email"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          const Text("Địa chỉ: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!["address"], style: const TextStyle( fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        children: [
                                          const Text("ID: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          Text(snapshot.data!["id"], style: const TextStyle( fontSize: 16, fontWeight: FontWeight.normal),),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Liên kết: ", style: TextStyle(color: mText, fontSize: 16, fontWeight: FontWeight.bold),),
                                          IconButton(
                                            iconSize: 30,
                                            icon: const Image(
                                              image: AssetImage("images/facebook.png"),
                                            ),
                                            onPressed: () {
                                              // do something when the button is pressed
                                              debugPrint('Hi there');
                                            },
                                          ),
                                          IconButton(
                                            iconSize: 30,
                                            icon: const Image(
                                              image: AssetImage("images/twitter.png"),
                                            ),
                                            onPressed: () {
                                              // do something when the button is pressed
                                              debugPrint('Hi there');
                                            },
                                          ),
                                          IconButton(
                                            iconSize: 30,
                                            icon: const Image(
                                              image: AssetImage("images/instagram.png"),
                                            ),
                                            onPressed: () {
                                              // do something when the button is pressed
                                              debugPrint('Hi there');
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width/2.25,
                              child: Card(
                                shadowColor: Colors.grey,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10,),
                                      const Text("Địa chỉ giao hàng", style: TextStyle(color: mText, fontSize: 18, fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        height: 350,
                                        child: FutureBuilder(
                                          future: _services.users.doc(widget.uid).collection('address').get(),
                                          builder: (BuildContext context1, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                                            if(snapshot.hasData){
                                              if (snapshot.data!.size==0) {
                                                return Container();
                                              }
                                              return BuildList(snapshot.data!);
                                            }
                                            else if(snapshot.hasError){
                                              return Text(snapshot.error.toString());
                                            }
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shadowColor: Colors.grey,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  const Text("Danh sách đơn hàng", style: TextStyle(color: mText, fontSize: 18, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 350,
                                    child: ListDataOrderWidget(widget.uid),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shadowColor: Colors.grey,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10,),
                                  const Text("Danh sách yêu cầu", style: TextStyle(color: mText, fontSize: 18, fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 10,),
                                  SizedBox(
                                    height: 350,
                                    child: ListDataRequestWidget(widget.uid),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,)
                ],
              ),
            ),
          );
        });
  }
  Widget buildDetail(DocumentSnapshot document) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: const AssetImage("images/green.jpg"),
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(left: 20),
          child: SizedBox(
            width: 450,
            height: 150,
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: document['image']==""?const AssetImage("images/user1.png")as ImageProvider:NetworkImage(document['image'])
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      document["name"],
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ]
            )
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.only(right: 20, bottom: 60),
          child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width/3,
            child: TabBar(
              controller: _tabController,
              tabs: _tabs,
              unselectedLabelColor: Colors.black,
              labelColor: _selectedColor,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(80.0),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 15,top: 10),
          child: TextButton.icon(
            onPressed: widget.onPressed,
            icon: const Icon( // <-- Icon
              Icons.arrow_back_ios_outlined,
              size: 24.0,
              color: mText,
            ),
            label: const Text("Quay lại", style: TextStyle(color: mText, fontSize: 18),), // <-- Text
          ),
        ),
      ],
    );
  }

  BuildList(QuerySnapshot snapshot){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        return ItemInfo(context,snapshot.docs[index]);
      },
    );
  }

  Widget ItemInfo(BuildContext context,QueryDocumentSnapshot document) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      //margin: EdgeInsets.fromLTRB(5, space_height, 5, 0),
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                        document["loai_dia_chi"]=="Văn phòng"?'images/location.png':'images/home.png',
                        height: 50,
                    ),

                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              document["name"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                              const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 10,),
                            Text(
                              document["number"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                              const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                            const SizedBox(width: 10,),
                            document["mac_dinh"]?Container(
                              decoration: const ShapeDecoration(
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                              ),
                              child: const Text(
                                "MẶC ĐỊNH",
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red
                                ),
                              ),
                            ):Container(),
                          ],
                        ),
                        Text(
                          document["address"],
                          style:
                          const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        Text(
                          "${document["xa"]}, ${document["huyen"]}, ${document["tinh"]}",
                          style:
                          const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ]
            ),

          )
      ),
    );
  }
}


