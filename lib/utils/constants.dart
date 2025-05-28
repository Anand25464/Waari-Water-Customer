import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants{

  static const Color primaryColor = Color(0xFF5EA2D6);

  static const Color primaryDullColor = Color(0xFFDEEFFC);

  static const Color backgroundColor = Color(0xFFF1F5F8);

  static const Color outLineColor = Color(0xFFE9EBED);

  static const Color successColor = Color(0xFF32DA2E);

  static const Color successDullColor = Color(0xFFE6FAE6);

  static const Color alertColor = Color(0xFFD65E5E);

  static const Color alertDullColor = Color(0xFFFAEBEB);

  static const Color pendingColor = Color(0xFFDA7F14);

  static const Color pendingDullColor = Color(0xFFFAEFE2);

  static const Color hyperLinkColor = Color(0xFF1193F6);

  static const Color textColor = Color(0xFF495969);

  static const Color textDisableColor = Color(0xFF929BA5);

  static const ImageProvider atmImage = AssetImage('assets/images/ATM.2.svg');

  static const ImageProvider atmFilledImage = AssetImage('assets/images/ATM Filled.svg');

  static const ImageProvider backSpaceImage = AssetImage('assets/images/Backspace.svg');

  static const ImageProvider closeImage = AssetImage('assets/images/Close.svg');

  static const ImageProvider copyImage = AssetImage('assets/images/Copy.svg');

  static const ImageProvider customerImage = AssetImage('assets/images/Customers.svg');

  static const ImageProvider dateImage = AssetImage('assets/images/Date.svg');

  static const ImageProvider deadLineImage = AssetImage('assets/images/Deadline.svg');

  static const ImageProvider editImage = AssetImage('assets/images/Edit.svg');

  static const ImageProvider feedbackImage = AssetImage('assets/images/Feedback.svg');

  static const ImageProvider historyImage = AssetImage('assets/images/History.2.svg');

  static const ImageProvider homeDefaultImage = AssetImage('assets/images/Home.2.svg');

  static const ImageProvider locationImage = AssetImage('assets/images/Location.svg');

  static const ImageProvider mailImage = AssetImage('assets/images/Mail.svg');

  static const ImageProvider minusImage = AssetImage('assets/images/Minus.svg');

  static const ImageProvider mobileNumberImage = AssetImage('assets/images/Mobile No..svg');

  static const ImageProvider moreDotsImage = AssetImage('assets/images/More.svg');

  static const ImageProvider myLocationImage = AssetImage('assets/images/My Location.svg');

  static const ImageProvider notificationImage = AssetImage('assets/images/Notification.svg');

  static const ImageProvider plusImage = AssetImage('assets/images/Plus.svg');

  static const ImageProvider profileImage = AssetImage('assets/images/Profile.svg');

  static const ImageProvider rejectImage = AssetImage('assets/images/Rejected.svg');

  static const ImageProvider scanImage = AssetImage('assets/images/Scan.svg');

  static const ImageProvider servicesImage = AssetImage('assets/images/Services.svg');

  static const ImageProvider settingImage = AssetImage('assets/images/Settings.2.svg');

  static const ImageProvider siteVisitImage = AssetImage('assets/images/Site Visit.svg');

  static const ImageProvider subscriptionImage = AssetImage('assets/images/Subscription.svg');

  static const ImageProvider thirdPersonImage = AssetImage('assets/images/Third Person.svg');

  static const ImageProvider ticImage = AssetImage('assets/images/Tic.svg');

  static const ImageProvider timeImage = AssetImage('assets/images/Time.svg');

  static const ImageProvider timeStartsImage = AssetImage('assets/images/Time Starts.svg');

  static const ImageProvider upgradeImage = AssetImage('assets/images/Upgrade.svg');

  static const ImageProvider walletImage = AssetImage('assets/images/Wallet.2.svg');

  static const ImageProvider waterWavePNGImage = AssetImage('assets/images/water_wave.png');

  static const ImageProvider waterBubblePNGImage = AssetImage('assets/images/water_bubble_wave.png');

  //static const ImageProvider waterBubbleImage = AssetImage('assets/images/water_bubble_wave.svg');

  static const ImageProvider waveImage = AssetImage('assets/images/wave_splash.svg');

  static const ImageProvider wavePNGImage = AssetImage('assets/images/wave_splash.png');

  static const ImageProvider onBoardingDecorationImage = AssetImage('assets/images/Rectangle 1.png');

  static const ImageProvider backArrowImage = AssetImage('assets/images/back_arrow.png');

  // Responsive Text Styles
  static TextStyle get headingStyle => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static TextStyle get subHeadingStyle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static TextStyle get bodyStyle => TextStyle(
    fontSize: 14.sp,
    color: textColor,
  );

  static TextStyle get captionStyle => TextStyle(
    fontSize: 12.sp,
    color: textDisableColor,
  );

  // Responsive Spacing
  static double get smallSpacing => 8.h;
  static double get mediumSpacing => 16.h;
  static double get largeSpacing => 24.h;
  static double get extraLargeSpacing => 32.h;

  // Responsive Padding
  static EdgeInsets get smallPadding => EdgeInsets.all(8.w);
  static EdgeInsets get mediumPadding => EdgeInsets.all(16.w);
  static EdgeInsets get largePadding => EdgeInsets.all(24.w);
  static EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: 16.h);

}