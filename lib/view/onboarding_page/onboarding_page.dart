import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waari_water/controller/onboarding_page_controller/onboarding_page_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/login_page/login_page.dart';



class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  OnboardingPageController onboardingPageController = Get.put(OnboardingPageController());
 final controller = PageController();


  @override
  void dispose() {
    // 5TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(bottom: 80),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: PageView(
              controller: controller,
              onPageChanged: (index){
                onboardingPageController.setIsLastPage = index == 2;
                onboardingPageController.setIsSecondPage = index == 1;
              },
              children: [
                Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: Constants.waterWavePNGImage,fit: BoxFit.cover,)),
                    child: const Image(image:  Constants.onBoardingDecorationImage,fit: BoxFit.cover,)
                ),
                Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: Constants.waterBubblePNGImage,fit: BoxFit.cover,)),
                  child: const Image(image:  Constants.onBoardingDecorationImage,fit: BoxFit.cover,)
                ),
                Container(
                  decoration: const BoxDecoration(image: DecorationImage(image: Constants.wavePNGImage,fit: BoxFit.cover)),
                    child: const Image(image:  Constants.onBoardingDecorationImage,fit: BoxFit.cover,)
                ),
              ],
            ),
          ),
        ),
        bottomSheet: onboardingPageController.getIsLastPage ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          height: MediaQuery.of(context).size.height/3.3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                const Text("Get Pure Water Anywhere", style: TextStyle(fontWeight: FontWeight.w900,color: Constants.textColor,fontSize: 38),),
                const Text("Get pure water anytime anywhere from our vending machines.",
                  style: TextStyle(color: Constants.textDisableColor,fontSize: 18,fontWeight: FontWeight.w600),),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     TextButton(onPressed: (){
                      controller.jumpToPage(2);
                    }, child:  Text("SKIP",
                    style: TextStyle(color: !onboardingPageController.getIsLastPage ? Constants.primaryColor : Colors.white),)),

                   Row(
                     children: [
                       Container(
                         height: 10,
                         width: 10,
                         decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                       ),
                       const SizedBox(width: 2,),
                       Container(
                         height: 10,
                         width: 10,
                         decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                       ),
                       const SizedBox(width: 2,),
                       Container(
                         height: 10,
                         width: 19,
                         decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                       ),
                     ],
                   ),
                    GestureDetector(
                      onTap: ()async{
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool("showHome", true);
                        CustomNavigation.pushNamed(const LoginPage());
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(shape: BoxShape.circle,color: Constants.primaryColor),
                        child: const Icon(Icons.arrow_right_alt_outlined,color: Colors.white,),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        )

            : onboardingPageController.getIsSecondPage ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          height: MediaQuery.of(context).size.height/3.3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                const Text("Supply to Customer's Place.", style: TextStyle(fontWeight: FontWeight.w900,color: Constants.textColor,fontSize: 38),),
                const Text("Don’t have water source. No worry we will supply pure water to your location.",
                  style: TextStyle(color: Constants.textDisableColor,fontSize: 18,fontWeight: FontWeight.w600),),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){
                      controller.jumpToPage(2);

                    }, child: const Text("SKIP")),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(width: 2,),
                        Container(
                          height: 10,
                          width: 19,
                          decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(width: 2,),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(shape: BoxShape.circle,color: Constants.primaryColor),
                        child: const Icon(Icons.arrow_right_alt_outlined,color: Colors.white,),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        )

            : Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          height: MediaQuery.of(context).size.height/3.3,
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(
              children: [
                const Text("Water Purification Plan", style: TextStyle(fontWeight: FontWeight.w900,color: Constants.textColor,fontSize: 38),),
                const Text("Providing water the best water purification plan at lower cost.",
                  style: TextStyle(color: Constants.textDisableColor,fontSize: 18,fontWeight: FontWeight.w600),),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){
                      controller.jumpToPage(2);

                    }, child: const Text("SKIP")),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 19,
                          decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(width: 2,),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                        ),
                        const SizedBox(width: 2,),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(color: Constants.primaryColor,borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(shape: BoxShape.circle,color: Constants.primaryColor),
                        child: const Icon(Icons.arrow_right_alt_outlined,color: Colors.white,),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

