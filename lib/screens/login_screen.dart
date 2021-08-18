import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:movie_flix/utils/constants.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoginScreenContent());
  }
}

class LoginScreenContent extends StatefulWidget {
  @override
  _LoginScreenContentState createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent>
    with CodeAutoFill {
  final moNumController = TextEditingController();

//  final otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();
  String vCode = '';
  String actualCode, selectedCountryCode = '+91';
  AuthCredential _authCredential;
  var firebaseAuth;
  bool isMoNumScreen = true;
  bool isLoading = false;
  FocusNode currentFocus = FocusNode();
  bool isTermsChecked = false;

  getSharedTerms() async {
    setState(() {
      isTermsChecked = true;
    });
  }

  @override
  void initState() {
    getSharedTerms();
    listenForCode();
    // FormKeyboardActions.setKeyboardActions(context, _buildConfig(context));
    super.initState();
  }

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: currentFocus,
          onTapAction: () {
            currentFocus.unfocus();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!isLoading) {
          if (!isMoNumScreen) {
            setState(() {
              isMoNumScreen = true;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        } else {
          return Future.value(false);
        }
      },
      child: KeyboardActions(
        config: _buildConfig(context),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  color: Color(0xff333333),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  child: IgnorePointer(
                    ignoring: isLoading,
                    child: isMoNumScreen
                        ? Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Text(
                            'Hi',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Let's get started",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Enter your mobile number to create an account or login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 0,
                                top: 50,
                                left: 20.00,
                                right: 20.00),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min, 
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Center(child: Text("+91",style: TextStyle(color: Colors.white,fontSize: 16))),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: TextField(
                                    focusNode: currentFocus,
                                    controller: moNumController,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    onSubmitted: (term) {
                                      currentFocus.unfocus();
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Phone Number*",
                                      hintStyle: TextStyle(
                                          color:Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: 40.00,
                                left: 20.00),
                            alignment: Alignment.centerLeft,
                            height: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Divider(
                                    height: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 60,
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: buildBtn(
                                    "SUBMIT", sendVerificationCode),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: showCodeScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showCodeScreen() {
    String cCode = "", mNum = "";
    if (this.selectedCountryCode != null) {
      cCode = this.selectedCountryCode.trim();
    }

    if (this.moNumController != null && this.moNumController.text != null) {
      mNum = this.moNumController.text.trim();
    }
    return Stack(
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.only(top: 40.00),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          iconSize: 35.00,
          onPressed: () {
            setState(() {
              isMoNumScreen = true;
            });
          },
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.00),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 8),
              Container(
                  height: 50,),
              SizedBox(height: 30.0),
              Text(
                  'Waiting to automatically detect OTP sent to your mobile number',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center),
              SizedBox(height: 20.0),
              Text('Sent to $cCode $mNum',
                  style: TextStyle(
                      color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center),
              SizedBox(height: 40.0),
              Text('Enter 6 - Digit code',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center),
              SizedBox(height: 50.0),
              PinFieldAutoFill(
                codeLength: 6,
                currentCode: vCode,
                decoration: const UnderlineDecoration(colorBuilder: FixedColorBuilder(Colors.white), textStyle: TextStyle(color: Colors.white)),
                onCodeChanged: (str) {
                  if (str != null && str.trim().length == 6 && vCode != str) {
                    vCode = str;
                    _signInWithPhoneNumber();
                  }
                },
                focusNode: otpFocusNode,
                onCodeSubmitted: (str) {
                  FocusScope.of(context).unfocus();
                  if (str != null && str.trim().length == 6) {
                    vCode = str;
                  }
                },
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () {
                  firebaseAuth = null;
                  sendVerificationCode();
                  showToast(context, "OTP resent successfully");
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Didn\'t receive the code? ',
                    style: TextStyle(color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'RESEND CODE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor)),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: SafeArea(
                      top: false,
                      child: Container(
                          height: 60,
                          child: Align(
                              alignment: FractionalOffset.bottomCenter,
                              child:
                              buildBtn("SUBMIT", _signInWithPhoneNumber)))))
            ],
          ),
        )
      ],
    );
  }

  void sendVerificationCode() async {
    if (isTermsChecked) {
      if (Platform.isIOS) {
        await SmsAutoFill().listenForCode;
      }
      // bool isNetworkConnected = await checkInternetConnection(context);
      bool isNetworkConnected = true;
      if (isNetworkConnected) {
        FocusScope.of(context).requestFocus(FocusNode());
        if (moNumController.text.trim().isEmpty) {
          showToast(context, "Enter mobile number");
        } else if (moNumController.text.trim().length > 13 ||
            moNumController.text.trim().length <= 6) {
          showToast(context, "Enter valid mobile number");
        } else {
          setState(() {
            this.isLoading = true;
          });
          String phone =
              this.selectedCountryCode + this.moNumController.text.trim();
          firebaseAuth = FirebaseAuth.instance;

          PhoneCodeSent codeSent =
              (String verificationId, [int forceResendingToken]) async {
            this.actualCode = verificationId;

            setState(() {
              this.isMoNumScreen = false;
              this.isLoading = false;
            });
          };

          firebaseAuth.verifyPhoneNumber(
              phoneNumber: phone,
              timeout: Duration(seconds: 5),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent,
              codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
        }
      }
    } else {
      showToast(context,
          "You need to accept the Terms of Use and Privacy Policy to use the app");
    }
  }

  void _signInWithPhoneNumber() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (vCode != null && vCode.trim() != "" && vCode.length >= 6) {
      setState(() {
        this.isLoading = true;
      });
      _authCredential = PhoneAuthProvider.credential(
          verificationId: actualCode, smsCode: vCode.trim());
      verificationCompleted(_authCredential);
    } else {
      showToast(context, "Enter 6 digit code");
    }
  }

  void verificationCompleted(AuthCredential auth) async {
    if (firebaseAuth != null) {
      UserCredential value;
      try {
        value = await firebaseAuth.signInWithCredential(auth);
      } catch (e) {
        print(e.toString());
        setState(() {
          vCode = '';
          isLoading = false;
          showToast(context, "Invalid code");
        });
      }
      if (value!=null) {
        user = value.user;
        onAuthenticationSuccessful(value.user.phoneNumber,value.user);
      } else {
        setState(() {
          vCode = '';
          isLoading = false;
          showToast(context, "Invalid code");
        });
      }
    } else {
      setState(() {
        isLoading = false;
        showToast(context, "Something has gone wrong, please try later");
      });
    }
  }

  void verificationFailed(Exception authException) {

  }

  void codeAutoRetrievalTimeout(String verificationId) {
    this.actualCode = verificationId;
  }

  void onAuthenticationSuccessful(String phoneNumber,User users) async {
    if (phoneNumber.trim() != "") {
      Navigator.popAndPushNamed(context, "/home");
    } else {
      showToast(context, "Something has gone wrong, please try later");
      setState(() {
        this.isLoading = false;
        this.isMoNumScreen = true;
      });
    }
  }

  @override
  void dispose() {
    moNumController.dispose();
    super.dispose();
  }

  @override
  void codeUpdated() {
    setState(() {
      if (code != null && code.trim() != '' && code.trim().length >= 6) {
        vCode = code;
      }
    });
  }
}