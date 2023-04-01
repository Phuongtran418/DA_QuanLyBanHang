import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:opc_app_main/main_screen.dart';

class ApiSave extends StatefulWidget {
  @override
  ApiSaveState createState() => ApiSaveState();
}

class ApiSaveState extends State<ApiSave> {
  final TextEditingController productIDController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController decimalValueController = TextEditingController();
  final TextEditingController partyIDController = TextEditingController();

  Future<String> fetchData() async {
    String productID = productIDController.text;
    String quantity = quantityController.text;
    String decimalValue = decimalValueController.text;
    String partyID = partyIDController.text;

    final String url =
        'https://my427593.businessbydesign.cloud.sap/sap/bc/srt/scs/sap/managesalesorderin5';
    final username = '_opc1';
    final password = 'Opc@2022#';
    final credentials = base64Encode(utf8.encode('$username:$password'));
    String requestBody = ''' 
  <SOAP-ENV:Envelope   xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"   xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"   xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<SOAP-ENV:Body>
		<n0:SalesOrderBundleMaintainRequest_sync xmlns:n0="http://sap.com/xi/SAPGlobal20/Global" xmlns:ypj="http://0005837950-one-off.sap.com/YPJHSCV4Y_">
			<BasicMessageHeader/>
			<SalesOrder>
				<DATETIME>2023-03-29T12:00:00.1234567Z</DATETIME>
				<Name languageCode="EN">APP_OPC</Name>
				<Item>
					<ItemProduct>
						<ProductID>$productID</ProductID>
					</ItemProduct>
					<ItemScheduleLine>
						<Quantity>$quantity</Quantity>
					</ItemScheduleLine>
					<ypj:PromotionID></ypj:PromotionID>
					<ypj:OrgPrice currencyCode="VND">0.00</ypj:OrgPrice>
					<ypj:GiftItem>false</ypj:GiftItem>
					<ypj:PurchProductID></ypj:PurchProductID>
					<ypj:OrgPrice currencyCode="VND">0</ypj:OrgPrice>
					<ypj:TotalDiscAllocation currencyCode="VND">0</ypj:TotalDiscAllocation>
					<PriceAndTaxCalculationItem>
						<ItemMainDiscount>
							<Rate>                         
								<DecimalValue>$decimalValue</DecimalValue>           
							</Rate>
						</ItemMainDiscount>
					</PriceAndTaxCalculationItem>
				</Item>
				<AccountParty>
					<PartyID>$partyID</PartyID>
				</AccountParty>
			</SalesOrder>
		</n0:SalesOrderBundleMaintainRequest_sync>
	</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
   ''';

    Map<String, String> headers = {
      'Content-Type': 'text/xml;charset=UTF-8',
      'Authorization': 'Basic $credentials',
      'SOAPAction': 'SalesOrderBundleMaintainRequest_sync',
    };
    final response =
        await http.post(Uri.parse(url), headers: headers, body: requestBody);
    if (response.statusCode == 200) {
      var jsonResponse = json.encode(response.body);
      print(response.statusCode);
      print(response.body);
      return "success";
    } else {
      print('Request failed with status: ${response.statusCode}.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thêm thất bại')),
      );
      return "failed";
    }
  }

//   @override
// void initState(){
//   super.initState();
//   fetchData();
// }
  Widget build(BuildContext context) {
    return Scaffold(
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
                'API SAVE',
                style: TextStyle(fontFamily: 'Anton', color: Colors.black54),
              ),
              TextButton(
                onPressed: () async {
                  String message = await fetchData();
                  if (message == 'success') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text(
                          'Thêm thành công',
                          style: TextStyle(color: Colors.white),
                        )));
                    productIDController.clear();
                    quantityController.clear();
                    decimalValueController.clear();
                    partyIDController.clear();
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
        body: Container(
            child: Column(children: [
          TextField(
            controller: productIDController,
            decoration: InputDecoration(
              labelText: 'Product ID',
            ),
          ),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          TextField(
            controller: decimalValueController,
            decoration: InputDecoration(
              labelText: 'Decimal Value',
            ),
          ),
          TextField(
            controller: partyIDController,
            decoration: InputDecoration(
              labelText: 'Party ID',
            ),
          ),
        ])));
  }
}
