import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/dumb_widgets/message_tile.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';
import '../../model/chatroom.dart';
import '../../model/usermodel.dart';

class MessagesScreenView extends StatefulWidget {
  final UserData userdata;

  const MessagesScreenView({Key? key, required this.userdata}) : super(key: key);
  @override
  State<MessagesScreenView> createState() => _MessagesScreenViewState();
}

class _MessagesScreenViewState extends State<MessagesScreenView> {
  List<ChatRoomModel> chatrooms = [];
  Future getChats() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('participants.${widget.userdata.userID}', isEqualTo: true)
          .get();
      if (snapshot.docs.isNotEmpty) {
        chatrooms =
            snapshot.docs.map((d) => ChatRoomModel.fromMap(d.data() as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      loadingBar(e.toString(), true, 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<MessagesScreenViewModel>.reactive(
    //builder: (BuildContext context, MessagesScreenViewModel viewModel, Widget? _) {
    //var scaffoldKey = GlobalKey<ScaffoldState>();
    //return Builder(builder: (context) {
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          leading: MaterialButton(
            child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomBlurredDrawerWidget(
                            data: widget.userdata,
                            unRead: 0,
                          )));
            },
          ),
          actions: [
            Icon(
              Icons.more_vert,
              color: !isLight ? Colors.white : Colors.black,
            ),
          ],
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text('Messages',
                    style: GoogleFonts.rubik(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: !isLight ? Colors.white : Colors.black)),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,
                          color: !isLight ? const Color(0xFF9F9F9F) : const Color(0xFF9F9F9F)),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                        borderSide: BorderSide(
                          color: accentColor,
                        ),
                      ),
                      filled: true,
                      hintStyle: GoogleFonts.rubik(color: Colors.grey[800]),
                      labelText: 'Search in messages',
                      labelStyle: GoogleFonts.rubik(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: !isLight ? Color(0xFF9F9F9F) : Color(0xFF9F9F9F)),
                      fillColor: !isLight ? Color(0xFF404040) : Color(0xFFF1F1F1)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .where('participants.${widget.userdata.userID}', isEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
                          List<ChatRoomModel> chatrooms = querySnapshot.docs
                              .map((d) => ChatRoomModel.fromMap(d.data() as Map<String, dynamic>))
                              .toList();
                          chatrooms
                              .sort((a, b) => a.createdon!.toDate().compareTo(b.createdon!.toDate()));
                          return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: chatrooms.length,
                              itemBuilder: (context, int index) {
                                return MessageTile(
                                  isLight: isLight,
                                  IsNewMessage: true,
                                  changeColor: false,
                                  model: chatrooms[index],
                                  userdata: widget.userdata,
                                );
                              });
                        } else {
                          return const Center(
                            child: Text('No Chats....!'),
                          );
                        }
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.red,
                        );
                      } else {
                        return const Text('Error in fetching chats...please try again later');
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
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

  void alert(String content, String title, context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: const [
                CloseButton(),
              ],
            ));
  }
}
