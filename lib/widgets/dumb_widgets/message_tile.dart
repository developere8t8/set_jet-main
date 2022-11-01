import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:set_jet/views/chatbox_screen/chatbox_screen_view.dart';

import '../../model/chatroom.dart';
import '../../model/usermodel.dart';

class MessageTile extends StatefulWidget {
  const MessageTile({
    Key? key,
    required this.isLight,
    this.IsNewMessage,
    this.changeColor,
    required this.model,
    required this.userdata,
  }) : super(key: key);

  final bool isLight;
  final bool? IsNewMessage;
  final bool? changeColor;
  final ChatRoomModel model; //chatroom details
  final UserData userdata; //user details

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  UserData? targetuser; //target user details
  int unread = 0;
  //getting target user info and last message etc
  void getchatroominfo() async {
    Map<String, dynamic> participants = widget.model.participants!;
    List<String> targetParticipant = participants.keys.toList();
    targetParticipant.remove(widget.userdata.userID);
    QuerySnapshot snapshotchat = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: targetParticipant[0])
        .get();

    QuerySnapshot snapshotunrad = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.model.ctrid)
        .collection('messages')
        .where('seen', isEqualTo: false)
        .where('sender', isNotEqualTo: widget.userdata.userID)
        .get();
    setState(() {
      targetuser = UserData.fromMap(snapshotchat.docs.first.data() as Map<String, dynamic>);
      unread = snapshotunrad.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getchatroominfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatboxScreenView(
                      userdata: widget.userdata,
                      targetuser: targetuser!,
                      model: widget.model,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 7.0, bottom: 7.0),
        width: double.infinity,
        height: 90.h,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: widget.IsNewMessage!
                ? !widget.isLight
                    ? const Color(0xFF1F374E)
                    : const Color(0xFFCEE6FD)
                : widget.changeColor!
                    ? Colors.transparent
                    : !widget.isLight
                        ? const Color(0xFF404040)
                        : const Color(0xFFF1F1F1)),
        child: targetuser == null
            ? Center(
                child: SizedBox(height: 20, width: 20, child: Container()),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: targetuser!.pic!.isEmpty
                                ? const CircleAvatar(
                                    radius: 30,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage('assets/profile.png'),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(targetuser!.pic!),
                                      backgroundColor: Colors.grey,
                                    ),
                                  )),
                        SizedBox(
                          width: 15.w,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                targetuser!.userName.toString(),
                                style: GoogleFonts.rubik(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: widget.IsNewMessage!
                                        ? const Color(0xFF0B78DF)
                                        : (!widget.isLight)
                                            ? Colors.white
                                            : Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Expanded(
                              child: Text(
                                widget.model.lastmessage!.length < 30
                                    ? widget.model.lastmessage!
                                    : widget.model.lastmessage!.substring(0, 25),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style: GoogleFonts.rubik(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: widget.IsNewMessage!
                                        ? !widget.isLight
                                            ? Colors.white
                                            : Colors.black
                                        : !widget.isLight
                                            ? const Color(0xFFC0C0C0)
                                            : const Color(0xFFC0C0C0)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(getHours(widget.model.createdon!.toDate()),
                            style: GoogleFonts.rubik(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: (widget.IsNewMessage! && !widget.isLight)
                                    ? const Color(0xFFC0C0C0)
                                    : const Color(0xFF7B7B7B))),
                        widget.IsNewMessage!
                            ? Visibility(
                                visible: unread == 0 ? false : true,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    height: 25.h,
                                    width: 25.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0982F4),
                                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                    ),
                                    child: Center(
                                      child: Text(unread.toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SizedBox(
                                  height: 23.h,
                                  width: 23.w,
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }

  String getHours(DateTime dateTime) {
    int days = DateTime.now().difference(dateTime).inDays;
    String label = '';
    if (days == 0) {
      setState(() {
        int mints = DateTime.now().difference(dateTime).inMinutes;
        label = DateFormat('hh:mm a').format(DateTime.now().subtract(Duration(minutes: mints)));
      });
    } else if (days == 1) {
      setState(() {
        label = 'yesterday';
      });
    } else if (days > 1) {
      setState(() {
        label = DateFormat('MM/dd/yyy').format(DateTime.now().subtract(Duration(days: days)));
      });
    }
    return label;
  }
}
