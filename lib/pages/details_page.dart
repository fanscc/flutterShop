import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import '../provide/cart.dart';
import '../provide/details_info.dart';
import '../provide/currentIndex.dart';
import '../model/details.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  const DetailsPage({Key key, this.goodsId}) : super(key: key);

  Future _getGoodInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return Provide.value<DetailsInfoProvide>(context).goodsInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('商品详情'),
      ),
      body: FutureBuilder(
        future: _getGoodInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DetailsGoodsData data = snapshot.data.data;
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    DetailsTopArea(goodInfo: data.goodInfo),
                    TabDetailsTabbar()
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                      height: ScreenUtil().setHeight(80),
                      child: BottomConten()),
                )
              ],
            );
          } else {
            return Text('加载中...');
          }
        },
      ),
    );
  }
}

// 头部信息
class DetailsTopArea extends StatelessWidget {
  final GoodInfo goodInfo;
  DetailsTopArea({Key key, this.goodInfo}) : super(key: key);

  Widget _explain() {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            '说明：> 极速送达 > 正品保证',
            style:
                TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(30)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      width: ScreenUtil().setWidth(740),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Image.network(
            goodInfo.image1,
            width: ScreenUtil().setWidth(740),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              goodInfo.goodsName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(30),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
            alignment: Alignment.centerLeft,
            child: Text('编号: ${goodInfo.goodsSerialNumber}',
                style: TextStyle(
                    color: Colors.black26, fontSize: ScreenUtil().setSp(28)),
                overflow: TextOverflow.ellipsis),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
            child: Row(
              children: <Widget>[
                Text(
                  '￥${goodInfo.presentPrice}',
                  style: TextStyle(
                      color: Colors.red, fontSize: ScreenUtil().setSp(34)),
                ),
                Text('市场价: ￥${goodInfo.oriPrice}',
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: ScreenUtil().setSp(28),
                      decoration: TextDecoration.lineThrough,
                    ))
              ],
            ),
          ),
          _explain()
        ],
      ),
    ));
  }
}

// tab 切换

class TabDetailsTabbar extends StatefulWidget {
  TabDetailsTabbar({Key key}) : super(key: key);

  @override
  _TabDetailsTabbarState createState() => _TabDetailsTabbarState();
}

class _TabDetailsTabbarState extends State<TabDetailsTabbar> {
  int tab = 1;
  Widget _myTabBarLeft() {
    return InkWell(
        onTap: () {
          setState(() {
            tab = 1;
          });
        },
        child: Container(
          width: ScreenUtil().setWidth(375),
          height: ScreenUtil().setHeight(80),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: tab == 1 ? Colors.pink : Colors.white))),
          child: Text(
            '详情',
            style: TextStyle(
              color: tab == 1 ? Colors.pink : Colors.black87,
              fontSize: ScreenUtil().setSp(30),
            ),
          ),
        ));
  }

  Widget _myTabBarRight() {
    return InkWell(
        onTap: () {
          setState(() {
            tab = 2;
          });
        },
        child: Container(
          width: ScreenUtil().setWidth(375),
          height: ScreenUtil().setHeight(80),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: tab == 2 ? Colors.pink : Colors.white))),
          child: Text(
            '评价',
            style: TextStyle(
              color: tab == 2 ? Colors.pink : Colors.black87,
              fontSize: ScreenUtil().setSp(30),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 40.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[_myTabBarLeft(), _myTabBarRight()],
              ),
              tab == 1 ? TabsContenL() : TabsContenR()
            ],
          )),
    );
  }
}

// tab左边的内容

class TabsContenL extends StatelessWidget {
  const TabsContenL({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DetailsModel detailsData =
        Provide.value<DetailsInfoProvide>(context).goodsInfo;
    String goodsDetails = detailsData.data.goodInfo.goodsDetail;
    return Container(
      child: Html(data: goodsDetails),
    );
  }
}

// tab 右边的内容

class TabsContenR extends StatelessWidget {
  const TabsContenR({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      alignment: Alignment.center,
      child: Text(
        '暂无评论',
        style: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.red),
      ),
    );
  }
}

// 底部内容

class BottomConten extends StatelessWidget {
  const BottomConten({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DetailsModel detailsData =
        Provide.value<DetailsInfoProvide>(context).goodsInfo;
    GoodInfo goodsInfo = detailsData.data.goodInfo;
    var goodsId = goodsInfo.goodsId;
    var goodsName = goodsInfo.goodsName;
    var price = goodsInfo.presentPrice;
    var images = goodsInfo.image1;

    return Container(
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(100),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.shopping_cart,
                      size: 35,
                      color: Colors.red,
                    ),
                  )),
              Provide<CartProvide>(
                builder: (BuildContext context, Widget child, val) {
                  int goodsCount = val.allGoodsCount;
                  return Positioned(
                      top: 0.0,
                      right: 10.0,
                      child: Container(
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setHeight(40),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.pink),
                          child: Text('$goodsCount',
                              style: TextStyle(color: Colors.white))));
                },
              )
            ],
          ),
          InkWell(
            onTap: () {
              Provide.value<CartProvide>(context)
                  .save(goodsId, goodsName, price, images);
            },
            child: Container(
              width: ScreenUtil().setWidth(325),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text('加入购物车', style: TextStyle(color: Colors.white)),
            ),
          ),
          InkWell(
            onTap: () {
              Provide.value<CartProvide>(context).remove();
            },
            child: Container(
              width: ScreenUtil().setWidth(325),
              alignment: Alignment.center,
              color: Colors.red,
              child: Text('立即购买', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
