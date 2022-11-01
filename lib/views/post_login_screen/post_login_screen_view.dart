import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:set_jet/loader.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/views/pre_login/auth.dart';
import 'package:set_jet/widgets/dumb_widgets/app_button.dart';
import 'package:set_jet/widgets/dumb_widgets/app_textfield.dart';
import 'package:set_jet/widgets/dumb_widgets/container_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';
import '../pre_login/pre_login_view.dart';
import 'post_login_screen_view_model.dart';
import 'package:snack/snack.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class PostLoginScreenView extends StatefulWidget {
  PostLoginScreenView({Key? key}) : super(key: key);

  @override
  State<PostLoginScreenView> createState() => _PostLoginScreenViewState();
}

class _PostLoginScreenViewState extends State<PostLoginScreenView> {
  TextEditingController textcontroller = TextEditingController(text: "");
  TextEditingController fNamecontroller = TextEditingController(text: "");
  TextEditingController lNamecontroller = TextEditingController(text: "");
  TextEditingController emailcontroller = TextEditingController(text: "");
  TextEditingController phonecontroller = TextEditingController(text: "");
  TextEditingController passcontroller = TextEditingController(text: "");
  bool phoneLogin = false;
  String thisText = "";
  String vTxt1 = '';
  String vTxt2 = '';
  String vTxt3 = '';
  String emailStatus = '';
  String gTxt = '';
  String cTxt = '';
  String profileImagePath = 'assets/profile.png';
  File? img;
  bool verified = false;
  String profileImageUrl = '';

  bool hasError = false;

  bool? accepted = false;

  bool isEmailVerified = false;

  bool sendLink = true;

  bool isLoading = false;

