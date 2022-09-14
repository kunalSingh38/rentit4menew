// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rentit4me_new/network/api.dart';
import 'package:rentit4me_new/themes/constant.dart';
import 'package:rentit4me_new/views/business_detail_screen.dart';
import 'package:rentit4me_new/views/dashboard.dart';
import 'package:rentit4me_new/views/home_screen.dart';
import 'package:rentit4me_new/views/make_payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailScreen extends StatefulWidget {
  const PersonalDetailScreen({Key key}) : super(key: key);

  @override
  State<PersonalDetailScreen> createState() => _PersonalDetailScreenState();
}

class _PersonalDetailScreenState extends State<PersonalDetailScreen> {
  bool _loading = false;

  // String usertype;

  List countrylistData = [];
  String country_id;

  List statelistData = [];
  String state_id;

  List citylistData = [];
  String city_id;

  // String initialkyc;
  // List<String> _kycdata = ["Yes", "No"];
  bool kyc = false;
  String initialtrustedbadge = "Select";
  String initialIdProof = "Select";
  List _badgedata = ["Select", "Yes", "No"];

  String adharcarddoc = "";
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController adharnum = TextEditingController();

  String internIdProofDocument = "";
  TextEditingController internIdProofController = TextEditingController();

  bool _emailcheck = false;
  bool _smscheck = false;
  // int _hidemobile = 0;
  // bool _hidemob = false;

  // int emailvalue;
  // int smsvalue;

  // String kyc, trustbadge;

  List<int> commprefs = [];

  List<String> _accounttypelist = ["Select", "Saving", "Current"];

  String selectedCountry;
  String selectedState;
  String selectedCity;

  //Bank detail
  TextEditingController bankname = TextEditingController();
  TextEditingController branchname = TextEditingController();
  TextEditingController ifsccode = TextEditingController();
  TextEditingController accounttype = TextEditingController(text: "Select");
  TextEditingController accountno = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getprofile().then((value) {
      _getcountryData();
    });

