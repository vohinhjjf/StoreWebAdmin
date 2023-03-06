import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category-screen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh mục',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            Text('Thêm danh mục mới và danh mục phụ'),
            Divider(thickness: 5,),
            //CategoryCreateWidget(),
            Divider(thickness: 5,),
            //CategoryListWidget(),
          ],
        ),
      ),
    );
  }
}
