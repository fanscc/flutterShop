import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo;

  // 从后台获取商品数据
  getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((val) {
      var responseData = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}
