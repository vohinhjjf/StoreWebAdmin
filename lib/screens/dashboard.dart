import 'package:eshop_admin/screens/admin_users.dart';
import 'package:eshop_admin/screens/login_screen.dart';
import 'package:eshop_admin/screens/request_screen.dart';
import 'package:eshop_admin/screens/store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:eshop_admin/screens/voucher_screen.dart';
import 'package:eshop_admin/screens/manage_banners.dart';
import 'package:eshop_admin/screens/product_screen.dart';

class DashBoardScreen extends StatefulWidget {
  static const String id = 'dashboard-screen';
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PageController page = PageController();
  SideMenuController sideMenu = SideMenuController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        actions: [
          buildImage(Colors.white),
        ],
        leadingWidth: 270,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 25,),
            const Icon(Icons.shopping_cart, size: 30,),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: const Text("eShop Admin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: "Lobster",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        title: Container(
          width: MediaQuery.of(context).size.width/2,
          child: _buildSearch(),
        ),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              backgroundColor: Colors.white,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: Column(
              children: [
                const SizedBox(height: 15,),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  child: Image.asset(
                    'images/logo.png',
                  ),
                ),
                const SizedBox(height: 15,),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Quảng cáo',
                onTap: (page,_) {
                  sideMenu.changePage(0);
                },
                icon: const Icon(CupertinoIcons.photo),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Danh sách sản phẩm',
                onTap: (page,_) {
                  setState(() {
                    sideMenu.changePage(1);
                  });
                },
                icon: const Icon(CupertinoIcons.square_list_fill),
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )
                ),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Khuyến mãi',
                onTap: (page,_) {
                  setState(() {
                    sideMenu.changePage(2);
                  });
                },
                icon: const Icon(CupertinoIcons.tickets_fill),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Địa chỉ',
                onTap: (page,_) {
                  setState(() {
                    sideMenu.changePage(3);
                  });
                },
                icon: const Icon(CupertinoIcons.location_solid),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Yêu cầu',
                onTap: (page,_) {
                  setState(() {
                    sideMenu.changePage(4);
                  });
                },
                icon: const Icon(CupertinoIcons.question_circle_fill),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Quản lý tài khoản',
                onTap: (page,_) {
                  setState(() {
                    sideMenu.changePage(5);
                  });
                },
                icon: const Icon(CupertinoIcons.rectangle_stack_person_crop_fill),
              ),
            ],
            alwaysShowFooter: true,
            footer: Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 50,
              child: Column(
                children: [
                  const Divider(
                    indent: 8.0,
                    endIndent: 8.0,
                  ),
                  TextButton.icon(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    },
                    icon: Icon(Icons.exit_to_app,color: Colors.red,),
                    label: Text("Thoát", style: TextStyle(color: Colors.red, fontSize: 18),),
                  )
                ],
              ),
            )
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                BannerScreen(),
                ProductScreen(),
                VoucherScreen(),
                StoreScreen(),
                RequestScreen(),
                AdminUsers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextField _buildSearch() {
    const border =  OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(15.0),
      ),
    );

    const sizeIcon = BoxConstraints(
      minWidth: 40,
      minHeight: 40,
    );

    return const TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(4),
        focusedBorder: border,
        enabledBorder: border,
        isDense: true,
        hintText: "Tìm kiếm",
        hintStyle: TextStyle(
          fontSize: 18,
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        suffixIcon: Icon(
          Icons.search,
        ),
        suffixIconConstraints: sizeIcon,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget buildImage(Color color) {
    var image = AssetImage("images/user.jfif");
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          backgroundImage: image as ImageProvider,
        ),
        SizedBox(width: 5,),
        const Text("Admin",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(width: 30,),
      ],
    );
  }

}