import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/views/booked_charters/booked_charters_view.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/views/messages_screen/messages_screen_view.dart';
import 'package:set_jet/views/search_results/search_results_view.dart';

import 'package:set_jet/views/sent_request/sent_request_view.dart';
import 'package:set_jet/views/user_setting_screeb/user_setting_screen_view.dart';
import 'package:snack/snack.dart';
import '../../../model/usermodel.dart';
import '../../../theme/common.dart';
import '../custom_theme_switch.dart';

class CustomBlurredDrawerWidget extends StatefulWidget {
  // final String? imgUrl;
  // final String? name;
  final int? unRead;
  final drawerOption;
  final UserData data;

  const CustomBlurredDrawerWidget({Key? key, this.drawerOption, this.unRead, required this.data})
      : super(key: key);

  @override
  State<CustomBlurredDrawerWidget> createState() => _CustomBlurredDrawerWidgetState();
}

class _CustomBlurredDrawerWidgetState extends State<CustomBlurredDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<CustomBlurredDrawerViewModel>.reactive(
    // builder: (BuildContext context, CustomBlurredDrawerViewModel viewModel, Widget? _) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return WillPopScope(
        onWillPop: () async => false,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    bottom: -50.h,
                    // height: 600.h,
                    // width: MediaQuery.of(context).size.width,
                    left: 0,
                    right: 0,
                    child: Image.asset("assets/drawer_bg_${isLight ? "light" : "dark"}.png"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: IconButton(
                                icon: Icon(Icons.close, color: !isLight ? Colors.white : Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Image.asset(
                                'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                                height: 41.h,
                                width: 50.w,
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                        ListTile(
                          leading: (widget.data.pic!.isEmpty)
                              ? CircleAvatar(
                                  radius: 30.h,
                                  backgroundColor: Colors.transparent,
                                  child: CircleAvatar(
                                      radius: 20.h,
                                      backgroundImage: const AssetImage('assets/profile.png')),
                                )
                              : CircleAvatar(
                                  radius: 30.h,
                                  backgroundColor: Colors.transparent,
                                  child: CircleAvatar(
                                      radius: 20.h, backgroundImage: NetworkImage(widget.data.pic!)),
                                ),
                          title: Text(
                            widget.data.userName!,
                            style: GoogleFonts.rubik(color: accentColor),
                          ),
                          trailing: const CustomThemeSwitch(),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 20.h,
                            left: 25.w,
                            right: 25.w,
                          ),
                          decoration: BoxDecoration(
                            color: isLight ? const Color(0xfff5f5f5) : const Color(0xff404040),
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: ListTile(
                            onTap: () {
                              loadingBar('Loading .... please wait', true, 4);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessagesScreenView(userdata: widget.data)));
                            },
                            leading: Icon(
                              Icons.mail,
                              color: accentColor,
                            ),
                            title: Text(
                              "Messages",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              widget.unRead == null ? '0' : widget.unRead.toString(),
                              style: GoogleFonts.rubik(
                                  color: accentColor, fontWeight: FontWeight.bold, fontSize: 32.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 25.h,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DrawerButton(
                            text: "Home",
                            icon: Icons.home_outlined,
                            isCurrentScreen: true,
                            onPressed: () {
                              loadingBar('Lodaing .. please wait', true, 2);
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => const HomeView()));
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DrawerButton(
                            text: "Search Flights",
                            icon: Icons.search,
                            isCurrentScreen: true,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchResultsView(
                                            data: widget.data,
                                          )));
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DrawerButton(
                            text: "Sent Requests",
                            icon: Icons.arrow_circle_up,
                            isCurrentScreen: true,
                            onPressed: () {
                              loadingBar('Lodaing .. please wait', true, 2);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SentRequestView(
                                            userdata: widget.data,
                                          )));
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DrawerButton(
                            text: "Booked Charters",
                            icon: Icons.note_alt_outlined,
                            isCurrentScreen: true,
                            onPressed: () {
                              loadingBar('Lodaing .. please wait', true, 2);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookedCharterView(
                                            data: widget.data,
                                          )));
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DrawerButton(
                              text: "Settings",
                              icon: Icons.settings_outlined,
                              isCurrentScreen: true,
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserSettingScreenView(data: widget.data)));
                              }),
                        ],
                      ))
                ],
              ),
            )));
    //)
    //},
    //viewModelBuilder: () => CustomBlurredDrawerViewModel(widget.drawerOption, widget.data),
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

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    this.icon,
    this.onPressed,
    this.text,
    required this.isCurrentScreen,
  }) : super(key: key);

  final IconData? icon;
  final Function()? onPressed;
  final String? text;
  final bool isCurrentScreen;

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: MaterialButton(
        color: isCurrentScreen
            ? isLight
                ? Color(0xfff5f5f5)
                : Color(0xff404040)
            : null,
        elevation: 10,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.w),
        ),
        child: ListTile(
          leading: Icon(icon, color: isCurrentScreen ? accentColor : null),
          title: Text(
            text!,
            style: GoogleFonts.rubik(fontSize: 18.sp, color: isCurrentScreen ? accentColor : null),
          ),
        ),
      ),
    );
  }
}
