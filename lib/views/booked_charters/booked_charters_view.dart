import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/model/flights.dart';
import 'package:set_jet/model/usermodel.dart';
import 'package:set_jet/widgets/dumb_widgets/bookedcharter.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';

class BookedCharterView extends StatefulWidget {
  final UserData data;
  const BookedCharterView({Key? key, required this.data}) : super(key: key);

  @override
  State<BookedCharterView> createState() => _BookedCharterViewState();
}

class _BookedCharterViewState extends State<BookedCharterView> {
  List<Flights> flights = [];
  //getting booked charters

  Future getbookings() async {
    //loadingBar('loading details..... please wait', true, 3);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('flights')
        .where('psngr_id', isEqualTo: widget.data.userID)
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        flights = snapshot.docs.map((e) => Flights.fromMap(e.data() as Map<String, dynamic>)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getbookings();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    //return ViewModelBuilder<BookedChartersViewModel>.reactive(
    //builder: (BuildContext context, BookedChartersViewModel viewModel, Widget? _) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
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
            centerTitle: true,
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.more_vert,
            //     ),
            //   )
            // ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booked Charters',
                          style: GoogleFonts.rubik(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600,
                          )),

                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "You have ${flights.length} bookings",
                        style: GoogleFonts.rubik(
                          color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      //add booked charter list
                      ListView.builder(
                          itemCount: flights.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Bookings(
                              flight: flights[index],
                              userData: widget.data,
                            );
                          })
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
    //},
    //viewModelBuilder: () => BookedChartersViewModel(),
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
