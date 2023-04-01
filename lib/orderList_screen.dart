import 'package:flutter/material.dart';
import 'package:opc_app_main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:opc_app_main/api_call_statistics.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class OrderListScreen extends StatefulWidget {
  @override
  OrderListScreenState createState() => OrderListScreenState();
}

class OrderListScreenState extends State<OrderListScreen> {
  @override
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  final _searchControllerCustomer = TextEditingController();
  var maCbNV;
  List<Results> data = [];
  List<Results> filteredData = [];
  List<Results> _allCustomers = [];
  Results? _selectedCustomer;
  String currentSearchTextCustomer = '';
  bool _isItemSelected = false;
  bool _isResultSelected = false;
  bool _isDoneSelected = false;
  int startDay = 0, startMonth = 0, startYear = 0;
  int endDay = 0, endYear = 0, endMonth = 0;

  double? soluong = 0, gia = 0, tien = 0, thue = 0, thanhtien = 0;
  String kCNINVQTYFormatted = '';
  dynamic SL = 0;
  dynamic TT = 0;
  dynamic giaGoc = 0;
  List<double> result = [];
  void handleDateRange() {
    DateTime startDate = DateTime.parse(_startDateController.text);
    DateTime endDate = DateTime.parse(_endDateController.text);
    int startDay = startDate.day; // lấy giá trị ngày bắt đầu
    int startMonth = startDate.month; // lấy giá trị tháng bắt đầu
    int startYear = startDate.year; // lấy giá trị năm bắt đầu

    int endDay = endDate.day; // lấy giá trị ngày kết thúc
    int endMonth = endDate.month; // lấy giá trị tháng kết thúc
    int endYear = endDate.year; // lấy giá trị năm kết thúc

    print(
        'Ngày bắt đầu: $startDay, Tháng bắt đầu: $startMonth, Năm bắt đầu: $startYear');
    print(
        'Ngày kết thúc: $endDay, Tháng kết thúc: $endMonth, Năm kết thúc: $endYear');
  }

  List<Results> removeDuplicates(List<Results> list) {
    Map<String, Results> map = {};

    for (Results item in list) {
      map[item.cDOCUUID!] = item;
    }
    return map.values.toList();
  }

