import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:opc_app_main/api_call_statistics.dart';
import 'package:opc_app_main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostApi extends StatefulWidget {
  @override
  PostApiState createState() => PostApiState();
}

class PostApiState extends State<PostApi> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController hotenController = TextEditingController();
  final TextEditingController maDvcsController = TextEditingController();
  final TextEditingController maCbNvontroller = TextEditingController();
  final TextEditingController ChucdanhController = TextEditingController();
  final TextEditingController maTDVcontroller = TextEditingController();
  final TextEditingController makhoController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  Future<String> postData() async {
    var url =
        "http://118.69.225.144/api/User"; // Điền đường dẫn đến API của bạn
    var headers = {
      "Content-Type": "application/json"
    }; // Đặt header Content-Type để chỉ định dữ liệu gửi đi là JSON
    var body = json.encode({
      // Điền các trường dữ liệu của user bạn muốn tạo
      "tendangnhap": usernameController.text,
      "matkhau": passwordController.text,
      "hoten": hotenController.text,
      "id": idController.text,
      "ma_Dvcs": maDvcsController.text,
      "ma_CbNv": maCbNvontroller.text,
      "chuc_Danh": ChucdanhController.text,
      "ma_TDV_Extra": maTDVcontroller.text,
      "ma_Kho": makhoController.text
    });

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      // Nếu thành công, giải mã dữ liệu JSON trả về và trả về message
      var jsonResponse = json.encode(response.body);
      return "success";
    } else {
      // Nếu thất bại, hiển thị mã lỗi và thông báo lỗi
      print('Request failed with status: ${response.statusCode}.');
      print(response.body);
      throw Exception('Failed to post data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 197, 195, 195),
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePageMain(
                              isLoggedIn: true,
                            )),
                  );
                },
                child: Text(
                  'HUỶ',
                  style: TextStyle(fontFamily: 'Anton', color: Colors.blue),
                ),
              ),
              Text(
                'THÊM USER',
                style: TextStyle(fontFamily: 'Anton', color: Colors.black54),
              ),
              TextButton(
                onPressed: () async {
                  String message = await postData();
                  if (message == 'success') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text(
                          'Thêm thành công',
                          style: TextStyle(color: Colors.white),
                        )));
                    usernameController.clear();
                    passwordController.clear();
                    hotenController.clear();
                    maCbNvontroller.clear();
                    maTDVcontroller.clear();
                    makhoController.clear();
                    ChucdanhController.clear();
                    idController.clear();
                    maDvcsController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Thêm thất bại ')));
                  }
                },
                child: Text(
                  'LƯU',
                  style: TextStyle(fontFamily: 'Anton', color: Colors.blue),
                ),
              )
            ],
          )),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(children: [
                    Text(
                      'Nhập đầy đủ thông tin',
                      style:
                          TextStyle(fontFamily: 'Anton', color: Colors.black54),
                    ),
                  ]),
                ),
                Container(
                  // height: 200,
                  color: Colors.white,
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          'Tên đăng nhập',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Tên đăng nhập',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                          controller: usernameController,
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Mật khẩu',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Expanded(
                            child: TextField(
                          controller: passwordController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Họ tên',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Expanded(
                            child: TextField(
                          controller: hotenController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Họ tên',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Id',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 120,
                        ),
                        Expanded(
                            child: TextField(
                          controller: idController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'ID',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Mã DVCS',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Expanded(
                            child: TextField(
                          controller: maDvcsController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Mã DVCS',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Mã CbNv',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Expanded(
                            child: TextField(
                          controller: maCbNvontroller,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Mã CbNv',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Chức danh',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Expanded(
                            child: TextField(
                          controller: ChucdanhController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Chức danh',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Mã TDV_Extra',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                            child: TextField(
                          controller: maTDVcontroller,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Mã TDV_Extra',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Text(
                          'Mã kho',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Expanded(
                            child: TextField(
                          controller: makhoController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Mã kho',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                        ))
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
