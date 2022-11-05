// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/uri_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.title, required this.orderId});

  static String id = 'pay';

  final String title;
  final String orderId;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pay with Razorpay',
            ),
            ElevatedButton(
                onPressed: () {
                  print('brother id is: ${widget.orderId}');
                  Razorpay razorpay = Razorpay();
                  var options = {
                    'key': 'rzp_test_qpZKjldGnI3hJS',
                    'amount': 100,
                    'name': 'Acme Corp.',
                    'description': 'Fine T-Shirt',
                    'order_id': widget.orderId,
                    'retry': {'enabled': true, 'max_count': 1},
                    'send_sms_hash': true,
                    'prefill': {
                      'contact': '8888888888',
                      'email': 'test@razorpay.com'
                    },
                    'external': {
                      'wallets': ['paytm']
                    }
                  };
                  razorpay.on(
                      Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                  razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                      handlePaymentSuccessResponse);
                  razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                      handleExternalWalletSelected);
                  razorpay.open(options);
                },
                child: const Text("Pay with Razorpay")),
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  //function to get locally stored user ID
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

//POST req, Add Agents Function
  void _paySuccess(id, sign) async {
    var data = {"razorpay_payment_id": id, "razorpay_signature": sign};
    //checks if valid user by auth in API
    String? token = '';
    await getToken().then((result) {
      token = result;
    });
    if (token != null) {
      try {
        Response response = await post(
          Uri.parse('$config/api/result/'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: data,
        );

        if (response.statusCode == 202) {
          // ignore: use_build_context_synchronously
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
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

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    print(response.paymentId);
    print(response.signature);
    _paySuccess(response.paymentId, response.signature);
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
