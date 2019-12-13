import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import '../model/category.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List list = [];
  var listIndex = 0;
  bool showOrhidden = false;
  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = jsonDecode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context)
          .getChildCategory(list[0].bxMallSubDto);
      Provide.value<ChildGoodgory>(context).getChildGoodgory(
          ncategoryId: list[0].bxMallSubDto[0].mallCategoryId);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  @override
  Widget build(BuildContext context) {
    Timer timer;
    ScrollController _scrollController = new ScrollController();
    _scrollController.addListener(() {
      timer?.cancel();
      timer = new Timer(Duration(seconds: 1), () {
        if (_scrollController.position.pixels > 1000) {
          setState(() {
            showOrhidden = true;
          });
        } else {
          setState(() {
            showOrhidden = false;
          });
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('分类菜单'),
      ),
      body: Center(
          child: Container(
        alignment: Alignment.center,
        child: Row(
          children: <Widget>[
            LeftCategoryNav(list: list),
            Column(
              children: <Widget>[
                // Ckytest(),
                RightCategoryNav(),
                CategoryGoodsList(scrollController: _scrollController)
              ],
            )
          ],
        ),
      )),
      floatingActionButton: showOrhidden
          ? FloatingActionButton(
              mini: true,
              onPressed: () {
                _scrollController.jumpTo(0.0);
              },
              child: Icon(Icons.arrow_upward),
            )
          : Text(''),
    );
  }
}

class LeftCategoryNav extends StatefulWidget {
  final List list;
  LeftCategoryNav({Key key, this.list}) : super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  int idCheck = 0;
  Widget _leftNavItems(item, context, index) {
    return Container(
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
            color: idCheck == index ? Colors.red : Colors.white,
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.black26),
            )),
        child: InkWell(
            onTap: () {
              setState(() {
                idCheck = index;
              });
              var childList = item.bxMallSubDto;
              Provide.value<ChildCategory>(context).getChildCategory(childList);
              Provide.value<ChildGoodgory>(context)
                  .getChildGoodgory(ncategoryId: item.mallCategoryId);
              Provide.value<ChildCategory>(context).switchTapindex(0);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                item.mallCategoryName,
                style: TextStyle(fontSize: ScreenUtil().setSp(34)),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black26))),
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          return _leftNavItems(widget.list[index], context, index);
        },
      ),
    );
  }
}

// 右侧nav
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  Widget _rightInkWell(BxMallSubDto item, int index) {
    int tapIndex = Provide.value<ChildCategory>(context).tapIndex;
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      alignment: Alignment.center,
      color:
          tapIndex == index ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
      child: InkWell(
        onTap: () {
          Provide.value<ChildGoodgory>(context)
              .getChildGoodgory(ncategorySubId: item.mallSubId);
          Provide.value<ChildCategory>(context).switchTapindex(index);
        },
        child: Text(item.mallSubName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(550),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(
                  childCategory.childCategoryList[index], index);
            },
          ),
        );
      },
    );
  }
}

// 右侧商品内容

class CategoryGoodsList extends StatefulWidget {
  ScrollController scrollController;
  CategoryGoodsList({Key key, this.scrollController}) : super(key: key);

  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  List list = [];
  EasyRefreshController _controller;
  // ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    // _scrollController = ScrollController();
  }

  Widget _leftImg(imgSrc) {
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setHeight(180),
      alignment: Alignment.center,
      child: Image.network(
        imgSrc,
        width: ScreenUtil().setWidth(150),
      ),
    );
  }

  Widget _rightTop(title) {
    return Container(
      width: ScreenUtil().setWidth(340),
      height: ScreenUtil().setHeight(100),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _rightBottom(price, oldPrice) {
    return Container(
        width: ScreenUtil().setWidth(340),
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                '价格: ￥$oldPrice',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.red),
              ),
            ),
            Expanded(
              child: Text(
                '￥$price',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black26,
                    decoration: TextDecoration.lineThrough),
              ),
              flex: 1,
            ),
          ],
        ));
  }

  Widget _listWidget(item) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black26),
          )),
      child: Row(
        children: <Widget>[
          _leftImg(item.image),
          Column(
            children: <Widget>[
              _rightTop(item.goodsName),
              _rightBottom(item.oriPrice, item.presentPrice)
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provide<ChildGoodgory>(builder: (context, child, data) {
      bool _enableLoad = Provide.value<ChildGoodgory>(context).enableLoad;
      _controller.finishLoad(
          noMore:
              Provide.value<ChildGoodgory>(context).enableLoad ? false : true);
      try {
        print(data.page);
        if (data.page == 2) {
          // 列表位置，放到最上边
          widget.scrollController.jumpTo(0.0);
        }
      } catch (e) {
        print('进入页面第一次初始化：$e');
      }
      if (data.childGoodList.length > 0) {
        return Expanded(
            child: Container(
                width: ScreenUtil().setWidth(550),
                child: EasyRefresh(
                    topBouncing: false,
                    controller: _controller,
                    enableControlFinishRefresh: _enableLoad ? false : true,
                    footer: ClassicalFooter(
                      //自定义refreshFooter
                      enableInfiniteLoad: false,
                      loadText: "上拉加载...",
                      loadReadyText: "准备加载...",
                      loadingText: "加载中...",
                      loadedText: "加载成功",
                      loadFailedText: "加载失败",
                      noMoreText: "没有更多了",
                      showInfo: false,
                      bgColor: Colors.transparent,
                      textColor: Colors.blue,
                    ),
                    child: ListView.builder(
                      controller: widget.scrollController,
                      itemCount: data.childGoodList.length,
                      itemBuilder: (context, index) {
                        return _listWidget(data.childGoodList[index]);
                      },
                    ),
                    onLoad: () async {
                      print('下拉加载更多......');
                      await Provide.value<ChildGoodgory>(context)
                          .getChildGoodgory();
                    })));
      } else {
        return Text('暂时没有数据');
      }
    });
  }
}

class BottomNomore extends StatelessWidget {
  const BottomNomore({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provide<ChildGoodgory>(builder: (context, child, data) {
      bool _enableLoad = Provide.value<ChildGoodgory>(context).enableLoad;
      return Container(
        child: _enableLoad
            ? Container()
            : Container(
                alignment: Alignment.center,
                height: ScreenUtil().setHeight(80),
                child: Text(
                  '没有更多了',
                  style: TextStyle(
                      color: Colors.red, fontSize: ScreenUtil().setSp(28)),
                ),
              ),
      );
    });
  }
}

// class Ckytest extends StatefulWidget {
//   String name = 'cky1';
//   String name1 = 'cky2';
//   Ckytest({Key key}) : super(key: key);

//   @override
//   _CkytestState createState() => _CkytestState(name1: name1);
// }

// class _CkytestState extends State<Ckytest> {
//   String name1;
//   _CkytestState({this.name1});

//   @override
//   Widget build(BuildContext context) {
//     print(name1);
//     return Container(
//       child: Text(widget.name),
//     );
//   }
// }
