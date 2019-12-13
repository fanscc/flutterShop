import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页商城'),
      ),
      body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = jsonDecode(snapshot.data.toString());
              List<Map> swiperDataList =
                  (data['data']['slides'] as List).cast(); // 顶部轮播组件数
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast(); // 导航
              String bannerImg =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String telImg = data['data']['shopInfo']['leaderImage']; //店长图片
              String telCode = data['data']['shopInfo']['leaderPhone']; //店长电话
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast(); // 商品推荐
              String floor1Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              String floor2Title =
                  data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              String floor3Title =
                  data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              List<Map> floor1 =
                  (data['data']['floor1'] as List).cast(); //楼层1商品和图片
              List<Map> floor2 =
                  (data['data']['floor2'] as List).cast(); //楼层1商品和图片
              List<Map> floor3 =
                  (data['data']['floor3'] as List).cast(); //楼层1商品和图片
              return EasyRefresh(
                  topBouncing: false,
                  footer: BezierBounceFooter(),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(swiperDataList: swiperDataList),
                      TopNavigator(navigatorList: navigatorList),
                      AdBanner(bannerImg: bannerImg),
                      LeaderPhone(telImg: telImg, telCode: telCode),
                      Recommend(recommendList: recommendList),
                      FloorTitle(floorImg: floor1Title),
                      FloorContent(floorGoodsList: floor1),
                      FloorTitle(floorImg: floor2Title),
                      FloorContent(floorGoodsList: floor2),
                      FloorTitle(floorImg: floor3Title),
                      FloorContent(floorGoodsList: floor3),
                      HotTitle(),
                      HotGoods(hotGoodsList: hotGoodsList)
                    ],
                  ),
                  onLoad: () async {
                    print('开始加载更多......');
                    var formData = {'page': page};
                    await request('homePageBelowConten', formData: formData)
                        .then((val) {
                      var data = json.decode(val.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    });
                  });
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          }),
    );
  }
}

// 顶部轮播
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                Application.router.navigateTo(
                    context, "/detail?id=${swiperDataList[index]['goodsId']}");
              },
              child: Image.network("${swiperDataList[index]['image']}",
                  fit: BoxFit.fill));
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 导航

class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridItemUi(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('11');
        // Application.router.navigateTo(context,"/detail?id=${item['goodsId']}");
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      child: Container(
        height: ScreenUtil().setHeight(330),
        padding: EdgeInsets.all(3.0),
        child: GridView.count(
          // 解决顶部导航区域（GridView）与全局（SingleChildScrollView）的滑动冲突问题
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navigatorList.map((item) {
            return _gridItemUi(context, item);
          }).toList(),
        ),
      ),
    );
  }
}

// 广告banner图

class AdBanner extends StatelessWidget {
  final String bannerImg;
  const AdBanner({Key key, this.bannerImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(bannerImg),
    );
  }
}

// 打电话功能
class LeaderPhone extends StatelessWidget {
  final String telImg;
  final String telCode;
  LeaderPhone({Key key, this.telImg, this.telCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(telImg),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + telCode;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_titleWidget(), _recommedList()],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (BuildContext context, int index) {
          return _item(index);
        },
      ),
    );
  }

  Widget _item(index) {
    return Container(
      width: ScreenUtil().setWidth(250),
      height: ScreenUtil().setHeight(330),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Image.network(recommendList[index]['image']),
          Text('￥${recommendList[index]['mallPrice']}'),
          Text(
            '￥${recommendList[index]['price']}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough, color: Colors.grey),
          )
        ],
      ),
    );
  }
}

// 楼层图片

class FloorTitle extends StatelessWidget {
  final String floorImg;
  const FloorTitle({Key key, this.floorImg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(floorImg),
    );
  }
}

//楼层商品组件
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

// 火爆专区

class HotTitle extends StatelessWidget {
  const HotTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
      child: Text(
        '火爆专区',
        style: TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.red),
      ),
    );
  }
}

class HotGoods extends StatelessWidget {
  final List<Map> hotGoodsList;
  HotGoods({Key key, this.hotGoodsList}) : super(key: key);

  List<Widget> _wrapList() {
    return hotGoodsList.map((val) {
      return InkWell(
        onTap: () {
          print('点击了火爆区域');
        },
        child: Container(
          width: ScreenUtil().setWidth(365),
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.only(bottom: 3.0, right: 2.0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              Image.network(val['image'], width: ScreenUtil().setWidth(360)),
              Text(
                val['name'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.blueGrey),
              ),
              Row(
                children: <Widget>[
                  Text('￥${val['mallPrice']}'),
                  Text(
                    '￥${val['price']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 3,
        children: _wrapList(),
      ),
    );
  }
}
