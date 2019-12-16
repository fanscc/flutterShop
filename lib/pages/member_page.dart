import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('会员中心'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              HeaderTop(),
              Myorder(),
              OrderTypeConten(),
              OrderList(),
            ],
          ),
        ),
      ),
    );
  }
}

// 头像

class HeaderTop extends StatelessWidget {
  const HeaderTop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(350),
        color: Colors.pink,
        alignment: Alignment.center,
        child: ClipOval(
          child: Image.asset(
            'images/header.jpeg',
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setHeight(200),
            fit: BoxFit.fill,
          ),
        ));
  }
}

// 我的订单

class Myorder extends StatelessWidget {
  const Myorder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, "/ckyDemo");
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListTile(
          leading: Icon(Icons.list),
          title: Text('我的demo练习'),
          trailing: Icon(Icons.arrow_right),
        ),
      ),
    );
  }
}

// 订单区域

class OrderTypeConten extends StatelessWidget {
  const OrderTypeConten({Key key}) : super(key: key);

  Widget _orderTypeList(iconfont, String text) {
    return Expanded(
        child: InkWell(
          onTap: () {
            Fluttertoast.showToast(
                msg: "正在玩命的开发中...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                fontSize: 16.0);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(iconfont, size: 30), Text(text)],
          ),
        ),
        flex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(150),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Row(
        children: <Widget>[
          _orderTypeList(Icons.party_mode, '待付款'),
          _orderTypeList(Icons.query_builder, '待付款'),
          _orderTypeList(Icons.directions_car, '待付款'),
          _orderTypeList(Icons.content_paste, '待付款')
        ],
      ),
    );
  }
}

// 列表区域

class OrderList extends StatelessWidget {
  const OrderList({Key key}) : super(key: key);

  Widget _itemList(String text) {
    return InkWell(
      onTap: () {
        Fluttertoast.showToast(
          msg: "正在玩命的开发中...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
        );
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: ListTile(
          leading: Icon(Icons.blur_circular),
          title: Text(text),
          trailing: Icon(Icons.arrow_right),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        _itemList('领取优惠券'),
        _itemList('已领取优惠券'),
        _itemList('地址管理'),
        _itemList('客服电话'),
        _itemList('关于我们'),
      ]),
    );
  }
}
