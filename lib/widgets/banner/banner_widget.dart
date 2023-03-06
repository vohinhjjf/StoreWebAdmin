import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eshop_admin/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class BannerWidget extends StatelessWidget {
  final FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*.7,
      child: StreamBuilder(
        stream: _services.banners.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 200,
                ),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return Item(context, document);
                }).toList()
            );
          }
          else if(snapshot.hasError){}
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }

  Widget Item(BuildContext context, DocumentSnapshot document){
    SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(
      context: context,
      barrierDimisable:  false,
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: Card(
              margin: EdgeInsets.all(5),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(document['image']),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: (){
                  dialog.show(message: 'Loading...');
                  _services.banners.doc(document.id).delete().then((value) {
                    dialog.hide();
                  });
                },
                icon: const Icon(Icons.delete,color: Colors.red,),
              ),
            ),
          )
        ],
      ),
    );
  }
}


