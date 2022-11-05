// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, unused_element, avoid_print, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';
import 'package:inspirathon/model.dart';
import 'package:inspirathon/uri_config.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:inspirathon/pages/checkOut_page.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/pages/login_page.dart';
import 'package:navigator/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationDetail extends StatefulWidget {
  static String id = 'location detail page';

  final String location_id;

  const LocationDetail({
    Key? key,
    required this.location_id,
  });

  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  Welcome? finalLoc;
  bool _isLoaded = false;
  @override
  void initState() {
    super.initState();
    _getOneLocation();
  }

  //GET req calling list of locations from API
  _getOneLocation() async {
    var id = widget.location_id;
    try {
      var res = await get(Uri.parse('$config/api/single-place/$id/'));
      // print(res.body);
      if (res.statusCode == 200) {
        // var rest = data;
        // print(rest);
        final locationData = await welcomeFromJson(res.body);
        print("List Size: ${locationData.multiImgs.first.img}");
        finalLoc = locationData;
        setState(() {
          _isLoaded = true;
        });
      }
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  //function to get locally stored user ID
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded
        ? Scaffold(
            backgroundColor: Colors.orange[100],
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                // child: appLogo,
              ),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.orange[600],
            ),
//Display Agent Details
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 40, 10, 40),
                    child: Text(
                      'Location Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 140,
                      width: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(finalLoc!.img),
                      )),
                    ),
                  ),
//Name tile
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: Colors.orange.shade300,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 2, top: 6),
                        child: Icon(
                          Icons.apartment,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Name:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(finalLoc!.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ),
//email tile
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: Colors.orange.shade300,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 6),
                        child: Icon(
                          Icons.book,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Description:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          finalLoc!.description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
//phone tile
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      tileColor: Colors.orange.shade300,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 6),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Location:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          finalLoc!.locality,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
//location tile
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      // shape: roundedRectangleBorder,
                      tileColor: Colors.orange.shade300,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 5, top: 6),
                        child: Icon(
                          Icons.star,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Rating:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          finalLoc!.ratings.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        String name = finalLoc!.name;
                        var img = finalLoc!.img;
                        //checks if valid user by auth in API
                        String? token = '';
                        await getToken().then((result) {
                          token = result;
                        });
                        if (token != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOutPage(
                                        id: finalLoc!.id,
                                        name: finalLoc!.name,
                                        id2: finalLoc!.slots,
                                      )));
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Please Login Before Booking!'),
                            ),
                            barrierDismissible: true,
                          );
                          print(
                              'id in loc: ${finalLoc!.id}'); // ignore: use_build_context_synchronously
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckOutPage(
                                        id: finalLoc!.id,
                                        name: finalLoc!.name,
                                        id2: finalLoc!.slots,
                                      )));
                        }
                      },
                      child: Container(
                        color: Colors.orange[600],
                        height: 40,
                        width: 100,
                        child: Center(
                          child: Text(
                            'Book Now!',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.yellow,
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
