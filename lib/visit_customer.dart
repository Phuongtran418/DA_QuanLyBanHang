import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:opc_app_main/call_api.dart';
import 'package:opc_app_main/checkin_customer.dart';
import 'package:opc_app_main/main_screen.dart';




import 'package:shared_preferences/shared_preferences.dart';

class VisitCustomerPage extends StatefulWidget {
  late final bool isLoggedIn;
  @override
  VisitCustomerPageState createState() => VisitCustomerPageState();
}

class VisitCustomerPageState extends State<VisitCustomerPage> {
  var filter, skip, top, format, expand, maCbNV;

  final String url2 = "http://118.69.225.144/api/user";
  List<Customer> data = [];
  List<Customer> filteredData = [];

  TextEditingController _businessPartnerNameController =
      TextEditingController();
  TextEditingController _internalIDController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String currentSearchText = '';

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String maCbNv = prefs.getString('maCbNv')!;
    maCbNV = maCbNv;
    print(maCbNv);
    final String url =
        "https://my427593.businessbydesign.cloud.sap/sap/byd/odata/cust/v1/khcustomertest/CustomerCurrentEmployeeResponsibleCollection?\$format=json&\$expand=Customer&\$filter=EmployeeID eq " +
            "'" +
            maCbNV +
            "'";
    final username = "OPCIT";
    final password = "Welcome2";
    final credentials = base64Encode(utf8.encode('$username:$password'));
    final headers = {
      'Authorization': 'Basic $credentials',
      'User-Agent': 'MyApp/1.0'
    };
    final response = await http.get(Uri.parse(Uri.encodeFull(url)),
        headers: headers); // đường link api thứ nhất
    // final response2 = await http.get(Uri.parse(Uri.encodeFull(url2)),
    //     headers: header2); // đường link api thứ hai
    setState(() {
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        var results = decodedJson['d']['results'];
        for (int i = 0; i < results.length; i++) {
          var customerJson = results[i]['Customer'];
          data.add(Customer.fromJson(customerJson));
          filteredData.add(Customer.fromJson(customerJson));
        }
      } else {
        throw Exception('Failed to load data');
      }

      // if (response2.statusCode == 200) {
      //   final decodedJson2 = json.decode(response2.body);
      //   // xử lý dữ liệu tại đây
      // } else {
      //   throw Exception('Failed to load data from URL 2');
      // }
    });
  }

// Mã là một hàm được gọi khi nhấp vào nút tìm kiếm.
//  Mã đầu tiên thiết lập một đối tượng với hai thuộc tính: filteredData và data.
//  Sau đó, nó lặp lại thông qua tất cả các khách hàng trong cơ sở dữ liệu, sử dụng
//biểu thức lambda để lọc ra chỉ những người có tên đối tác kinh doanh hoặc ID nội
//bộ của họ khớp với những gì được nhập vào trường văn bản trên màn hình.
//  Sau đó, nó trả về một danh sách các đối tượng này sẽ được hiển thị trong giao diện người dùng.
//  Mã bắt đầu bằng cách thiết lập một đối tượng có hai thuộc tính: filteredData và data.
//  Sau đó, nó lặp lại thông qua tất cả các khách hàng trong cơ sở dữ liệu, sử dụng biểu thức
//lambda để lọc ra chỉ những người có tên đối tác kinh doanh hoặc ID nội bộ của họ khớp với những gì
//được nhập vào trường văn bản trên màn hình.
//  Sau đó, nó trả về một danh sách các đối tượng này sẽ được hiển thị trong giao diện người dùng
//  Mã sẽ tìm kiếm chuỗi "tìm kiếm" trong trường văn bản.
  // void _search() {
  //   String searchText = _searchController.text.toLowerCase();
  //   setState(() {
  //     filteredData = data.where((customer) {
  //       return (customer.businessPartnerName?.toLowerCase() ?? '')
  //               .contains(searchText) ||
  //           (customer.internalID?.toLowerCase() ?? '').contains(searchText);
  //     }).toList();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 54, 168, 89),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageMain(isLoggedIn: true,)),
                    );
                  },
                  icon: Icon(Icons.arrow_back_sharp)),
              Text("Viếng thăm khách hàng"),
            ],
          )),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(hintText: "Tìm kiếm"),
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  currentSearchText = value.toLowerCase();
                  filteredData = data.where((customer) {
                    return (customer.businessPartnerName?.toLowerCase() ?? '')
                            .contains(currentSearchText) ||
                        (customer.internalID?.toLowerCase() ?? '')
                            .contains(currentSearchText);
                  }).toList();
                  print(data);
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              filteredData[index]
                                      .businessPartnerName
                                      .toString() ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              filteredData[index].internalID.toString() ?? "",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  filteredData[index].objectID.toString() ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 173, 173, 173),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "BẢN ĐỔ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
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
                                onPressed: () {},
                                child: Text(
                                  "BÁO CÁO",
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
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckInCustomerPage(
                                        businessPartnerName: filteredData[index]
                                                .businessPartnerName ??
                                            '',
                                        internalID:
                                            filteredData[index].internalID ??
                                                '',
                                        objectID:
                                            filteredData[index].objectID ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "CHECK IN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

