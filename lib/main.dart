import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android Emulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DataPage(),
    );
  }
}

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  Map<String, dynamic>? data;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    // Set a timer to fetch data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.105:3000/data'));

      if (response.statusCode == 200) {
        final newData = json.decode(response.body);
        if (data == null || newData.toString() != data.toString()) {
          setState(() {
            data = newData;
          });
        }
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IOT Data'),
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Suhu Max', '${data!['suhumax']}°C'),
                    _buildInfoRow('Suhu Rata-rata', '${data!['suhurata']}°C'),
                    _buildInfoRow('Suhu Min', '${data!['suhummin']}°C'),
                    SizedBox(height: 16.0),
                    Text(
                      'Nilai Suhu Max dan Humid Max',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ...data!['nilai_suhu_max_humid_max'].map<Widget>((item) => _buildDataItem(
                          'Index: ${item['idx']}',
                          'Suhu: ${item['suhu']}°C, Humid: ${item['humid']}%, Kecerahan: ${item['kecerahan']}',
                          'Timestamp: ${item['timestamp']}',
                        )),
                    SizedBox(height: 16.0),
                    Text(
                      'Month Year Max',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ...data!['month_year_max'].map<Widget>((item) => _buildDataItem(
                          'Month Year: ${item['month_year']}',
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDataItem(String title, [String? subtitle, String? timestamp]) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.0),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
            if (timestamp != null) ...[
              SizedBox(height: 8.0),
              Text(
                timestamp,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
