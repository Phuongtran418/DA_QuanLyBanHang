import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:opc_app_main/Comment_object.dart';
import 'package:opc_app_main/visit_customer.dart';
import 'api_SOAP.dart';
import 'onlineshop.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CheckInCustomerPage(
        businessPartnerName: '', internalID: '', objectID: ''),
  ));
}

class CheckInCustomerPage extends StatefulWidget {
  
  final String businessPartnerName;
  final String internalID;
  final String objectID;
  const CheckInCustomerPage(
      {Key? key,
      required this.businessPartnerName,
      required this.internalID,
      required this.objectID})
      : super(key: key);
  @override
  _CheckInCustomerState createState() => _CheckInCustomerState();
}

class _CheckInCustomerState extends State<CheckInCustomerPage> {
  TextEditingController _commentController = TextEditingController();
  
  List<Comments> _comments = [];
  late Stream<int> timerStream;
  int secondsElapsed = 0;
  DateTime currentDateTime = DateTime.now();

  StreamSubscription<int>?
      timerSubscription; // khai báo biến để lưu stream subscription

  void _addComment(String text) {
  if (text.isNotEmpty) {
    final now = DateTime.now();
    final formattedTime = DateFormat('dd/MM/yyyy HH:mm').format(now); // định dạng giờ
    final newComment = Comments(NoiDung: text, Gio: DateTime.now());

    setState(() {
      _comments.add(newComment);
    });
  }
}


  @override
  void initState() {
    super.initState();
    timerStream = Stream<int>.periodic(Duration(seconds: 1), (int x) => x);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Check IN Khách Hàng"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  Text(
                    "Thời gian viếng thăm: ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: timerStream,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      currentDateTime =
                          DateTime.now().add(Duration(seconds: secondsElapsed));
                      // Tính thời gian đã trôi qua
                      secondsElapsed = snapshot.data ?? 0;

                      // Format lại thời gian hiển thị
                      final String timerText =
                          _formatDuration(Duration(seconds: secondsElapsed));

                      // Trả về widget hiển thị thời gian
                      return Text(
                        timerText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' ${widget.businessPartnerName}'),
                SizedBox(height: 8.0),
                Text(' ${widget.internalID}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(' ${widget.objectID}'),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  width: 110,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 41, 104, 43),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "ĐẶT HÀNG",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  height: 50,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 207, 88, 19),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => TakePictureScreen(camera: false)),
                      // );
                    },
                    child: Text(
                      "CHỤP ẢNH",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  height: 50,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 19, 126, 120),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      timerSubscription?.cancel(); // dừng stream
                      Navigator.pop(context); // thoát khỏi trang
                    },
                    child: Text('CHECK OUT'),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    onSubmitted: _addComment,
                    decoration: InputDecoration(
                      hintText: "Khảo sát khách hàng",
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      final newComment = Comments(
                          NoiDung: _commentController.text,
                          Gio: DateTime.now());
                      setState(() {
                        _comments.add(newComment);
                        _commentController.clear();
                      });
                    },
                    icon: Icon(Icons.send, color: Colors.blue))
              ]),
            ),
            Column(
              children: [
              Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  ),
  height: 300,
  child: ListView.builder(
    shrinkWrap: true,
    itemBuilder: (context, index) {
      final comment = _comments[index];
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  comment.NoiDung,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy HH:mm:ss').format(comment.Gio),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    },
    itemCount: _comments.length,
  ),
),


              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
