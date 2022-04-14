import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:translation_app/config/size_config.dart';
import 'package:translation_app/config/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translation_app/controllers/language_model_controller.dart';

import 'home_page.dart';
// import 'home_screen.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({Key? key}) : super(key: key);

  @override
  _IntroPagesState createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Get.find<LanguageModelController>().calcAvailableSourceAndTargetLanguages();
    Get.off(() => const HomePage());
  }

  Widget _buildImage(String assetName, [double width = 20]) {
    return ColorFiltered(
      colorFilter:
          const ColorFilter.matrix([0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
      child: Image.asset(
        '${AppConstants.IMAGE_ASSETS_PATH}$assetName',
        width: width,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context: context);

    var pageDecoration = PageDecoration(
      titleTextStyle: GoogleFonts.lobsterTwo(fontSize: SizeConfig.blockSizeHorizontal * 10, fontWeight: FontWeight.bold),
      bodyTextStyle: GoogleFonts.kalam(fontSize: SizeConfig.blockSizeHorizontal * 5),
      titlePadding: EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 5),
      bodyPadding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
      // pageColor: const Color.fromARGB(255, 240, 240, 240),
      pageColor: Colors.transparent,
    );

    ScreenUtil.init(BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(540, 1200), context: context, minTextAdapt: true, orientation: Orientation.portrait);

    return Stack(
      children: [
        Container(height: double.infinity, width: double.infinity, color: const Color.fromARGB(255, 240, 240, 240)),
        _getBgImage(imagePath: '${AppConstants.IMAGE_ASSETS_PATH}intro_page_bg_top.webp', imageAlignment: Alignment.topCenter, opacity: 0.06),
        _getBgImage(imagePath: '${AppConstants.IMAGE_ASSETS_PATH}intro_page_bg_bottom.webp', imageAlignment: Alignment.bottomCenter, opacity: 0.1),
        IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.transparent,
          globalHeader: Align(
            alignment: Alignment.center,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.blockSizeVertical * 8,
                ),
                child: Text(AppConstants.APP_NAME, style: GoogleFonts.frederickaTheGreat(fontSize: SizeConfig.blockSizeHorizontal * 11)),
              ),
            ),
          ),
          globalFooter: SizedBox(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 6,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black87),
              ),
              child: Text(
                'Let\'s Translate Right Away!',
                style: GoogleFonts.kodchasan(fontSize: SizeConfig.blockSizeHorizontal * 5, color: Colors.grey[300]),
              ),
              onPressed: () => _onIntroEnd(context),
            ),
          ),
          pages: [
            PageViewModel(
              title: "Speech To Speech Translation",
              body: "Convert your voice in one Indian language to another Indian language",
              image: _buildImage('intro_screen_img1.webp', SizeConfig.blockSizeHorizontal * 95),
              decoration: pageDecoration.copyWith(
                imageAlignment: Alignment.bottomCenter,
                imageFlex: 5,
                bodyFlex: 3,
              ),
            ),

            PageViewModel(
              title: "Speech Recoganition",
              body: "Automatically recoganise and convert your voice to text",
              image: _buildImage('intro_screen_img2.webp', SizeConfig.blockSizeHorizontal * 95),
              decoration: pageDecoration.copyWith(
                imageAlignment: Alignment.bottomCenter,
                imageFlex: 5,
                bodyFlex: 3,
              ),
            ),

            PageViewModel(
              title: "Language Trasnlation",
              body: "Convert sentences from one Indian language to another",
              image: _buildImage('intro_screen_img3.webp', SizeConfig.blockSizeHorizontal * 95),
              decoration: pageDecoration.copyWith(
                imageAlignment: Alignment.bottomCenter,
                imageFlex: 5,
                bodyFlex: 3,
              ),
            ),

            // To go to the first page
            //   footer: ElevatedButton(
            //     onPressed: () {
            //       introKey.currentState?.animateScroll(0);
            //     },
          ],
          onDone: () => _onIntroEnd(context),
          showSkipButton: false,
          skipOrBackFlex: 0,
          nextFlex: 0,
          showBackButton: true,
          back: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 200, 200, 200), size: SizeConfig.blockSizeHorizontal * 6),
          next: Icon(Icons.arrow_forward, color: const Color.fromARGB(255, 200, 200, 200), size: SizeConfig.blockSizeHorizontal * 6),
          done: Text('DONE', style: GoogleFonts.comfortaa(color: const Color.fromARGB(255, 200, 200, 200), fontWeight: FontWeight.bold)),
          curve: Curves.fastLinearToSlowEaseIn,
          controlsMargin: EdgeInsets.only(
            right: SizeConfig.blockSizeHorizontal * 4,
            left: SizeConfig.blockSizeHorizontal * 4,
            bottom: SizeConfig.blockSizeVertical * 2,
          ),
          dotsDecorator: DotsDecorator(
            size: Size(SizeConfig.blockSizeHorizontal * 2.5, SizeConfig.blockSizeHorizontal * 2.5),
            color: const Color.fromARGB(255, 200, 200, 200),
            activeColor: const Color.fromARGB(255, 200, 200, 200),
            activeSize: Size(SizeConfig.blockSizeHorizontal * 8, SizeConfig.blockSizeHorizontal * 2.5),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 1)),
            ),
          ),
          dotsContainerDecorator: ShapeDecoration(
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 3)),
            ),
          ),
        ),
      ],
    );
  }

  Container _getBgImage({required String imagePath, required Alignment imageAlignment, required double opacity}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fitWidth,
            alignment: imageAlignment,
            image: AssetImage(imagePath),
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(opacity), BlendMode.dstATop)
            // centerSlice: Rect.fromCenter(center: Offset(50, 50), width: 10, height: 10),
            ),
      ),
    );
  }
}
