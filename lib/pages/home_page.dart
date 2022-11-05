// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sort_child_properties_last, unnecessary_new, use_key_in_widget_constructors, unused_import, avoid_print, unused_element
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:inspirathon/uri_config.dart';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inspirathon/pages/checkOut_page.dart';
import 'package:inspirathon/pages/locationDetail_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String id = "Home_page";
  final LocationDataModel? locationDataModel;
  const HomePage({
    Key? key,
    this.locationDataModel,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences sharedPreferences;
  String searchString = "";
  TextEditingController editingController = TextEditingController();
  Widget listView(List<LocationDataModel> locationDataModel) {
    return Container(
      // ignore: prefer_const_literals_to_create_immutables
      child: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: TextField(
            cursorColor: Colors.black,
            onChanged: (value) {
              setState(() {
                searchString = value.toLowerCase();
              });
            },
            controller: editingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.orange[300],
              hintText: "Search Locations",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(40)),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: locationDataModel.length,
              itemBuilder: (BuildContext context, int index) {
                return locationDataModel[index]
                        .name!
                        .toLowerCase()
                        .contains(searchString)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationDetail(
                                  location_id:
                                      locationDataModel[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 130,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  locationDataModel[index]
                                                      .img
                                                      .toString()))),
                                    ),
                                    SizedBox(width: 40),
                                    Column(
                                      children: [
                                        SizedBox(height: 6),
                                        Text(
                                          'Name: ${locationDataModel[index].name.toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Desc: ${locationDataModel[index].desc.toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Locality: ${locationDataModel[index].locality.toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text(
                                              'Price: ${locationDataModel[index].price.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              'Rating: ${locationDataModel[index].ratings.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            color: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
              }),
        )
      ]),
    );
  }

  //GET req calling list of locations from API
  Future<List<LocationDataModel>> _getLocation() async {
    List<LocationDataModel> locationData = [];
    try {
      var res = await get(Uri.parse('$config/api/all-places/'));
      // print(res.body);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var rest = data as List;
        print(rest);
        locationData = rest
            .map<LocationDataModel>((json) => LocationDataModel.fromJson(json))
            .toList();
      }
      print("List Size: ${locationData.length}");
      return locationData;
    } catch (e) {
      print(e.toString());
      return locationData;
    }
  }

  // Image appLogo = new Image(
  //   image: ExactAssetImage("assets/goa-app-bar.png"),
  //   height: 50.0,
  //   width: 50.0,
  //   alignment: FractionalOffset.center,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          // child: appLogo,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.orange[600],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.orange[100],
        width: 200,
        // drawer logout button
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // logOut user and clear user data from local storage
                          showDialog(
                              context: context,
                              builder: (ctxt) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 100.0),
                                  child: AlertDialog(
                                    backgroundColor: Colors.orange[100],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    contentPadding: EdgeInsets.all(0),
                                    title: Center(
                                      child: Text(
                                        "Logout!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.all(30.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Do you really want to logout?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(height: 40),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: 115,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .orange[600]),
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              SizedBox(
                                                width: 115,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.orange[600],
                                                  ),
                                                  child: Text(
                                                    "Logout",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.remove('token');
                                                    // Navigator.popAndPushNamed(
                                                    //     context, '/');
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/',
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getLocation(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              print(snapshot.data);
              return Container(
                child: Center(
                  child: Text('Loading Location....'),
                ),
              );
            }
            return listView(snapshot.data);
          }),
    );
  }
}

//function to get location details
class LocationDataModel {
  String? id;
  String? name;
  String? desc;
  String? locality;
  double ratings;
  String? img;
  double price;

  LocationDataModel(this.id, this.name, this.desc, this.locality, this.ratings,
      this.img, this.price);

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      json['id'],
      json['name'],
      json['short_desc'],
      json['locality'],
      json['ratings'],
      json['img'],
      json['price'],
    );
  }
}
