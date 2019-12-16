import 'package:flutter/material.dart';

class Ckydemo extends StatelessWidget {
  const Ckydemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ckyDemo'),
        ),
        body: Center(
          child: Container(
            child: Text('练习'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openModalBottomSheet(context);
          },
          child: Icon(Icons.assignment),
        ),
      ),
    );
  }
}

Future _openModalBottomSheet(context) async {
  final option = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('拍照', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '拍照');
                },
              ),
              ListTile(
                title: Text('从相册选择', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '从相册选择');
                },
              ),
              ListTile(
                title: Text('取消', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '取消');
                },
              ),
            ],
          ),
        );
      });

  print(option);
}
