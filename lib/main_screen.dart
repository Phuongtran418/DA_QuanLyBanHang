import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opc_app_main/api_SOAP.dart';
import 'package:opc_app_main/api_save.dart';
import 'package:opc_app_main/call_api.dart';
import 'package:opc_app_main/customer.dart';
import 'package:opc_app_main/login_screen.dart';
import 'package:opc_app_main/orderList_screen.dart';
import 'package:opc_app_main/order_screen.dart';
import 'package:opc_app_main/post_api.dart';
import 'package:opc_app_main/statistical_screen.dart';
import 'package:opc_app_main/visit_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePageMain extends StatefulWidget {
  final bool isLoggedIn;

  HomePageMain({required this.isLoggedIn});
  @override
  State<StatefulWidget> createState() {
    return HomePageMainState();
  }
}

class HomePageMainState extends State<HomePageMain> {
  bool isUserGD = false; // initialize with false
  String? userRole = null; // fetch user's role using getChucDanh()
  String? hoten;
  String? chuc_Danh;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showBottomSheet = false;
  bool _isLoggedIn = false;
  Color _backgroundColor = Colors.white;
  TextEditingController _searchController = TextEditingController();
  final items = const [
    Icon(Icons.home_filled, size: 30, color: Colors.white),
    Icon(Icons.account_balance_wallet_rounded, size: 30, color: Colors.white),
    Icon(Icons.add_shopping_cart_rounded, size: 30, color: Colors.white),
  ];
  int index = 0;
  Future<void> getHoten() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hoten = prefs.getString('hoten') ?? '';
    setState(() {});
  }

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    login('username', 'password', 'GD').catchError((e) {
      print('Login error: $e');
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    prefs = await SharedPreferences.getInstance();
    final chucDanh = prefs.getString('chucdanh');
    if (chucDanh != null && chucDanh.toUpperCase() == 'GD') {
      setState(() {
        this.chuc_Danh = 'GD';
        isUserGD = true;
      });
    } else {
      setState(() {
        this.chuc_Danh = 'Unknown';
        isUserGD = false;
      });
    }
  }

  Future<void> login(String username, String password, String chucDanh) async {
    final url = "http://118.69.225.144/api/User";
    final response = await http.post(Uri.parse(url),
        body: {'tendangnhap': username, 'matkhau': password});

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('API response: $jsonResponse');
      if (jsonResponse.containsKey('chuc_Danh')) {
        final chucDanhFromApi = jsonResponse['chuc_Danh'];
        prefs.setString('chucdanh', chucDanhFromApi);

        if (chucDanhFromApi.toUpperCase() == 'GD') {
          setState(() {
            this.chuc_Danh = 'GD';
            isUserGD = true;
          });
        } else {
          setState(() {
            this.chuc_Danh = 'Unknown';
            isUserGD = false;
          });
        }
      } else {
        print('Error getting chuc_Danh: key not found');
        setState(() {
          this.chuc_Danh = 'Unknown';
          isUserGD = false;
        });
      }
    } else {
      throw Exception('Failed to get chuc_Danh from API');
    }

    // Perform any necessary action using the value of chucDanh parameter here
    print('chuc_Danh parameter: $chucDanh');
  }

  @override
  Widget build(BuildContext context) {
    getHoten();
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(244, 243, 238, 1),
        drawer: Drawer(
          child: Container(
            color: Color.fromARGB(255, 214, 212,
                212), // Thiết lập màu nền trắng cho toàn bộ Drawer
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Container(
                      //  padding: EdgeInsets.only(top:10),
                      height: 100,
                      color: Color.fromARGB(255, 158, 136, 121),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage('images/user.png'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt,
                                      color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      showBottomSheet = true;
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                                0.8), // opacity giữa 0 và 1
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20.0),
                                              topRight: Radius.circular(20.0),
                                              bottomLeft: Radius.circular(20.0),
                                              bottomRight:
                                                  Radius.circular(20.0),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.camera_alt),
                                                    SizedBox(
                                                        width:
                                                            8.0), // thêm khoảng cách giữa icon và text
                                                    Text(
                                                      'Chụp ảnh',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {},
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.photo_library),
                                                    SizedBox(width: 10.0),
                                                    Text('Chọn ảnh từ thư viện',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                onPressed: () {},
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors.blueGrey[
                                                      800], // sử dụng màu xanh dương
                                                  onPrimary: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0), // chỉ định bán kính bo tròn
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.cancel),
                                                    SizedBox(width: 10),
                                                    Text('Hủy',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ).then((value) {
                                      setState(() {
                                        showBottomSheet = false;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(hoten ?? '',
                              style: TextStyle(fontFamily: 'Labrada')),
                        ],
                      )),
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.account_circle_rounded, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Thông tin cá nhân',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Labrada')),
                    ],
                  ),
                  onTap: () {
                    // Do something
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.group_add_outlined, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Thêm User',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Labrada')),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostApi()));
                  },
                ),
                if (isUserGD) // Only show if user is GD
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.check, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          'Phê duyệt tài khoản',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Labrada',
                          ),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Cài đặt',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Labrada')),
                    ],
                  ),
                  onTap: () {
                    // Do something
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Đăng xuất',
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Labrada')),
                    ],
                  ),
                  onTap: () async {
                    setState(() {
                      _isLoggedIn = false;
                    });
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              Icon(
                                Icons.logout, // Icon logout
                                color: Colors.red,
                                size: 24,
                              ),
                              SizedBox(
                                  width: 8), // Khoảng cách giữa Icon và Text
                              Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 16),
                              Text(
                                'Bạn có chắc chắn muốn đăng xuất?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    child: Text(
                                      'Có',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.clear();
                                      Navigator.of(context).pop();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoginScreen()),
                                        ModalRoute.withName('/'),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text(
                                      'Không',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      // Xử lý khi người dùng chọn không đăng xuất ở đây
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: Color.fromARGB(255, 54, 168, 89),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Color.fromARGB(255, 54, 168, 89),
          items: items,
          index: index,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
          height: 70,
          animationDuration: const Duration(milliseconds: 300),
        ),
        body: ListView(children: [
          Container(
            child: Column(
              children: [
                Container(
                  color: Color.fromARGB(255, 54, 168, 89),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                if (_scaffoldKey.currentState != null) {
                                  _scaffoldKey.currentState!.openDrawer();
                                }
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('images/logo.png',
                                    width: 80, height: 80),
                              ],
                            ),
                            Container(
                              // margin: EdgeInsets.only(left: 25),
                              child: SizedBox(
                                width: 170,
                                height: 50,
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          )),
                                      labelText: 'Tìm kiếm',
                                      labelStyle: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          print(
                                              'Search Term: ${_searchController.text}');
                                        },
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.notifications,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            // margin: EdgeInsets.only(top: 70),
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 15.0,
                                    offset: Offset(0.0, 0.75))
                              ],
                            ),
                            child: PopupMenuButton(
                              color: _backgroundColor,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text(
                                    "1. Danh mục khách hàng",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    "2. Danh mục bảng giá",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: 2,
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    "3. Danh mục đối tác",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: 3,
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 1:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CustomerPage()),
                                    );
                                    break;
                                  case 2:
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => PriceListCategoryPage()),
                                    // );
                                    break;
                                  case 3:
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => PartnerCategoryPage()),
                                    // );
                                    break;
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/danhmuc.png',
                                    height: 30,
                                  ),
                                  Text(
                                    'DANH MỤC',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // margin: EdgeInsets.only(top: 70),
                                width: 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 15.0,
                                        offset: Offset(0.0, 0.75))
                                  ],
                                ),
                                child: PopupMenuButton(
                                  color: _backgroundColor,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text(
                                        "1. Viếng thăm khách hàng",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 1,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "2. Danh sách đơn hàng",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 2,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "3. Đơn đặt hàng TDV",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 3,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "4. Bảng kê nộp tiền mặt",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 4,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "5. Bảng kê nộp tiền GH",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 5,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "6. Thu nợ khách hàng",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 6,
                                    ),
                                    PopupMenuItem(
                                      child: Text(
                                        "7. Thêm sản phẩm",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                      value: 7,
                                    ),
                                  ],
                                  onSelected: (value) {
                                    switch (value) {
                                      case 1:
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VisitCustomerPage()),
                                        );
                                        break;
                                      case 2:
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => PriceListCategoryPage()),
                                        // );
                                        break;
                                      case 3:
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => PartnerCategoryPage()),
                                        // );
                                        break;
                                      case 4:
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => PartnerCategoryPage()),
                                        // );
                                        break;
                                      case 5:
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => PartnerCategoryPage()),
                                        // );
                                        break;
                                      case 6:
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => PartnerCategoryPage()),
                                        // );
                                        break;
                                      case 7:
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => PartnerCategoryPage()),
                                        // );
                                        break;
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/banhang.png',
                                        height: 30,
                                      ),
                                      Text(
                                        'BÁN HÀNG',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // margin: EdgeInsets.only(top: 70),
                                width: 120,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 15.0,
                                        offset: Offset(0.0, 0.75))
                                  ],
                                ),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewScreen()),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/baocao.png',
                                          height: 30,
                                        ),
                                        Text(
                                          'BÁO CÁO',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(150, 50),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 0.75))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(left: 7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 15.0,
                                        offset: Offset(0.0, 0.75))
                                  ],
                                ),
                                child: OutlinedButton(
                                    onPressed: () {},
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/viengtham.png',
                                          height: 40,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          'VIẾNG THĂM',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(150, 50),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 15.0,
                                        offset: Offset(0.0, 0.75))
                                  ],
                                ),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderListScreen()),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/DsDH.png',
                                          height: 40,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          'DS ĐƠN HÀNG',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(150, 50),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 15.0,
                                        offset: Offset(0.0, 0.75))
                                  ],
                                ),
                                child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OrderPage()),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/Donhang.png',
                                          height: 40,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          'ĐƠN HÀNG',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(150, 50),
                                        side: BorderSide(
                                            color: Colors.transparent))),
                              )
                            ],
                          ),
                          Container(
                            // color: Colors.blue,
                            // height: 10,
                            margin: EdgeInsets.only(top: 20, left: 35),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.black54,
                                              blurRadius: 15.0,
                                              offset: Offset(0.0, 0.75))
                                        ],
                                      ),
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => APISoap()),
                                      );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/doipass.png',
                                                height: 40,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                              ),
                                              Text(
                                                'ĐỔI PASS',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              minimumSize: Size(150, 50),
                                              side: BorderSide(
                                                  color: Colors.transparent))),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsets.only(left: 50),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.black54,
                                              blurRadius: 15.0,
                                              offset: Offset(0.0, 0.75))
                                        ],
                                      ),
                                      child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ApiSave()),
                                      );
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/KH_onl.png',
                                                height: 40,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                              ),
                                              Text(
                                                'KH ONLINE',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          style: OutlinedButton.styleFrom(
                                              minimumSize: Size(150, 50),
                                              side: BorderSide(
                                                  color: Colors.transparent))),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
                ),
              ],
            ),
          )
        ]));

    // Container(
    //   color: Colors.transparent,
    //   width: double.infinity,
    //   height: double.infinity,
    //   alignment: Alignment.center,
    //   // child: getselectedWidget(index: index)
    // ),
  }

//   Widget getselectedWidget({required int index}) {
//   Widget widget;
//   switch (index) {
//     // case 0:
//     //   widget = info_page();
//     //   break;
//     // case 1:
//     //   widget = history_page();
//     //   break;
//     // case 2:
//     //   widget = FrendsTab();
//     //   break;
//     // case 3:
//     //   widget = const backpack_page();
//     //   break;
//     // default:
//     //   widget = info_page();
//     //   break;
//   }

//   return widget;
// }

}
