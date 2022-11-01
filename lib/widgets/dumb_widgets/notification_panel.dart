import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({Key? key}) : super(key: key);

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 25.w,
      ),
      height: 133.h,
      width: 340.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: (isLight ? const Color(0xffF5F5F5) : const Color(0xff404040)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ListView(
              controller: _scrollController,
              children: [
                for (int i = 0; i < 3; i++)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: ListTile(
                      title: Text(
                        "You have a new message.",
                        style: GoogleFonts.rubik(),
                      ),
                      subtitle: Text(
                        "Adam Smith sent you 2 new messages.",
                        style: GoogleFonts.rubik(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: accentColor,
                ),
                Icon(
                  Icons.arrow_downward,
                  color: accentColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