  final controller = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const Loader()
      : ViewModelBuilder<PostLoginScreenViewModel>.reactive(
          builder: (BuildContext context, PostLoginScreenViewModel viewModel, Widget? _) {
            return Builder(builder: (context) {
              var theme = Theme.of(context);
              var isLight = theme.brightness == Brightness.light;
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                                        child: Container(
                                          color: !isLight
                                              ? const Color(0xFF3A3A3A)
                                              : const Color(0xFFE9E9E9),
                                          height: 5.h,
                                        ),
                                      ),
                                      SmoothPageIndicator(
                                        count: 6,
                                        controller: controller,
                                        effect: SlideEffect(
                                          radius: 4.0,
                                          spacing: 0.0,
                                          dotWidth: 60.0.h,
                                          dotHeight: 5.0.h,
                                          dotColor: !isLight
                                              ? const Color(0xFF3A3A3A)
                                              : const Color(0xFFE9E9E9),
                                          paintStyle: PaintingStyle.fill,
                                          activeDotColor: !isLight ? Colors.white : accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 18,
                                child: Center(
                                  child: PageView(
                                    controller: controller,
                                    onPageChanged: viewModel.pageChange,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // ContainerSelector(
                                            //   isLight: isLight,
                                            //   title: 'User',
                                            //   icon: Icons.person,
                                            //   subtitle:
                                            //       'Signup as user to search \nflights',
                                            //   value: viewModel.selector.value,
                                            //   onpressed: () {
                                            //     viewModel.OptionSelector();
                                            //   },
                                            // ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            ContainerSelector(
                                              isLight: isLight,
                                              title: 'User',
                                              icon: Icons.person,
                                              subtitle: 'Signup as user to search \nflights',
                                              value: !viewModel.selector.value,
                                              onpressed: () {
                                                viewModel.OptionSelector();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AppTextField(
                                              label: 'First Name',
                                              // Onchange: (val) {
                                              //   setState(() => fName = val);
                                              // },
                                              controller: fNamecontroller,
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            AppTextField(
                                              label: 'Last Name',
                                              controller: lNamecontroller,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AppTextField(
                                              label: 'Email',
                                              controller: emailcontroller,
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            AppTextField(
                                              label: 'Password',
                                              controller: passcontroller,
                                              obscureText: true,
                                            ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            SizedBox(
                                              width: 331.w,
                                              height: 75.h,
                                              child: IntlPhoneField(
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(15.0),
                                                    ),
                                                    filled: true,
                                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                                    labelText: 'Phone Number',
                                                    fillColor: Colors.transparent),
                                                onChanged: (phone) =>
                                                    phonecontroller.text = phone.completeNumber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Column(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Column(
                                      //       children: [
                                      //         Text(
                                      //           vTxt1,
                                      //           //'Enter the code that sent',
                                      //           style: GoogleFonts.rubik(
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400,
                                      //             color: Color(0xFFA7A7A7),
                                      //           ),
                                      //         ),
                                      //         RichText(
                                      //           textAlign: TextAlign.center,
                                      //           text: TextSpan(children: <TextSpan>[
                                      //             TextSpan(
                                      //               text: vTxt2,
                                      //               style: GoogleFonts.rubik(
                                      //                 fontSize: 16,
                                      //                 fontWeight: FontWeight.w400,
                                      //                 color: Color(0xFFA7A7A7),
                                      //               ),
                                      //             ),
                                      //             TextSpan(
                                      //               text: vTxt3,
                                      //               style: GoogleFonts.rubik(
                                      //                 fontSize: 16,
                                      //                 fontWeight: FontWeight.w400,
                                      //                 color: accentColor,
                                      //               ),
                                      //             ),
                                      //           ]),
                                      //         ),
                                      //         Text(
                                      //           gTxt,
                                      //           style: GoogleFonts.rubik(
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w400,
                                      //             color: Color(0xFFA7A7A7),
                                      //           ),
                                      //         ),
                                      //         InkWell(
                                      //           child: Text(
                                      //             cTxt,
                                      //             style: GoogleFonts.rubik(
                                      //               fontSize: 16,
                                      //               fontWeight: FontWeight.w400,
                                      //               color: Colors.blue,
                                      //             ),
                                      //           ),
                                      //           onTap: () {
                                      //             sendVerificationEmail();
                                      //           },
                                      //         )
                                      //       ],
                                      //     ),
                                      //     Container(
                                      //       height: 100.h,
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           Text(
                                      //             emailStatus,
                                      //             style: GoogleFonts.rubik(
                                      //               fontSize: 18,
                                      //               fontWeight: FontWeight.bold,
                                      //               color: accentColor,
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                                      //       child: Row(
                                      //         mainAxisAlignment: MainAxisAlignment.center,
                                      //         children: [
                                      //           AppButton(
                                      //               text: 'Check Email verification Status',
                                      //               textColor:
                                      //                   !isLight ? Color(0xFF848484) : Color(0xFF9A9A9A),
                                      //               color:
                                      //                   !isLight ? Color(0xFF3A3A3A) : Color(0xFFE9E9E9),
                                      //               onpressed: () async {
                                      //                 await FirebaseAuth.instance.currentUser!.reload();
                                      //                 setState(() {
                                      //                   verified = FirebaseAuth
                                      //                       .instance.currentUser!.emailVerified;
                                      //                 });
                                      //                 if (verified) {
                                      //                   emailStatus = 'Email Verified';
                                      //                   controller.nextPage(
                                      //                       duration: const Duration(milliseconds: 500),
                                      //                       curve: Curves.ease);
                                      //                 } else {
                                      //                   emailStatus = 'Email Not Verified yet';
                                      //                 }
                                      //               })
                                      //         ],
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                AppButton(
                                                  text: 'SKIP',
                                                  textColor:
                                                      !isLight ? Color(0xFF0982F4) : Color(0xFF0982F4),
                                                  color:
                                                      !isLight ? Color(0xFF194A77) : Color(0xFF9DCDFB),
                                                  onpressed: () {
                                                    controller.nextPage(
                                                        duration: const Duration(milliseconds: 500),
                                                        curve: Curves.ease);
                                                  },
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: accentColor,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Image.asset(
                                                        'assets/delete.png',
                                                        height: 20.h,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    setState(() => img = null);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: 120.w,
                                                height: 56.h,
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    await Permission.photos.request();

                                                    var permissionStatus =
                                                        await Permission.photos.status;
                                                    if (permissionStatus.isGranted) {
                                                      final image = await ImagePicker()
                                                          .pickImage(source: ImageSource.gallery);
                                                      if (image == null) {
                                                        return;
                                                      }
                                                      setState(() {
                                                        img = File(image.path);
                                                      });
                                                    } else {
                                                      loadingBar('cant access your gallery', false, 2);
                                                    }
                                                  },
                                                  color: !isLight ? Colors.white : Colors.black,
                                                  textColor: !isLight ? accentColor : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                          flex: 3,
                                                          child: Image.asset(
                                                            'assets/pick.jpg',
                                                            // !isLight
                                                            //     ? 'assets/upload_dark.png'
                                                            //     : 'assets/upload_light.png',
                                                            height: 23.h,
                                                          )),
                                                      Expanded(
                                                        flex: 5,
                                                        child: Text(
                                                          'Image',
                                                          style: GoogleFonts.rubik(
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            img != null
                                                ? ClipOval(
                                                    child: Image.file(
                                                    img!,
                                                    height: 210,
                                                    width: 210,
                                                    fit: BoxFit.cover,
                                                  ))
                                                : ClipOval(
                                                    child: Image.asset(
                                                      profileImagePath,
                                                      height: 210,
                                                      width: 210,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            SizedBox(
                                              width: 120.w,
                                              height: 56.h,
                                              child: MaterialButton(
                                                onPressed: () async {
                                                  try {
                                                    final user = FirebaseAuth.instance.currentUser;
                                                    final firebaseStorage = FirebaseStorage.instance;
                                                    loadingBar('Uploading Please wait....', true, 3);
                                                    if (img != null) {
                                                      var snapshot = await firebaseStorage
                                                          .ref()
                                                          .child('profileImages/${user!.uid}')
                                                          .putFile(img!);
                                                      var imgUrl = await snapshot.ref.getDownloadURL();
                                                      setState(() {
                                                        profileImageUrl = imgUrl;
                                                      });

                                                      final docuser = FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user.uid);
                                                      docuser.update({'pic': profileImageUrl});
                                                      controller.nextPage(
                                                          duration: const Duration(milliseconds: 500),
                                                          curve: Curves.ease);
                                                    }
                                                  } catch (e) {
                                                    alert(e.toString(), 'Warning', context);
                                                  }
                                                },
                                                color: !isLight ? Colors.white : Colors.black,
                                                textColor: !isLight ? accentColor : Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        flex: 3,
                                                        child: Image.asset(
                                                          !isLight
                                                              ? 'assets/upload_dark.png'
                                                              : 'assets/upload_light.png',
                                                          height: 23.h,
                                                        )),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Text(
                                                        'Upload',
                                                        style: GoogleFonts.rubik(
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Expanded(
                                              flex: 20,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: !isLight ? Colors.black : Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: const Color(0xff707070),
                                                  ),
                                                ),
                                                margin: const EdgeInsets.only(
                                                  top: 30,
                                                  left: 30,
                                                  right: 30,
                                                ),
                                                height: 51.h,
                                                width: 380.w,
                                                child: SingleChildScrollView(
                                                    child: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'LEGAL DOCUMENT',
                                                          style: GoogleFonts.roboto(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Text(
                                                          "       Malesuada tincidunt ante condimentum eget pulvinar id vulputate sit ut. Nibh quis etiam nibh nullam diam auctor. Eu a tellus molestie urna nulla odio nunc. Facilisi vitae molestie quam semper bibendum. Aliquet mi dictum purus feugiat lorem bibendum diam pharetra. Faucibus amet, mi senectus purus. Tellus viverra non adipiscing velit arcu, massa commodo commodo, eget. Amet, ut mauris non pellentesque tellus dolor vivamus \n \n      Nunc eu neque ultrices tristique. A viverra amet interdum lacus, amet sed. Auctor pellentesque pharetra ullamcorper ornare auctor varius egestas rhoncus, lobortis. Tristique egestas et aliquam libero ultrices auctor. Quis fusce proin neque felis felis magna. In tempus massa ullamcorper viverra. Tincidunt senectus luctus lectus blandit tortor. Ipsum sollicitudin arcu sit amet rutrum semper turpis amet, ut. Blandit habitasse sit pulvinar donec sit in massa convallis quis. Rhoncus massa nisl commodo pulvinar placerat tincidunt posuere ac Lectus malesuada mattis tristique arcu, in consequat cursus id. Adipiscing consectetur lectus auctor amet odio suspendisse varius sit tellus. Lectus a mauris nulla dui scelerisque.Quis fusce proin neque felis felis magna. In tempus massa ullamcorper viverra. Tincidunt senectus luctus lectus blandit tortor. Ipsum sollicitudin arcu sit amet rutrum semper turpis amet, ut. Blandit habitasse sit pulvinar donec sit in massa convallis quis. Rhoncus massa nisl commodo pulvinar placerat tincidunt posuere ac.",
                                                          style: GoogleFonts.roboto(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ]),
                                                )),
                                              )),
                                          Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 35.0),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border:
                                                              Border.all(color: accentColor, width: 2.3),
                                                        ),
                                                        width: 24.w,
                                                        height: 24.h,
                                                        child: Checkbox(
                                                            checkColor: accentColor,
                                                            fillColor: MaterialStateProperty.resolveWith(
                                                                (_) => Colors.transparent),
                                                            activeColor: Colors.transparent,
                                                            value: viewModel.checkBoxValue.value,
                                                            tristate: false,
                                                            onChanged: (val) {
                                                              viewModel.ChangeCheckboxValue();
                                                              accepted = val;
                                                            }),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: " I have read and agree the\n",
                                                          style: GoogleFonts.rubik(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                            color: !isLight
                                                                ? Color(0xFFA7A7A7)
                                                                : Color(0xFF848484),
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: "Terms and Conditions ",
                                                          style: GoogleFonts.rubik(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                            color: accentColor,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: "and",
                                                          style: GoogleFonts.rubik(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                            color: !isLight
                                                                ? Color(0xFFA7A7A7)
                                                                : Color(0xFF848484),
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: " Privacy Policy",
                                                          style: GoogleFonts.rubik(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w400,
                                                            color: accentColor,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: MaterialButton(
                                                elevation: 0,
                                                color: !isLight ? Color(0xFF242424) : Colors.white,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.arrow_back_ios,
                                                      color: !isLight ? Colors.white : Colors.black,
                                                    ),
                                                    Text(
                                                      'Back',
                                                      style: GoogleFonts.rubik(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: !isLight
                                                            ? Colors.white
                                                            : Colors.black, //change your color here
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  controller.previousPage(
                                                      duration: const Duration(milliseconds: 500),
                                                      curve: Curves.ease);
                                                  if (controller.page == 0) {
                                                    Navigator.pop(context);
                                                  }
                                                })),
                                        Expanded(
                                          child: Container(),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 50.h,
                                            width: 20.w,
                                            child: MaterialButton(
                                              color: accentColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              onPressed: () {
                                                collectInfo(
                                                    controller,
                                                    fNamecontroller.text,
                                                    lNamecontroller.text,
                                                    emailcontroller.text,
                                                    phonecontroller.text,
                                                    thisText,
                                                    'Warning',
                                                    context);
                                                if (controller.page == 4) {
                                                  if (accepted == true) {
                                                    viewModel.navigateToViewTimeZoneScreen();
                                                  } else {
                                                    alert('Must accept terms and conditions to proceed',
                                                        'Warning', context);
                                                  }
                                                }
                                              },
                                              child: Text(
                                                "Next",
                                                style: GoogleFonts.rubik(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white, //change your color here
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },
          viewModelBuilder: () => PostLoginScreenViewModel(),
        );
  //} //this to be remove

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

  String message = 'Please fill all field';
  void collectInfo(PageController _controller, String fn, String ln, String em, String ph, String _otp,
      String warning, context) {
    _controller.page == 0
        ? _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease)
        : _controller.page == 1
            ? (fn.isEmpty || ln.isEmpty)
                ? alert(message, warning, context)
                : _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease)
            : _controller.page == 2
                ? (em.isEmpty || ph.isEmpty || passcontroller.text.isEmpty)
                    ? alert(message, warning, context)
                    : sendEmailAuth()
                : _controller.page == 3
                    ? _controller.nextPage(
                        duration: const Duration(milliseconds: 500), curve: Curves.ease)
                    : _controller.nextPage(
                        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  Future sendEmailAuth() async {
    try {
      loadingBar('Loading....please wait', true, 3);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text.trim(), password: passcontroller.text.trim());
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text.trim(), password: passcontroller.text.trim());
      createUser();

      controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // ignore: prefer_const_constructors
        try {
          loadingBar('Email already in use', false, 1);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthLogin()));
        } on FirebaseAuthException catch (e) {
          loadingBar(e.code.toString(), false, 2);
        }
      } else {
        loadingBar(e.code.toString(), false, 2);
      }
    } catch (e) {
      alert(e.toString(), 'Error', context);
    }
  }

  // Future sendVerificationEmail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await user.sendEmailVerification();
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     final bar = SnackBar(content: Text(e.code.toString()));
  //     bar.show(context);
  //   }
  // }

  // Future<bool> checkVerification() async {
  //   return user!.emailVerified;
  // }

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

  //saving user data
  Future createUser() async {
    try {
      loadingBar('saving data please wait...', true, 4);
      final user = FirebaseAuth.instance.currentUser;
      final docUser = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final json = {
        'firstname': fNamecontroller.text.trim(),
        'lastname': lNamecontroller.text.trim(),
        'phone': phonecontroller.text.trim(),
        'pic': profileImageUrl,
        'terms': accepted,
        'timezone': '',
        'subscrp': false,
        'subscrp_date': DateTime.now(),
        'end_Date': DateTime.now().add(const Duration(days: 1500)),
        'amount': 0,
        'subscrp_type': 'user',
        'id': user.uid,
        'role': 'user',
      };
      await docUser.set(json);
    } catch (e) {
      alert(e.toString(), 'exception', context);
    }
  }
}
