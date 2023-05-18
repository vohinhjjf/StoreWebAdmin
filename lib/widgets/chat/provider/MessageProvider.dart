import 'package:cloud_firestore/cloud_firestore.dart';

class MessageProvider {
  final FirebaseFirestore firebaseFirestore;

  MessageProvider({required this.firebaseFirestore});

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(
      String pathCollection, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return FirebaseFirestore.instance
          .collection(pathCollection)
          .limit(limit)
          .where("name", isEqualTo: textSearch)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection(pathCollection)
          .limit(limit)
          .snapshots();
    }
  }

  Future<String> getCustomerName(String textValue) async {
    var customer = FirebaseFirestore.instance.collection('Users');
    final list_id = <String>[];
    var id_customer, name;
    QuerySnapshot id = await customer.get();
    id.docs.forEach((doc) {
      list_id.add(doc.id);
    });
    for (int i = 0; i < list_id.length; i++) {
      final docSnapshot = await customer.doc(list_id[i]).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        name = data['information']['name'];
        if (textValue == name) {
          id_customer = list_id[i];
        }
      }
    }
    var docSnapshotreceiver = await customer.doc(id_customer).get();
    if (docSnapshotreceiver.exists) {
      return "";
    }
    return "";
  }

  // getLastMessage(String adminID, String userID) {
  //   String id = "$userID-$adminID", content = "";
  //   MessageChat messagechat =
  //       MessageChat(content: '', idFrom: '', idTo: '', timestamp: '', type: 0);
  //   final id_message = <String>[];
  //   QuerySnapshot doc =  FirebaseFirestore.instance
  //       .collection('message')
  //       .doc(id)
  //       .collection(id)
  //       .get() as QuerySnapshot<Object?>;
  //   doc.docs.forEach((doc) {
  //     id_message.add(doc.id);
  //   });
  //   var docSnapshot =  FirebaseFirestore.instance
  //       .collection('message')
  //       .doc(id)
  //       .collection(id)
  //       .doc(id_message[id_message.length - 1])
  //       .get();
  //     messagechat = MessageChat.fromDocument();
  //   return messagechat.content;
  // }
}