    //_getprofile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: const Text("Personal Detail",
            style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: key,
              child: Column(
                children: [
                  Card(
                    elevation: 4.0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Country*",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: DropdownSearch(
                              selectedItem: selectedCountry,
                              mode: Mode.DIALOG,
                              showSelectedItem: true,
                              autoFocusSearchBox: true,
                              showSearchBox: true,
                              hint: 'Select Country',
                              favoriteItems: (val) {
                                return ["India"];
                              },
                              showFavoriteItems: true,
                              dropdownSearchDecoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.deepOrangeAccent,
                                          width: 1)),
                                  contentPadding: EdgeInsets.only(left: 10)),
                              items: countrylistData.map((e) {
                                return e['name'].toString();
                              }).toList(),
                              onChanged: (value) {
                                if (value != "Select Country") {
                                  countrylistData.forEach((element) {
                                    if (element['name'].toString() == value) {
                                      setState(() {
                                        selectedCountry = value;
                                        country_id = element['id'].toString();
                                        _getStateData(element['id'].toString());
                                        selectedState = 'Select State';
                                        selectedCity = 'Select City';
                                        initialtrustedbadge = 'Select';
                                        kyc = false;
                                      });
                                    }
                                  });
                                } else {
                                  showToast("Select Country");
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("State*",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          DropdownSearch(
                            selectedItem: selectedState,
                            mode: Mode.DIALOG,
                            showSelectedItem: true,
                            autoFocusSearchBox: true,
                            showSearchBox: true,
                            hint: 'Select State',
                            dropdownSearchDecoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 1)),
                                contentPadding: EdgeInsets.only(left: 10)),
                            items: statelistData.map((e) {
                              return e['name'].toString();
                            }).toList(),
                            onChanged: (value) {
                              if (value != "Select State") {
                                statelistData.forEach((element) {
                                  if (element['name'].toString() == value) {
                                    setState(() {
                                      selectedState = value;
                                      state_id = element['id'].toString();
                                      _getCityData(element['id'].toString());
                                      selectedCity = 'Select City';
                                    });
                                  }
                                });
                              } else {
                                showToast("Select State");
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Text("City*",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          DropdownSearch(
                            selectedItem: selectedCity,
                            mode: Mode.DIALOG,
                            showSelectedItem: true,
                            autoFocusSearchBox: true,
                            showSearchBox: true,
                            hint: 'Select City',
                            dropdownSearchDecoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 1)),
                                contentPadding: EdgeInsets.only(left: 10)),
                            items: citylistData.map((e) {
                              return e['name'].toString();
                            }).toList(),
                            onChanged: (value) {
                              if (value != "Select City") {
                                citylistData.forEach((element) {
                                  if (element['name'].toString() == value) {
                                    setState(() {
                                      selectedCity = value;
                                      city_id = element['id'].toString();
                                    });
                                  }
                                });
                              } else {
                                showToast("Select City");
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          Text("Address*",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.deepOrangeAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required Field';
                                    }
                                    return null;
                                  },
                                  controller: address,
                                  onChanged: (val) {
                                    if (selectedCity == null) {
                                      setState(() {
                                        address.clear();
                                      });
                                      showToast("Please select city first");
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            if (address.text == "") {
                                              print("wo");
                                              _determinePosition().then(
                                                  (value) =>
                                                      _getAddress(value));
                                            }
                                          },
                                          icon: Icon(Icons.my_location,
                                              color: address.text == null
                                                  ? Colors.deepOrangeAccent
                                                  : Colors.grey))),
                                ),
                              )),
                          SizedBox(height: 10),
                          Text("Pincode*",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.deepOrangeAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required Field';
                                    }
                                    return null;
                                  },
                                  controller: pincode,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              )),
                          SizedBox(height: 10),
                          Text("Communication Preferences*",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      value: _emailcheck,
                                      onChanged: (value) {
                                        setState(() {
                                          _emailcheck = value;
                                          // if (_emailcheck) {
                                          //   commprefs.add(1);
                                          // } else {
                                          //   commprefs.forEach((element) {
                                          //     if (element == 1) {
                                          //       commprefs.removeWhere(
                                          //           (element) => element == 1);
                                          //     }
                                          //   });
                                          // }
                                        });
                                      }),
                                  Text("Email",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                              SizedBox(width: 20),
                              Row(
                                children: [
                                  Checkbox(
                                      value: _smscheck,
                                      onChanged: (value) {
                                        setState(() {
                                          _smscheck = value;
                                          // if (_smscheck) {
                                          //   commprefs.add(2);
                                          // } else {
                                          //   commprefs.forEach((element) {
                                          //     if (element == 2) {
                                          //       commprefs.removeWhere(
                                          //           (element) => element == 2);
                                          //     }
                                          //   });
                                          // }
                                        });
                                      }),
                                  Text("SMS",
                                      style: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.w700))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Trusted Badge*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text("Kyc*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          FormField(
                            builder: (FormFieldState state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                    suffixIcon: Checkbox(
                                        value: kyc, onChanged: (val) {}),
                                    fillColor: Colors.white,
                                    filled: true,
                                    // labelText: "Select",
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: initialtrustedbadge,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      if (newValue == "Select") {
                                        showToast("Please select Yes/No");
                                      } else {
                                        if (country_id == null) {
                                          showToast("Please select country");
                                        } else {
                                          setState(() {
                                            initialtrustedbadge = newValue;
                                            if (newValue == "Yes") {
                                              kyc = true;
                                              initialIdProof = "Select";
                                            } else {
                                              kyc = false;
                                            }
                                          });
                                        }
                                      }
                                    },
                                    items: _badgedata.map((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.toString()));
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          kyc == true && country_id == "113"
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Aadhaar Number",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.deepOrangeAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Required Field';
                                              }
                                              return null;
                                            },
                                            controller: adharnum,
                                            decoration: InputDecoration(
                                              // hintText: adharnum,
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Adhar Card",
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.deepOrangeAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              adharcarddoc.toString() == "" ||
                                                      adharcarddoc.toString() ==
                                                          "null"
                                                  ? SizedBox()
                                                  : CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage:
                                                          FileImage(File(
                                                              adharcarddoc)),
                                                    ),
                                              InkWell(
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  _captureadharcard(true);
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 120,
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors
                                                              .deepOrangeAccent,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                  child: Text("Choose file",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                              : kyc == true && country_id != "113"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Select Id Proof",
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 8.0),
                                        FormField(
                                          builder: (FormFieldState state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0))),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  value: initialIdProof,
                                                  isDense: true,
                                                  onChanged: (newValue) {
                                                    if (newValue == "Select") {
                                                      showToast(
                                                          "Please select Id Proof");
                                                    } else {
                                                      setState(() {
                                                        initialIdProof =
                                                            newValue;
                                                        adharcarddoc = "";
                                                        adharnum.clear();
                                                        internIdProofDocument =
                                                            "";
                                                        internIdProofController
                                                            .clear();
                                                      });
                                                    }
                                                  },
                                                  items: [
                                                    "Select",
                                                    "Passport",
                                                    "Driving Licence"
                                                  ].map((value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(
                                                            value.toString()));
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        initialIdProof == "Select"
                                            ? SizedBox()
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      initialIdProof +
                                                          " Number",
                                                      style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .deepOrangeAccent),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0),
                                                        child: TextFormField(
                                                          controller:
                                                              internIdProofController,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                      "Upload " +
                                                          initialIdProof,
                                                      style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .deepOrangeAccent),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12))),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.0,
                                                                horizontal:
                                                                    8.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            internIdProofDocument
                                                                            .toString() ==
                                                                        "" ||
                                                                    internIdProofDocument
                                                                            .toString() ==
                                                                        "null"
                                                                ? SizedBox()
                                                                : CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundImage:
                                                                        FileImage(
                                                                            File(internIdProofDocument)),
                                                                  ),
                                                            InkWell(
                                                              onTap: () {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                                _captureadharcard(
                                                                    false);
                                                              },
                                                              child: Container(
                                                                height: 45,
                                                                width: 120,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: const BoxDecoration(
                                                                    color: Colors
                                                                        .deepOrangeAccent,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(8.0))),
                                                                child: Text(
                                                                    "Choose file",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                      ],
                                    )
                                  : SizedBox()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                      elevation: 4.0,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Column(
                          children: [
                            const Text("Bank Detail",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Bank Name*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.deepOrangeAccent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required Field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: bankname,
                                  ),
                                )),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Branch Name*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.deepOrangeAccent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required Field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: branchname,
                                  ),
                                )),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Account Number*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.deepOrangeAccent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required Field';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: accountno,
                                  ),
                                )),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("Account Type*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 8),
                            FormField(
                              builder: (FormFieldState state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      // labelText: "Select",
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0))),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: accounttype.text.toString(),
                                      isDense: true,
                                      onChanged: (newValue) {
                                        if (newValue == "Select") {
                                          showToast(
                                              "Please select account type");
                                        } else {
                                          setState(() {
                                            accounttype.text = newValue;
                                          });
                                        }
                                      },
                                      items: _accounttypelist.map((value) {
                                        return DropdownMenuItem(
                                            value: value,
                                            child: Text(value.toString()));
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Container(
                            //     decoration: BoxDecoration(
                            //         border: Border.all(
                            //             width: 1,
                            //             color: Colors.deepOrangeAccent),
                            //         borderRadius:
                            //             BorderRadius.all(Radius.circular(12))),
                            //     child: Padding(
                            //       padding: const EdgeInsets.only(
                            //           left: 10.0, right: 10.0),
                            //       child: DropdownButtonHideUnderline(
                            //         child: DropdownButton<String>(
                            //           value: accounttype.text,
                            //           elevation: 16,
                            //           isExpanded: true,
                            //           style: TextStyle(
                            //               color: Colors.grey.shade700,
                            //               fontSize: 16),
                            //           onChanged: (String data) {
                            //             if (accounttype.text == "Select") {
                            //               showToast(
                            //                   "Please select account type");
                            //             } else {
                            //               setState(() {
                            //                 accounttype.text = data;
                            //               });
                            //             }
                            //           },
                            //           items: _accounttypelist
                            //               .map<DropdownMenuItem<String>>(
                            //                   (String value) {
                            //             return DropdownMenuItem<String>(
                            //               value: value,
                            //               child: Text(value),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     )),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text("IFSC Code*",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: Colors.deepOrangeAccent),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Required Field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    controller: ifsccode,
                                  ),
                                )),
                          ],
                        ),
                      )),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      // if (kyc == "1") {
                      if (country_id == null || country_id == "") {
                        showToast("Please select your country");
                      } else if (state_id == null || state_id == "") {
                        showToast("Please select your state");
                      } else if (city_id == null || city_id == "") {
                        showToast("Please select your city");
                      } else if (!_emailcheck && !_smscheck) {
                        showToast("Please check either email or sms");
                      } else if (initialtrustedbadge == "Select") {
                        showToast("Please select Trusted Badge");
                      } else if (kyc == true &&
                          country_id == "113" &&
                          adharcarddoc == "") {
                        showToast("Please upload Aadhaar Card");
                      } else if (kyc == true &&
                          country_id != "113" &&
                          initialIdProof == "Select") {
                        showToast("Please select Id Proof");
                      } else if (kyc == true &&
                          country_id != "113" &&
                          internIdProofDocument == "") {
                        showToast("Please upload " +
                            initialIdProof.toString() +
                            " documents");
                      } else if (accounttype.text == "Select") {
                        showToast("Please select account type");
                      } else if (key.currentState.validate()) {
                        _personaldetailupdatewithdoc();
                      }

                      // else if (commprefs.isEmpty || commprefs.length == 0) {
                      //     showToast("Please check one communication preference");
                      //   } else if (kyc == null || kyc == "" || kyc == "Select") {
                      //     showToast("Please select kyc");
                      //   } else if (trustbadge == null ||
                      //       trustbadge == "" ||
                      //       trustbadge == "Select") {
                      //     showToast("Please select trusted Badge");
                      //   }
                      //   // else if(bankname == null || bankname == ""){
                      //   //   showToast("Please enter bank name");
                      //   // }
                      //   // else if(branchname == null || bankname == ""){
                      //   //   showToast("Please enter bank name");
                      //   // }
                      //   // else if(accountno == null || accountno == ""){
                      //   //   showToast('Please enter account number');
                      //   // }
                      //   // else if(ifsccode == null || ifsccode == ""){
                      //   //   showToast('Please enter ifsc code');
                      //   // }
                      //   else {
                      //     _personaldetailupdatewithdoc(
                      //         country_id,
                      //         state_id,
                      //         city_id,
                      //         address,
                      //         pincode,
                      //         commprefs.join(","),
                      //         kyc,
                      //         trustbadge);
                      //   }
                      // } else {
                      //   if (country_id == null || country_id == "") {
                      //     showToast("Please select your country");
                      //   } else if (state_id == null || state_id == "") {
                      //     showToast("Please select your state");
                      //   } else if (city_id == null || city_id == "") {
                      //     showToast("Please select your city");
                      //   } else if (address == null || address == "") {
                      //     showToast("Please enter your address");
                      //   } else if (commprefs.isEmpty || commprefs.length == 0) {
                      //     showToast("Please check one communication preference");
                      //   } else if (kyc == null || kyc == "" || kyc == "Select") {
                      //     showToast("Please select kyc");
                      //   } else if (trustbadge == null ||
                      //       trustbadge == "" ||
                      //       trustbadge == "Select") {
                      //     showToast("Please select trusted Badge");
                      //   } else {
                      //     _personaldetailupdatewithoutdoc(
                      //         country_id,
                      //         state_id,
                      //         city_id,
                      //         address,
                      //         pincode,
                      //         commprefs.join(","),
                      //         kyc,
                      //         trustbadge);
                      //   }
                      // }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Card(
                        elevation: 12.0,
                        color: Colors.deepOrangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text("CONTINUE",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future _getcheckapproveData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final body = {
  //     "user_id": prefs.getString('userid'),
  //   };
  //   var response = await http.post(Uri.parse(BASE_URL + checkapprove),
  //       body: jsonEncode(body),
  //       headers: {
  //         "Accept": "application/json",
  //         'Content-Type': 'application/json'
  //       });
  //   print(response.body);
  //   print(prefs.getString('userid'));
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body)['Response'];
  //     setState(() {
  //       // usertype = data['user_type'].toString();
  //       // usertype = "3";
  //     });
  //   } else {
  //     throw Exception('Failed to get data due to ${response.body}');
  //   }
  // }

  Future _getprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      setState(() {
        country_id = data['User']['country'].toString();
        state_id = data['User']['state'].toString();
        city_id = data['User']['city'].toString();

        selectedCountry = data['User']['country_name'].toString();
        selectedState = data['User']['state_name'].toString();
        selectedCity = data['User']['city_name'].toString();

        bankname.text = data['User']['bank_name'].toString();
        branchname.text = data['User']['branch_name'].toString();
        accountno.text = data['User']['account_no'].toString();
        accounttype.text = data['User']['account_type'].toString();
        ifsccode.text = data['User']['ifsc'].toString();
        pincode.text = data['User']['pincode'].toString();

        initialtrustedbadge =
            data['User']['trusted_badge'].toString() == "1" ? "Yes" : "No";
        kyc = data['User']['kyc'].toString() == "1" ? true : false;
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getprofileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "id": prefs.getString('userid'),
    };
    var response = await http.post(Uri.parse(BASE_URL + profileUrl),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['Response'];
      if (data['User']['package_id'] != null &&
          data['User']['package_id'] != 1) {
        if (data['User']['payment_status'].toString() == "1") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Dashboard()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MakePaymentScreen()));
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      }
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getcountryData() async {
    setState(() {
      _loading = true;
    });
    var response = await http.get(Uri.parse(BASE_URL + getCountries), headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['countries'];
      setState(() {
        // countrylistData.add({"name": "Select", "id": 0});
        countrylistData.addAll(list);
        _loading = false;
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getStateData(String id) async {
    setState(() {
      _loading = true;
      statelistData.clear();
    });
    final body = {
      "id": int.parse(id),
    };
    var response = await http.post(Uri.parse(BASE_URL + getState),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['states'];
      setState(() {
        _loading = false;
        statelistData.addAll(list);
      });
    } else {
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _getCityData(String id) async {
    setState(() {
      _loading = true;
      citylistData.clear();
    });
    final body = {
      "id": int.parse(id),
    };
    var response = await http.post(Uri.parse(BASE_URL + getCity),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body)['Response']['cities'];
      setState(() {
        _loading = false;
        citylistData.addAll(list);
      });
    } else {
      print(response.body);
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future _personaldetailupdatewithdoc() async {
    List temp = [];
    if (_emailcheck) {
      temp.add("1");
    }
    if (_smscheck) {
      temp.add("2");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _loading = true;
    // });

    var requestMulti =
        http.MultipartRequest('POST', Uri.parse(BASE_URL + personalupdate));
    requestMulti.fields["id"] = prefs.getString('userid').toString();
    requestMulti.fields["address"] = address.text.toString();
    requestMulti.fields["country"] = country_id.toString();
    requestMulti.fields["state"] = state_id.toString();
    requestMulti.fields["city"] = city_id.toString();
    requestMulti.fields["kyc"] = kyc ? "1" : "0";
    requestMulti.fields["com_prefs"] = temp.join(",").toString();
    requestMulti.fields["trusted_badge"] =
        initialtrustedbadge == "Yes" ? "1" : "0";
    requestMulti.fields["account_type"] = accounttype.text.toString();
    requestMulti.fields["bank_name"] = bankname.text.toString();
    requestMulti.fields["branch_name"] = branchname.text.toString();
    requestMulti.fields["ifsc"] = ifsccode.text.toString();
    requestMulti.fields["account_no"] = accountno.text.toString();
    requestMulti.fields["adhaar_no"] = kyc && country_id == "113"
        ? accountno.text.toString()
        : internIdProofController.text.toString();
    requestMulti.fields["pincode"] = pincode.text.toString();
    print(requestMulti.fields);

    if (kyc && country_id == "113") {
      requestMulti.files
          .add(await http.MultipartFile.fromPath('adhaar_doc', adharcarddoc));
    } else if (kyc && country_id != "113") {
      requestMulti.files.add(await http.MultipartFile.fromPath(
          'adhaar_doc', internIdProofDocument));
    }

    requestMulti.send().then((response) {
      response.stream.toBytes().then((value) {
        try {
          var responseString = String.fromCharCodes(value);
          setState(() {
            _loading = false;
          });
          var jsonData = jsonDecode(responseString);
          if (jsonData['ErrorCode'].toString() == "0") {
            if (jsonData['Response']['user_type'].toString() == "3") {
              _getprofileData();
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          BankAndBusinessDetailScreen()));
            }
          } else {
            showToast(jsonData['Response'].toString());
          }
        } catch (e) {
          setState(() {
            _loading = false;
          });
        }
      });
    });
  }

  Future _personaldetailupdatewithoutdoc(
      String countryid,
      String stateid,
      String cityid,
      String address,
      String pincode,
      String commpref,
      String kyc,
      String trustbadge) async {
    print("Without doc");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
    });

    final body = {
      "id": prefs.getString('userid'),
      "address": address,
      // "country": country_id,
      "state": state_id,
      "city": city_id,
      "kyc": kyc,
      "com_prefs": commpref,
      "trusted_badge": trustbadge,
      "account_type": accounttype,
      "bank_name": bankname,
      "branch_name": branchname,
      "ifsc": ifsccode,
      "account_no": accountno,
      "pincode": pincode.toString()
    };
    print(jsonEncode(body));
    var response = await http.post(Uri.parse(BASE_URL + personalupdate),
        body: jsonEncode(body),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      if (json.decode(response.body)['Response']['user_type'].toString() ==
          "3") {
        _getprofileData();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    BankAndBusinessDetailScreen()));
      }
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to get data due to ${response.body}');
    }
  }

  Future<void> _captureadharcard(bool imageFor) async {
    final ImagePicker _picker = ImagePicker();
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(12, 0, 7, 0),
                    child: Text(
                      'Select',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            final XFile result = await _picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 80,
                              maxHeight: 480,
                              maxWidth: 640,
                            );
                            if (result != null) {
                              if (imageFor) {
                                setState(() {
                                  adharcarddoc = result.path.toString();
                                });
                              } else {
                                setState(() {
                                  internIdProofDocument =
                                      result.path.toString();
                                });
                              }
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: const Icon(Icons.camera, color: Colors.black),
                          label: const Text("Camera",
                              style: TextStyle(color: Colors.black))),
                      const SizedBox(width: 30),
                      ElevatedButton.icon(
                          onPressed: () async {
                            final XFile result = await _picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 80,
                              maxHeight: 480,
                              maxWidth: 640,
                            );

                            if (result != null) {
                              if (imageFor) {
                                setState(() {
                                  adharcarddoc = result.path.toString();
                                });
                              } else {
                                setState(() {
                                  internIdProofDocument =
                                      result.path.toString();
                                });
                              }
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                          icon: const Icon(Icons.photo, color: Colors.black),
                          label: const Text("Gallery",
                              style: TextStyle(color: Colors.black))),
                    ],
                  )
                ])));
  }

  Future<Position> _determinePosition() async {
    setState(() {
      _loading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(value) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(value.latitude, value.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      _loading = false;
      address.text = place.subLocality.toString() +
          "," +
          place.locality.toString() +
          "," +
          place.postalCode.toString() +
          "," +
          place.administrativeArea.toString() +
          "," +
          place.country.toString();
    });
  }
}
