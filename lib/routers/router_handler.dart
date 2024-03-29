import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/details_page.dart';
import '../pages/demo.dart';

Handler detailsHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String goodsId = params['id'].first;
  print('index>details goodsID is $goodsId');
  return DetailsPage(goodsId: goodsId);
});

Handler ckyDemoHandler = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return Ckydemo();
});
