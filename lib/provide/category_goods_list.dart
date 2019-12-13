import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';
import '../service/service_method.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ChildGoodgory with ChangeNotifier {
  List<CategoryListData> childGoodList = [];
  String categoryId;
  String categorySubId;
  int page = 1;
  // 是否开启加载
  bool enableLoad = true;

  getChildGoodgory({
    String ncategoryId,
    String ncategorySubId,
  }) async {
    if (ncategoryId != null) {
      // 点击大类
      page = 1;
      enableLoad = true;
      categoryId = ncategoryId;
      categorySubId = "";
      childGoodList = [];
    } else if (ncategorySubId != null) {
      // 点击子类
      page = 1;
      enableLoad = true;
      categorySubId = ncategorySubId;
      childGoodList = [];
    }
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': categorySubId == null ? '' : categorySubId,
      'page': page
    };
    print(data);
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Fluttertoast.showToast(
            msg: "已经到底了",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0);
        enableLoad = false;
        return null;
      }
      childGoodList.addAll(goodsList.data);
      page++;
    });
    notifyListeners();
  }
}
