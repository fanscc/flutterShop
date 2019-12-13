import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import '../model/cartInfo.dart';

class CartPage extends StatelessWidget {
  Future _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return '完成加载';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('购物车'),
        ),
        body: FutureBuilder(
            future: _getCartInfo(context),
            builder: (context, data) {
              if (data.hasData) {
                return Provide<CartProvide>(builder: (context, child, val) {
                  List<CartInfoMode> cartList = val.cartList;
                  return Container(
                    color: Color.fromRGBO(244, 244, 244, 1.0),
                    child: Stack(
                      children: <Widget>[
                        ListView.builder(
                            itemCount: cartList.length,
                            itemBuilder: (context, index) {
                              return CartItem(cartInfoMode: cartList[index]);
                            }),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          child: CartBottom(),
                        )
                      ],
                    ),
                  );
                });
              } else {
                return Text('加载中...');
              }
            }));
  }
}

// 购物车每列子项
class CartItem extends StatelessWidget {
  final CartInfoMode cartInfoMode;
  CartItem({Key key, this.cartInfoMode}) : super(key: key);

  // 复选框
  Widget _checkbox(cartInfoMode, context) {
    return Container(
        child: Checkbox(
      value: cartInfoMode.check,
      activeColor: Colors.pink,
      onChanged: (bool val) {
        Provide.value<CartProvide>(context).checkBoxActive(cartInfoMode, val);
      },
    ));
  }

  // 图片widget
  Widget _goodImg(item) {
    return Container(
      width: ScreenUtil().setWidth(170),
      height: ScreenUtil().setHeight(170),
      margin: EdgeInsetsDirectional.only(start: 10.0),
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Image.network(item.images),
    );
  }

  // 商品添加减少控制widget
  Widget _cartCount(item, context) {
    // 减少商品
    Widget _reduceBtn(item, context) {
      return InkWell(
        onTap: () {
          // 先判断如果等于1则不让再减少
          if (item.count <= 1) {
            return;
          }
          Provide.value<CartProvide>(context)
              .addOrReduceAction(item.goodsId, 'reduce');
        },
        child: Container(
          width: ScreenUtil().setWidth(50),
          height: ScreenUtil().setHeight(50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26)),
          child: Text(
            item.count <= 1 ? '' : '-',
            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
          ),
        ),
      );
    }

    // 显示商品
    Widget _countArea(item) {
      return Container(
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setHeight(50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 1, color: Colors.black26),
                top: BorderSide(width: 1, color: Colors.black26))),
        child: Text('${item.count}'),
      );
    }

    // 增加商品
    Widget _addBtn(item, context) {
      return InkWell(
        onTap: () {
          Provide.value<CartProvide>(context)
              .addOrReduceAction(item.goodsId, 'add');
        },
        child: Container(
          width: ScreenUtil().setWidth(50),
          height: ScreenUtil().setHeight(50),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26)),
          child: Text('+', style: TextStyle(fontSize: ScreenUtil().setSp(30))),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          _reduceBtn(item, context),
          _countArea(item),
          _addBtn(item, context)
        ],
      ),
    );
  }

  // 商品widget
  Widget _cartGoodsName(item, context) {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(230),
      margin: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 10.0, 0.0),
      child: Column(
        children: <Widget>[
          Text(
            item.goodsName,
            style: TextStyle(
                color: Colors.black, fontSize: ScreenUtil().setSp(32)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          _cartCount(item, context)
        ],
      ),
    );
  }

  // 价格widget
  Widget _cartPrice(item, context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              '￥${item.price * item.count}',
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(32)),
            ),
            InkWell(
              onTap: () {
                Provide.value<CartProvide>(context).deleteGood(item.goodsId);
              },
              child: Icon(Icons.delete_forever, size: 35),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black26)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          _checkbox(cartInfoMode, context),
          _goodImg(cartInfoMode),
          _cartGoodsName(cartInfoMode, context),
          _cartPrice(cartInfoMode, context)
        ],
      ),
    );
  }
}

// 购物车的底部

class CartBottom extends StatelessWidget {
  const CartBottom({Key key}) : super(key: key);

  // 全选widget
  Widget _allCheck(allCheck, context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: allCheck,
            activeColor: Colors.pink,
            onChanged: (bool val) {
              Provide.value<CartProvide>(context).allCheckBoxActive(val);
            },
          ),
          Container(
            child: Text('全选'),
          )
        ],
      ),
    );
  }

  // 总价widget
  Widget _allPrice(allPrice) {
    return Container(
      margin: EdgeInsets.only(left: 20.0),
      width: ScreenUtil().setWidth(320),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '合计:',
                style: TextStyle(fontSize: ScreenUtil().setSp(32)),
              ),
              Text(
                '￥$allPrice',
                style: TextStyle(
                    color: Colors.red, fontSize: ScreenUtil().setSp(32)),
              )
            ],
          ),
          Container(
            child: Text(
              '满10元免配送费,预购免配送费',
              style: TextStyle(
                  color: Colors.black26, fontSize: ScreenUtil().setSp(22)),
            ),
          )
        ],
      ),
    );
  }

  // 结算按钮widget
  Widget _closeAnAccount() {
    return Expanded(
        child: InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text('结算',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(30))),
            )));
  }

  @override
  Widget build(BuildContext context) {
    double allPrice = Provide.value<CartProvide>(context).allPrice;
    bool allCheck = Provide.value<CartProvide>(context).allCheck;
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(80),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _allCheck(allCheck, context),
          _allPrice(allPrice),
          _closeAnAccount()
        ],
      ),
    );
  }
}
