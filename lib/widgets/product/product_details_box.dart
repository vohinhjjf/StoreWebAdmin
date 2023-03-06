import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:eshop_admin/services/firebase_services.dart';

class ProductDetailsBox extends StatefulWidget {
  final String uid;

  ProductDetailsBox(this.uid);

  @override
  _ProductDetailsBoxState createState() => _ProductDetailsBoxState();
}

class _ProductDetailsBoxState extends State<ProductDetailsBox> {
  FirebaseServices _services = FirebaseServices();
  var _detail = TextEditingController();
  GlobalKey<FormState>  _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _services.product.doc(widget.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          _detail.text = snapshot.data!['details'];
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          height: MediaQuery.of(context).size.height-140,
                          width: MediaQuery.of(context).size.width * .3,
                          child: ListView(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  snapshot.data!['image'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data!['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '${Format().currency(snapshot.data!['price']*(100-snapshot.data!['discountPercentage'])/100, decimal: false).replaceAll(RegExp(r','), '.')}đ',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              if (snapshot.data!['discountPercentage'] != 0) Row(
                                children: [
                                  Text(
                                    '${Format().currency(snapshot.data!['price'], decimal: false).replaceAll(RegExp(r','), '.')}đ',
                                    softWrap: true,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(
                                    "${snapshot.data!['discountPercentage']}%",
                                    style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Divider(
                                thickness: 4,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Mô tả sản phẩm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _detail,
                                maxLines : 10,
                                decoration: const InputDecoration(),
                                // Only numbers can be entered
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Vui lòng nhập thông tin sản phẩm';
                                  }
                                  else if(value.length <= 3){
                                    return 'Vui lòng nhập trên 3 kí tự';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: snapshot.data!['active']
                            ? Chip(
                          backgroundColor: Colors.green,
                          label: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
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
                              Icon(
                                Icons.remove_circle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
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
                    onTap: () async {
                      if(_formKey.currentState!.validate()) {
                        await showDialog(
                            context: context,
                            builder: (context) =>
                            FutureProgressDialog(_services.updateDetailProduct(
                                id: snapshot.data!.id,
                                detail: _detail.text
                              ), message: Text('Loading...')
                            ),
                        );
                        Navigator.of(context, rootNavigator: true).pop();
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
          );
        });
  }
}
