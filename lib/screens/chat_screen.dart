import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';
import '../data/utilities.dart';
import '../services/firebase_services.dart';
import '../widgets/chat/provider/MessageProvider.dart';

class ChatWidget extends StatefulWidget {
  static const String id = 'chat-screen';
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> with SingleTickerProviderStateMixin{
  final FirebaseServices _services = FirebaseServices();
  var _search = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  StreamController<bool> btnClearController = StreamController<bool>();
  int temp = 0;
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _services.users.snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return buildUI(context, snapshot.data!.docs);
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }
      },
    );
  }
  Widget buildUI(BuildContext context, List data){
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width/5,
            child: Card(
              shadowColor: Colors.grey,
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    const Text("Đoạn Chat", style: TextStyle(color: mTitleColor, fontSize: 20, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.lightBlueAccent.withAlpha(180),
                      ),
                      //padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      //margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5,),
                          const Icon(Icons.search, color: Colors.white, size: 20),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.search,
                              controller: _search,
                              onChanged: (value) {
                                /* searchDebouncer.run(() {
                                if (value.isNotEmpty) {
                                  btnClearController.add(true);
                                  setState(() {
                                    _textSearch = value;
                                  });
                                } else {
                                  btnClearController.add(false);
                                  setState(() {
                                    _textSearch = "";
                                  });
                                }
                              });*/
                              },
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Tìm kiếm',
                                hintStyle:
                                TextStyle(fontSize: 13, color: Colors.white),
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          StreamBuilder<bool>(
                              stream: btnClearController.stream,
                              builder: (context, snapshot) {
                                return snapshot.data == true
                                    ? GestureDetector(
                                    onTap: () {
                                      _search.clear();
                                      btnClearController.add(false);
                                      setState(() {
                                        _search.text = "";
                                      });
                                    },
                                    child: const Icon(Icons.clear_rounded,
                                        color: Colors.white, size: 20))
                                    : const SizedBox.shrink();
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Expanded(
                      child: data.isNotEmpty
                          ? ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context, index) => buildItem(
                                context, data[index], index),
                            itemCount: data.length,
                            //controller: listScrollController,
                          )
                          :const Center(
                        child: Text("No users"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width/1.8,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300, width: 0.5)),
                          color: Colors.white10),
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: data[temp]['image'],
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.account_circle_rounded,
                                    size: 50,
                                  ),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        data[temp]['name'],
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const Text("Hoạt động 5 phút trước",
                                      style: TextStyle(color: mTitleColor, fontSize: 14),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Material(
                            color: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              child: IconButton(
                                icon: const Icon(Icons.more_vert_outlined),
                                onPressed: (){},
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: buildInput(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(
      BuildContext context, DocumentSnapshot? document, int index) {
    if (document != null) {
      return Container(
        height: 65,
        margin: const EdgeInsets.only(bottom: 15, left: 5, right: 5),
        child: TextButton(
          onPressed: () {
            if (Utilities.isKeyboardShowing()) {
              Utilities.closeKeyboard(context);
            }
            setState(() {
              temp = index;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.grey.shade100),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: document['image'],
                  progressIndicatorBuilder:
                      (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.account_circle_rounded,
                    size: 50,
                  ),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          document['name'],
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: (){},
                color: Colors.blue,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.face),
                onPressed: (){},
                color: Colors.blue,
              ),
            ),
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  //onSendMessage(textEditingController.text, TypeMessage.text);
                },
                style: const TextStyle(
                    color: Colors.blue, fontSize: 15),
                controller: textEditingController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                //focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {},
                    //onSendMessage(textEditingController.text, TypeMessage.text),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}