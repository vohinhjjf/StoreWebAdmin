import 'package:eshop_admin/widgets/request/list_data_request.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatefulWidget {
  static const String id = 'request-screen';

  const RequestScreen({super.key});
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh sách các yêu cầu/góp ý',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 25,),
            ListDataRequestWidget("all"),
          ],
        ),
      ),
    );
  }
}