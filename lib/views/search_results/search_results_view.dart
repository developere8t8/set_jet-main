import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/model/charter.dart';
import 'package:set_jet/model/usermodel.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/dumb_widgets/saerchcharter.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import '../../widgets/dumb_widgets/app_button.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' show Brightness, FontWeight, ImageFilter, TextAlign;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:snack/snack.dart';

class SearchResultsView extends StatefulWidget {
  final UserData data;

  const SearchResultsView({Key? key, required this.data}) : super(key: key);

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  List<String> airPorts = [];
  List<Charter> charters = [];
  int charterLength = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController departureAirport = TextEditingController();
  TextEditingController arrivalAirport = TextEditingController();
  //searching charters
  Future searchCharter(String departure, String arrival) async {
    loadingBar('searching charters....please wait', true, 3);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('charters')
        .where('from', isEqualTo: departure)
        .where('to', isEqualTo: arrival)
        .where('active', isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        charters = snapshot.docs.map((e) => Charter.fromMap(e.data() as Map<String, dynamic>)).toList();
        charterLength = charters.length;
      });
    } else {
      // ignore: use_build_context_synchronously
      alert('No charter found', 'Alert', context);
    }
  }

  //getting airports for search
  void getAiports(String? val) async {
    String apiKey = 'AIzaSyCEmHBhem_KFl1_prIbKS2wIA1pTDGRB74';
    if (val!.isNotEmpty) {
      Uri requestUri = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$val&key=$apiKey');
      final response = await http.get(requestUri);
      if (response.statusCode == 200) {
        setState(() {
          var temp = jsonDecode(response.body)['predictions'];
          //airPorts.clear();
          for (var element in temp) {
            airPorts.add(element['description']);
          }
        });
      }
    } else {
      setState(() {
        airPorts.clear();
      });
    }
  }

  //search airports
  Widget createdepatureAirportSearch() {
    return Form(
        child: SizedBox(
      height: 70.h,
      width: 331.w,
      child: TypeAheadFormField(
        suggestionsCallback: (patteren) =>
            airPorts.where((element) => element.toLowerCase().contains(patteren.toLowerCase())),
        onSuggestionSelected: (String value) {
          departureAirport.text = value;
        },
        itemBuilder: (_, String item) => Card(
          color: Colors.purple[100],
          child: ListTile(
            title: Text(item),
            leading: const Icon(Icons.place_outlined),
          ),
        ),
        getImmediateSuggestions: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
        noItemsFoundBuilder: (_) => const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text('No airport found'),
        ),
        textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                labelText: 'Departure',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
            controller: departureAirport,
            onChanged: (String? val) {
              getAiports(val);
            }),
      ),
    ));
  }

  Widget createarrivalAirportSearch() {
    return Form(
        child: SizedBox(
      height: 70.h,
      width: 331.w,
      child: TypeAheadFormField(
        suggestionsCallback: (patteren) =>
            airPorts.where((element) => element.toLowerCase().contains(patteren.toLowerCase())),
        onSuggestionSelected: (String value) async {
          arrivalAirport.text = value;
        },
        itemBuilder: (_, String item) => Card(
          color: Colors.purple[100],
          child: ListTile(
            title: Text(item),
            leading: const Icon(Icons.place_outlined),
          ),
        ),
        getImmediateSuggestions: true,
        hideSuggestionsOnKeyboardHide: true,
        hideOnEmpty: true,
        noItemsFoundBuilder: (_) => const Padding(
          padding: EdgeInsets.all(5.0),
          child: Text('No airport found'),
        ),
        textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                labelText: 'Arrival',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
            controller: arrivalAirport,
            onChanged: (String? val) {
              getAiports(val);
            }),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<SearchResultsViewModel>.reactive(
    // builder: (BuildContext context, SearchResultsViewModel viewModel, Widget? _) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: MaterialButton(
                  child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomBlurredDrawerWidget(data: widget.data)));
                  },
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                title: Image.asset(
                  'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                  height: 41.h,
                  width: 50.w,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(3.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Charters',
                            style: GoogleFonts.rubik(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w600,
                                color: !isLight ? Colors.white : Colors.black),
                          ),
                          Text(
                            "You have ${charters.length} options",
                            style: GoogleFonts.rubik(
                              color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          createdepatureAirportSearch(),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          createarrivalAirportSearch(),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150.w,
                                height: 56.h,
                                child: AppButton(
                                  color: accentColor,
                                  textColor: Colors.white,
                                  text: 'Search Charters',
                                  onpressed: () {
                                    if (departureAirport.text.isNotEmpty &&
                                        arrivalAirport.text.isNotEmpty) {
                                      searchCharter(departureAirport.text, arrivalAirport.text);
                                    } else {
                                      loadingBar(
                                          'please provide departure & arrival airports', false, 1);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          ListView.builder(
                              itemCount: charters.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return SearchCharterResult(
                                  charter: charters[index],
                                  data: widget.data,
                                );
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ))),
    );
    //},
    //viewModelBuilder: () => SearchResultsViewModel(),
    //);
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
