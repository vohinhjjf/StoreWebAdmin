import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference admin = FirebaseFirestore.instance.collection('Admin');
  CollectionReference banners = FirebaseFirestore.instance.collection('Banner');
  CollectionReference product =
      FirebaseFirestore.instance.collection('Products');
  CollectionReference cart = FirebaseFirestore.instance.collection('Cart');
  CollectionReference voucher =
      FirebaseFirestore.instance.collection('Voucher');
  CollectionReference location =
      FirebaseFirestore.instance.collection('Location');
  CollectionReference request =
      FirebaseFirestore.instance.collection('Request Support');
  CollectionReference blogs = FirebaseFirestore.instance.collection('Blogs');
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<DocumentSnapshot> getAdminCredentials(id) {
    var result = FirebaseFirestore.instance.collection('Admin').doc(id).get();
    return result;
  }

  //-------------------Upload and delete Banner to DB-------------------
  Future<String> uploadBannerImageToDb(String url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('Banner').add({
        'image': downloadUrl,
      });
    }
    return downloadUrl;
  }

  deleteBannerImageFromDb(id) async {
    firestore.collection('Banner').doc(id).delete();
  }
  //-------------------Upload and delete Banner to DB-------------------

  //-------------------Update Product-------------------------
  updateProductStatus({id, status}) async {
    product.doc(id).update({'active': status ? false : true});
  }

  updateHotProduct({id, status}) async {
    product.doc(id).update({'hot': status ? false : true});
  }

  updateFreeshipProduct({id, status}) async {
    product.doc(id).update({'freeship': status ? false : true});
  }

  updateDetailProduct({id, detail}) async {
    product.doc(id).update({'details': detail});
  }
  //-------------------Update Product-------------------------

  //-------------------Update Blog-------------------------
  updateBlogStatus({id, status}) async {
    blogs.doc(id).update({'active': status ? false : true});
  }

  updateHotBlog({id, status}) async {
    blogs.doc(id).update({'hot': status ? false : true});
  }

  updateContentBlog(
      {id,
      required String name,
      required String short,
      required String content}) async {
    blogs.doc(id).update({'name': name, 'short': short, 'content': content});
  }
  //-------------------Update Blog-------------------------

  //-------------------Voucher-------------------------
  Future addVoucher(String percentage, String discount, String name,
      String time, bool freeship, String point) async {
    return voucher.add({
      'active': true,
      'campaignId': '',
      'discountPercentage': double.parse(percentage),
      'freeship': freeship,
      'maxDiscount': double.parse(discount),
      'name': name,
      'time': int.parse(time),
      'exchangedPoint': int.parse(point),
    });
  }

  activeVoucher({id, status}) async {
    voucher.doc(id).update({'active': status ? false : true});
  }

  freeshipVoucher({id, status}) async {
    voucher.doc(id).update({'freeship': status ? false : true});
  }
  //-------------------Voucher-------------------------

  //-----------------Store -------------------
  addStore(
      String address, String longitude, String latitude, String name) async {
    location.add({
      'active': true,
      'address': address,
      'longitude': double.parse(longitude),
      'latitude': double.parse(latitude),
      'name': name,
    });
  }

  activeStore({id, status}) async {
    location.doc(id).update({'active': status ? false : true});
  }
  //-----------------Store -------------------

  //-------------------------Show dialog------------------------------
  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //người dùng phải nhấn vào button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
//-------------------------Show dialog------------------------------

//-------------------------Puschase------------------------------
  activePuschase({uid, id, status}) async {
    users.doc(uid).collection("purchase history").doc(id).update({'orderStatus': status});
  }
//-------------------------Puschase------------------------------
}
