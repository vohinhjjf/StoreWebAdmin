import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eshop_admin/services/firebase_services.dart';

import 'edit_blog_widget.dart';

class ListBlog extends StatefulWidget {
  @override
  _ListBlogTableState createState() => _ListBlogTableState();
}

class _ListBlogTableState extends State<ListBlog> {
  final FirebaseServices _services = FirebaseServices();

  int tag = 0;
  List<String> options = [
    'Tất cả', //0
    'Đồ công nghệ', //1,
    'Game', //2
    'Thủ thuật - Hướng dẫn', //3
    'Giải trí', //4
    'Coding', //5
    'Chưa kích hoạt', //6
  ];

  late var _stream =
      _services.blogs.where('Author', isEqualTo: 'Admin').snapshots();

  filter(val) {
    switch (val) {
      case 0:
        {
          setState(() {
            _stream =
                _services.blogs.where('Author', isEqualTo: 'Admin').snapshots();
          });
          break;
        }
      case 1:
        {
          setState(() {
            _stream = _services.blogs
                .where('category', isEqualTo: 'Đồ công nghệ')
                .snapshots();
          });
          break;
        }
      case 2:
        {
          setState(() {
            _stream = _services.blogs
                .where('category', isEqualTo: 'Game')
                .snapshots();
          });
          break;
        }
      case 3:
        {
          setState(() {
            _stream = _services.blogs
                .where('category', isEqualTo: 'Thủ thuật - Hướng dẫn')
                .snapshots();
          });
          break;
        }
      case 4:
        {
          setState(() {
            _stream = _services.blogs
                .where('category', isEqualTo: 'Giải trí')
                .snapshots();
          });
          break;
        }
      case 5:
        {
          setState(() {
            _stream = _services.blogs
                .where('category', isEqualTo: 'Coding')
                .snapshots();
          });
          break;
        }
      case 6:
        {
          setState(() {
            _stream =
                _services.blogs.where('active', isEqualTo: false).snapshots();
          });
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: ShapeDecoration(
            shadows: const [BoxShadow(color: Colors.grey)],
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) {
                setState(() {
                  tag = val;
                });
                filter(val);
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        StreamBuilder(
            stream: _stream,
            builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: ShapeDecoration(
                    shadows: const [BoxShadow(color: Colors.grey)],
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: DataTable(
                    showBottomBorder: true,
                    dataRowHeight: 60,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.grey[350]),
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                    //table headers
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text('Active/Inactive'),
                      ),
                      DataColumn(
                        label: Text('Tiêu đề'),
                      ),
                      DataColumn(
                        label: Text('Tóm tắt'),
                      ),
                      DataColumn(
                        label: Text('Ngày đăng'),
                      ),
                      DataColumn(
                        label: Text('Tác giả'),
                      ),
                      DataColumn(
                        label: Text(
                          'Hot',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DataColumn(
                        label: Text('Thumbnail'),
                      ),
                      DataColumn(
                        label: Text('Edit'),
                      ),
                    ],
                    //details
                    rows: _vendorDetailsRows(snapshot.data!, _services),
                  ),
                ),
              );
            }),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(cells: [
        DataCell(
          SizedBox(
            width: MediaQuery.of(context).size.width / 15,
            child: IconButton(
              onPressed: () {
                services.updateBlogStatus(
                    id: document.id, status: document['active']);
              },
              icon: document['active']
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
            ),
          ),
        ),
        //Name
        DataCell(
          SizedBox(
            width: 100,
            child: Text(document['name']),
          ),
        ),
        DataCell(
          SizedBox(width: 150, child: Text(document['short'])),
        ),

        DataCell(
          Text(document['time']),
        ),
        DataCell(
          Text(document['Author']),
        ),
        //Hot
        DataCell(
          IconButton(
            onPressed: () {
              services.updateHotBlog(id: document.id, status: document['hot']);
            },
            icon: document['hot']
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 50,
            child: Image(
              image: NetworkImage(document['image']),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, child, errorProgress) => const Center(
                child: Text(
                  'Image not found',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
        //Details
        DataCell(IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            //will popup vendor details screen
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditBlogBox(document.id);
                });
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
