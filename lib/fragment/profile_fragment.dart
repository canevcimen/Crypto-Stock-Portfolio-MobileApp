  import 'package:flutter/material.dart';
  import 'package:nb_utils/nb_utils.dart';
  import 'package:stock_investment_flutter/main.dart';
  import 'package:stock_investment_flutter/model/stock_invest_model.dart';
  import 'package:stock_investment_flutter/screens/edit_profile_screen.dart';
  import 'package:stock_investment_flutter/screens/signin_screen.dart';
  import 'package:stock_investment_flutter/utils/colors.dart';
  import 'package:stock_investment_flutter/utils/common.dart';
  import 'package:stock_investment_flutter/utils/configs.dart';
  import 'package:stock_investment_flutter/utils/data_generator.dart';
  import 'package:stock_investment_flutter/utils/images.dart';
  import 'package:url_launcher/url_launcher_string.dart';

import '../model/user.dart';

  class ProfileFragment extends StatefulWidget {
    User user=new User.withoutAnyInfo();

  ProfileFragment(User user){
    this.user = user;
  }
    @override
    _ProfileFragmentState createState() => _ProfileFragmentState(user);
  }

  class _ProfileFragmentState extends State<ProfileFragment> {
    List<StockInvestModel> profileList = getProfileDataModel();

    String? nameProfile;
    User? user;

  _ProfileFragmentState(User user){
    this.user=user;
  }

    @override
    void initState() {
      super.initState();
      init();
    }

    void init() async {
      setStatusBarColor(appStore.isDarkModeOn ? black : white);
    }

    @override
    void setState(fn) {
      if (mounted) super.setState(fn);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: commonAppBarWidget(context, title: "Profile", showLeadingIcon: false),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      CommonCachedNetworkImage('assets/stock/user.jpg', width: 130, height: 130, fit: BoxFit.cover, radius: 75),
                      16.height,
                      Text(user!.fullname.toString(), style: boldTextStyle()),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonCachedNetworkImage(ic_edit, width: 20, height: 20, color: appStore.isDarkModeOn ? white : primaryColor, fit: BoxFit.cover),
                          8.width,
                          Text('Normal Skin', style: primaryTextStyle()),
                        ],
                      ),
                    ],
                  ).paddingOnly(top: 24, bottom: 24),
                  SettingItemWidget(
                    leading: settingIconWidget(icon: Icons.person),
                    title: "Edit Profile",
                    trailing: trailing,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    onTap: () {
                      EditProfileScreen().launch(context);
                    },
                  ),
                  SettingItemWidget(
                    leading: settingIconWidget(icon: Icons.notifications),
                    title: "Notification",
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    trailing: trailing,
                    onTap: () {
                      toast("Notification");
                    },
                  ),
                  SettingItemWidget(
                    leading: settingIconWidget(icon: Icons.dark_mode),
                    title: "App Theme",
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    trailing: SizedBox(
                      height: 20,
                      width: 30,
                      child: Switch(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: appStore.isDarkModeOn,
                        onChanged: (bool value) {
                          setState(() {
                            appStore.toggleDarkMode(value: value);
                          });
                        },
                      ),
                    ),
                  ),
                  SettingItemWidget(
                    leading: settingIconWidget(icon: Icons.lock),
                    title: "Privacy & Policy",
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    trailing: trailing,
                    onTap: () {
                      commonLaunchUrl(PRIVACY_POLICY_URL, launchMode: LaunchMode.externalApplication);
                    },
                  ),
                  SettingItemWidget(
                    leading: settingIconWidget(icon: Icons.question_mark),
                    title: "Help Support",
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    trailing: trailing,
                    onTap: () {
                      commonLaunchUrl(HELP_SUPPORT_URL, launchMode: LaunchMode.externalApplication);
                    },
                  ),
                  SettingItemWidget(
                    leading: settingIconWidget(icon: Icons.question_mark),
                    title: "Terms & Condition",
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    trailing: trailing,
                    onTap: () {
                      commonLaunchUrl(TERMS_CONDITION_URL, launchMode: LaunchMode.externalApplication);
                    },
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        showConfirmDialogCustom(
                          context,
                          negativeText: "Cancel",
                          positiveText: "Yes",
                          primaryColor: primaryColor,
                          onAccept: (_) {
                            finish(context);
                            SignInScreen().launch(context, isNewTask: true);
                          },
                          dialogType: DialogType.CONFIRMATION,
                          title: "Do you want to logout from the app?",
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        alignment: Alignment.center,
                        width: 170,
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: primaryColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: white, size: 24),
                            8.width,
                            Text('Sign Out', style: boldTextStyle(color: white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
