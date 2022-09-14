import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rentit4me_new/network/api.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me_new/themes/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailScreen extends StatefulWidget {
  String orderid;
  OrderDetailScreen({this.orderid});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState(orderid);
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String orderid;
  _OrderDetailScreenState(this.orderid);

  bool _loading = false;

  //Detail Information
  String productimage;
  String productname;
  String productqty;
  String description;
  String boostpack;
  String currency;
  String productprice;
  String name;
  String email;
  String address;
  String negotiable;
  String securitydeposit;

  //Order Detail
  String quantity;
  String period;
  String renttype;
  String productpeice;
  String productsecurity;
  String offerammount;
  String totalrent;
  String totalsecurity;
  String finalamount;
  String startdate;
  String enddate;
  String status;
  String createdAt;
  String renttypeid;

  //rating submit
  String productrating;
  String userrating;
  String feedback;
  bool showConversionCharges = false;
  String convenience_charge;
  String convenience_chargeValue;

  //rating
  double getuserrating = 0;
  double getproductrating = 0;
  String feedbackhint = 'Give your feedback (optional)';

  bool renteecheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(orderid);
    _getorderdetailproduct();
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
        title: Text("Order Detail", style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
          inAsyncCall: _loading,
          color: kPrimaryColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _loading == true
                  ? SizedBox()
                  : Column(
                      children: [
                        Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                const Text("Product Detail",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 10),
                                productimage == null
                                    ? Container(
                                        height: 180,
                                        width: double.infinity,
                                        child: Image.asset(
                                            'assets/images/no_image.jpg',
                                            fit: BoxFit.fill),
                                      )
                                    : Container(
                                        height: 180,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: sliderpath + productimage,
                                          fit: BoxFit.fill,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/images/no_image.jpg',
                                                  fit: BoxFit.fill),
                                        ),
                                      ),
                                const SizedBox(height: 10),
                                productname == null
                                    ? const SizedBox()
                                    : Text(productname,
                                        style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700)),
                                const SizedBox(height: 10),
                                description == null
                                    ? const SizedBox()
                                    : Text(description,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                productprice == null || productprice == ""
                                    ? const SizedBox()
                                    : Text(productprice,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                Text("Security Deposit: INR $securitydeposit",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400)),
                                const SizedBox(height: 10),
                                const Text("Product Rating",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 5.0),
                                RatingBar.builder(
                                  initialRating: getproductrating == 0
                                      ? 0
                                      : getproductrating,
                                  minRating: 1,
                                  ignoreGestures:
                                      renteecheck == true ? true : false,
                                  itemSize: 24,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    size: 24,
                                    color: kPrimaryColor,
                                  ),
                                  onRatingUpdate: (rating) {
                                    if (renteecheck != true) {
                                      productrating = rating.toString();
                                    }
                                  },
                                ),
                                SizedBox(height: 5.0),
                                const Text("User Rating",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(height: 5.0),
                                RatingBar.builder(
                                    initialRating:
                                        getuserrating == 0 ? 0 : getuserrating,
                                    minRating: 1,
                                    itemSize: 24,
                                    ignoreGestures:
                                        renteecheck == true ? true : false,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          size: 24,
                                          color: kPrimaryColor,
                                        ),
                                    onRatingUpdate: (rating) {
                                      if (renteecheck != true) {
                                        userrating = rating.toString();
                                      }
                                    }),
                                SizedBox(height: 20),
                                renteecheck == true
                                    ? SizedBox()
                                    : Column(
                                        children: [
                                          Container(
                                            height: 45,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                border: Border.all(
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                    width: 1)),
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: TextField(
                                                onChanged: (value) {
                                                  feedback = value.toString();
                                                },
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: feedbackhint),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          InkWell(
                                            onTap: () {
                                              if (productrating == null ||
                                                  productrating == "") {
                                                showToast(
                                                    "Please check product rating");
                                              } else if (userrating == null ||
                                                  userrating == "") {
                                                showToast(
                                                    "Please check user rating");
                                              } else {
                                                _submitrating();
                                              }
                                            },
                                            child: getuserrating == 0
                                                ? Container(
                                                    height: 45,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                        color: Colors
                                                            .deepOrangeAccent),
                                                    alignment: Alignment.center,
                                                    child: Text("Submit",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  )
                                                : SizedBox(),
                                          ),
                                        ],
                                      ),
                                SizedBox(height: 5)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5.0),
                                const Text("Order Detail",
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                const SizedBox(height: 5),
                                const Divider(
                                    height: 5,
                                    color: kPrimaryColor,
                                    thickness: 2),
                                const Text("Order Info",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const Divider(
                                    height: 5,
                                    color: kPrimaryColor,
                                    thickness: 2),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Item",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    productname == null
                                        ? const SizedBox()
                                        : Text(productname,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Quantity",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    quantity == null || quantity == ""
                                        ? SizedBox()
                                        : Text(quantity,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                // SizedBox(height: 10),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text("Rent Type", style: TextStyle(color: Colors.black, fontSize: 14)),
                                //     negotiable.toString() == "1" ? Container(
                                //       height: 20,
                                //       width: 80,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(8.0),
                                //           color: Colors.green
                                //       ),
                                //       child: Text("Negotiable", style: TextStyle(color: Colors.white)),
                                //     ) : Container(
                                //       height: 20,
                                //       width: 65,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(8.0),
                                //           color: Colors.green
                                //       ),
                                //       child: Text("Fixed", style: TextStyle(color: Colors.white)),
                                //     )
                                //   ],
                                // ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Duration",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    period == null || period == ""
                                        ? SizedBox()
                                        : Text(
                                            period +
                                                " " +
                                                _getrenttype(renttypeid),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Product Price (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    productprice == null || productprice == ""
                                        ? SizedBox()
                                        : Text(productpeice,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Product Security (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    productsecurity == null ||
                                            productsecurity == ""
                                        ? SizedBox()
                                        : Text(productsecurity,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Offer Amount (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    offerammount == null || offerammount == ""
                                        ? SizedBox()
                                        : Text(offerammount,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Rent (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    totalrent == null || totalrent == ""
                                        ? SizedBox()
                                        : Text(totalrent,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Total Security (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    totalsecurity == null || totalsecurity == ""
                                        ? SizedBox()
                                        : Text(totalsecurity,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),

                                showConversionCharges
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Convenience Charge (" +
                                                      convenience_charge
                                                          .toString() +
                                                      "%)",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14)),
                                              Text(convenience_chargeValue,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Final Amount (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    finalamount == null || finalamount == ""
                                        ? SizedBox()
                                        : Text(finalamount,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Start Date",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    startdate == null || startdate == ""
                                        ? SizedBox()
                                        : Text(
                                            DateFormat("d/MMM/yy")
                                                .add_jm()
                                                .format(DateTime.parse(startdate
                                                    .toString()
                                                    .replaceAll("/", "-"))),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("End Date",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    enddate == null || enddate == ""
                                        ? SizedBox()
                                        : Text(
                                            DateFormat("d/MMM/yy")
                                                .add_jm()
                                                .format(DateTime.parse(startdate
                                                    .toString()
                                                    .replaceAll("/", "-"))),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Status",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    status == null
                                        ? const SizedBox()
                                        : Text(
                                            status == "scheduler pickup"
                                                ? "Delivery Pending"
                                                : status,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Created At",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    createdAt == null || createdAt == ""
                                        ? SizedBox()
                                        : Text(
                                            DateFormat("d/MMM/yy")
                                                // .add_jm()
                                                .format(DateTime.parse(
                                                    createdAt.toString())),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                    height: 5,
                                    color: kPrimaryColor,
                                    thickness: 2),
                                const Text("Product Info",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const Divider(
                                    height: 5,
                                    color: kPrimaryColor,
                                    thickness: 2),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Security (INR)",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    securitydeposit == null
                                        ? const SizedBox()
                                        : Text(securitydeposit,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Quantity",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    productqty == null || productqty == "null"
                                        ? const Text("N/A",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                        : Text(productqty.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Currency",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    currency == null
                                        ? const SizedBox()
                                        : Text(currency,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: const Text("Rent Prices",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: productprice == null
                                          ? const SizedBox()
                                          : Text(productprice,
                                              maxLines: 2,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14)),
                                    )
                                  ],
                                ),
                                // SizedBox(height: 10),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     const Text("Rent Type", style: TextStyle(color: Colors.black, fontSize: 14)),
                                //     negotiable.toString() == "1" ? Container(
                                //       height: 20,
                                //       width: 80,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(8.0),
                                //           color: Colors.green
                                //       ),
                                //       child: Text("Negotiable", style: TextStyle(color: Colors.white)),
                                //     ) : Container(
                                //       height: 20,
                                //       width: 65,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(8.0),
                                //           color: Colors.green
                                //       ),
                                //       child: Text("Fixed", style: TextStyle(color: Colors.white)),
                                //     )
                                //   ],
                                // ),
                                const SizedBox(height: 10),
                                const Divider(
                                    height: 5,
                                    color: kPrimaryColor,
                                    thickness: 2),
                                const Text("Renter Information",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                const Divider(
                                    height: 5,
                                    color: kPrimaryColor,
                                    thickness: 2),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Renter Name",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    name == null
                                        ? const SizedBox()
                                        : Text(name,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Email",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    email == null
                                        ? const SizedBox()
                                        : Text(email,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Address",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14)),
                                    SizedBox(
                                        width: size.width * 0.60,
                                        child: address == null
                                            ? const SizedBox()
                                            : Text(address,
                                                textAlign: TextAlign.end,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14)))
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          )),
    );
  }

  Future<void> _getorderdetailproduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {"order_id": orderid, "user_id": prefs.getString('userid')};
    print(jsonEncode(body));
    print(BASE_URL + orderdetail);
    var response = await http.post(Uri.parse(BASE_URL + orderdetail),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        productimage = data['Image']['upload_base_path'] +
            data['Image']['file_name'].toString();
        productname = data['Product Details']['title'].toString();
        final document =
            parse(data['Product Details']['description'].toString());
        description = parse(document.body.text).documentElement.text.toString();
        boostpack = data['Product Details']['boost_package_status'].toString();
        securitydeposit = data['Product Details']['security'].toString();
        negotiable = data['Product Details']['negotiate'].toString();
        productqty = data['Product Details']['quantity'].toString();
        currency = data['Product Details']['currency'].toString();
        status = data['order']['status'].toString();

        List temp = [];
        data['Product Details']['prices'].forEach((element) {
          if (element['price'] != null) {
            temp.add("INR ${element['price']} (${element['rent_type_name']})");
          }
        });

        productprice = temp.join("/").toString();

        //offer detail
        quantity = data['Order Details']['quantity'].toString();
        period = data['Order Details']['period'].toString();
        renttype = data['Order Details']['rent_type_name'].toString();
        productpeice = data['Order Details']['product_price'].toString();
        productsecurity = data['Order Details']['product_security'].toString();
        offerammount =
            data['Order Details']['final_product_selling_amount'].toString();
        totalrent = data['Order Details']['total_rent'].toString();
        totalsecurity = data['Order Details']['total_security'].toString();
        finalamount = data['Order Details']['final_amount'].toString();
        startdate = data['Order Details']['start_date'].toString();
        enddate = data['Order Details']['end_date'].toString();
        //status = data['Order Details']['offer_status'].toString();
        renttypeid = data['Order Details']['rent_type_id'].toString();
        //createdAt = data['Order Details']['created_at'].toString().split("T")[0].toString();
        createdAt = data['Order Details']['created_at'].toString();

        //Renter Detail
        name = data['Additional Information']['name'].toString();
        email = data['Additional Information']['email'].toString();
        address =
            "${data['Additional Information']['address']}, ${data['Additional Information']['city_name']}, ${data['Additional Information']['state_name']}, ${data['Additional Information']['pincode']}";

        print(prefs.getString('userid').toString() +
            "----" +
            data['Order Details']['advertiser_id'].toString());
        if (prefs.getString('userid').toString() ==
            data['Order Details']['advertiser_id'].toString()) {
          renteecheck = true;
        }

        if (data['Rating'] != null) {
          getuserrating =
              double.parse(data['Rating']['user_rating'].toString());
          getproductrating =
              double.parse(data['Rating']['post_ad_rating'].toString());
          feedbackhint = data['Rating']['feedback'];
        }
        convenience_charge =
            data['Order Details']['convenience_charge'].toString();
        if (data['Order Details']['advertiser_id'].toString() ==
            prefs.getString('userid')) {
          showConversionCharges = false;
          var temp = (double.parse(convenience_charge) / 100) *
              (double.parse(totalrent) + double.parse(totalsecurity));
          finalamount = (double.parse(finalamount) - temp).toString();
        } else {
          showConversionCharges = true;
          var temp = (double.parse(convenience_charge) / 100) *
              (double.parse(totalrent) + double.parse(totalsecurity));
          convenience_chargeValue = temp.toString();
        }
        print("showConversionCharges---" + showConversionCharges.toString());
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _submitrating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });
    final body = {
      "product_rating": productrating,
      "user_rating": userrating,
      "userid": prefs.getString('userid'),
      "orderid": orderid,
      "feedback": feedback
    };
    var response = await http.post(Uri.parse(BASE_URL + rating),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['ErrorCode'] == 0) {
        showToast(json.decode(response.body)['ErrorMessage'].toString());
        setState(() {
          userrating = null;
          productrating = null;
        });
        _getorderdetailproduct();
      } else {
        showToast(json.decode(response.body)['ErrorMessage'].toString());
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  String _getStatus(String statusvalue) {
    if (statusvalue == "13") {
      return "Complete";
    } else if (statusvalue == "1") {
      return "Accepted";
    } else if (statusvalue == "3") {
      return "Pending";
    } else if (statusvalue == "6") {
      return "Active";
    } else if (statusvalue == "4") {
      return "Inactive";
    } else if (statusvalue == "2") {
      return "Rejected";
    } else {
      return "Approved";
    }
  }

  String _getrenttype(String renttypevalue) {
    if (renttypevalue == "1") {
      return "Hour";
    } else if (renttypevalue == "2") {
      return "Day";
    } else if (renttypevalue == "3") {
      return "Month";
    } else {
      return "Year";
    }
  }
}
