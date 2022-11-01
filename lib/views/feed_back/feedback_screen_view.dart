import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/constants/drawer_enum.dart';
import 'package:set_jet/model/feedback.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/dumb_widgets/app_button.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';
import 'package:stacked/stacked.dart';
import '../../model/usermodel.dart';
import 'feedback_screen_view_model.dart';

class FeedbackScreenView extends StatefulWidget {
  final UserData data;
  const FeedbackScreenView({Key? key, required this.data}) : super(key: key);

  @override
  State<FeedbackScreenView> createState() => _FeedbackScreenViewState();
}

class _FeedbackScreenViewState extends State<FeedbackScreenView> {
  TextEditingController feedback = TextEditingController();
  TextEditingController category = TextEditingController(text: 'Other');
  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<FeedbackScreenViewModel>.reactive(
    // builder: (BuildContext context, FeedbackScreenViewModel viewModel, Widget? _) {

    return Builder(builder: (context) {
      var theme = Theme.of(context);
      var isLight = theme.brightness == Brightness.light;
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: MaterialButton(
              child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomBlurredDrawerWidget(data: widget.data)));
              },
            ),
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 50.h,
              width: 150.w,
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: accentColor, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Image.asset(
                    'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 18.0),
                    child: Text('Feedback',
                        style: GoogleFonts.rubik(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w600,
                            color: !isLight ? Colors.white : Colors.black)),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0, bottom: 15.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      items: ['Other']
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value,
                                    style: GoogleFonts.rubik(
                                        color: !isLight ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp)),
                              ))
                          .toList(),
                      onChanged: (String? value) {},
                      isExpanded: false,
                      value: 'Other',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0, bottom: 15.0),
                      child: TextField(
                        controller: feedback,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          hintText: 'Write your feedback here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          contentPadding: EdgeInsets.all(10),
                        ),
                        maxLines: 23,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: SizedBox(
                      width: 331.w,
                      height: 56.h,
                      child: AppButton(
                        color: accentColor,
                        textColor: Colors.white,
                        text: 'Send',
                        onpressed: () {
                          loadingBar('Sending feedback please wait', true, 2);
                          final docUser = FirebaseFirestore.instance.collection('feedback').doc();
                          Remarks remarks = Remarks(
                              createdon: Timestamp.fromDate(DateTime.now()),
                              feedback: feedback.text,
                              id: docUser.id,
                              remarks: '',
                              sender: widget.data.userID,
                              category: category.text);
                          docUser.set(remarks.toMap());
                          alert('feedback sent successfully', 'Alert', context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
    //},
    //viewModelBuilder: () => FeedbackScreenViewModel(),
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
              actions: [
                CloseButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
