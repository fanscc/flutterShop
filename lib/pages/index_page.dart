import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './cart_page.dart';
import './category_page.dart';
import './home_page.dart';
import './member_page.dart';
import 'package:provide/provide.dart';
import '../provide/currentIndex.dart';

class IndexPage extends StatefulWidget {
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> boottomTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(Icons.add_shopping_cart), title: Text('购物车')),
    BottomNavigationBarItem(icon: Icon(Icons.person_pin), title: Text('会员中心'))
  ];

  final List<Widget> tabPages = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Provide<CurrentIndexProvide>(
      builder: (context, child, val) {
        return Container(
          child: Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: val.currentIndex,
                items: boottomTabs,
                onTap: (index) {
                  Provide.value<CurrentIndexProvide>(context)
                      .changeIndex(index);
                },
              ),
              body: IndexedStack(index: val.currentIndex, children: tabPages)),
        );
      },
    );
  }
}
