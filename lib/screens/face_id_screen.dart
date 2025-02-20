import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stock_investment_flutter/screens/proof_residency_screen.dart';
import 'package:stock_investment_flutter/utils/common.dart';
import 'package:stock_investment_flutter/utils/images.dart';

class FaceIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context, changeIcon: false, title: ""),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              60.height,
              commonImageWidget(image: scan),
              42.height,
              Text('Enable Face ID', style: boldTextStyle(size: 24)),
              16.height,
              Text(
                'Face ID is convenient and secure method of signing into your account',
                textAlign: TextAlign.center,
                style: secondaryTextStyle(),
              ),
            ],
          ).center().paddingAll(16),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CommonButton(
                    buttonText: "Enable Face ID",
                    margin: 16,
                    width: context.width(),
                    onTap: () {
                      ProofResidencyScreen().launch(context);
                    }),
                16.height,
                SizedBox(
                  width: context.width(),
                  child: OutlinedButton(
                    onPressed: () {
                      //
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))), disabledForegroundColor: Colors.white.withOpacity(0.38),
                    ),
                    child: Text('Maybe Later', style: boldTextStyle(color: context.iconColor)),
                  ).paddingSymmetric(horizontal: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
