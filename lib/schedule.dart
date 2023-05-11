import 'package:flutter/material.dart';

import 'package:fp/slide/slide.dart';
import 'package:fp/slide/slide_item.dart';
import 'package:infinity_page_view/infinity_page_view.dart';


class SchedulePage extends StatefulWidget {
  final String title;

  const SchedulePage({Key? key, required this.title}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String title;
  final rows = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
  final columns = ['第  1節', '第  2節', '第  3節', '第  4節', '第  5節', '第  6節', '第  7節', '第  8節', '第  9節', '第10節', '第11節', '第12節', '第13節', '第14節', '第15節', '第16節'];
  final time = ["8:10~9:00", "9:10~10:00", "10:10~11:00", "11:10~12:00", "13:10~14:00", "14:10~15:00", "15:10~16:00", "16:10~17:00", "17:10~18:00", "18:10~18:55", "19:00~19:45", "19:50~20:35", "20:40~21:25", "21:30~22:15", "7:10~8:00", "12:10~13:00"];
  var now = DateTime.now();


  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

  InfinityPageController infinityPageController = new InfinityPageController(initialPage: 0);

  @override
  void initState() {
    super.initState();

    title = widget.title;
  }

  @override
  void dispose() {

    _textFieldController1.dispose();
    _textFieldController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    now = DateTime.now();
    print(now);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.blue, Colors.lightBlueAccent.shade200]),
          ),
        ),
      ),
      body: InfinityPageView(
        itemCount: slideList.length,
        itemBuilder: (context, i) => SlidePage(idx: i),
        controller: infinityPageController,
      ),

    );
  }

  Future<void> initData() async{
  }

}