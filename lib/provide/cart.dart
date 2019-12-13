import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List<CartInfoMode> cartList = [];
  int allGoodsCount = 0; // 总共勾选多少件商品;
  double allPrice = 10.0; // 勾选后的商品总计格;
  bool allCheck = false; // 全选复现框;
  save(goodsId, goodsName, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var tem = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> temList = (tem as List).cast();
    int index = 0;
    bool hasVal = false;
    temList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        temList[index]['count'] = item['count'] + 1;
        hasVal = true;
      }
      index++;
    });

    if (!hasVal) {
      List<Map> newAdd = [];
      newAdd.add({
        'goodsId': goodsId,
        'goodsName': goodsName,
        'price': price,
        'images': images,
        'count': 1,
        'check': true // 默认添加勾选的
      });
      temList.addAll(newAdd);
    }
    cartString = json.encode(temList).toString();
    prefs.setString('cartInfo', cartString);
    allGoodsCount++;
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();//清空键值对
    prefs.remove('cartInfo');
    Fluttertoast.showToast(
        msg: "清空缓存成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 16.0);
    cartList = [];
    allGoodsCount = 0;
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];
    allGoodsCount = 0;
    allPrice = 0.0;

    if (cartString != null) {
      List<Map> temList = (json.decode(cartString) as List).cast();
      allCheck = true;
      temList.forEach((item) {
        cartList.add(CartInfoMode.fromJson(item));
        // 统计出来勾选过的商品个数
        if (item['check'] != null && item['check']) {
          allGoodsCount += item['count'];
          allPrice += item['count'] * item['price'];
        } else {
          allCheck = false;
        }
      });
    }
    notifyListeners();
  }

  // 复现框的勾选控制
  checkBoxActive(CartInfoMode cartInfoMode, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var tem = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> temList = (tem as List).cast();
    int index = 0;
    temList.forEach((item) {
      if (item['goodsId'] == cartInfoMode.goodsId) {
        temList[index]['check'] = val;
      }
      index++;
    });
    prefs.setString('cartInfo', json.encode(temList));
    await getCartInfo();
  }

  // 全选复选框
  allCheckBoxActive(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List tem = cartString == null ? [] : json.decode(cartString.toString());
    allCheck = val;
    int index = 0;
    tem.forEach((item) {
      tem[index]['check'] = val;
      index++;
    });
    prefs.setString('cartInfo', json.encode(tem));
    await getCartInfo();
  }

  // 删除当前商品
  deleteGood(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List tem = cartString == null ? [] : json.decode(cartString.toString());
    int index = 0;
    int deletIndex = 0;
    tem.forEach((item) {
      if (item['goodsId'] == goodsId) {
        deletIndex = index;
        // tem.removeAt(index);
      }
      index++;
    });
    tem.removeAt(deletIndex);
    prefs.setString('cartInfo', json.encode(tem));
    await getCartInfo();
  }

  // 增加减商品
  addOrReduceAction(String goodsId, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List tem = cartString == null ? [] : json.decode(cartString.toString());
    int index = 0;

    tem.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tem[index]['count'] =
            type == 'add' ? item['count'] + 1 : item['count'] - 1;
      }
      index++;
    });
    prefs.setString('cartInfo', json.encode(tem));
    await getCartInfo();
  }
}
