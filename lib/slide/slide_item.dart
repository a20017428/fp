import 'package:flutter/material.dart';
import 'package:fp/data.dart';
import 'package:fp/slide/slide.dart';


class SlidePage extends StatefulWidget {
  final int idx;

  const SlidePage({Key? key, required this.idx}) : super(key: key);

  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  late int idx;
  final date = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
  final period = ['第  1節', '第  2節', '第  3節', '第  4節', '第  5節', '第  6節', '第  7節', '第  8節', '第  9節', '第10節', '第11節', '第12節', '第13節', '第14節', '第15節', '第16節'];
  final time = ["8:10~9:00", "9:10~10:00", "10:10~11:00", "11:10~12:00", "13:10~14:00", "14:10~15:00", "15:10~16:00", "16:10~17:00", "17:10~18:00", "18:10~18:55", "19:00~19:45", "19:50~20:35", "20:40~21:25", "21:30~22:15", "7:10~8:00", "12:10~13:00"];
  var now = DateTime.now();
  bool doing = false;


  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();


  @override
  void initState() {
    super.initState();

    idx = widget.idx;
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(date[idx], style: TextStyle(fontSize: 24),),
        Expanded(
          child: ListView(
            children: List.generate(16, (i) => Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              height: 120,
              child: Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: now.hour*60+now.minute+5 >= int.parse(time[i].split('~')[0].split(":")[0])*60+int.parse(time[i].split('~')[0].split(":")[1]) &&
                           now.hour*60+now.minute <= int.parse(time[i].split('~')[1].split(":")[0])*60+int.parse(time[i].split('~')[1].split(":")[1]) ?
                           Colors.redAccent : Colors.blueGrey.shade100,
                    width: now.hour*60+now.minute+5 >= int.parse(time[i].split('~')[0].split(":")[0])*60+int.parse(time[i].split('~')[0].split(":")[1]) &&
                           now.hour*60+now.minute <= int.parse(time[i].split('~')[1].split(":")[0])*60+int.parse(time[i].split('~')[1].split(":")[1]) ?
                           2 : 1,
                  ),
                ),
                child: InkWell(
                    onTap: (){
                      dialogInput(context, i);
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey.shade100,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                Data.schedules[idx*7+i].split(' ').first,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                period[i],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                time[i],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                    ),
                  ),

              ),
            )),
          ),
        ),
      ],
    );


  }

  Future<void> dialogInput(BuildContext context, int i) async {
    print(idx);
    _textFieldController1.text = Data.schedules[idx*7+i].split(' ').first;
    _textFieldController2.text = Data.schedules[idx*7+i].split(' ').last;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: _textFieldController1,
                decoration: InputDecoration(
                  hintText: '科目',
                ),
              ),
              TextField(
                controller: _textFieldController2,
                decoration: InputDecoration(
                  hintText: '地點',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                alignment: Alignment.center,
                width: 70,
                height: 25,
                child: Text('OK', style: TextStyle(fontSize: 16),),
              ),
              onPressed: () {
                setState(() {
                  Data.schedules[idx*7+i]
                    = _textFieldController1.text + ' ' +  _textFieldController2.text;
                });

                _textFieldController1.text = '';
                _textFieldController2.text = '';

                Navigator.pop(context);

              },
            ),
            TextButton(
              child: Container(
                alignment: Alignment.center,
                width: 70,
                height: 25,
                child: Text('Cancel', style: TextStyle(fontSize: 16),),
              ),
              onPressed: () {
                Navigator.pop(context);
                _textFieldController1.text = '';
                _textFieldController2.text = '';
              },
            ),
          ],
        );
      },
    );
  }

}