import 'dart:async';
import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pce/screens/login/login_bloc.dart';
import 'package:pce/utils/constants.dart' as Constants;
import 'package:url_launcher/url_launcher.dart';

import '../../base_widgets/app_textstyle.dart';
import '../../network/api_provider.dart';
import '../../utils/singleton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _name = TextEditingController();
  // final TextEditingController _email = TextEditingController();
  final TextEditingController _email = TextEditingController(text: '');
  final TextEditingController _forgotemail = TextEditingController();
  // final TextEditingController _password = TextEditingController();
  final TextEditingController _password = TextEditingController(text: '');
  late bool passwordVisible;


  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppSingleton.instance.getPrimaryColor(),
        body: buildSignInScreen(),
      ),
    );
  }

  Widget buildSignInScreen() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.loose,
      children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: AppSingleton.instance.getWidth(200),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppSingleton.instance.getSecondaryColor(),
                  AppSingleton.instance.getPrimaryColor()
                ],
              )),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo_old.png",
                  width: AppSingleton.instance.getWidth(250),
                  height: AppSingleton.instance.getWidth(200),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: ScreenUtil().screenHeight * 0.7,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          'Login',
                          style: AppTextStyle.bold(Colors.black87, 30.0),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          "Let's explore the world's largest project controls event",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: SizedBox(
                        height: AppSingleton.instance.getHeight(45),
                        child: TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            contentPadding: const EdgeInsets.only(left: 25),
                            counterText: '',
                            counterStyle: const TextStyle(fontSize: 0),
                            fillColor:
                                AppSingleton.instance.getLightGrayColor(),
                            border: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            focusedBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            disabledBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            enabledBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            errorBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            focusedErrorBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            filled: true,
                            hintText: 'Email',
                            hintStyle: AppTextStyle.regular(
                              Colors.grey,
                              AppSingleton.instance.getSp(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: SizedBox(
                        height: AppSingleton.instance.getHeight(45),
                        child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          maxLines: 1,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock_outline),
                            contentPadding: const EdgeInsets.only(left: 25),
                            counterText: '',
                            counterStyle: const TextStyle(fontSize: 0),
                            fillColor:
                                AppSingleton.instance.getLightGrayColor(),
                            border: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            focusedBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            disabledBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            enabledBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            errorBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            focusedErrorBorder: AppSingleton.instance
                                .getLightGrayOutLineBorder(),
                            filled: true,
                            hintText: 'Password',
                            hintStyle: AppTextStyle.regular(
                              Colors.grey,
                              AppSingleton.instance.getSp(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        height: AppSingleton.instance.getHeight(60),
                        child: BlocConsumer(
                          bloc: BlocProvider.of<LoginBloc>(context),
                          listener: (context, state) {
                            if (state is LoginError) {
                              _showError(state.error);
                            }
                            if (state is LoginLoaded) {
                              ApiProvider.instance.setUserId(state.response.data?.userId ?? "");
                              BlocProvider.of<LoginBloc>(context).add(EventListEvent(body: getRequestBody(state.response.data?.userId ?? "")));
                            }
                            if(state is UserEventFetch){
                              Navigator.pushNamed(context, Constants.ROUTE_SELECT_EVENT,arguments: state.response.data);
                            }
                          },
                          builder: (context, state) {
                            if (state is LoginLoading) {
                              return AppSingleton.instance
                                  .buildCenterSizedProgressBar();
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: AppSingleton.instance.getButtonColor(),
                                elevation: 4,
                                shadowColor:
                                    AppSingleton.instance.getButtonColor(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () async {
                                makeLogin();
                              },
                              child: const Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     // _launchUrl();
                    //    await _launchURLBrowser();
                    //   },
                    //   child: Text(
                    //     "Don't have account ! Please Register.",
                    //     style: AppTextStyle.regular(Colors.black87, 14.0),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: (){
              displayBottomSheet();
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Forgot Password?',
                  style: AppTextStyle.regular(Colors.black87, 15.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void makeLogin() {
    if (validate()) {
      Map<String, String> body = {
        Constants.PARAM_NAME: _name.text,
        Constants.PARAM_EMAIL: _email.text,
        Constants.PARAM_PASSWORD: _password.text
      };
      BlocProvider.of<LoginBloc>(context).add(LoginEvent(body: body));
    }
  }

  bool validate() {
    if (_email.text.isEmpty) {
      _showError('Please enter email');
      return false;
    } else if (!EmailValidator.validate(_email.text)) {
      _showError('Please enter valid email');
      return false;
    } else if (_password.text.isEmpty) {
      _showError('Please enter password');
      return false;
    } else {
      return true;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getSuccessSnackBar(message));
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(AppSingleton.instance.getErrorSnackBar(message));
  }

 Map<String, dynamic> getRequestBody(String userId){
    Map<String, String> body = {
      Constants.PARAM_USER_ID: userId,
    };

    return body;
  }

  _launchURLBrowser() async {
    var url = Uri.parse(Constants.PARAM_REGISTER);
    if (await canLaunchUrl(url)) {
      await launchUrl(url,mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void displayBottomSheet()
  {
    scaffoldKey.currentState?.showBottomSheet((context)
    {
      return Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, bottom: 10),
                child: Text(
                  'Forgot password',
                  style: AppTextStyle.bold(Colors.black87, 30.0),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30, bottom: 10),
                child: Text(
                  "Please enter register email id and you can get the link of forget password on email",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 10),
              child: SizedBox(
                height: AppSingleton.instance.getHeight(45),
                child: TextFormField(
                  controller: _forgotemail,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    contentPadding: const EdgeInsets.only(left: 25),
                    counterText: '',
                    counterStyle: const TextStyle(fontSize: 0),
                    fillColor:
                    AppSingleton.instance.getLightGrayColor(),
                    border: AppSingleton.instance
                        .getLightGrayOutLineBorder(),
                    focusedBorder: AppSingleton.instance
                        .getLightGrayOutLineBorder(),
                    disabledBorder: AppSingleton.instance
                        .getLightGrayOutLineBorder(),
                    enabledBorder: AppSingleton.instance
                        .getLightGrayOutLineBorder(),
                    errorBorder: AppSingleton.instance
                        .getLightGrayOutLineBorder(),
                    focusedErrorBorder: AppSingleton.instance
                        .getLightGrayOutLineBorder(),
                    filled: true,
                    hintText: 'Email',
                    hintStyle: AppTextStyle.regular(
                      Colors.grey,
                      AppSingleton.instance.getSp(14),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 5),
              child: SizedBox(
                width: double.infinity,
                height: AppSingleton.instance.getHeight(60),
                child: BlocConsumer(
                  bloc: BlocProvider.of<LoginBloc>(context),
                  listener: (context, state) {
                    if (state is ForgetPasswordError) {
                      _showError(state.error);
                    }
                    if (state is ForgetPasswordDone) {
                      _showSuccessMessage(state.response.msg ?? 'Success');
                    }
                  },
                  builder: (context, state) {
                    if (state is ForgetPasswordLoading) {
                      return AppSingleton.instance
                          .buildCenterSizedProgressBar();
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppSingleton.instance.getButtonColor(),
                              elevation: 4,
                              shadowColor:
                              AppSingleton.instance.getButtonColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppSingleton.instance.getButtonColor(),
                              elevation: 4,
                              shadowColor:
                              AppSingleton.instance.getButtonColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                            onPressed: () async {
                              makeForgetPassword();
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    );
  }

  void makeForgetPassword() {
    if (validateEmail()) {
      Map<String, String> body = {
        Constants.PARAM_EMAIL: _forgotemail.text,
      };
      BlocProvider.of<LoginBloc>(context).add(ForgetPasswordEvent(body: body));
    }
  }

  bool validateEmail() {
    if (_forgotemail.text.isEmpty) {
      _showError('Please enter email');
      return false;
    } else {
      return true;
    }
  }



}
