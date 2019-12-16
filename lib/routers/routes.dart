import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static String root = '/';
  static String detailsPage = '/detail';
  static String ckyDemo = '/ckyDemo';
  static void configureRoutes(Router router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!! $params");
      return Text("");
    });
    router.define(detailsPage, handler: detailsHandler);
    router.define(ckyDemo, handler: ckyDemoHandler);
  }
}
