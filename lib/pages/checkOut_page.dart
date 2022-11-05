// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, unused_local_variable, non_constant_identifier_names, prefer_const_constructors_in_immutables, avoid_unnecessary_containers
import 'dart:convert';
import 'package:inspirathon/uri_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inspirathon/model.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/pages/paymentPage.dart';
import 'package:inspirathon/uri_config.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutPage extends StatefulWidget {
  static String page_id = "checkOut page";
  CheckOutPage({
    Key? key,
    required this.name,
    required this.id,
    required this.id2,
  });
  final String name;
  final String id;
  final List<Slot> id2;

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  TextEditingController dateinput = TextEditingController();
  int simpleIntInput = 1;
//function to get locally stored user ID
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//POST req, Add Agents Function
  void _booking(int quant, String date, id, id2, slot) async {
    var data = {
      "place_id": id.toString(),
      "quantity": quant.toString(),
      "date": date.toString(),
      "slot_id": "4ee09a3d-7f65-478f-a461-88f56340d1e2",
    };
    print(data);
    //checks if valid user by auth in API
    String? token = '';
    await getToken().then((result) {
      token = result;
    });
    if (token != null) {
      print('id is : ${widget.id}');
      try {
        Response response = await post(
          Uri.parse('$config/api/book-now/'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: data,
        );

        if (response.statusCode == 202) {
          print("checkout is 202");
          var textD = await checkOut();
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentPage(
                        title: 'title',
                        orderId: textD,
                      )));
          // print('booked');
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Booked Successfully!'),
                  ),
              barrierDismissible: true);
        }
      } catch (e) {
        print(e.toString());
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Unauthorised user!'),
              ),
          barrierDismissible: true);
    }
  }

  //GET req calling list of locations from API
  Future<String> checkOut() async {
    String? token = '';
    await getToken().then((result) {
      token = result;
    });
    PaymentData paymentData;
    try {
      var res = await get(
        Uri.parse('$config/api/checkout/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // print(res.body);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print("checkout is 200");
        paymentData = paymentDataFromJson(res.body);
        print('ID IS:${paymentData.cart.razorpayOrderId}');
        return paymentData.cart.razorpayOrderId;
      }
      // print("List Size: ${paymentData.cart}");
    } catch (e) {
      print('error is ${e.toString()}');
      return 'balo';
    }
    return 'helo';
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  // Initial Selected Value
  String dropdownvalue = '08:00 am';

  // List of items in our dropdown menu
  var items = [
    '08:00 am',
    '09:00 am',
    '10:00 am',
    '11:00 am',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[300],
      appBar: AppBar(
        title: Text(
          'CheckOut Page',
          style: TextStyle(color: Colors.black),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          // child: appLogo,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.orange[900],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Text(
              widget.name.toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     height: 80,
            //     width: 80,
            //     decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: NetworkImage(
            //                 widget.locationDataModel!.img.toString()))),
            //   ),
            // ),
            SizedBox(height: 40),
            QuantityInput(
                value: simpleIntInput,
                onChanged: (value) => setState(() =>
                    simpleIntInput = int.parse(value.replaceAll(',', '')))),
            SizedBox(height: 10),
            Text('Number of Tickets: $simpleIntInput',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: TextField(
                controller: dateinput, //editing controller of this TextField
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "Enter Date",
                ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement
                    setState(() {
                      dateinput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              'Select Visiting Slot ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )),
            // DropDownStuff(times: widget.id2),
            DropdownButton(
              iconEnabledColor: Colors.black,
              dropdownColor: Colors.orange[100],
              // Initial Value
              value: dropdownvalue,
              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),
              // Array list of items
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
            SizedBox(height: 30),
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orange[600])),
                onPressed: () {
                  print("testing book bton");
                  _booking(
                    simpleIntInput,
                    dateinput.text,
                    widget.id,
                    widget.id2,
                    dropdownvalue,
                  );
                },
                child: Text(
                  'BOOK',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }
}

// class DropDownStuff extends StatefulWidget {
//   const DropDownStuff({super.key, required this.times});
//   final List<Slot> times;

//   @override
//   State<DropDownStuff> createState() => _DropDownStuffState();
// }

// class _DropDownStuffState extends State<DropDownStuff> {
//   // late Slot time = widget.times.first;
//   Slot time = Slot(id: '5', startTime: '5', endTime: '7');
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<Slot>(
//       value: time,
//       icon: Icon(Icons.arrow_downward),
//       iconSize: 24,
//       elevation: 16,
//       style: TextStyle(color: Colors.purple[700]),
//       underline: Container(
//         height: 2,
//         color: Colors.purple[700],
//       ),
//       onChanged: (Slot? newServer) {
//         setState(() {
//           time = newServer!;
//         });
//       },
//       items: widget.times.map<DropdownMenuItem<Slot>>((Slot server) {
//         return DropdownMenuItem<Slot>(
//           value: server,
//           child: Text(server.startTime, style: TextStyle(fontSize: 20)),
//         );
//       }).toList(),
//     );
//   }
// }

PaymentData paymentDataFromJson(String str) =>
    PaymentData.fromJson(json.decode(str));

String paymentDataToJson(PaymentData data) => json.encode(data.toJson());

class PaymentData {
  PaymentData({
    required this.cart,
  });

  Cart cart;

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        cart: Cart.fromJson(json["cart"]),
      );

  Map<String, dynamic> toJson() => {
        "cart": cart.toJson(),
      };
}

class Cart {
  Cart({
    required this.id,
    required this.cartItems,
    required this.owner,
    required this.cost,
    required this.tax,
    required this.totalAmt,
    required this.couponApplied,
    required this.razorpayOrderId,
    required this.invoice,
  });

  String id;
  List<CartItem> cartItems;
  Owner owner;
  double cost;
  double tax;
  double totalAmt;
  bool couponApplied;
  String razorpayOrderId;
  dynamic invoice;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        cartItems: List<CartItem>.from(
            json["cart_items"].map((x) => CartItem.fromJson(x))),
        owner: Owner.fromJson(json["owner"]),
        cost: json["cost"],
        tax: json["tax"].toDouble(),
        totalAmt: json["total_amt"],
        couponApplied: json["coupon_applied"],
        razorpayOrderId: json["razorpay_order_id"],
        invoice: json["invoice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "owner": owner.toJson(),
        "cost": cost,
        "tax": tax,
        "total_amt": totalAmt,
        "coupon_applied": couponApplied,
        "razorpay_order_id": razorpayOrderId,
        "invoice": invoice,
      };
}

class CartItem {
  CartItem({
    required this.item,
    required this.quantity,
    required this.total,
    required this.date,
  });

  Item item;
  int quantity;
  double total;
  DateTime date;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        item: Item.fromJson(json["item"]),
        quantity: json["quantity"],
        total: json["total"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
        "quantity": quantity,
        "total": total,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

class Item {
  Item({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.locality,
    required this.price,
    required this.img,
    required this.ratings,
  });

  String id;
  String name;
  String shortDesc;
  String locality;
  double price;
  String img;
  double ratings;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        shortDesc: json["short_desc"],
        locality: json["locality"],
        price: json["price"],
        img: json["img"],
        ratings: json["ratings"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_desc": shortDesc,
        "locality": locality,
        "price": price,
        "img": img,
        "ratings": ratings,
      };
}

class Owner {
  Owner({
    required this.fName,
    required this.lName,
    required this.email,
    required this.phone,
  });

  String fName;
  String lName;
  String email;
  String phone;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "phone": phone,
      };
}
