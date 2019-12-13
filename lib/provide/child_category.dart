import 'package:flutter/material.dart';
import '../model/category.dart';

//ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int tapIndex = 0;
  getChildCategory(List<BxMallSubDto> list) {
    childCategoryList = [];
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList.add(all);
    childCategoryList.addAll(list);
    notifyListeners();
  }

  switchTapindex(int index) {
    tapIndex = index;
    notifyListeners();
  }
}
