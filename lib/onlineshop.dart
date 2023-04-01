import 'package:dart_mysql/dart_mysql.dart';
import 'package:flutter/material.dart';

class SQLExamplePage extends StatefulWidget {
  const SQLExamplePage({Key? key}) : super(key: key);

  @override
  _SQLExamplePageState createState() => _SQLExamplePageState();
}

class MySQLExample {
  static const String _host = '115.73.221.53';
  static const int _port = 1433;
  static const String _user = 'sa';
  static const String _password = 'Hai@thong';
  static const String _database = 'OnlineShop';

  MySqlConnection? _connection;

  Future<MySqlConnection> _getConnection() async {
    if (_connection == null) {
      final settings = ConnectionSettings(
        host: _host,
        port: _port,
        user: _user,
        password: _password,
        db: _database,
      );
      _connection = await MySqlConnection.connect(settings);
      print('Connected to MySQL database');
    }
    return _connection!;
  }

  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    print('Disconnected from MySQL database');
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final connection = await _getConnection();
    final results = await connection.query('SELECT ID, Name FROM Categories');
    return results.map((resultRow) => resultRow.fields).toList();
  }
}

class _SQLExamplePageState extends State<SQLExamplePage> {
  final MySQLExample _mySql = MySQLExample();
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<Map<String, dynamic>>> _fetchCategories() async {
    try {
      final connection = await _mySql._getConnection(); // Kết nối cơ sở dữ liệu trước khi gọi fetchCategories()
      final categories = await _mySql.fetchCategories();
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    } finally {
      await _mySql.disconnect();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text('${category['ID']} - ${category['Name']}'),
                );
              },
            );
          }
 else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching categories: ${snapshot.error}'),
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

  @override
  void dispose() {
    _mySql.disconnect();
    super.dispose();
  }
}