  Future<void> fetchData1() async {
    // Khởi tạo biến progress và loaded
    bool loaded = false;
    double progress = 0.0;
    // Lấy SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      progress = 0.01;
    });
    // Lấy mã cán bộ nhân viên từ SharedPreferences
    String? maCbNv = prefs.getString('maCbNv');
    if (maCbNv != null) {
      maCbNV = maCbNv;
      print("Mã được in ra của API 2 là: " + maCbNv);
      // Tiếp tục xử lý dữ liệu
    } else {
      // Xử lý lỗi
      print('Không tìm thấy mã cán bộ nhân viên!');
    }
    var _ci = 'CI';
    final String url =
        "https://my427593.businessbydesign.cloud.sap/sap/byd/odata/ana_businessanalytics_analytics.svc/RPCRMCIVIB_Q0001QueryResults?\$select=CDOC_YEAR,CDOC_CREATED_DT,KCINV_QTY,CIPR_REFO_CATCP,CIPR_PROD_UUID,TIPR_PROD_UUID,KKITM_NET_AM_RC,TIPR_REFO_CATCP,CIPR_REFO_PRDTY,TIPR_REFO_PRDTY,CIP_SAL_EMP,TIP_SAL_EMP,CDOC_UUID,CDOC_PROC_TYPE,CDPY_BUYER_UUID,TDPY_BUYER_UUID,CDOC_INV_DATE,CDOC_YEAR_MONTH,KCNT_REVENUE,KCNT_VAL_INV,KKITM_GROSS_AMT&\$format=json&\$filter=PARA_CAL_DAY gt datetime'2023-02-01T00:00:00'  &\$filter=PARA_CAL_DAY lt datetime'2023-02-28T00:00:00'  and CIP_SAL_EMP eq " +
            "'" +
            maCbNV +
            "'" +
            " and CDOC_PROC_TYPE eq'CI' and (CDOC_INV_DATE ge datetime'2023-02-01T00:00:00' and CDOC_INV_DATE le datetime'2023-02-28T00:00:00')&\$top=200&\$skip=0";
    final username = "OPCIT";
    final password = "Welcome2";
    final credentials = base64Encode(utf8.encode('$username:$password'));
    final headers = {
      'Authorization': 'Basic $credentials',
      'User-Agent': 'MyApp/1.0',
      'Accept': 'application/json'
    };
    final response =
        await http.get(Uri.parse(Uri.encodeFull(url)), headers: headers);

    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      var results = decodedJson['d']['results'];
      for (int i = 0; i < results.length; i++) {
        var customerJson = results[i];
        data.add(Results.fromJson(customerJson));
      }
      filteredData = removeDuplicates(data);
    } else {
      throw Exception('Failed to load data');
    }
    for (int i = 0; i < filteredData.length; i++) {
      soluong = double.parse(filteredData[i].kCNINVQTY.toString());
      giaGoc = double.parse(filteredData[i].kCNTREVENUE.toString());
      final String kCNINVQTYFormatted =
          NumberFormat.currency(locale: 'vi_VN').format(soluong ?? 0);
      TT = (soluong! * giaGoc)!;
      print(TT.toString());
    }
  }

  Future<Results?> _showCustomerList(BuildContext context) async {
    return showDialog<Results>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Danh sách đối tượng'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(data[index].tDPYBUYERUUID ?? ''),
                  trailing: Text(data[index].cDPYBUYERUUID ?? ''),
                  onTap: () {
                    Navigator.of(context).pop(data[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    fetchData1();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Widget build(BuildContext) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromRGBO(10, 141, 94, 1),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePageMain(
                                  isLoggedIn: true,
                                )),
                      );
                    },
                    icon:
                        Icon(Icons.navigate_before_sharp, color: Colors.white)),
                Text('BẢNG KÊ HOÁ ĐƠN BÁN HÀNG',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Labrada',
                        fontSize: 15))
              ],
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime.now(),
                            onConfirm: (date) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);
                              _startDateController.text = formattedDate;
                            },
                            locale: LocaleType.vi,
                          );
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            controller: _startDateController,
                            decoration: InputDecoration(
                              labelText: 'Ngày bắt đầu',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime.now(),
                            onConfirm: (date) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);
                              _endDateController.text = formattedDate;
                            },
                            locale: LocaleType.vi,
                          );
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            style: TextStyle(fontSize: 10, color: Colors.white),
                            controller: _endDateController,
                            decoration: InputDecoration(
                              labelText: 'Ngày kết thúc',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // color: Colors.red,
                        //margin: EdgeInsets.all(10),
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                            // onChanged: _handleTextFieldChanged,
                            decoration: InputDecoration(
                                hintText: 'Chọn mã đối tượng',
                                hintStyle: TextStyle(fontFamily: 'Labrada')),
                            controller: _searchControllerCustomer,
                          ),
                          suggestionsCallback: (pattern) async {
                            // Lấy danh sách các gợi ý dựa trên từ khóa tìm kiếm
                            return data.where((customer) {
                              return (customer.tDPYBUYERUUID?.toLowerCase() ??
                                          '')
                                      .contains(pattern.toLowerCase()) ||
                                  (customer.cDPYBUYERUUID?.toLowerCase() ?? '')
                                      .contains(pattern.toLowerCase());
                            }).toList();
                          },
                          itemBuilder: (context, suggestion) {
                            // Hiển thị gợi ý trong danh sách
                            return ListTile(
                              title: Text(suggestion.tDPYBUYERUUID ?? ''),
                              subtitle: Text(suggestion.cDPYBUYERUUID ?? ''),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            // Xử lý sự kiện khi người dùng chọn một gợi ý
                            setState(() {
                              _selectedCustomer = suggestion;
                              _searchControllerCustomer.text =
                                  _selectedCustomer?.tDPYBUYERUUID ?? '';
                              currentSearchTextCustomer = _selectedCustomer
                                      ?.tDPYBUYERUUID
                                      ?.toLowerCase() ??
                                  '';
                              filteredData = data.where((customer) {
                                return (customer.tDPYBUYERUUID?.toLowerCase() ??
                                            '')
                                        .contains(currentSearchTextCustomer) ||
                                    (customer.cDPYBUYERUUID?.toLowerCase() ??
                                            '')
                                        .contains(currentSearchTextCustomer);
                              }).toList();
                              _isItemSelected = false;
                              _isResultSelected =
                                  true; // đánh dấu là đã chọn kết quả
                            });
                          },
                        ),
                      ),
                    ),
                    //SizedBox(width: 10),
                    Visibility(
                      visible: !_isDoneSelected,
                      child: Container(
                        width: 70,
                        child: Expanded(
                          child: Container(
                            // margin: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                _showCustomerList(context).then((value) {
                                  setState(() {
                                    _selectedCustomer = value;
                                    _searchControllerCustomer.text =
                                        _selectedCustomer?.tDPYBUYERUUID ?? '';
                                    currentSearchTextCustomer =
                                        _selectedCustomer?.tDPYBUYERUUID
                                                ?.toLowerCase() ??
                                            '';
                                    filteredData = data.where((customer) {
                                      return (customer.tDPYBUYERUUID
                                                      ?.toLowerCase() ??
                                                  '')
                                              .contains(
                                                  currentSearchTextCustomer) ||
                                          (customer.cDPYBUYERUUID
                                                      ?.toLowerCase() ??
                                                  '')
                                              .contains(
                                                  currentSearchTextCustomer);
                                    }).toList();
                                  });
                                });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    // color: Colors.black,
                                    margin: EdgeInsets.only(left: 10),
                                    width: 50,
                                    child: Row(children: [
                                      Icon(Icons.arrow_drop_down),
                                      //SizedBox(width: 10),
                                      if (_selectedCustomer != null)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedCustomer = null;
                                              _searchControllerCustomer.text =
                                                  '';
                                              currentSearchTextCustomer = '';
                                              filteredData = data;
                                              _isDoneSelected = false;
                                            });
                                          },
                                          child: Icon(Icons.close),
                                        ),
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(10, 141, 94, 1),
                          minimumSize: Size(60, 50), //<-- SEE HERE
                        ),
                        child:
                            Text('Xem', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          handleDateRange();
                          fetchData1();
                        },
                      ),
                    )),
                  ],
                ),
              ),
              Container(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  columnWidths: {
                    0: FixedColumnWidth(100),
                    1: FixedColumnWidth(100),
                    2: FixedColumnWidth(100),
                    3: FixedColumnWidth(100),
                    4: FixedColumnWidth(100),
                    5: FixedColumnWidth(100),
                    6: FixedColumnWidth(100),
                    7: FixedColumnWidth(100),
                    8: FixedColumnWidth(100),
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Số CT",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Ngày CT",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Đối tượng",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Vật tư",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Số lượng",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Giá",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Tiền",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Thuế",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Tổng tiền",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontFamily: 'Labrada',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    for (int i = 0; i < filteredData.length; i++)
                      TableRow(children: [
                        TableCell(
                          child: Text(filteredData[i].cDOCUUID.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].cDOCYEARMONTH.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].tDPYBUYERUUID.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].tIPRPRODUUID.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].kCNINVQTY.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].kCNTVALINV.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(TT.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].tIPRPRODUUID.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                        TableCell(
                          child: Text(filteredData[i].tIPRPRODUUID.toString(),
                              style: TextStyle(fontFamily: 'Amiri')),
                        ),
                      ]),
                  ],
                ),
              ))
            ],
          ),
        ));
  }
}
