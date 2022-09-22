import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:outshade_internship/user_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('database1');
  await Hive.openBox('database2');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String age_value;
  late String gender_value;
  late List data = [];
  late Box DBboxOne;
  late Box DBboxTwo;

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/data.json');
    setState(() => data = json.decode(jsonText));
    return 'success';
  }

  void createBox() {
    DBboxOne = Hive.box("database1");
    DBboxTwo = Hive.box('database2');
  }

  @override
  void initState() {
    super.initState();
    this.loadJsonData();
    createBox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFFFF5E4)),
      home: Scaffold(
        backgroundColor: Color(0xFFFFF5E4),
        appBar: AppBar(
          title:  Text("OutShade Digital Media Assignment",
            style: GoogleFonts.poppins(
            ),
          ),
          backgroundColor: Color(0xFFFF9494),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFFFFF5E4),
          ),
        ),
        body: SafeArea(
            child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  var name = data[index]['name'];
                  late String userName;

                  return Container(
                    color: const Color(0xFFFFF5E4),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(child: Text(name)),
                        ),
                        DBboxOne.get(name) == null
                            ? ElevatedButton(
                                child: const Text('Sign In'),
                                style: ElevatedButton.styleFrom(
                                   backgroundColor: Color(0xFFFF9494)),
                                onPressed: () {
                                  userName = data[index]['name'];
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                      backgroundColor: Color(0xFFFFF5E4),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))),
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(height: 20),
                                            TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Enter Your Age',
                                                hintText: 'Age',
                                                hintStyle: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 10),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(50),
                                                    borderSide: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              onChanged: (text) {
                                                age_value = text;
                                              },
                                            ),
                                            SizedBox(height: 20),
                                            TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Enter Your Gender',
                                                hintText: 'Gender',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(50),
                                                    borderSide: const BorderSide(
                                                        color: Colors.grey)),
                                              ),
                                              onChanged: (text) {
                                                gender_value = text;
                                              },
                                            ),
                                            SizedBox(height: 20),
                                            ElevatedButton(
                                              child: Text('Sign In'),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFFFF9494)),
                                              onPressed: () {
                                                setState(() {});
                                                if (age_value == null ||
                                                    gender_value == null) {
                                                  print('Nothing');
                                                } else {
                                                  DBboxOne.put(userName, age_value);
                                                  DBboxTwo.put(userName, gender_value);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserPage(
                                                              userName,
                                                              age_value,
                                                              gender_value),
                                                    ),
                                                  );;
                                                }
                                              },
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : buildElevatedButton(
                                data[index]['name'], index, context),
                        Divider(),
                      ],
                    ),
                  );
                })),
      ),
    );
  }

  Row buildElevatedButton(String user_name, int index, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text('Sign Out'),
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF9494)),
          onPressed: () {
            user_name = data[index]['name'];
            setState(() {
              DBboxOne.delete(user_name);
              DBboxTwo.delete(user_name);
            });
          },
        ),
        const SizedBox(width: 10),
        ElevatedButton(
            child: Text('Sign In'),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD1D1)),
            onPressed: () {
              user_name = data[index]['name'];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserPage(user_name, DBboxOne.get(user_name), DBboxTwo.get(user_name)),
                ),
              );
            }),
        const SizedBox(height: 10),
      ],
    );
  }
}
