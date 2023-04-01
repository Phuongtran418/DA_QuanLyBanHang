import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:collection/collection.dart';
import 'dart:collection';

class APISoap extends StatefulWidget {
  @override
  APISoapState createState() => APISoapState();
}

class APISoapState extends State<APISoap> {
  Future<String>? _futureResponse;
  List<Map<String, String>> _medicines = [];


  @override
  Future<String> fetchSalesPriceList() async {
    final String url =
        'https://my427593.businessbydesign.cloud.sap/sap/bc/srt/scs/sap/ManageSalesPriceListIn';
    final username = "_opc1";
    final password = "Opc@2022#";
    final credentials = base64Encode(utf8.encode('$username:$password'));

    String requestBody = '''
      <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <SOAP-ENV:Body>
          <n0:SalesPriceListFindByIDQuery_sync xmlns:n0="http://sap.com/xi/A1S/Global">
            <SalesPriceList>
              <!-- Identifier of Price / Discount List -->
              <ID>LIST PRICE 1</ID>
            </SalesPriceList>
          </n0:SalesPriceListFindByIDQuery_sync>
        </SOAP-ENV:Body>
      </SOAP-ENV:Envelope>
    ''';

    Map<String, String> headers = {
      'Content-Type': 'text/xml;charset=UTF-8',
      'Authorization': 'Basic $credentials',
      'SOAPAction': 'SalesPriceListFindByIDQuery_sync',
    };

    final response =
        await http.post(Uri.parse(url), headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      print(response.statusCode);
      return response.body;
    } else {
      throw Exception(
          'Failed to load sales price list: ${response.statusCode}');
    }
  }

  Future<void> fetchMedicines() async {
    final xmlData = await fetchSalesPriceList();
    final medicines = await parseXML(xmlData);
    setState(() {
      _medicines = medicines;
    });
  }

  Future<List<Map<String, String>>> parseXML(String xml) async {
  final document = XmlDocument.parse(xml);
  final descriptions = document.findAllElements('Description');
  final prices = document.findAllElements('PriceSpecification');
  final medicines = <String, Map<String, String>>{};

  for (var i = 0; i < descriptions.length; i++) {
    final description = descriptions.elementAt(i);
    final name = description.text.trim();
    final price = prices.length > i ? prices.elementAt(i).findElements('Amount').first?.text?.trim() ?? "" : "";
    String id = "";
    if (prices.length > i) {
      final priceElement = prices.elementAt(i); // lấy phần tử ở vị trí i
      final idElement = priceElement.findElements('PropertyValuation').firstOrNull?.findElements('PriceSpecificationElementPropertyValuation').firstOrNull?.findElements('PriceSpecificationElementPropertyValue').firstOrNull?.findElements('ID').firstOrNull;
      if (idElement != null) {
        id = idElement.text.trim();
      }
    }
    if (id.isNotEmpty && price.isNotEmpty) {
      if (!medicines.containsKey(name)) {
        medicines[name] = {'name': name, 'price': price, 'id': id};
      }
    }
  }

  return medicines.values.toList();
}

  @override
  void initState() {
    super.initState();
    fetchMedicines();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API SOAP'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: Future.value(_medicines),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final medicines = snapshot.data!;
            return ListView.builder(
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return ListTile(
                  title: Text(medicine['name']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${medicine['price']}'),
                      Text('ID: ${medicine['id']}'),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
