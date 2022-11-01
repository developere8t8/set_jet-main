import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/model/charter.dart';
import 'package:set_jet/model/planes.dart';
import 'package:set_jet/views/charter_details/charter_details_view.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';

import '../../model/contact.dart';
import '../../model/usermodel.dart';
import '../../theme/common.dart';
import '../../theme/dark.dart';
import '../../theme/light.dart';

class SentRequestView extends StatefulWidget {
  final UserData userdata;
  const SentRequestView({Key? key, required this.userdata}) : super(key: key);

  @override
  State<SentRequestView> createState() => _SentRequestViewState();
}

class _SentRequestViewState extends State<SentRequestView> {
  List<ContactRequest> contactRequest = [];
  List<ContactRequest> dummyRequests = [];
  //getting pending contact requests
  void getRequest() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('contact_requests')
        .where('sender', isEqualTo: widget.userdata.userID)
        .orderBy('sent_on', descending: true)
        .get();

    setState(() {
      contactRequest =
          snapshot.docs.map((d) => ContactRequest.fromMap(d.data() as Map<String, dynamic>)).toList();
      dummyRequests =
          snapshot.docs.map((e) => ContactRequest.fromMap(e.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getRequest();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    //return ViewModelBuilder<SentRequestViewModel>.reactive(
    //builder: (BuildContext context, SentRequestViewModel viewModel, Widget? _) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: MaterialButton(
            child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomBlurredDrawerWidget(data: widget.userdata)));
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Image.asset(
            'assets/logo_${!isLight ? 'dark' : 'light'}.png',
            height: 41.h,
            width: 50.w,
          ),
          actions: [
            IconButton(
              color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
              onPressed: () {
                setState(() {
                  contactRequest.clear();
                });
                getRequest();
              },
              icon: const Icon(
                Icons.refresh,
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Requests',
                      style: GoogleFonts.rubik(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(
                    "You have ${contactRequest.length} contact request",
                    style: GoogleFonts.rubik(
                      color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                      itemCount: contactRequest.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Request(
                          isLight: isLight,
                          request: contactRequest[index],
                          userdata: widget.userdata,
                        );
                      })
                ],
              ),
            )),
      ),
    );
    //},
    //viewModelBuilder: () => SentRequestViewModel(),
//);
  }
}

class Request extends StatefulWidget {
  final bool isLight;
  final ContactRequest request;
  final UserData userdata;
  const Request({Key? key, required this.isLight, required this.request, required this.userdata})
      : super(key: key);

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  String statusTxt = '';
  UserData? data;
  void getSenderData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.request.receiver)
        .get();
    // alert(snapshot.docs.first.data().toString(), '_title', context);
    setState(() {
      if (snapshot.docs.isNotEmpty) {
        data = UserData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      statusTxt = widget.request.status.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getSenderData();
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Center(child: Container())
        : Container(
            margin: const EdgeInsets.only(top: 10.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: widget.isLight ? lightSecondary : darkSecondary,
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                    leading: data!.pic.toString().isEmpty
                        ? const CircleAvatar(
                            radius: 20.0,
                            backgroundImage: AssetImage('assets/profile.png'),
                          )
                        : CircleAvatar(
                            radius: 20.0,
                            backgroundImage: NetworkImage(data!.pic.toString()),
                          ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text('${data!.userName.toString()} ${data!.lastName.toString()}'),
                        )
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: statusTxt == 'Pending'
                              ? Colors.pink[200]
                              : statusTxt == 'Accepted'
                                  ? Colors.green[200]
                                  : Colors.red[500],
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        statusTxt,
                        style: TextStyle(color: accentColor),
                      ),
                    )),
                SizedBox(
                  height: 10.h,
                ),
                //Create accept and reject button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            getCharter();
                          },
                          color: accentColor,
                          child: const Text(
                            "View Charter",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  //chareter get
  Future getCharter() async {
    loadingBar('loading details ...please wait', true, 5);

    QuerySnapshot snapshotcharter = await FirebaseFirestore.instance
        .collection('charters')
        .where('id', isEqualTo: widget.request.charterid)
        .get();
    Charter charter = Charter.fromMap(snapshotcharter.docs.first.data() as Map<String, dynamic>);

    QuerySnapshot snapshotplane = await FirebaseFirestore.instance
        .collection('planes')
        .where('id', isEqualTo: charter.planeid)
        .get();
    Planes planes = Planes.fromMap(snapshotplane.docs.first.data() as Map<String, dynamic>);

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CharterDetailsView(
                  userdata: widget.userdata,
                  charter: charter,
                  plane: planes,
                  operator: data!,
                  visible: true,
                )));
  }

//loding bar
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
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                        color: Colors.green,
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection('contact_requests')
                              .doc(widget.request.id);
                          docUser.update({'status': 'Rejected'});
                          setState(() {
                            statusTxt = 'Rejected';
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Yes')),
                    MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'))
                  ],
                )
              ],
            ));
  }
}
