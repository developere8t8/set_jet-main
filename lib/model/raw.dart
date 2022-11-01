// Column(
//         children: [
//           Expanded(child: Container()),
//           Expanded(
//             flex: 15,
//             //child: SizedBox(
//             // height: MediaQuery.of(context).size.height / 1.1,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   StreamBuilder(
//                       stream: FirebaseFirestore.instance
//                           .collection('chatrooms')
//                           .doc(widget.model.ctrid)
//                           .collection('messages')
//                           .orderBy('createdon', descending: true)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState == ConnectionState.active) {
//                           if (snapshot.hasData) {
//                             QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
//                             List<Messages> msgs = datasnapshot.docs
//                                 .map((d) => Messages.fromMap(d.data() as Map<String, dynamic>))
//                                 .toList();
//                             return ListView.builder(
//                                 controller: scrollController,
//                                 shrinkWrap: true,
//                                 primary: false,
//                                 reverse: true,
//                                 itemCount: datasnapshot.docs.length,
//                                 itemBuilder: (context, int index) {
//                                   return msgs[index].sender != widget.userdata.userID
//                                       ? Row(
//                                           mainAxisAlignment: MainAxisAlignment.end,
//                                           children: [
//                                             ReceiverBubble(
//                                                 isLight: isLight,
//                                                 text: msgs[index].text,
//                                                 time: DateFormat('hh:mm a')
//                                                     .format(msgs[index].createdon!.toDate()))
//                                           ],
//                                         )
//                                       : Row(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           children: [
//                                             SendBubble(
//                                                 isLight: isLight,
//                                                 text: msgs[index].text,
//                                                 time: DateFormat('hh:mm a')
//                                                     .format(msgs[index].createdon!.toDate()))
//                                           ],
//                                         );
//                                 });
//                           } else {
//                             return const Center(
//                               child: Text(
//                                 'No previous Chats',
//                               ),
//                             );
//                           }
//                         } else if (snapshot.connectionState == ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(color: Colors.red),
//                           );
//                         } else {
//                           return const Text('Error in fetching chats...please try again later');
//                         }
//                       })
//                   // const MessageTimeDivider(
//                   //   time: '02.13.2021',
//                   // ),
//                 ],
//               ),
//             ),
//             // )
//           ),
//           Expanded(
//             flex: 4,
//             child: Container(
//               color: !isLight ? Colors.black : const Color(0xFFF1F1F1),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 5,
//                       child: TextField(
//                         maxLines: null,
//                         controller: msgController,
//                         decoration: InputDecoration(
//                             enabledBorder: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                               ),
//                             ),
//                             focusedBorder: const OutlineInputBorder(
//                               borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                               borderSide: BorderSide(
//                                 color: Colors.transparent,
//                               ),
//                             ),
//                             filled: true,
//                             hintStyle: GoogleFonts.rubik(color: const Color(0xFFB3B3B3)),
//                             hintText: 'Write message...',
//                             labelStyle: GoogleFonts.rubik(
//                                 fontSize: 14.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: !isLight ? const Color(0xFF9F9F9F) : const Color(0xFF9F9F9F)),
//                             fillColor: !isLight ? const Color(0xFF404040) : Colors.white),
//                       ),
//                     ),
//                     Expanded(
//                       child: MaterialButton(
//                           color: accentColor,
//                           shape: const CircleBorder(),
//                           onPressed: () {
//                             scrollController.animateTo(scrollController.position.maxScrollExtent,
//                                 duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
//                             sendMsg();
//                           },
//                           child: SizedBox(
//                               width: 56.w,
//                               height: 56.h,
//                               child: const Icon(
//                                 Icons.send_outlined,
//                                 color: Colors.white,
//                               ))),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),