import 'dart:convert';
import 'package:opc_app_main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDataValid = false;
  bool isLoggedIn =
      false; // khai báo biến isLoggedIn và đặt giá trị ban đầu là false

  final String url = "http://118.69.225.144/api/user";
  late List data;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _maDvcsController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    data = [];
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
        // Encoding the url in case of there are any spaces
        Uri.parse(Uri.encodeFull(url)),
        // only accepting json respond
        headers: {"Accept": "application/json"});
    print(response.body);
    setState(() {
      final convertDataToJson = jsonDecode(response.body);
      data = convertDataToJson;
    });
    return "Success";
  }

  Future<void> _login() async {
    String username = _usernameController.text.toLowerCase();
    String password = _passwordController.text.toLowerCase();
    String maDvcs = _maDvcsController.text.toLowerCase();
    String? maCbNv;
    String? hoten;
    String? chuc_Danh;
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null &&
          data[i]['tendangnhap'].toLowerCase() == username &&
          data[i]['matkhau'].toLowerCase() == password &&
          data[i]['ma_Dvcs'].toLowerCase() == maDvcs) {
        maCbNv = data[i]['ma_CbNv'];
        hoten = data[i]['hoten'];
        chuc_Danh = data[i]['chuc_Danh'];
        print(maCbNv);
        isDataValid = true;
        break;
      }
    }
    if (!isDataValid) {
      // show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng nhập thất bại! Vui lòng thử lại',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -50,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 50,
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: OutlinedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      String? maCbNv;
      String? hoten;
      String? chuc_Danh;
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null &&
            data[i]['tendangnhap'].toLowerCase() == username &&
            data[i]['matkhau'].toLowerCase() == password &&
            data[i]['ma_Dvcs'].toLowerCase() == maDvcs) {
          maCbNv = data[i]['ma_CbNv'];
          hoten = data[i]['hoten'];
          chuc_Danh =
              data[i]['chuc_Danh']; // extract chuc_Danh from data object
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('maCbNv', maCbNv!);
          prefs.setString('hoten', hoten!);
          prefs.setString('chucdanh', chuc_Danh!);
          print(maCbNv);
          setState(() {
            isLoggedIn = true;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageMain(
                isLoggedIn: isLoggedIn,
              ),
            ),
          );
        }
      }
      if (!isDataValid) {
        // show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng nhập thất bại! Vui lòng thử lại',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 50,
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    right: 10.0,
                    child: OutlinedButton(
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // show success dialog

        if (chuc_Danh == 'GD') {
          // show GD dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  'Chào mừng Admin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                content: Text(
                  'Bạn đã đăng nhập thành công với tài khoản có chức danh Admin.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // show normal user dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng nhập thành công',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Đăng nhập thành công!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> sortedData = List<DropdownMenuItem>.from(
        Set<String>.from(data
                .where((item) => item['ma_Dvcs'].contains("A"))
                .map((item) => item['ma_Dvcs']))
            .toList()
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.black),
                  ),
                ))
            .toList());
    sortedData.sort((a, b) => a.value.compareTo(b.value));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Schyler',
                      fontSize: 20,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Schyler',
                      fontSize: 20,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  items: sortedData,
                  onChanged: (value) {
                    _maDvcsController.text = value.toString();
                  },
                  decoration: InputDecoration(
                    labelText: "Mã ĐVCS",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Schyler',
                      fontSize: 20,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  style: TextStyle(
                      color: Colors.black), // thiết lập màu chữ của nút bấm
                  iconEnabledColor:
                      Colors.black, // thiết lập màu của mũi tên xuống
                ),
                SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _isLoggedIn ? null : _login,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Schyler',
                      fontSize: 20,
                    ),
                  ),
                ),
                _isLoggedIn ? Text('Đăng nhập thành công!') : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
