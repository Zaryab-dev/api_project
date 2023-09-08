import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'drop_down_model.dart';
import 'package:http/http.dart' as http;

class DropDownButtonScreen extends StatefulWidget {
  const DropDownButtonScreen({super.key});

  @override
  State<DropDownButtonScreen> createState() => _DropDownButtonScreenState();
}

class _DropDownButtonScreenState extends State<DropDownButtonScreen> {
  Future<List<DropDownModel>> getPost() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      final body = json.decode(response.body) as List;

      if (response.statusCode == 200) {
        return body.map((e) {
          final map = e as Map<String, dynamic>;
          return DropDownModel.fromJson(map);
        }).toList();
      }
    } on SocketException {
      throw Exception('No Internet');
    }
    throw Exception('Error While Fetching Data');
  }

  var selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drop Down APi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: getPost(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton(
                          isExpanded: true,
                          hint: const Text('Select your value'),
                          value: selected,
                          icon: const Icon(Icons.add),
                          items: snapshot.data!.map((e) {
                            return DropdownMenuItem(
                                value: e.id.toString(),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(e.id.toString()),
                                      Text(e.title.toString()),
                                    ],
                                  ),
                                ));
                          }).toList(),
                          onChanged: (value) {
                            selected = value;
                            setState(() {});
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
