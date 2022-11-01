// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/loader.dart';
import 'package:set_jet/theme/common.dart';
import 'package:snack/snack.dart';
import 'package:stacked/stacked.dart';
import '../../model/usermodel.dart';
import '../home/home_view.dart';
import 'time_zone_setting_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: use_key_in_widget_constructors
class TimeZoneSettingView extends StatefulWidget {
  @override
  State<TimeZoneSettingView> createState() => _TimeZoneSettingViewState();
}

class _TimeZoneSettingViewState extends State<TimeZoneSettingView> {
  List<String> dropdownValues = [];
  bool isLoading = false;
  bool autoDetect = true;
  String detectedTimeZone = '';
  DateTime datetime = DateTime.now();
  Future getTimeZones() async {
    //loadingBar('Loading.... please wait', true, 3);
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('http://worldtimeapi.org/api/timezone');
    final response =
        await http.get(url, headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"});

    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      setState(() {
        dropdownValues = jsonDecode(response.body).cast<String>() as List<String>;
      });
    } else {
      // ignore: use_build_context_synchronously
      alert(response.body, 'Error', context);
    }
  }

  Future getSpecificTimeZone(String? country) async {
    setState(() {
      isLoading = true;
    });

    var url = Uri.parse('http://worldtimeapi.org/api/timezone/$country');
    final response =
        await http.get(url, headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"});
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      setState(() {
        detectedTimeZone =
            '${jsonDecode(response.body)['abbreviation']} (${jsonDecode(response.body)['timezone']})';
      });
    } else {
      // ignore: use_build_context_synchronously
      alert(response.body, 'Error', context);
    }
  }

  @override
  void initState() {
    super.initState();
    getTimeZones();
    detectedTimeZone = datetime.timeZoneName;
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const Loader()
      : ViewModelBuilder<TimeZoneSettingViewModel>.reactive(
          builder: (BuildContext context, TimeZoneSettingViewModel viewModel, Widget? _) {
            return Builder(builder: (context) {
              var theme = Theme.of(context);
              var isLight = theme.brightness == Brightness.light;
              return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: SizedBox(
                      height: 50.h,
                      width: 50.w,
                      child: Image.asset(
                        'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: Center(
                      child: Column(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Center(
                            child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Timezone Settings',
                                    style: GoogleFonts.rubik(
                                        color: !isLight ? Color(0xFFA7A7A7) : Color(0xFF7C7C7C),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp)),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  Text('Detected Timezone',
                                      style: GoogleFonts.rubik(
                                          color: !isLight ? Color(0xFFA7A7A7) : Color(0xFF7C7C7C),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp)),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(detectedTimeZone,
                                      style: GoogleFonts.rubik(
                                          color: accentColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24.sp)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Container(
                                    height: 62.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: !isLight ? Colors.black : Color(0xFFF1F1F1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Set Automatically',
                                                style: GoogleFonts.rubik(
                                                    color: !isLight ? Colors.white : Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15.sp)),
                                            Switch(
                                                value: autoDetect,
                                                onChanged: (value) {
                                                  setState(() {
                                                    detectedTimeZone = datetime.timeZoneName;
                                                    autoDetect = value;
                                                  });
                                                })
                                            // ToggleSwitch(
                                            //   minWidth: 60.w,
                                            //   cornerRadius: 6.0,
                                            //   activeBgColors: [
                                            //     [accentColor],
                                            //     [accentColor]
                                            //   ],
                                            //   activeFgColor: Colors.white,
                                            //   inactiveBgColor:
                                            //       !isLight ? Color(0xFF404040) : Colors.white,
                                            //   inactiveFgColor: Color(0xFF707070),
                                            //   initialLabelIndex: 1,
                                            //   totalSwitches: 2,
                                            //   labels: ['Yes', 'No'],
                                            //   radiusStyle: true,
                                            //   onToggle: (index) {
                                            //     viewModel.timeZoneIndex(index);
                                            //     // setState(() {
                                            //     //   //index == 0 ? autoDetect = true : autoDetect = false;
                                            //     // });
                                            //   },
                                            // ),
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  Text('Or Select Timezone Manually',
                                      style: GoogleFonts.rubik(
                                          color: !isLight ? Color(0xFFA7A7A7) : Color(0xFF7C7C7C),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16.sp)),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Timezones',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                      ),
                                      items: dropdownValues
                                          .map((value) => DropdownMenuItem(
                                                child: Text(value,
                                                    style: GoogleFonts.rubik(
                                                        color: !isLight ? Colors.white : Colors.black,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16.sp)),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: autoDetect == true
                                          ? null
                                          : (String? value) {
                                              getSpecificTimeZone(value);
                                            },
                                      isExpanded: false,
                                      value: dropdownValues.first,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        )),
                      ),
                      Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: MaterialButton(
                                        elevation: 0,
                                        color: !isLight ? Color(0xFF242424) : Colors.white,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              color: !isLight ? Colors.white : Colors.black,
                                            ),
                                            Text(
                                              'Back',
                                              style: GoogleFonts.rubik(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color: !isLight
                                                    ? Colors.white
                                                    : Colors.black, //change your color here
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })),
                                Expanded(
                                  child: Container(),
                                  flex: 2,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 20.w,
                                    child: MaterialButton(
                                      color: accentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      onPressed: () {
                                        updateUserData();
                                        viewModel.navigateToSubsciptionScreen();
                                      },
                                      child: Text(
                                        "Next",
                                        style: GoogleFonts.rubik(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white, //change your color here
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    ],
                  )));
            });
          },
          viewModelBuilder: () => TimeZoneSettingViewModel(),
        );
  //}//

  Future updateUserData() async {
    try {
      loadingBar('Updating data ... please wait', true, 3);
      User? user = FirebaseAuth.instance.currentUser;
      final docUser = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      docUser.update({'timezone': detectedTimeZone});
      if (user != null) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
        if (snapshot.docs.isNotEmpty) {
          UserData data = UserData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
        }
      }
    } catch (e) {
      alert(e.toString(), 'Error', context);
    }
  }

  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(content),
          (load) ? const CircularProgressIndicator(color: Colors.red) : const Text(''),
        ],
      ),
      duration: Duration(seconds: duration),
    );
    bar.show(context);
  }

  void alert(String _content, String _title, _context) {
    showDialog(
        context: _context,
        builder: (context) => AlertDialog(
              title: Text(_title),
              content: Text(_content),
              actions: const [
                CloseButton(),
              ],
            ));
  }
}
