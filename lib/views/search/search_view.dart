import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/search/widgets/aircraft_size.dart';
import 'package:set_jet/views/search/widgets/depart_arrival_widget.dart';
import 'package:set_jet/views/search/widgets/est_time_widget.dart';
import 'package:set_jet/views/search/widgets/flight_features.dart';
import 'package:set_jet/views/search/widgets/passenger.dart';
import 'package:set_jet/views/search/widgets/previous_flights_card.dart';
import 'package:set_jet/views/search/widgets/price_widget.dart';
import 'package:set_jet/views/search/widgets/trip_date_time.dart';
import 'package:set_jet/views/search/widgets/trip_type_selector.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../constants/drawer_enum.dart';
import 'search_view_model.dart';

class SearchView extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (BuildContext context, SearchViewModel viewModel, Widget? _) {
        var isLight = Theme.of(context).brightness == Brightness.light;
        return Scaffold(
            // key: scaffoldKey,
            // drawer: const CustomBlurredDrawerWidget(
            //   drawerOption: DrawerOptions.SearchFlights,
            // ),
            appBar: AppBar(
              leading: MaterialButton(
                child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
              backgroundColor: isLight ? const Color(0xffF1F1F1) : Colors.black,
              elevation: 0,
              title: Image.asset(
                'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                height: 41.h,
                width: 50.w,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    openSearchDialog(context, isLight);
                  },
                ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                  margin: EdgeInsets.only(right: 25.w),
                  child: CircleAvatar(
                    backgroundImage: const AssetImage(
                      "assets/profile.png",
                    ),
                    radius: 20.h,
                  ),
                )
              ],
            ),
            body: Stack(
              // fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100.h,
                  width: MediaQuery.of(context).size.width,
                  color: isLight ? const Color(0xffF1F1F1) : Colors.black,
                ),
                ListView(
                  children: [
                    EstimatedTimeWidget(isLight: isLight),
                    const DepartArrivalWidget(),
                    TripTypeSelector(
                      isLight: isLight,
                      index: viewModel.index,
                      onOneway: viewModel.onOneWay,
                      onRoundTrip: viewModel.ononRoundTrip,
                      onMultiLeg: viewModel.onMultiLeg,
                    ),
                    TripDateTimeWidget(isLight: isLight),
                    PassengerWidget(isLight: isLight),
                    AircraftSizeWidget(isLight: isLight),
                    PriceWidget(isLight: isLight),
                    FlightFeaturesWidget(
                      isLight: isLight,
                      text: "Non-stop",
                      value: true,
                    ),
                    FlightFeaturesWidget(
                      isLight: isLight,
                      text: "WiFi",
                      value: true,
                    ),
                    FlightFeaturesWidget(
                      isLight: isLight,
                      text: "WYVERN",
                      value: true,
                    ),
                  ],
                )
              ],
            ));
      },
      viewModelBuilder: () => SearchViewModel(),
    );
  }

  void openSearchDialog(context, isLight) {
    showDialog(
        barrierColor: Colors.black38,
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(

                      // height: 100.h,
                      padding: EdgeInsets.all(8.w),
                      margin: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isLight ? lightSecondary : darkSecondary,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: accentColor,
                              prefixIcon: const Icon(
                                Icons.search_sharp,
                                color: Color(0x66ffffff),
                              ),
                              label: Text("Search Airport",
                                  style: GoogleFonts.rubik(
                                    color: Color(0x66ffffff),
                                  )),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            "Previous Searches",
                            style: GoogleFonts.rubik(
                                color: isLight ? darkSecondary : const Color(0x66ffffff)),
                          ),
                          const PreviousFlightSearches(),
                          const PreviousFlightSearches(),
                          const PreviousFlightSearches(),
                          const PreviousFlightSearches(),
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }
}
