// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:quickblox_sdk/auth/module.dart';

import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:rentit4me_new/helper/loader.dart';
import 'package:rentit4me_new/network/api.dart';
import 'package:rentit4me_new/themes/constant.dart';
import 'package:rentit4me_new/views/advertiser_profile_screen.dart';
import 'package:rentit4me_new/views/conversation.dart';
import 'package:rentit4me_new/views/home_screen.dart';
import 'package:rentit4me_new/views/login_screen.dart';
import 'package:rentit4me_new/views/make_edit_offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  String productid;
  ProductDetailScreen({this.productid});

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState(productid);
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String productid;

  _ProductDetailScreenState(this.productid);

  String productname;
  String productprice;
  String description;
  String securitydeposit;
  String addedbyid;
  String addedby;
  String boostpack;
  String renttype;
  String renttypeid;
  String useramount;

  String query_id;
  String address;
  String price;
  String email;

  bool _checkData = false;
  bool _checkuser = false;

  String renttypename;
  String renteramount;
  String productamount;
  String securityamount;

  String negotiable;
  double totalrent = 0;
  double totalsecurity = 0;
  double finalamount = 0;
  double conviencechargeper = 0;
  double conviencevalue = 0;
  String days;

  List<dynamic> rentpricelist = [];
  List<String> renttypelist = [];

  List<dynamic> likedadproductlist = [];

  String productQty;
  String startDate = "From Date";
  String actionbtn;

  String capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  String productimage = "";

  String userid;
  String usertype;
  String trustedbadge;
  String trustedbadgeapproval;

  String appId = "96417";
  String authKey = "BmYxKrbn3HDthbc";
  String authSecret = "XRfs7bw3Y9H4yMc";
  String accountKey = "hr2cuVsMyCZXsZMEE32H";

  List productimages = [];

  final TextEditingController useramountController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController quantityContoller = TextEditingController();

  GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.42796133580664, -122.085749655962), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();

    // init();

    _getproductDetail(productid);
    _getcheckapproveData();
    _getmakeoffer(productid);

    _getgooglelocation();
  }

  _getgooglelocation() async {
    Position position = await _determinePosition();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14)));
    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude)));
    setState(() {});
  }

  // void init() async {
  //   //print(appId);
  //   //print(authKey);
  //   //print(authSecret);
  //   ////print(accountKey);
  //   try {
  //     await QB.settings.init(appId, authKey, authSecret, accountKey);
  //     mylogin();
  //   } on PlatformException catch (e) {
  //     // print(e);
  //     Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  // void mylogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   ////print(prefs.getString('quicklogin'));
  //   ////print(prefs.getString('quickpassword'));
  //   try {
  //     QBLoginResult result = await QB.auth.login(
  //         prefs.getString('quicklogin'), prefs.getString('quickpassword'));
  //     //_connectnow();
  //   } on PlatformException catch (e) {
  //     // Some error occurred, look at the exception message for more details
  //   }
  // }

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
            child: Icon(
              Icons.arrow_back,
              color: kPrimaryColor,
            )),
        title: Text("Detail", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: _checkData == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: productimage,
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/no_image.jpg'),
                      ),
                    ),
                    Container(
                      height: 80,
                      padding: EdgeInsets.only(top: 5),
                      width: size.width,
                      child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(width: 10),
                          itemCount: productimages.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  productimage = sliderpath +
                                      productimages[index]['upload_base_path']
                                          .toString() +
                                      productimages[index]['file_name']
                                          .toString();
                                });
                              },
                              child: Container(
                                height: 55,
                                width: size.width * 0.30,
                                child: CachedNetworkImage(
                                  imageUrl: sliderpath +
                                      productimages[index]['upload_base_path'] +
                                      productimages[index]['file_name'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          }),
                    ),
                    Divider(
                      thickness: 0.9,
                      height: 30,
                    ),
                    Text(productname,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    // SizedBox(height: 2.0),
                    Align(
                        alignment: Alignment.topLeft,
                        child: boostpack == "null" ||
                                boostpack == "" ||
                                boostpack == null
                            ? SizedBox()
                            : Container(
                                height: 25,
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(4.0)),
                                child: Text("Sponsored",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)))),
                    SizedBox(height: 15.0),
                    Align(
                        alignment: Alignment.topLeft,
                        child: description == "" ||
                                description == "null" ||
                                description == null
                            ? SizedBox()
                            : Text(description,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12))),
                    SizedBox(height: 35.0),
                    Align(
                        alignment: Alignment.topLeft,
                        child: renttype == null ||
                                renttype == "" ||
                                renttype == "null"
                            ? Text(productprice,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500))
                            : Text(productprice,
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500))),
                    SizedBox(height: 15.0),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("Security Deposit : INR $securitydeposit",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500))),
                    SizedBox(height: 15.0),
                    Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdvertiserProfileScreen(
                                            advertiserid: addedbyid)));
                          },
                          child: Text("Added By : $addedby",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        )),
                    SizedBox(height: 35.0),
                    userid == null || userid == ""
                        ? Container(
                            height: 60,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: Container(
                                    height: 45,
                                    width: size.width * 0.45,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22.0))),
                                    child: Text("LOGIN TO START DISCUSSION",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: Container(
                                    height: 45,
                                    width: size.width * 0.45,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22.0))),
                                    child: Text("RENT NOW",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _checkuser == false
                            ? Container(
                                height: 60,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(query_id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Conversation(
                                                        query_id: query_id)));
                                      },
                                      child: Container(
                                        height: 45,
                                        width: size.width * 0.45,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22.0))),
                                        child: Text("START DISCUSSION",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (trustedbadge == "1" &&
                                            trustedbadgeapproval
                                                    .toLowerCase() ==
                                                "pending") {
                                          showToast(
                                              "Your verification is under process.");
                                        } else {
                                          if (actionbtn == "Make An Offer") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MakeEditOfferScreen(
                                                          pageFor:
                                                              "Make an offer",
                                                          productid: productid,
                                                          nego: int.parse(
                                                              negotiable),
                                                          editable: false,
                                                        )));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MakeEditOfferScreen(
                                                          pageFor: "Edit Offer",
                                                          productid: productid,
                                                          nego: int.parse(
                                                              negotiable),
                                                          editable: true,
                                                        )));
                                          }
                                        }
                                      },
                                      // onTap: () {
                                      //   ////print("0");
                                      //   if (trustedbadge == "1") {
                                      //     ////print("trusted badge 1");
                                      //     if (trustedbadgeapproval
                                      //             .toLowerCase() ==
                                      //         "pending") {
                                      //       ////print("2");
                                      //       showToast(
                                      //           "Your verification is under process.");
                                      //     } else {
                                      //       ////print("3");
                                      //       if (actionbtn == "Make An Offer") {
                                      //         ////print("5");
                                      //         setState(() {
                                      //           productQty = null;
                                      //           totalrent = 0;
                                      //           useramount = null;
                                      //           days = null;
                                      //           totalsecurity = 0;
                                      //           finalamount = 0;
                                      //           conviencevalue = 0;
                                      //         });
                                      //         //print(renttypelist);
                                      //         showDialog(
                                      //             context: context,
                                      //             barrierDismissible: false,
                                      //             builder:
                                      //                 (context) =>
                                      //                     StatefulBuilder(
                                      //                         builder: (context,
                                      //                             setState) {
                                      //                       return AlertDialog(
                                      //                           title: const Align(
                                      //                               alignment:
                                      //                                   Alignment
                                      //                                       .topLeft,
                                      //                               widthFactor:
                                      //                                   20.0,
                                      //                               child: Text(
                                      //                                   "Make An Offer",
                                      //                                   style: TextStyle(
                                      //                                       color: Colors
                                      //                                           .deepOrangeAccent))),
                                      //                           content:
                                      //                               Container(
                                      //                             child:
                                      //                                 SingleChildScrollView(
                                      //                               child: Column(
                                      //                                   children: [
                                      //                                     DropdownButtonHideUnderline(
                                      //                                       child:
                                      //                                           DropdownButton<String>(
                                      //                                         hint: Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                      //                                         value: renttypename,
                                      //                                         elevation: 16,
                                      //                                         isExpanded: true,
                                      //                                         style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                      //                                         onChanged: (String data) {
                                      //                                           setState(() {
                                      //                                             quantityContoller.text = null;
                                      //                                             useramountController.text = null;
                                      //                                             durationController.text = null;
                                      //                                             productQty = null;
                                      //                                             totalrent = 0;
                                      //                                             useramount = null;
                                      //                                             days = null;
                                      //                                             totalsecurity = 0;
                                      //                                             finalamount = 0;
                                      //                                             conviencevalue = 0;
                                      //                                             rentpricelist.forEach((element) {
                                      //                                               if (element['rent_type_name'].toString() == data.toString()) {
                                      //                                                 renttypename = data.toString();
                                      //                                                 productamount = element['price'].toString();
                                      //                                                 useramount = element['price'].toString();
                                      //                                                 renttypeid = element['rent_type_id'].toString();
                                      //                                                 renteramount = "Listed Price: ${element['price'].toString() + "/" + element['rent_type_name'].toString()}";
                                      //                                               }
                                      //                                             });
                                      //                                           });
                                      //                                         },
                                      //                                         items: renttypelist.map<DropdownMenuItem<String>>((String value) {
                                      //                                           return DropdownMenuItem<String>(
                                      //                                             value: value,
                                      //                                             child: Text(value),
                                      //                                           );
                                      //                                         }).toList(),
                                      //                                       ),
                                      //                                     ),
                                      //                                     SizedBox(
                                      //                                         height: 2),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 20),
                                      //                                     Align(
                                      //                                         alignment: Alignment.topLeft,
                                      //                                         child: renteramount == "null" || renteramount == null || renteramount == "" ? Text("Listed Price: 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                     SizedBox(
                                      //                                         height: 2),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 20),
                                      //                                     Align(
                                      //                                         alignment: Alignment.topLeft,
                                      //                                         child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                     SizedBox(
                                      //                                         height: 2),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 10),
                                      //                                     TextField(
                                      //                                       keyboardType:
                                      //                                           TextInputType.number,
                                      //                                       decoration:
                                      //                                           const InputDecoration(
                                      //                                         hintText: 'Enter Product Quantity',
                                      //                                         border: null,
                                      //                                       ),
                                      //                                       controller:
                                      //                                           quantityContoller,
                                      //                                       onChanged:
                                      //                                           (value) {
                                      //                                         setState(() {
                                      //                                           if (negotiable == "0") {
                                      //                                             productQty = value.toString();
                                      //                                             days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                             totalsecurity = double.parse(productQty) * double.parse(securitydeposit);

                                      //                                             conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));

                                      //                                             days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                           } else {
                                      //                                             setState(() {
                                      //                                               useramount = useramount == null ? null : useramount;
                                      //                                               days = days == null ? null : days;
                                      //                                             });
                                      //                                             double qtyg = double.parse(value.toString());
                                      //                                             double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                             double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                             double totalrentg = qtyg * useramountg * daysg;
                                      //                                             setState(() {
                                      //                                               totalrent = 0;
                                      //                                               productQty = qtyg.toString();
                                      //                                               totalrent = totalrentg;
                                      //                                               totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                               conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                               finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                             });
                                      //                                           }
                                      //                                         });
                                      //                                       },
                                      //                                     ),
                                      //                                     negotiable == "1"
                                      //                                         ? TextField(
                                      //                                             keyboardType: TextInputType.number,
                                      //                                             controller: useramountController,
                                      //                                             decoration: InputDecoration(hintText: _getrenttypeamounthint(renttypename), border: null),
                                      //                                             onChanged: (value) {
                                      //                                               setState(() {
                                      //                                                 productQty = productQty == null ? null : productQty;
                                      //                                                 days = days == null ? null : days;
                                      //                                               });
                                      //                                               double qtyg = double.parse(productQty.toString());
                                      //                                               double useramountg = double.parse(value.toString());
                                      //                                               double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                               double totalrentg = qtyg * useramountg * daysg;
                                      //                                               setState(() {
                                      //                                                 totalrent = 0;
                                      //                                                 totalrent = totalrentg;
                                      //                                                 useramount = useramountg.toString();
                                      //                                                 totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                                 conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                                 finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                               });
                                      //                                             },
                                      //                                           )
                                      //                                         : SizedBox(),
                                      //                                     TextField(
                                      //                                       keyboardType:
                                      //                                           TextInputType.number,
                                      //                                       decoration:
                                      //                                           InputDecoration(
                                      //                                         hintText: _getrenttypehint(renttypename),
                                      //                                         border: null,
                                      //                                       ),
                                      //                                       controller:
                                      //                                           durationController,
                                      //                                       onChanged:
                                      //                                           (value) {
                                      //                                         if (negotiable == "0") {
                                      //                                           setState(() {
                                      //                                             productQty = productQty == null ? null : productQty;
                                      //                                             days = value.toString();
                                      //                                             days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                             totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                             conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                             days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                           });
                                      //                                         } else {
                                      //                                           setState(() {
                                      //                                             productQty = productQty == null ? null : productQty;
                                      //                                             useramount = useramount == null ? null : useramount;
                                      //                                           });
                                      //                                           double qtyg = double.parse(productQty.toString());
                                      //                                           double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                           double daysg = double.parse(value.toString());
                                      //                                           double totalrentg = qtyg * useramountg * daysg;
                                      //                                           setState(() {
                                      //                                             totalrent = 0;
                                      //                                             days = daysg.toString();
                                      //                                             totalrent = totalrentg;
                                      //                                             totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                             conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                             finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                           });
                                      //                                         }
                                      //                                       },
                                      //                                     ),
                                      //                                     SizedBox(
                                      //                                         height: 20),
                                      //                                     Align(
                                      //                                         alignment: Alignment.topLeft,
                                      //                                         child: totalrent == "" || totalrent == "null" || totalrent == null ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Total Rent: $totalrent", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                     SizedBox(
                                      //                                         height: 2),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 20),
                                      //                                     Align(
                                      //                                         alignment: Alignment.topLeft,
                                      //                                         child: totalsecurity == "" || totalsecurity == "null" || totalsecurity == null ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Total Security: $totalsecurity", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                     SizedBox(
                                      //                                         height: 2),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 20),
                                      //                                     Align(
                                      //                                         alignment: Alignment.topLeft,
                                      //                                         child: Text("Convenience charge (" + conviencechargeper.toString() + "%) : " + double.parse(conviencevalue.toString()).toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 20),
                                      //                                     Align(
                                      //                                         alignment: Alignment.topLeft,
                                      //                                         child: finalamount == "" || finalamount == "null" || finalamount == null ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16)) : Text("Final Amount: $finalamount", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                     SizedBox(
                                      //                                         height: 2),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 10),
                                      //                                     renttypename == "Hourly"
                                      //                                         ? _datetimepickerwithhour()
                                      //                                         : Row(
                                      //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //                                             children: [
                                      //                                               Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                      //                                               IconButton(
                                      //                                                   onPressed: () {
                                      //                                                     //print("You are here3");
                                      //                                                     //print("my rent type $renttypename");
                                      //                                                     if (renttypename == "Hourly" || renttypename == "hourly") {
                                      //                                                       _datetimepickerwithhour();
                                      //                                                     } else {
                                      //                                                       _selectStartDate(context, setState);
                                      //                                                     }
                                      //                                                   },
                                      //                                                   icon: Icon(Icons.calendar_today, size: 16))
                                      //                                             ],
                                      //                                           ),
                                      //                                     Divider(
                                      //                                         height: 1,
                                      //                                         color: Colors.grey,
                                      //                                         thickness: 1),
                                      //                                     SizedBox(
                                      //                                         height: 25),
                                      //                                     InkWell(
                                      //                                       onTap:
                                      //                                           () {
                                      //                                         if (renttypename == null || renttypename == "") {
                                      //                                           showToast("Please select rent type");
                                      //                                         } else if (productQty == null || productQty == "") {
                                      //                                           showToast("Please enter product quantity");
                                      //                                         } else if (days == null || days == "") {
                                      //                                           showToast("Please enter period");
                                      //                                         } else if (startDate == null || startDate == "" || startDate == "From Date") {
                                      //                                           showToast("Please enter start date");
                                      //                                         } else {
                                      //                                           Navigator.of(context, rootNavigator: true).pop();
                                      //                                           _setmakeoffer();
                                      //                                         }
                                      //                                       },
                                      //                                       child:
                                      //                                           Container(
                                      //                                         height: 45,
                                      //                                         width: double.infinity,
                                      //                                         alignment: Alignment.center,
                                      //                                         decoration: const BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                      //                                         child: Text("Make Offer", style: TextStyle(color: Colors.white)),
                                      //                                       ),
                                      //                                     )
                                      //                                   ]),
                                      //                             ),
                                      //                           ));
                                      //                     }));
                                      //       } else if (actionbtn ==
                                      //           "Edit Offer") {
                                      //         setState(() {
                                      //           productQty =
                                      //               getOfferData['quantity']
                                      //                   .toString();
                                      //           totalrent = double.parse(
                                      //               getOfferData['total_rent']
                                      //                   .toString());
                                      //           useramount = getOfferData[
                                      //                   'renter_amount']
                                      //               .toString();
                                      //           days = getOfferData['period']
                                      //               .toString();
                                      //           totalsecurity = double.parse(
                                      //               getOfferData[
                                      //                       'total_security']
                                      //                   .toString());

                                      //           finalamount = double.parse(
                                      //               getOfferData['final_amount']
                                      //                   .toString());
                                      //           conviencevalue = 0;
                                      //           showDialog(
                                      //               context: context,
                                      //               barrierDismissible: false,
                                      //               builder: (context) =>
                                      //                   StatefulBuilder(builder:
                                      //                       (context,
                                      //                           setState) {
                                      //                     return AlertDialog(
                                      //                         title:
                                      //                             const Align(
                                      //                           alignment:
                                      //                               Alignment
                                      //                                   .topLeft,
                                      //                           child: Text(
                                      //                               "Make An Offer",
                                      //                               style: TextStyle(
                                      //                                   color: Colors
                                      //                                       .deepOrangeAccent)),
                                      //                         ),
                                      //                         content:
                                      //                             Container(
                                      //                           child:
                                      //                               SingleChildScrollView(
                                      //                             child: Column(
                                      //                                 children: [
                                      //                                   DropdownButtonHideUnderline(
                                      //                                     child:
                                      //                                         DropdownButton<String>(
                                      //                                       hint:
                                      //                                           Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                      //                                       value:
                                      //                                           capitalize(getOfferData['rent_type_name'].toString()),
                                      //                                       elevation:
                                      //                                           16,
                                      //                                       isExpanded:
                                      //                                           true,
                                      //                                       style:
                                      //                                           TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                      //                                       onChanged:
                                      //                                           (String data) {
                                      //                                         setState(() {
                                      //                                           rentpricelist.forEach((element) {
                                      //                                             setState(() {
                                      //                                               if (element['rent_type_name'].toString() == data.toString()) {
                                      //                                                 renttypename = data.toString();
                                      //                                                 productamount = element['price'].toString();
                                      //                                                 useramount = element['price'].toString();
                                      //                                                 renttypeid = element['rent_type_id'].toString();
                                      //                                                 renteramount = "Listed Price: ${element['price'].toString() + "/" + element['rent_type_name'].toString()}";
                                      //                                               }
                                      //                                             });
                                      //                                           });
                                      //                                         });
                                      //                                         //print(renttypename);
                                      //                                       },
                                      //                                       items:
                                      //                                           renttypelist.map<DropdownMenuItem<String>>((String value) {
                                      //                                         return DropdownMenuItem<String>(
                                      //                                           value: value,
                                      //                                           child: Text(value),
                                      //                                         );
                                      //                                       }).toList(),
                                      //                                     ),
                                      //                                   ),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: renteramount == "null" || renteramount == null || renteramount == ""
                                      //                                           ? Text("Listed Price: 09", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null
                                      //                                           ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           10),
                                      //                                   TextFormField(
                                      //                                     initialValue:
                                      //                                         productQty,
                                      //                                     keyboardType:
                                      //                                         TextInputType.number,
                                      //                                     decoration: const InputDecoration(
                                      //                                         hintText: 'Enter Product Quantity',
                                      //                                         border: null),
                                      //                                     onChanged:
                                      //                                         (value) {
                                      //                                       setState(() {
                                      //                                         if (negotiable == "0") {
                                      //                                           productQty = value.toString();
                                      //                                           days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                           totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                         } else {
                                      //                                           setState(() {
                                      //                                             useramount = useramount == null ? null : useramount;
                                      //                                             days = days == null ? null : days;
                                      //                                           });
                                      //                                           double qtyg = double.parse(value.toString());
                                      //                                           double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                           double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                           double totalrentg = qtyg * useramountg * daysg;
                                      //                                           setState(() {
                                      //                                             totalrent = 0;
                                      //                                             productQty = qtyg.toString();
                                      //                                             totalrent = totalrentg;
                                      //                                             totalsecurity = int.parse(securitydeposit) * qtyg;
                                      //                                             conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                             finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                           });
                                      //                                         }
                                      //                                       });
                                      //                                     },
                                      //                                   ),
                                      //                                   negotiable ==
                                      //                                           "1"
                                      //                                       ? TextFormField(
                                      //                                           initialValue: useramount,
                                      //                                           keyboardType: TextInputType.number,
                                      //                                           decoration: InputDecoration(
                                      //                                             hintText: _getrenttypeamounthint(getOfferData['rent_type_name'].toString()),
                                      //                                             border: null,
                                      //                                           ),
                                      //                                           onChanged: (value) {
                                      //                                             setState(() {
                                      //                                               productQty = productQty == null ? null : productQty;
                                      //                                               days = days == null ? null : days;
                                      //                                             });
                                      //                                             double qtyg = double.parse(productQty.toString());
                                      //                                             double useramountg = double.parse(value.toString());
                                      //                                             double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                             double totalrentg = qtyg * useramountg * daysg;
                                      //                                             setState(() {
                                      //                                               totalrent = 0;
                                      //                                               totalrent = totalrentg;
                                      //                                               useramount = useramountg.toString();
                                      //                                               totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                               conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                               finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                             });
                                      //                                           },
                                      //                                         )
                                      //                                       : SizedBox(),
                                      //                                   TextFormField(
                                      //                                     initialValue:
                                      //                                         days,
                                      //                                     keyboardType:
                                      //                                         TextInputType.number,
                                      //                                     decoration:
                                      //                                         InputDecoration(
                                      //                                       hintText:
                                      //                                           _getrenttypehint(capitalize(getOfferData['rent_type_name'].toString())),
                                      //                                       border:
                                      //                                           null,
                                      //                                     ),
                                      //                                     onChanged:
                                      //                                         (value) {
                                      //                                       if (negotiable ==
                                      //                                           "0") {
                                      //                                         setState(() {
                                      //                                           productQty = productQty == null ? null : productQty;
                                      //                                           days = value.toString();
                                      //                                           days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                           totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                         });
                                      //                                       } else {
                                      //                                         setState(() {
                                      //                                           productQty = productQty == null ? null : productQty;
                                      //                                           useramount = useramount == null ? null : useramount;
                                      //                                         });
                                      //                                         double qtyg = double.parse(productQty.toString());
                                      //                                         double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                         double daysg = double.parse(value.toString());
                                      //                                         double totalrentg = qtyg * useramountg * daysg;
                                      //                                         setState(() {
                                      //                                           totalrent = 0;
                                      //                                           days = daysg.toString();
                                      //                                           totalrent = totalrentg;
                                      //                                           totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                         });
                                      //                                       }
                                      //                                     },
                                      //                                   ),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: totalrent == "" || totalrent == "null" || totalrent == null
                                      //                                           ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Total Rent: " + totalrent.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: totalsecurity == "" || totalsecurity == "null" || totalsecurity == null
                                      //                                           ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Total Security: " + totalsecurity.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment:
                                      //                                           Alignment.topLeft,
                                      //                                       child: Text("Convenience charge (" + conviencechargeper.toString() + "%) : " + double.parse(conviencevalue.toString()).toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: finalamount == "" || finalamount == "null" || finalamount == null
                                      //                                           ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Final Amount: " + finalamount.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           10),
                                      //                                   Row(
                                      //                                     mainAxisAlignment:
                                      //                                         MainAxisAlignment.spaceBetween,
                                      //                                     children: [
                                      //                                       Text(startDate,
                                      //                                           style: TextStyle(color: Colors.black, fontSize: 16)),
                                      //                                       IconButton(
                                      //                                           onPressed: () {
                                      //                                             //print("You are here1");
                                      //                                             if (renttypename == "Hourly" || renttypename == "hourly") {
                                      //                                               _datetimepickerwithhour();
                                      //                                             } else {
                                      //                                               _selectStartDate(context, setState);
                                      //                                             }
                                      //                                           },
                                      //                                           icon: Icon(Icons.calendar_today, size: 16))
                                      //                                     ],
                                      //                                   ),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           25),
                                      //                                   InkWell(
                                      //                                     onTap:
                                      //                                         () {
                                      //                                       Navigator.of(context, rootNavigator: true).pop();
                                      //                                       if (renttypename == null ||
                                      //                                           renttypename == "") {
                                      //                                         showToast("Please select rent type");
                                      //                                       } else if (days == null ||
                                      //                                           days == "") {
                                      //                                         showToast("Please enter period");
                                      //                                       } else if (productQty == null ||
                                      //                                           productQty == "") {
                                      //                                         showToast("Please enter product quantity");
                                      //                                       } else if (startDate == null ||
                                      //                                           startDate == "" ||
                                      //                                           startDate == "From Date") {
                                      //                                         showToast("Please enter start date");
                                      //                                       } else {
                                      //                                         Navigator.of(context, rootNavigator: true).pop();
                                      //                                         _setmakeoffer();
                                      //                                       }
                                      //                                     },
                                      //                                     child:
                                      //                                         Container(
                                      //                                       height:
                                      //                                           45,
                                      //                                       width:
                                      //                                           double.infinity,
                                      //                                       alignment:
                                      //                                           Alignment.center,
                                      //                                       decoration:
                                      //                                           const BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                      //                                       child:
                                      //                                           Text("Make Offer", style: TextStyle(color: Colors.white)),
                                      //                                     ),
                                      //                                   )
                                      //                                 ]),
                                      //                           ),
                                      //                         ));
                                      //                   }));
                                      //         });
                                      //       } else {
                                      //         //Payment Option
                                      //       }
                                      //     }
                                      //   } else {
                                      //     //print("4");
                                      //     if (actionbtn == "Make An Offer") {
                                      //       //print("5");
                                      //       setState(() {
                                      //         productQty = null;
                                      //         totalrent = 0;
                                      //         useramount = null;
                                      //         days = null;
                                      //         totalsecurity = 0;
                                      //         finalamount = 0;
                                      //         conviencevalue = 0;
                                      //       });
                                      //       //print(renttypelist);
                                      //       showDialog(
                                      //           context: context,
                                      //           barrierDismissible: false,
                                      //           builder:
                                      //               (context) =>
                                      //                   StatefulBuilder(builder:
                                      //                       (context,
                                      //                           setState) {
                                      //                     return AlertDialog(
                                      //                         title: const Align(
                                      //                             alignment:
                                      //                                 Alignment
                                      //                                     .topLeft,
                                      //                             child: Text(
                                      //                                 "Make An Offer",
                                      //                                 style: TextStyle(
                                      //                                     color:
                                      //                                         Colors.deepOrangeAccent))),
                                      //                         content: Container(
                                      //                           child:
                                      //                               SingleChildScrollView(
                                      //                             child: Column(
                                      //                                 children: [
                                      //                                   DropdownButtonHideUnderline(
                                      //                                     child:
                                      //                                         DropdownButton<String>(
                                      //                                       hint:
                                      //                                           Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                      //                                       value:
                                      //                                           renttypename,
                                      //                                       elevation:
                                      //                                           16,
                                      //                                       isExpanded:
                                      //                                           true,
                                      //                                       style:
                                      //                                           TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                      //                                       onChanged:
                                      //                                           (String data) {
                                      //                                         setState(() {
                                      //                                           rentpricelist.forEach((element) {
                                      //                                             if (element['rent_type_name'].toString() == data.toString()) {
                                      //                                               renttypename = data.toString();
                                      //                                               productamount = element['price'].toString();
                                      //                                               useramount = element['price'].toString();
                                      //                                               renttypeid = element['rent_type_id'].toString();
                                      //                                               renteramount = "Listed Price: ${element['price'].toString() + "/" + element['rent_type_name'].toString()}";
                                      //                                             }
                                      //                                           });
                                      //                                         });
                                      //                                       },
                                      //                                       items:
                                      //                                           renttypelist.map<DropdownMenuItem<String>>((String value) {
                                      //                                         return DropdownMenuItem<String>(
                                      //                                           value: value,
                                      //                                           child: Text(value),
                                      //                                         );
                                      //                                       }).toList(),
                                      //                                     ),
                                      //                                   ),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: renteramount == "null" || renteramount == null || renteramount == ""
                                      //                                           ? Text("Listed Price: 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null
                                      //                                           ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           10),
                                      //                                   TextField(
                                      //                                     keyboardType:
                                      //                                         TextInputType.number,
                                      //                                     decoration:
                                      //                                         const InputDecoration(
                                      //                                       hintText:
                                      //                                           'Enter Product Quantity',
                                      //                                       border:
                                      //                                           null,
                                      //                                     ),
                                      //                                     onChanged:
                                      //                                         (value) {
                                      //                                       setState(() {
                                      //                                         if (negotiable == "0") {
                                      //                                           productQty = value.toString();
                                      //                                           days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                           totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                         } else {
                                      //                                           setState(() {
                                      //                                             useramount = useramount == null ? null : useramount;
                                      //                                             days = days == null ? null : days;
                                      //                                           });
                                      //                                           double qtyg = double.parse(value.toString());
                                      //                                           double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                           double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                           double totalrentg = qtyg * useramountg * daysg;
                                      //                                           setState(() {
                                      //                                             totalrent = 0;
                                      //                                             productQty = qtyg.toString();
                                      //                                             totalrent = totalrentg;
                                      //                                             totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                             conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                             finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                           });
                                      //                                         }
                                      //                                       });
                                      //                                     },
                                      //                                   ),
                                      //                                   negotiable ==
                                      //                                           "1"
                                      //                                       ? TextField(
                                      //                                           keyboardType: TextInputType.number,
                                      //                                           decoration: InputDecoration(hintText: _getrenttypeamounthint(renttypename), border: null),
                                      //                                           onChanged: (value) {
                                      //                                             setState(() {
                                      //                                               productQty = productQty == null ? null : productQty;
                                      //                                               days = days == null ? null : days;
                                      //                                             });
                                      //                                             double qtyg = double.parse(productQty.toString());
                                      //                                             double useramountg = double.parse(value.toString());
                                      //                                             double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                             double totalrentg = qtyg * useramountg * daysg;
                                      //                                             setState(() {
                                      //                                               totalrent = 0;
                                      //                                               totalrent = totalrentg;
                                      //                                               useramount = useramountg.toString();
                                      //                                               totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                               conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                               finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                             });
                                      //                                           },
                                      //                                         )
                                      //                                       : SizedBox(),
                                      //                                   TextField(
                                      //                                     keyboardType:
                                      //                                         TextInputType.number,
                                      //                                     decoration:
                                      //                                         InputDecoration(
                                      //                                       hintText:
                                      //                                           _getrenttypehint(renttypename),
                                      //                                       border:
                                      //                                           null,
                                      //                                     ),
                                      //                                     onChanged:
                                      //                                         (value) {
                                      //                                       if (negotiable ==
                                      //                                           "0") {
                                      //                                         setState(() {
                                      //                                           productQty = productQty == null ? null : productQty;
                                      //                                           days = value.toString();
                                      //                                           days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                           totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                         });
                                      //                                       } else {
                                      //                                         setState(() {
                                      //                                           productQty = productQty == null ? null : productQty;
                                      //                                           useramount = useramount == null ? null : useramount;
                                      //                                         });
                                      //                                         double qtyg = double.parse(productQty.toString());
                                      //                                         double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                         double daysg = double.parse(value.toString());
                                      //                                         double totalrentg = qtyg * useramountg * daysg;
                                      //                                         setState(() {
                                      //                                           totalrent = 0;
                                      //                                           days = daysg.toString();
                                      //                                           totalrent = totalrentg;
                                      //                                           totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                         });
                                      //                                       }
                                      //                                     },
                                      //                                   ),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: totalrent == "" || totalrent == "null" || totalrent == null
                                      //                                           ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Total Rent: $totalrent", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: totalsecurity == "" || totalsecurity == "null" || totalsecurity == null
                                      //                                           ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Total Security: $totalsecurity", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment:
                                      //                                           Alignment.topLeft,
                                      //                                       child: Text("Convenience charge (" + conviencechargeper.toString() + "%) : " + double.parse(conviencevalue.toString()).toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: finalamount == "" || finalamount == "null" || finalamount == null
                                      //                                           ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Final Amount: $finalamount", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           10),
                                      //                                   renttypename ==
                                      //                                           "Hourly"
                                      //                                       ? _datetimepickerwithhour()
                                      //                                       : Row(
                                      //                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //                                           children: [
                                      //                                             Text(startDate, style: TextStyle(color: Colors.black, fontSize: 16)),
                                      //                                             IconButton(
                                      //                                                 onPressed: () {
                                      //                                                   //print("You are here3");
                                      //                                                   //print("my rent type $renttypename");
                                      //                                                   if (renttypename == "Hourly" || renttypename == "hourly") {
                                      //                                                     _datetimepickerwithhour();
                                      //                                                   } else {
                                      //                                                     _selectStartDate(context, setState);
                                      //                                                   }
                                      //                                                 },
                                      //                                                 icon: Icon(Icons.calendar_today, size: 16))
                                      //                                           ],
                                      //                                         ),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           25),
                                      //                                   InkWell(
                                      //                                     onTap:
                                      //                                         () {
                                      //                                       if (renttypename == null ||
                                      //                                           renttypename == "") {
                                      //                                         showToast("Please select rent type");
                                      //                                       } else if (productQty == null ||
                                      //                                           productQty == "") {
                                      //                                         showToast("Please enter product quantity");
                                      //                                       } else if (days == null ||
                                      //                                           days == "") {
                                      //                                         showToast("Please enter period");
                                      //                                       } else if (startDate == null ||
                                      //                                           startDate == "" ||
                                      //                                           startDate == "From Date") {
                                      //                                         showToast("Please enter start date");
                                      //                                       } else {
                                      //                                         Navigator.of(context, rootNavigator: true).pop();
                                      //                                         _setmakeoffer();
                                      //                                       }
                                      //                                     },
                                      //                                     child:
                                      //                                         Container(
                                      //                                       height:
                                      //                                           45,
                                      //                                       width:
                                      //                                           double.infinity,
                                      //                                       alignment:
                                      //                                           Alignment.center,
                                      //                                       decoration:
                                      //                                           const BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                      //                                       child:
                                      //                                           Text("Make Offer", style: TextStyle(color: Colors.white)),
                                      //                                     ),
                                      //                                   )
                                      //                                 ]),
                                      //                           ),
                                      //                         ));
                                      //                   }));
                                      //     } else if (actionbtn ==
                                      //         "Edit Offer") {
                                      //       //print("6");
                                      //       //print(getOfferData);
                                      //       setState(() {
                                      //         renttypeid =
                                      //             getOfferData['rent_type_id']
                                      //                 .toString();
                                      //         startDate =
                                      //             getOfferData['start_date']
                                      //                 .toString();
                                      //         renttypename = capitalize(
                                      //             getOfferData['rent_type_name']
                                      //                 .toString());
                                      //         productQty =
                                      //             getOfferData['quantity']
                                      //                 .toString();
                                      //         totalrent = double.parse(
                                      //             getOfferData['total_rent']
                                      //                 .toString());
                                      //         useramount =
                                      //             getOfferData['renter_amount']
                                      //                 .toString();
                                      //         days = getOfferData['period']
                                      //             .toString();
                                      //         totalsecurity = double.parse(
                                      //             getOfferData['total_security']
                                      //                 .toString());
                                      //         finalamount = double.parse(
                                      //             getOfferData['final_amount']
                                      //                 .toString());
                                      //         renteramount = "Listed Price: " +
                                      //             getOfferData['product_price']
                                      //                 .toString() +
                                      //             "/" +
                                      //             capitalize(getOfferData[
                                      //                     'rent_type_name']
                                      //                 .toString());
                                      //         conviencevalue = 0;
                                      //       });
                                      //       showDialog(
                                      //           context: context,
                                      //           barrierDismissible: false,
                                      //           builder:
                                      //               (context) =>
                                      //                   StatefulBuilder(builder:
                                      //                       (context,
                                      //                           setState) {
                                      //                     return AlertDialog(
                                      //                         title: const Align(
                                      //                             alignment:
                                      //                                 Alignment
                                      //                                     .topLeft,
                                      //                             child: Text(
                                      //                                 "Make An Offer",
                                      //                                 style: TextStyle(
                                      //                                     color:
                                      //                                         Colors.deepOrangeAccent))),
                                      //                         content: Container(
                                      //                           child:
                                      //                               SingleChildScrollView(
                                      //                             child: Column(
                                      //                                 children: [
                                      //                                   DropdownButtonHideUnderline(
                                      //                                     child:
                                      //                                         DropdownButton<String>(
                                      //                                       hint:
                                      //                                           Text("Select", style: TextStyle(color: Colors.black, fontSize: 18)),
                                      //                                       value:
                                      //                                           renttypename,
                                      //                                       elevation:
                                      //                                           16,
                                      //                                       isExpanded:
                                      //                                           true,
                                      //                                       style:
                                      //                                           TextStyle(color: Colors.grey.shade700, fontSize: 16),
                                      //                                       onChanged:
                                      //                                           (String data) {
                                      //                                         //print(rentpricelist);
                                      //                                         rentpricelist.forEach((element) {
                                      //                                           setState(() {
                                      //                                             if (element['rent_type_name'].toString() == data.toString()) {
                                      //                                               renttypeid = element['rent_type_id'].toString();
                                      //                                               renttypename = capitalize(data.toString());
                                      //                                               productamount = element['price'].toString();
                                      //                                               useramount = element['price'].toString();
                                      //                                               renttypeid = element['rent_type_id'].toString();
                                      //                                               renteramount = "Listed Price: ${element['price'].toString() + "/" + element['rent_type_name'].toString()}";
                                      //                                             }
                                      //                                           });
                                      //                                         });
                                      //                                         //print(renttypename);
                                      //                                       },
                                      //                                       items:
                                      //                                           renttypelist.map<DropdownMenuItem<String>>((String value) {
                                      //                                         return DropdownMenuItem<String>(
                                      //                                           value: value,
                                      //                                           child: Text(value),
                                      //                                         );
                                      //                                       }).toList(),
                                      //                                     ),
                                      //                                   ),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: renteramount == null
                                      //                                           ? Text("Listed Price: 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text(renteramount, style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: securitydeposit == "" || securitydeposit == "null" || securitydeposit == null
                                      //                                           ? Text("Security Deposit : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Security Deposit: $securitydeposit", style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           10),
                                      //                                   TextFormField(
                                      //                                     initialValue:
                                      //                                         productQty,
                                      //                                     keyboardType:
                                      //                                         TextInputType.number,
                                      //                                     decoration: const InputDecoration(
                                      //                                         hintText: 'Enter Product Quantity',
                                      //                                         border: null),
                                      //                                     onChanged:
                                      //                                         (value) {
                                      //                                       totalrent =
                                      //                                           0;
                                      //                                       finalamount =
                                      //                                           0;
                                      //                                       conviencevalue =
                                      //                                           0;
                                      //                                       if (negotiable ==
                                      //                                           "0") {
                                      //                                         setState(() {
                                      //                                           productQty = value.toString();
                                      //                                           days == "null" || days == "" || days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                           totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent + conviencevalue : finalamount = totalrent + totalsecurity + conviencevalue;
                                      //                                         });
                                      //                                       } else {
                                      //                                         setState(() {
                                      //                                           if (value.isEmpty) {
                                      //                                             productQty = "";
                                      //                                           }
                                      //                                           totalrent = 0;
                                      //                                           finalamount = 0;
                                      //                                           conviencevalue = 0;
                                      //                                           useramount = useramount == null ? null : useramount;
                                      //                                           days = days == null ? null : days;
                                      //                                         });
                                      //                                         double qtyg = value.isEmpty ? 0 : double.parse(value.toString());
                                      //                                         double useramountg = useramount == null ? renteramount : double.parse(useramount.toString());
                                      //                                         double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                         double totalrentg = 0;
                                      //                                         if (qtyg == 0) {
                                      //                                           totalrentg = useramountg * daysg;
                                      //                                         } else {
                                      //                                           totalrentg = qtyg * useramountg * daysg;
                                      //                                         }
                                      //                                         //print(qtyg);
                                      //                                         //print(useramountg);
                                      //                                         //print(daysg);
                                      //                                         setState(() {
                                      //                                           totalrent = 0;
                                      //                                           productQty = qtyg.toString();
                                      //                                           totalrent = totalrentg;
                                      //                                           totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                         });
                                      //                                       }
                                      //                                     },
                                      //                                   ),
                                      //                                   negotiable ==
                                      //                                           "1"
                                      //                                       ? TextFormField(
                                      //                                           initialValue: useramount,
                                      //                                           keyboardType: TextInputType.number,
                                      //                                           decoration: InputDecoration(
                                      //                                             hintText: _getrenttypeamounthint(renttypename),
                                      //                                             border: null,
                                      //                                           ),
                                      //                                           onChanged: (value) {
                                      //                                             setState(() {
                                      //                                               totalrent = 0;
                                      //                                               finalamount = 0;
                                      //                                               conviencevalue = 0;
                                      //                                               productQty = productQty == null ? null : productQty;
                                      //                                               days = days == null ? null : days;
                                      //                                             });
                                      //                                             double qtyg = double.parse(productQty.toString());
                                      //                                             double useramountg = value.isEmpty ? 0 : double.parse(value.toString());
                                      //                                             double daysg = days == null ? 1 : double.parse(days.toString());
                                      //                                             double totalrentg = 0;
                                      //                                             if (useramountg == 0) {
                                      //                                               totalrentg = qtyg * daysg;
                                      //                                             } else {
                                      //                                               totalrentg = qtyg * useramountg * daysg;
                                      //                                             }
                                      //                                             //print(qtyg);
                                      //                                             //print(useramountg);
                                      //                                             //print(daysg);
                                      //                                             setState(() {
                                      //                                               totalrent = 0;
                                      //                                               totalrent = totalrentg;
                                      //                                               useramount = useramountg.toString();
                                      //                                               totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                               conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                               finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                             });
                                      //                                           },
                                      //                                         )
                                      //                                       : SizedBox(),
                                      //                                   TextFormField(
                                      //                                     initialValue:
                                      //                                         days,
                                      //                                     keyboardType:
                                      //                                         TextInputType.number,
                                      //                                     decoration:
                                      //                                         InputDecoration(
                                      //                                       hintText:
                                      //                                           _getrenttypehint(renttypename),
                                      //                                       border:
                                      //                                           null,
                                      //                                     ),
                                      //                                     onChanged:
                                      //                                         (value) {
                                      //                                       if (negotiable ==
                                      //                                           "0") {
                                      //                                         setState(() {
                                      //                                           productQty = productQty == null ? null : productQty;
                                      //                                           days = value.toString();
                                      //                                           days == null ? totalrent = 0 : totalrent = double.parse(productQty) * double.parse(days) * double.parse(productamount);
                                      //                                           totalsecurity = double.parse(productQty) * double.parse(securitydeposit);
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           days == "null" || days == "" || days == null ? finalamount = totalsecurity + totalrent : finalamount = totalrent + totalsecurity;
                                      //                                         });
                                      //                                       } else {
                                      //                                         setState(() {
                                      //                                           productQty = productQty == null ? null : productQty;
                                      //                                           useramount = useramount == null ? null : useramount;
                                      //                                         });

                                      //                                         double qtyg = double.parse(productQty.toString());
                                      //                                         double useramountg = useramount == null ? 1 : double.parse(useramount.toString());
                                      //                                         double daysg = value.isEmpty ? 0 : double.parse(value.toString());

                                      //                                         double totalrentg = 0;
                                      //                                         if (useramountg == 0) {
                                      //                                           totalrentg = qtyg * useramountg;
                                      //                                         } else {
                                      //                                           totalrentg = qtyg * useramountg * daysg;
                                      //                                         }
                                      //                                         //print(qtyg);
                                      //                                         //print(useramountg);
                                      //                                         //print(daysg);
                                      //                                         setState(() {
                                      //                                           totalrent = 0;
                                      //                                           days = daysg.toString();
                                      //                                           totalrent = totalrentg;
                                      //                                           totalsecurity = double.parse(securitydeposit) * qtyg;
                                      //                                           conviencevalue = ((conviencechargeper / 100) * (totalsecurity + totalrent));
                                      //                                           finalamount = totalsecurity + totalrent + conviencevalue;
                                      //                                         });
                                      //                                       }
                                      //                                     },
                                      //                                   ),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: totalrent == "" || totalrent == "null" || totalrent == null
                                      //                                           ? Text("Total Rent : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Total Rent: " + totalrent.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: totalsecurity == "" || totalsecurity == "null" || totalsecurity == null
                                      //                                           ? Text("Total Security : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Total Security: " + totalsecurity.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment:
                                      //                                           Alignment.topLeft,
                                      //                                       child: Text("Convenience charge (" + conviencechargeper.toString() + "%) : " + double.parse(conviencevalue.toString()).toStringAsFixed(2), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           20),
                                      //                                   Align(
                                      //                                       alignment: Alignment
                                      //                                           .topLeft,
                                      //                                       child: finalamount == "" || finalamount == "null" || finalamount == null
                                      //                                           ? Text("Final Amount : 0", style: TextStyle(color: Colors.black, fontSize: 16))
                                      //                                           : Text("Final Amount: " + finalamount.toString(), style: TextStyle(color: Colors.black, fontSize: 16))),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           2),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           10),
                                      //                                   Row(
                                      //                                     mainAxisAlignment:
                                      //                                         MainAxisAlignment.spaceBetween,
                                      //                                     children: [
                                      //                                       Text(startDate,
                                      //                                           style: TextStyle(color: Colors.black, fontSize: 16)),
                                      //                                       IconButton(
                                      //                                           onPressed: () {
                                      //                                             //print("You are here2");
                                      //                                             /*setState((){
                                      //                            startDate = null;
                                      //                         });*/
                                      //                                             if (renttypename == "Hourly" || renttypename == "hourly") {
                                      //                                               _datetimepickerwithhour();
                                      //                                             } else {
                                      //                                               _selectStartDate(context, setState);
                                      //                                             }
                                      //                                           },
                                      //                                           icon: Icon(Icons.calendar_today, size: 16))
                                      //                                     ],
                                      //                                   ),
                                      //                                   Divider(
                                      //                                       height:
                                      //                                           1,
                                      //                                       color:
                                      //                                           Colors.grey,
                                      //                                       thickness: 1),
                                      //                                   SizedBox(
                                      //                                       height:
                                      //                                           25),
                                      //                                   InkWell(
                                      //                                     onTap:
                                      //                                         () {
                                      //                                       if (renttypename == null ||
                                      //                                           renttypename == "") {
                                      //                                         showToast("Please select rent type");
                                      //                                       } else if (productQty == null ||
                                      //                                           productQty == "") {
                                      //                                         showToast("Please enter product quantity");
                                      //                                       } else if (days == null ||
                                      //                                           days == "") {
                                      //                                         showToast("Please enter period");
                                      //                                       } else if (startDate == null ||
                                      //                                           startDate == "" ||
                                      //                                           startDate == "From Date") {
                                      //                                         showToast("Please enter start date");
                                      //                                       } else {
                                      //                                         //Navigator.of(context).pop();
                                      //                                         Navigator.of(context, rootNavigator: true).pop();
                                      //                                         _setmakeoffer();
                                      //                                       }
                                      //                                     },
                                      //                                     child:
                                      //                                         Container(
                                      //                                       height:
                                      //                                           45,
                                      //                                       width:
                                      //                                           double.infinity,
                                      //                                       alignment:
                                      //                                           Alignment.center,
                                      //                                       decoration:
                                      //                                           const BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                      //                                       child:
                                      //                                           Text("Make Offer", style: TextStyle(color: Colors.white)),
                                      //                                     ),
                                      //                                   )
                                      //                                 ]),
                                      //                           ),
                                      //                         ));
                                      //                   }));
                                      //     } else {
                                      //       //Start Payment
                                      //     }
                                      //   }
                                      // },

                                      child: Container(
                                        height: 45,
                                        width: size.width * 0.45,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.deepOrangeAccent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22.0))),
                                        child: Text(
                                            actionbtn.toString().toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address : ",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: size.width * 0.70,
                          child: address == null
                              ? SizedBox()
                              : Text(address,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: kPrimaryColor, fontSize: 18)),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text("Price : ",
                    //         style: TextStyle(
                    //             color: kPrimaryColor,
                    //             fontSize: 18,
                    //             fontWeight: FontWeight.bold)),
                    //     SizedBox(
                    //       width: size.width * 0.70,
                    //       child: negotiable == "0" ? Text("Fixed",
                    //           maxLines: 2,
                    //           style: TextStyle(
                    //               color: kPrimaryColor, fontSize: 18)) : Text(
                    //           "Negotiable",
                    //           maxLines: 2,
                    //           style: TextStyle(
                    //               color: kPrimaryColor, fontSize: 18)),
                    //     )
                    //   ],
                    //   ],
                    // ),
                    // SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email : ",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: size.width * 0.70,
                          child: email == null
                              ? SizedBox()
                              : Text(email,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: kPrimaryColor, fontSize: 18)),
                        )
                      ],
                    ),
                    // Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 10.0),
                    //     child: Container(
                    //       height: 550,
                    //       width: double.infinity,
                    //       child: GoogleMap(
                    //         initialCameraPosition: initialCameraPosition,
                    //         markers: markers,
                    //         zoomControlsEnabled: false,
                    //         mapType: MapType.normal,
                    //         onMapCreated: (GoogleMapController controller) {
                    //           googleMapController = controller;
                    //         },
                    //       ),
                    //     ),
                    // ),
                    likedadproductlist.length == 0
                        ? SizedBox()
                        : SizedBox(height: 30),
                    likedadproductlist.length == 0
                        ? SizedBox(height: 0)
                        : const Text("You May Also Like",
                            style: TextStyle(
                                color: Colors.deepOrangeAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 21)),
                    likedadproductlist.length == 0
                        ? SizedBox(height: 0)
                        : SizedBox(height: 10),
                    likedadproductlist.length == 0
                        ? SizedBox(height: 0)
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: likedadproductlist.length,
                            physics: ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4.0,
                                    mainAxisSpacing: 4.0,
                                    childAspectRatio: 1.0),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                                  productid:
                                                      likedadproductlist[index]
                                                              ['id']
                                                          .toString())));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        height: 80,
                                        width: double.infinity,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                                'assets/images/no_image.jpg',
                                                fit: BoxFit.fill),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/no_image.jpg',
                                                fit: BoxFit.fill),
                                        fit: BoxFit.fill,
                                        imageUrl: likedadproductlist[index]
                                                        ['images']
                                                    .length >
                                                0
                                            ? sliderpath +
                                                "assets/frontend/images/listings/" +
                                                likedadproductlist[index]
                                                            ['images'][0]
                                                        ['file_name']
                                                    .toString()
                                            : "http://themedemo.wpeka.com/wp-content/themes/apppress/images/icons/included/color.png",
                                      ),
                                      SizedBox(height: 5.0),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, right: 15.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                              likedadproductlist[index]['title']
                                                  .toString(),
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, right: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width: size.width * 0.4,
                                                child: Text(
                                                    "Starting from ${likedadproductlist[index]['currency'].toString()} ${likedadproductlist[index]['prices'][0]['price'].toString()}",
                                                    style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize: 12))),
                                            // IconButton(
                                            //     iconSize: 28,
                                            //     onPressed: () {
                                            //       Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //               builder: (context) =>
                                            //                   ProductDetailScreen(
                                            //                       productid: likedadproductlist[
                                            //                                   index]
                                            //                               ['id']
                                            //                           .toString())));
                                            //     },
                                            //     icon: Icon(
                                            //         Icons.add_box_rounded,
                                            //         color: kPrimaryColor))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ],
                ),
              ),
            ),
    );
  }

  Future _getcheckapproveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + checkapprove),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if (data != null) {
        setState(() {
          usertype = data['user_type'].toString();
          trustedbadge = data['trusted_badge'].toString();
          trustedbadgeapproval = data['trusted_badge_approval'].toString();
        });
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  String _getrenttypeamounthint(String renttype) {
    if (renttype == "Hourly" || renttype == "hourly") {
      return "Enter Amount Per Hour";
    } else if (renttype == "Weekly" || renttype == "weekly") {
      return "Enter Amount Per Week";
    } else if (renttype == "Monthly" || renttype == "monthly") {
      return "Enter Amount Per Month";
    } else if (renttype == "Yearly" || renttype == "yearly") {
      return "Enter Amount Per Year";
    } else if (renttype == "Days" || renttype == "days") {
      return "Enter Amount Per Day";
    } else {
      return "Enter Amount Per Period";
    }
  }

  String _getrenttypehint(String renttype) {
    if (renttype == "Hourly" || renttype == "hourly") {
      return "Enter Hours";
    } else if (renttype == "Weekly" || renttype == "weekly") {
      return "Enter Weeks";
    } else if (renttype == "Monthly" || renttype == "monthly") {
      return "Enter Months";
    } else if (renttype == "Yearly" || renttype == "yearly") {
      return "Enter Years";
    } else if (renttype == "Days" || renttype == "days") {
      return "Enter Days";
    } else {
      return "Enter Period";
    }
  }

  Future _getproductDetail(String productid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {"id": productid, "user_id": prefs.getString('userid')};
    //print(productid);
    //print(prefs.getString('userid'));
    var response = await http.post(Uri.parse(BASE_URL + productdetail),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      //print("test----" + response.body);
      setState(() {
        userid = prefs.getString('userid');

        if (data['Images'].length > 0) {
          productimage = sliderpath +
              data['Images'][0]['upload_base_path'].toString() +
              data['Images'][0]['file_name'].toString();
          productimages.addAll(data['Images']);

          productname = data['posted_ad']['title'].toString();
          final document = parse(data['posted_ad']['description'].toString());
          description =
              parse(document.body.text).documentElement.text.toString();
          boostpack = data['posted_ad']['boost_package_status'].toString();
          renttype = data['posted_ad']['rent_type'].toString();
          negotiable = data['posted_ad']['negotiate'].toString();

          query_id = data['additional']['added-by']['quickblox_id'].toString();
          //print("query id here $query_id");

          List temp = [];
          data['posted_ad']['prices'].forEach((element) {
            if (element['price'] != null) {
              temp.add("INR " +
                  element['price'].toString() +
                  " (" +
                  element['rent_type_name'].toString() +
                  ")");
            }
          });
          productprice = temp.join("/").toString();
          securitydeposit = data['posted_ad']['security'].toString();
          addedbyid = data['additional']['added-by']['id'].toString();
          addedby = data['additional']['added-by']['name'].toString();
          email = data['additional']['added-by']['email'].toString();
          address = data['additional']['added-by']['address'].toString();
          actionbtn = data['offer'].toString();

          likedadproductlist.addAll(data['liked_ads']);

          if (data['posted_ad']['user_id'].toString() ==
              prefs.getString('userid')) {
            _checkuser = true;
          } else {
            _checkuser = false;
          }

          _checkData = true;
        } else {
          productname = data['posted_ad']['title'].toString();
          final document = parse(data['posted_ad']['description'].toString());
          description =
              parse(document.body.text).documentElement.text.toString();
          boostpack = data['posted_ad']['boost_package_status'].toString();
          renttype = data['posted_ad']['rent_type'].toString();
          negotiable = data['posted_ad']['negotiate'].toString();

          query_id = data['additional']['added-by']['quickblox_id'].toString();
          //print("query id here $query_id");

          List temp = [];
          data['posted_ad']['prices'].forEach((element) {
            if (element['price'] != null) {
              temp.add("INR " +
                  element['price'].toString() +
                  " (" +
                  element['rent_type_name'].toString() +
                  ")");
            }
          });
          productprice = temp.join("/").toString();
          securitydeposit = data['posted_ad']['security'].toString();
          addedbyid = data['additional']['added-by']['id'].toString();
          addedby = data['additional']['added-by']['name'].toString();
          email = data['additional']['added-by']['email'].toString();
          address = data['additional']['added-by']['address'].toString();
          actionbtn = data['offer'].toString();

          likedadproductlist.addAll(data['liked_ads']);

          if (data['posted_ad']['user_id'].toString() ==
              prefs.getString('userid')) {
            _checkuser = true;
          } else {
            _checkuser = false;
          }

          _checkData = true;
        }
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Map getOfferData = {};
  Future _getmakeoffer(String productid) async {
    print("called");
    //print("product id $productid");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(jsonEncode(
    // {"user_id": prefs.getString('userid'), "post_ad_id": productid}));
    final body = {
      "user_id": prefs.getString('userid'),
      "post_ad_id": productid
    };
    var response = await http.post(Uri.parse(BASE_URL + createoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];

      // data.forEach((e) {
      //   print(e.key + "-" + e.value);
      // });
      try {
        setState(() {
          if (data['data'] != "null" || data['data'] != null) {
            getOfferData = data['data'];
          }
          securitydeposit = data['posted_ad']['security'].toString();
          rentpricelist.addAll(data['posted_ad']['prices']);
          rentpricelist.forEach((element) {
            if (element['price'] != null) {
              renttypelist.add(element['rent_type_name'].toString());
            }
          });
          conviencechargeper =
              double.parse(data['convenience_charges']['charge'].toString());
          conviencevalue = 0;
        });
      } catch (e) {}
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _setmakeoffer() async {
    showLaoding(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ////print(jsonEncode({
    //   "post_ad_id": productid,
    //   "period": days,
    //   "rent_type": renttypeid,
    //   "quantity": productQty,
    //   "start_date": startDate,
    //   "renter_amount": useramount,
    //   "user_id": prefs.getString('userid'),
    // }));
    final body = {
      "post_ad_id": productid,
      "period": days,
      "rent_type": renttypeid,
      "quantity": productQty,
      "start_date": startDate,
      "renter_amount": useramount,
      "user_id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + makeoffer),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      showToast(data['ErrorMessage'].toString());
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _selectStartDate(BuildContext context, setState) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //firstDate: DateTime.now().subtract(Duration(days: 0)),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
              primaryColor: Colors.indigo,
              accentColor: Colors.indigo,
              primarySwatch: const MaterialColor(
                0xFF3949AB,
                <int, Color>{
                  50: Colors.indigo,
                  100: Colors.indigo,
                  200: Colors.indigo,
                  300: Colors.indigo,
                  400: Colors.indigo,
                  500: Colors.indigo,
                  600: Colors.indigo,
                  700: Colors.indigo,
                  800: Colors.indigo,
                  900: Colors.indigo,
                },
              )),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        startDate = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  Widget _datetimepickerwithhour() {
    return DateTimePicker(
      type: DateTimePickerType.dateTime,
      dateMask: 'yyyy/MMM/dd - hh:mm a',
      //initialValue: _initialValue,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      //icon: Icon(Icons.event),
      dateLabelText: 'Date Time',
      use24HourFormat: false,
      locale: Locale('en', 'US'),
      icon: Icon(Icons.calendar_today_sharp, size: 20),
      validator: (val) {
        setState(() {
          startDate = val;
        });
      },
      onSaved: (val) {
        setState(() {
          startDate = val;
        });
      },
      onChanged: (val) {
        setState(() {
          startDate = val;
        });
      },
      onFieldSubmitted: (v) {
        setState(() {
          startDate = v;
        });
      },
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
