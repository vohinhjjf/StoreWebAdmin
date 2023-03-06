import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class RequestDetailsBox extends StatefulWidget {
  final String uid;

  const RequestDetailsBox(this.uid);

  @override
  _RequestDetailsBoxState createState() => _RequestDetailsBoxState();
}

class _RequestDetailsBoxState extends State<RequestDetailsBox> {
  final FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _services.request.doc(widget.uid).get(),
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
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height-140,
                        width: MediaQuery.of(context).size.width * .3,
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            Text(
                              "Loại vấn đề: "+snapshot.data!['problemType'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 4,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Mô tả chi tiết",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54)
                              ),
                              child: Text(snapshot.data!["description"]),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              thickness: 4,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Hình ảnh",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                snapshot.data!['photo'],
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: snapshot.data!['isActive'] =="true"
                            ? Chip(
                          backgroundColor: Colors.green,
                          label: Row(
                            children: [
                              const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Text(
                                'Active',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
                            : Chip(
                          backgroundColor: Colors.red,
                          label: Row(
                            children: [
                              const Icon(
                                Icons.remove_circle,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Text(
                                'Inactive',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
                          'Đóng',
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
          );
        });
  }
}