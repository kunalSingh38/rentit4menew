import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me_new/themes/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool isLoading = true;
  final _key = UniqueKey();

  String title;
  String validemail = "Enter your email";
  WebViewController _controller;

  String url = "https://dev.techstreet.in/rentit4me/public/forget-password/";

  WebViewState(String title, String url) {
    this.title = title;
    this.url = url;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Forget Password", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: this.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(),
        ],
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     children: [
      //       Card(
      //         elevation: 4.0,
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Column(
      //             children: [
      //               const Align(
      //                 alignment: Alignment.topLeft,
      //                 child: Text("Reset Password", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
      //               ),
      //               const SizedBox(height: 10),
      //               const Align(
      //                   alignment: Alignment.topLeft,
      //                   child: Text("Enter your email address and we'll send you an email with instructons to reset your password.", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500))),
      //               SizedBox(height: 10),
      //               const Align(
      //                 alignment: Alignment.topLeft,
      //                 child: Text("Email", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.w700)),
      //               ),
      //               SizedBox(height: 10),
      //               Container(
      //                   decoration: BoxDecoration(
      //                       border: Border.all(
      //                           width: 1,
      //                           color: Colors.deepOrangeAccent
      //                       ),
      //                       borderRadius: BorderRadius.all(Radius.circular(12))
      //                   ),
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(left: 10.0),
      //                     child: TextField(
      //                       decoration: InputDecoration(
      //                         hintText: validemail,
      //                         border: InputBorder.none,
      //                       ),
      //                       onChanged: (value){
      //                         setState((){
      //                           validemail = value;
      //                         });
      //                       },
      //                     ),
      //                   )
      //               ),
      //               SizedBox(height: 5),
      //             ],
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       InkWell(
      //         onTap: () {
      //           //_generateticket();
      //         },
      //         child: Card(
      //           elevation: 8.0,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8.0),
      //           ),
      //           child: Container(
      //             height: 45,
      //             width: double.infinity,
      //             alignment: Alignment.center,
      //             decoration: const BoxDecoration(
      //                 color: Colors.deepOrangeAccent,
      //                 borderRadius: BorderRadius.all(Radius.circular(8.0))
      //             ),
      //             child: Text("Create", style: TextStyle(color: Colors.white)),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Future<void> _resetpassword() async {
    const url = "https://dev.techstreet.in/rentit4me/public/password/reset";
    if (await canLaunch(url))
      await launch(url);
    else
      // can't launch url, there is some error
      throw "Could not launch $url";
  }
}
