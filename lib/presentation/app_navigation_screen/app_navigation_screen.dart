import 'package:flutter/material.dart';

import '../../core/app_export.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        body: SizedBox(
          width: 375.h,
          child: Column(
            children: [
              _buildAppNavigation(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: AppDecoration.fillWhiteA,
                    child: Column(
                      children: [
                        _buildScreenTitle(
                          context,
                          screenTitle: "logo One",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.logoOneScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "LogInScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.loginscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "SignUpScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.signupscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "TwoHomeScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.twohomescreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "EventDetails",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.eventdetailsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "AttendanceDetails",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.attendancedetailsScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "ScannerScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.scannerscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "GeneratedList",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.generatedlistScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "GeneratorScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.generatorscreenScreen),
                        ),
                        _buildScreenTitle(
                          context,
                          screenTitle: "AnalyticsScreen",
                          onTapScreenTitle: () => onTapScreenTitle(
                              context, AppRoutes.analyticsscreenScreen),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Section Widget
  Widget _buildAppNavigation(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        children: [
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                "App Navigation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.errorContainer.withOpacity(1),
                  fontSize: 20.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                "Check your app's UI from the below demo screens of your app.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: appTheme.blueGray400,
                  fontSize: 16.fSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.v),
          Divider(
            height: 1.v,
            thickness: 1.v,
            color: theme.colorScheme.errorContainer.withOpacity(1),
          )
        ],
      ),
    );
  }

  ///Common Widget
  Widget _buildScreenTitle(
    BuildContext context, {
    required String screenTitle,
    Function? onTapScreenTitle,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: AppDecoration.fillWhiteA,
        child: Column(
          children: [
            SizedBox(height: 10.v),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Text(
                  screenTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.errorContainer.withOpacity(1),
                    fontSize: 20.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.v),
            SizedBox(height: 5.v),
            Divider(
              height: 1.v,
              thickness: 1.v,
              color: appTheme.blueGray400,
            )
          ],
        ),
      ),
    );
  }

  ///Common click event
  void onTapScreenTitle(
    BuildContext context,
    String routeName,
  ) {
    Navigator.pushNamed(context, routeName);
  }
}
