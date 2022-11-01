import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/model/chatroom.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';

import '../../model/message.dart';
import '../../model/usermodel.dart';
import 'package:intl/intl.dart';

class ChatboxScreenView extends StatefulWidget {
  final UserData userdata;
  final UserData targetuser;
  final ChatRoomModel model;
  const ChatboxScreenView(
      {Key? key, required this.userdata, required this.targetuser, required this.model})
      : super(key: key);

  @override
  State<ChatboxScreenView> createState() => _ChatboxScreenViewState();
}

class _ChatboxScreenViewState extends State<ChatboxScreenView> {
  TextEditingController msgController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void updateSeen() {
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.model.ctrid)
        .collection('messages')
        .where('seen', isEqualTo: false)
        .get()
        .then((res) {
      for (var result in res.docs) {
        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.model.ctrid)
            .collection('messages')
            .doc(result.id)
            .update({'seen': true});
      }
    });
    setState(() {});
  }

  void sendMsg() {
    String msg = msgController.text.trim();
    msgController.clear();
    if (msg.isNotEmpty) {
      final msgUser = FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.model.ctrid)
          .collection('messages')
          .doc();
      Messages msgs = Messages(
          messageid: msgUser.id,
          createdon: Timestamp.fromDate(DateTime.now()),
          seen: false,
          sender: widget.userdata.userID,
          text: msg);

      final lastmsg = FirebaseFirestore.instance.collection('chatrooms').doc(widget.model.ctrid);

      lastmsg.update({
        'lastmessage': msg,
        'created_on': Timestamp.fromDate(DateTime.now())
      }); //updating last message

      msgUser.set(msgs.toMap()); //saving new message
    }
  }

  @override
  void initState() {
    super.initState();
    updateSeen();
  }

  @override
  Widget build(BuildContext context) {
    // return ViewModelBuilder<ChatboxScreenViewModel>.reactive(
    // builder: (BuildContext context, ChatboxScreenViewModel viewModel, Widget? _) {
    //var scaffoldKey = GlobalKey<ScaffoldState>();
    //return Builder(builder: (context) {
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: !isLight ? Colors.black : const Color(0xFFF1F1F1),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: accentColor, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Container(
                  child: widget.targetuser.pic!.isEmpty
                      ? const CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                        )
                      : CircleAvatar(
                          radius: 20,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(widget.targetuser.pic!),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                ),
                SizedBox(width: 10.w),
                Text('${widget.targetuser.userName} ${widget.targetuser.lastName}',
                    style: GoogleFonts.rubik(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: !isLight ? Colors.white : Colors.black)),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(widget.model.ctrid)
                          .collection('messages')
                          .orderBy('createdon', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                            List<Messages> msgs = datasnapshot.docs
                                .map((d) => Messages.fromMap(d.data() as Map<String, dynamic>))
                                .toList();
                            return ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                primary: false,
                                reverse: true,
                                itemCount: datasnapshot.docs.length,
                                itemBuilder: (context, int index) {
                                  return msgs[index].sender != widget.userdata.userID
                                      ? SizedBox(
                                          width: 100,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                  child: ReceiverBubble(
                                                      isLight: isLight,
                                                      text: msgs[index].text,
                                                      time: DateFormat('MM/dd/yyyy hh:mm')
                                                          .format(msgs[index].createdon!.toDate())))
                                            ],
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: SendBubble(
                                                    isLight: isLight,
                                                    text: msgs[index].text,
                                                    time: DateFormat('MM/dd/yyyy hh:mm')
                                                        .format(msgs[index].createdon!.toDate())))
                                          ],
                                        );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                'No previous Chats',
                              ),
                            );
                          }
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          );
                        } else {
                          return const Text('Error in fetching chats...please try again later');
                        }
                      })),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      backgroundColor: Colors.grey,
                      child: const Icon(Icons.arrow_downward),
                      onPressed: () {
                        scrollController.animateTo(scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                      }),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        maxLines: null,
                        controller: msgController,
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            filled: true,
                            hintStyle: GoogleFonts.rubik(color: const Color(0xFFB3B3B3)),
                            hintText: 'Write message...',
                            labelStyle: GoogleFonts.rubik(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: !isLight ? const Color(0xFF9F9F9F) : const Color(0xFF9F9F9F)),
                            fillColor: !isLight ? const Color(0xFF404040) : Colors.white),
                      ),
                    ),
                    MaterialButton(
                        color: accentColor,
                        shape: const CircleBorder(),
                        onPressed: () {
                          scrollController.animateTo(scrollController.position.minScrollExtent,
                              duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                          sendMsg();
                        },
                        child: SizedBox(
                            width: 56.w,
                            height: 56.h,
                            child: const Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //}
    // );
    // },
    // viewModelBuilder: () => ChatboxScreenViewModel(),
    //);
  }
}

class ReceiverBubble extends StatelessWidget {
  const ReceiverBubble({
    Key? key,
    required this.isLight,
    this.text,
    this.time,
  }) : super(key: key);

  final bool isLight;
  // ignore: prefer_typing_uninitialized_variables
  final text;
  // ignore: prefer_typing_uninitialized_variables
  final time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 50.h, right: 10, top: 10, bottom: 10),
      child: ChatBubble(
        backGroundColor: !isLight ? Colors.black : Color(0xFF9A9A9A),
        elevation: 0,
        clipper: ChatBubbleClipper6(type: BubbleType.receiverBubble),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.rubik(
                        fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    time,
                    style: GoogleFonts.rubik(
                        fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color(0xFFAEAEAE)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SendBubble extends StatelessWidget {
  const SendBubble({
    Key? key,
    required this.isLight,
    this.text,
    this.time,
  }) : super(key: key);

  final bool isLight;
  // ignore: prefer_typing_uninitialized_variables
  final text;
  // ignore: prefer_typing_uninitialized_variables
  final time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 50.h, top: 10, bottom: 10),
      child: ChatBubble(
        backGroundColor: !isLight ? const Color(0xFF404040) : const Color(0xFFF1F1F1),
        elevation: 0,
        clipper: ChatBubbleClipper6(type: BubbleType.sendBubble),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.rubik(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: !isLight ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GoogleFonts.rubik(
                      fontSize: 10.sp, fontWeight: FontWeight.w400, color: Color(0xFFAEAEAE)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
