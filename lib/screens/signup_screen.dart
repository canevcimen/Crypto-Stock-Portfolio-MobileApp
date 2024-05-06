import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/model/user.dart';
import 'package:stock_investment_flutter/screens/signin_with%20_email_screen.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/images.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

import '../model/dbHelper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  bool isPassOkay= false;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context, changeIcon: true, title: ""),
      bottomNavigationBar: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "By continuing, you agree to the ",
          style: secondaryTextStyle(height: 1.3),
          children: [
            TextSpan(
              text: "Stock Platform Terms & Conditions. Reward Policy,",
              style: boldTextStyle(size: 14),
            ),
            TextSpan(
              text: " and ",
              style: secondaryTextStyle(),
            ),
            TextSpan(
              text: "Privacy Policy",
              style: boldTextStyle(size: 14),
            ),
          ],
        ),
      ).paddingOnly(bottom: 24, left: 24, right: 24),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to Stock', style: boldTextStyle(size: 24)),
            16.height,
            Text('Create a commintent-free profile to explore stock products and rewards.', style: secondaryTextStyle()),
            28.height,
            commonSocialLoginButton(context),
            24.height,
            Row(
              children: [
                Container(color: gray.withOpacity(0.2), height: 1).expand(),
                12.width,
                Text('Or continue with email', style: secondaryTextStyle()),
                12.width,
                Container(color: gray.withOpacity(0.2), height: 1).expand(),
              ],
            ),
            24.height,
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: fNameCont,
              nextFocus: emailFocus,
              decoration: inputDecoration(context, labelText: "Full name", prefixIcon: ic_profile.iconImage(size: 10).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.EMAIL,
              controller: emailCont,
              focus: emailFocus,
              nextFocus: passwordFocus,
              decoration: inputDecoration(context, labelText: "Email", prefixIcon: ic_message.iconImage(size: 10).paddingAll(14)),
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.PASSWORD,
              controller: passwordCont,
              focus: passwordFocus,
              suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
              suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
              decoration: inputDecoration(context, labelText: "Password", prefixIcon: ic_lock.iconImage(size: 10).paddingAll(14)),
            ),
            new FlutterPwValidator(
              controller: passwordCont,
              minLength: 8,
              uppercaseCharCount: 1,
              lowercaseCharCount: 1,
              numericCharCount: 1,
              specialCharCount: 1,
              width: 400,
              height: 150,
              onSuccess: passValid,
              onFail: passNotValid,
          ),
          32.height,
          CommonButton(
              buttonText: "Continue",
              width: context.width(),
              onTap: () {
                String fullName = this.fNameCont.text;
                String password = this.passwordCont.text;
                String email = this.emailCont.text;

                if(!validateEmail(email)){
                  showAlertDialog(context, "düzgün email", "email formatı yanlış");
                }
                else if(!validateFullName(fullName)){
                  showAlertDialog(context, "düzgün fullName", "fullName formatı yanlış");
                }
                else if(!validatePassword()){
                  showAlertDialog(context, "düzgün pass", "pass formatı yanlış");
                }
                
                if(validateEmail(email) & validatePassword() & validateFullName(fullName)){
                  tryInsertUser(fullName, email, password);
                }

              }
            ),
          
            
              
          ],
        ).paddingAll(16),
      ),
    );
  }

  void showAlertDialog(BuildContext context,String title, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new TextButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  void insertSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Kayıt Başarılı"),
        content: new Text("Üyeliğiniz başarıyla oluşturuldu. Giriş Sayfasına yönlenebilirsiniz."),
        actions: <Widget>[
          new TextButton(
            child: new Text("Tamam"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignWithEmailInScreen()),
                );
            },
          ),
        ],
      );
    },
  );
}

  bool validateEmail(String email){
    return EmailValidator.validate(email);
  }

  bool validatePassword(){
    return this.isPassOkay;
  }

  bool validateFullName(String fullName){
   
    if (fullName.length == 0) {
      return false;
    }
    return true;

  }
  

  void passNotValid(){
    this.isPassOkay = false;
  }
  
  void passValid(){
    this.isPassOkay = true;
  }
  
   isEmailUnique(String email,var postgreSQLHelper) async {
    var result = postgreSQLHelper.isEmailUsed(email);
    return result;  
  }

  void tryInsertUser(String fullName, String email, String password) async {
    // öncelikle chekUSer
    PostgreSQLHelper postgreSQLHelper = new PostgreSQLHelper();
    await postgreSQLHelper.initDatabaseConnection();

    var count = await isEmailUnique(email,postgreSQLHelper);
    if(count>0){
      showAlertDialog(context,"Email on used", "Bu email kullanımda");
    }else{

      User newUser = new User.withoutId(fullName, email, password,"default.png","");
      postgreSQLHelper.insertUser(newUser);
      insertSuccessDialog(context);
    }

  
  }
}
