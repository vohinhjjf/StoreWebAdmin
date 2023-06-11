import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_admin/Model/chat_message_model.dart';
import 'package:eshop_admin/widgets/chat/loading_view_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../data/utilities.dart';
import '../services/firebase_services.dart';
import '../widgets/chat/provider/Chatprovider.dart';

class ChatWidget extends StatefulWidget {
  static const String id = 'chat-screen';

  const ChatWidget({super.key});
  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with SingleTickerProviderStateMixin {
  final FirebaseServices _services = FirebaseServices();
  final _search = TextEditingController();
  final TextEditingController textEditingController = TextEditingController();
  StreamController<bool> btnClearController = StreamController<bool>();
  int temp = 0;
  final ScrollController listScrollController = ScrollController();
  List<QueryDocumentSnapshot> listMessage = [];
  String groupChatId = "";
  String currentUserId = 'Admin';
  bool isLoading = false;
  bool isShowSticker = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _services.users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

  Widget buildUI(BuildContext context, List data) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 5,
            child: Card(
              shadowColor: Colors.grey,
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Đoạn Chat",
                      style: TextStyle(
                          color: mTitleColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.search,
                              color: Colors.white, size: 20),
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
                                hintStyle: TextStyle(
                                    fontSize: 13, color: Colors.white),
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
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: data.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (context, index) =>
                                  buildItem(context, data[index], index),
                              itemCount: data.length,
                              //controller: listScrollController,
                            )
                          : const Center(
                              child: Text("No users"),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: Card(
              shadowColor: Colors.grey,
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade300, width: 0.5)),
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
                                  errorWidget: (context, url, error) =>
                                      const Icon(
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
                                    const Text(
                                      "Hoạt động 5 phút trước",
                                      style: TextStyle(
                                          color: mTitleColor, fontSize: 14),
                                    ),
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
                                onPressed: () {},
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: groupChatId.isNotEmpty
                          ? StreamBuilder<QuerySnapshot>(
                              stream: _services.getChatStream(groupChatId, 100),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  listMessage = snapshot.data!.docs;
                                  if (listMessage.isNotEmpty) {
                                    return ListView.builder(
                                      padding: const EdgeInsets.all(10),
                                      itemBuilder: (context, index) =>
                                          buildBubble(index,
                                              snapshot.data?.docs[index], data),
                                      itemCount: snapshot.data?.docs.length,
                                      reverse: true,
                                      controller: listScrollController,
                                    );
                                  } else {
                                    return const Center(
                                        child: Text("No message here yet..."));
                                  }
                                } else {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  );
                                }
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                    ),
                    isShowSticker
                        ? buildSticker(data[temp]['id'])
                        : const SizedBox.shrink(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: buildInput(context, data),
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
              groupChatId = '$currentUserId-${document.id}';
              temp = index;
            });
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade100),
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
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
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
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 17),
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

  Widget buildInput(BuildContext context, List data) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
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
                onPressed: () {
                  uploadToStorage(data[temp]['id']);
                },
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
                onPressed: () {
                  setState(() {
                    isShowSticker = !isShowSticker;
                  });
                },
                color: Colors.blue,
              ),
            ),
          ),

          // Edit text
          Flexible(
            child: TextField(
              onSubmitted: (value) {
                onSendMessage(textEditingController.text, TypeMessage.text,
                    data[temp]['id']);
              },
              style: const TextStyle(color: Colors.blue, fontSize: 15),
              controller: textEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              //focusNode: focusNode,
            ),
          ),

          // Button send message
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  onSendMessage(textEditingController.text, TypeMessage.text,
                      data[temp]['id']);
                },
                //onSendMessage(textEditingController.text, TypeMessage.text),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBubble(int index, DocumentSnapshot? document, List data) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // Right (my message)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            messageChat.type == TypeMessage.text
                // Text
                ? Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                    child: Text(
                      messageChat.content,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  )
                : messageChat.type == TypeMessage.image
                    // Image
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(0))),
                          child: Material(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              messageChat.content,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  width: 200,
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    // Sticker
                    : Container(
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20 : 10,
                            right: 10),
                        child: Image.asset(
                          'images/${messageChat.content}.gif',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
          ],
        );
      } else {
        // Left (peer message)
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            data[temp]['image'],
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Colors.grey.shade100,
                              );
                            },
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(width: 35),
                  messageChat.type == TypeMessage.text
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            messageChat.content,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : messageChat.type == TypeMessage.image
                          ? Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(0))),
                                child: Material(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    messageChat.content,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) =>
                                            Material(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  bottom: isLastMessageRight(index) ? 20 : 10,
                                  right: 10),
                              child: Image.asset(
                                'images/${messageChat.content}.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 50, top: 5, bottom: 5),
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(messageChat.timestamp))),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildSticker(String peerId) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(5),
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi1', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi1.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi2', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi2.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi3', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi3.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi4', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi4.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi5', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi5.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi6', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi6.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi7', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi7.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi8', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi8.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      onSendMessage('mimi9', TypeMessage.sticker, peerId),
                  child: Image.asset(
                    'images/mimi9.gif',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const LoadingView() : const SizedBox.shrink(),
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSendMessage(String content, int type, String peerId) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      _services.sendMessage(content, type, groupChatId, currentUserId, peerId);
      listScrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      // Fluttertoast.showToast(
      //     msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  void readLocal(String peerId) {
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
  }

  uploadToStorage(String peerId) {
    String downloadUrl = '';
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      final path = 'Admin/$dateTime';
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child(path).putBlob(file);
        String url = await snapshot.ref.getDownloadURL();
        setState(() {
          downloadUrl = url;
        });
        try {
          setState(() {
            onSendMessage(downloadUrl, TypeMessage.image, peerId);
          });
        } on FirebaseException {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  // Future uploadFile() async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   UploadTask uploadTask = _services.uploadFile(imageFile!, fileName);
  //   try {
  //     TaskSnapshot snapshot = await uploadTask;
  //     imageUrl = await snapshot.ref.getDownloadURL();
  //     setState(() {
  //       isLoading = false;
  //       onSendMessage(imageUrl, TypeMessage.image);
  //     });
  //   } on FirebaseException catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(msg: e.message ?? e.toString());
  //   }
  // }
}
