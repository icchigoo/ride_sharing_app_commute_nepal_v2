import 'package:android_sms_retriever/android_sms_retriever.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_sharing_app_commute_nepal_v2/components/custom_button.dart';
import 'package:ride_sharing_app_commute_nepal_v2/utils/sharedPrefs/shared_prefs.dart';
import 'package:ride_sharing_app_commute_nepal_v2/utils/style.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getPhoneNumber();
    _phoneController.addListener(() => setState(() {}));
  }

  void _getPhoneNumber() async {
    String phoneNumber = "";
    phoneNumber = (await AndroidSmsRetriever.requestPhoneNumber())!;
    try {
      _phoneController.text = phoneNumber.substring(phoneNumber.length - 10);
      _phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneController.text.length));
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          backgroundColor: ColorShades.backGroundBlack,
          body: Container(
            height: screenHeight - MediaQuery.of(context).padding.top,
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.04,
              horizontal: screenWidth * 0.08,
            ).copyWith(top: screenHeight * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We need your number to verify that it's you",
                  style: Theme.of(context).textTheme.h2,
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  "Give us your number",
                  style: Theme.of(context)
                      .textTheme
                      .h5
                      .copyWith(color: ColorShades.grey),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  width: double.maxFinite,
                  child: TextField(
                    maxLength: 10,
                    focusNode: phoneFocusNode,
                    onChanged: (value) async {
                      if (value.length >= 10) {
                        phoneFocusNode.unfocus();
                      }
                    },
                    controller: _phoneController,
                    autofocus: true,
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.h2,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        counterText: '',
                        hintStyle: Theme.of(context).textTheme.h2.copyWith(
                            color: const Color.fromRGBO(97, 97, 97, 1)),
                        hintText: '9876543210',
                        border: InputBorder.none),
                  ),
                ),
                const Spacer(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By clicking continue, you agree to our ",
                        style: Theme.of(context).textTheme.h7,
                      ),
                      TextSpan(
                        text: "Terms and Conditions ",
                        style: Theme.of(context)
                            .textTheme
                            .h7
                            .copyWith(color: ColorShades.neon),
                      ),
                      TextSpan(
                        text: "and have read our ",
                        style: Theme.of(context).textTheme.h7,
                      ),
                      TextSpan(
                        text: "Privacy Policy",
                        style: Theme.of(context)
                            .textTheme
                            .h7
                            .copyWith(color: ColorShades.neon),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                CustomButton(
                  isActive: _phoneController.text.length == 10,
                  onPressed: () async {
                    final regExp = RegExp(r"^[1-9]\d{9}$");
                    if (regExp.hasMatch(_phoneController.text)) {
                      SharedPrefs().phoneNumber = _phoneController.text;
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/otp', (route) => false);
                    } else {
                      _phoneController.clear();
                      Fluttertoast.showToast(msg: "Please enter valid number");
                    }
                  },
                  child: Center(
                    child: Text(
                      "Continue",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.h3,
                      // textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
