import 'package:flutter/material.dart';
import 'package:fp/data.dart';


class SchedulePage extends StatefulWidget {
  final String title;

  const SchedulePage({Key? key, required this.title}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late String title;
  final rows = ['', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
  final columns = ['', '第  1節', '第  2節', '第  3節', '第  4節', '第  5節', '第  6節', '第  7節', '第  8節', '第  9節', '第10節', '第11節', '第12節', '第13節', '第14節', '第15節', '第16節'];
  final time = ["0:0~0:0", "8:10~9:00", "9:10~10:00", "10:10~11:00", "11:10~12:00", "13:10~14:00", "14:10~15:00", "15:10~16:00", "16:10~17:00", "17:10~18:00", "18:10~18:55", "19:00~19:45", "19:50~20:35", "20:40~21:25", "21:30~22:15", "7:10~8:00", "12:10~13:00"];
  var now = DateTime.now();


  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: buildDataTable(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initData() async{
  }

  Widget buildDataTable() {

    return Column(
      children: [
        for(int i = 0; i<16+1; ++i)
          Row(
            children: [
              for(int j = 0; j<7+1; ++j)
                Card(
                  margin: EdgeInsets.all(1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 80,
                      height: 40,
                      child: InkWell(
                        onTap: i == 0 || j == 0 ? null : (){
                          showAlertDialog(context, i*7+j-8);
                        },
                        onLongPress: i == 0 || j == 0 ? null : (){
                          dialogInput(context, i*7+j-8);
                        },
                        child: Center(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.center,
                            color: now.hour*60+now.minute+5 >= int.parse(time[i].split('~')[0].split(":")[0])*60+int.parse(time[i].split('~')[0].split(":")[1]) &&
                                   now.hour*60+now.minute <= int.parse(time[i].split('~')[1].split(":")[0])*60+int.parse(time[i].split('~')[1].split(":")[1]) ?
                                   Colors.redAccent : i%2 == 0 ?
                                   Colors.grey.shade300 : Colors.grey.shade100,
                            child: i == 0 && j == 0 ? Container() : Text(
                              i == 0 ? rows[j] : j == 0 ? columns[i] : Data.schedules[i*7+j-8][0],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

            ],
          ),

      ],
    );
  }


  Future<void> dialogInput(BuildContext context, idx) async {
    print(idx);
    _textFieldController1.text = Data.schedules[idx][0];
    _textFieldController2.text = Data.schedules[idx][1];
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
                  Data.schedules[idx][0] = _textFieldController1.text;
                  Data.schedules[idx][1] = _textFieldController2.text;
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

  showAlertDialog(BuildContext context, idx) {
    print(idx);
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(
            Data.schedules[idx][0],
            style: TextStyle(fontSize: 22,),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Data.schedules[idx][1],
                style: TextStyle(fontSize: 18),
              ),
              Padding(padding: EdgeInsets.only(bottom: 25),),
              Text(
                time[idx~/7+1],
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ],
          ),

          actions: [
            TextButton(
              child: Text("Ok", style: TextStyle(fontSize: 18),),
              onPressed:  () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}