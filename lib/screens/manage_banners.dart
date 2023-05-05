import 'package:eshop_admin/widgets/banner/banner_upload_widget.dart';
import 'package:eshop_admin/widgets/banner/banner_widget.dart';
import 'package:flutter/material.dart';

class BannerScreen extends StatefulWidget {
  static const String id = 'banner-screen';

  const BannerScreen({super.key});
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quản lý hình ảnh quảng cáo',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                SizedBox(
                  height: 35,
                  child: MaterialButton(
                    color: Colors.lightBlue,
                    onPressed: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          // <-- Icon
                          Icons.add,
                          size: 12.0,
                          color: Colors.white,
                        ),
                        Text(
                          'Thêm quảng cáo',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ), // <-- Text
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25,),
            BannerUploadWidget(_visible),
            const SizedBox(height: 25,),
            //Banners
            Card(
              shadowColor: Colors.grey,
              elevation: 3,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: BannerWidget(),
            ),
          ],
        ),
      ),
    );
  }

}
