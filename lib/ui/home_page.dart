import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translation_app/config/app_constants.dart';
import 'package:translation_app/controllers/recorder_controller.dart';
import 'package:translation_app/controllers/speech_to_speech_controller.dart';

import '../controllers/language_model_controller.dart';
import '../controllers/app_ui_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height),
        designSize: const Size(540, 1200), context: context, minTextAdapt: true, orientation: Orientation.portrait);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstants.STANDARD_WHITE,
        body: GetBuilder<AppUIController>(
          builder: (_appUIController) {
            return !_appUIController.areModelsLoadedSuccessfully
                // Loading Screen with Tip
                ? const LoadingScreen()
                //STS Screen
                : Stack(
                    children: [
                      const HomePageBG(
                        topRightImagePath: '${AppConstants.IMAGE_ASSETS_PATH}${AppConstants.HOMEPAGE_TOP_RIGHT_IMAGE}',
                        bottomLeftImagePath: '${AppConstants.IMAGE_ASSETS_PATH}${AppConstants.HOMEPAGE_BOTTOM_LEFT_IMAGE}',
                      ),
                      // ASR Container, Translation Container, TTS Controls Container
                      Center(
                        child: SizedBox(
                          width: 0.9.sw,
                          height: 0.9.sh,
                          child: Column(
                            children: [
                              //ASR Container
                              Expanded(
                                flex: 4,
                                child: BaseContainer(
                                  borderRadius: 10.w,
                                  width: 0.85.sw,
                                  childWidget: const ContainerContent(
                                    outputOfASROrTranslation: MODEL_TYPES.ASR,
                                    headerLabel: AppConstants.SPEECH_TO_TEXT_HEADER_LABEL,
                                    sourceTargetIconDataList: [Icons.multitrack_audio_rounded, Icons.text_fields_outlined],
                                  ),
                                ),
                              ),
                              30.verticalSpace,
                              // Translation Container
                              Expanded(
                                flex: 4,
                                child: BaseContainer(
                                  borderRadius: 10.w,
                                  width: 0.85.sw,
                                  childWidget: const ContainerContent(
                                    outputOfASROrTranslation: MODEL_TYPES.TRANSLATION,
                                    headerLabel: AppConstants.TRANSLATION_HEADER_LABEL,
                                    sourceTargetIconDataList: [Icons.text_fields_rounded, Icons.text_fields_rounded],
                                  ),
                                ),
                              ),
                              40.verticalSpace,
                              // TTS Controls Container
                              Expanded(
                                flex: 5,
                                child: BaseContainer(
                                  borderRadius: 25.w,
                                  childWidget: Padding(
                                    padding: EdgeInsets.only(left: 30.w, right: 20.w, top: 25.h, bottom: 25.h),
                                    child: Column(
                                      children: [
                                        // Source/Target language select
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              const SourceTargetLanguageSelect(dropdownType: LANG_DROP_DOWN_TYPE.sourceLanguage),
                                              80.horizontalSpace,
                                              const SourceTargetLanguageSelect(dropdownType: LANG_DROP_DOWN_TYPE.targetLanguage)
                                            ],
                                          ),
                                        ),
                                        HorizontalDivider(horMargin: 10.w, verMargin: 15.h, dividerHeight: 2.h, dividerBorderRad: 2.h),

                                        // Input Record Button
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                'Input',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.kodchasan(
                                                    fontSize: 20.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                                              ),
                                              Expanded(
                                                  child: SizedBox(
                                                width: 1.sw,
                                                child: const RecordStopButton(
                                                    iconList: [Icons.mic_none_rounded, Icons.stop_circle_outlined],
                                                    labelList: [AppConstants.RECORD_BUTTON_TEXT, AppConstants.STOP_BUTTON_TEXT]),
                                              )),
                                            ],
                                          ),
                                        ),

                                        HorizontalDivider(horMargin: 10.w, verMargin: 15.h, dividerHeight: 2.h, dividerBorderRad: 2.h),

                                        // Output => Gender Select and Play Button
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  'Output',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.kodchasan(
                                                      fontSize: 20.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 29,
                                                    child: Row(children: const [
                                                      Expanded(
                                                        child: MaleGenderSelectButton(),
                                                      ),
                                                      Expanded(
                                                        child: FemaleGenderSelectButton(),
                                                      )
                                                    ]),
                                                  ),
                                                  // 20.horizontalSpace,
                                                  const Expanded(
                                                      flex: 30,
                                                      child: PlayButton(
                                                          iconsList: [Icons.campaign_outlined, Icons.volume_up_rounded],
                                                          labelsList: [AppConstants.PLAY_BUTTON_TEXT, AppConstants.PLAYING_BUTTON_TEXT])),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              10.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.only(left: 40.w, right: 5.w),
                            height: 35.h,
                            color: AppConstants.STANDARD_BLACK,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Current Status : ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 10.w,
                                    fontWeight: FontWeight.w700,
                                    color: AppConstants.STANDARD_WHITE,
                                  ),
                                ),
                                5.horizontalSpace,
                                Expanded(
                                  child: AutoSizeText(
                                    _appUIController.currentRequestStatusForUI.isEmpty
                                        ? AppConstants.INITIAL_CURRENT_STATUS_VALUE
                                        : _appUIController.currentRequestStatusForUI,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.kodchasan(
                                      fontSize: 8.w,
                                      color: AppConstants.STANDARD_WHITE,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitSpinningLines(color: AppConstants.STANDARD_BLACK, size: 0.5.sw),
            30.verticalSpace,
            AutoSizeText.rich(
              TextSpan(
                  text: 'Tip:',
                  style: GoogleFonts.kodchasan(
                    color: AppConstants.STANDARD_BLACK,
                    fontSize: 25.w,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(
                      text: AppConstants.LOADING_SCREEN_TIP,
                      style: GoogleFonts.kodchasan(
                        color: AppConstants.STANDARD_BLACK,
                        fontSize: 23.w,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

// Connected dots in the homepage background
class HomePageBG extends StatelessWidget {
  final String topRightImagePath;
  final String bottomLeftImagePath;
  const HomePageBG({
    required this.topRightImagePath,
    required this.bottomLeftImagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ColorFiltered(
          colorFilter:
              const ColorFilter.matrix([0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
          child: Image.asset(topRightImagePath, fit: BoxFit.fitWidth),
        )),
        Expanded(
            child: ColorFiltered(
          colorFilter:
              const ColorFilter.matrix([0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0.2126, 0.7152, 0.0722, 0, 0, 0, 0, 0, 1, 0]),
          child: Image.asset(bottomLeftImagePath, fit: BoxFit.fitWidth),
        )),
      ],
    );
  }
}

// Three major black containers
class BaseContainer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Widget childWidget;

  const BaseContainer({
    this.height = double.infinity,
    this.width = double.infinity,
    required this.borderRadius,
    required this.childWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppConstants.STANDARD_BLACK,
      ),
      child: childWidget,
    );
  }
}

/*
 ASR/Translation container content => 
    - Icon Group, ASR/Translation header
    - Horizontal Divider
    - ASR/Translation Output Container
*/
class ContainerContent extends StatelessWidget {
  final List<IconData> sourceTargetIconDataList;
  final String headerLabel;
  final MODEL_TYPES outputOfASROrTranslation;

  const ContainerContent({
    required this.sourceTargetIconDataList,
    required this.headerLabel,
    required this.outputOfASROrTranslation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding around => row - horrizontal divider - output container
      padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 1.h, top: 1.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Icon Group and Header (ASR/Translation)
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //Speech to Text/Translation Icon Group
                Row(
                  children: [
                    Icon(
                      sourceTargetIconDataList[0],
                      color: AppConstants.STANDARD_WHITE,
                      size: 30.w,
                    ),
                    Icon(
                      Icons.arrow_right_rounded,
                      color: AppConstants.STANDARD_WHITE,
                      size: 30.w,
                    ),
                    Icon(
                      sourceTargetIconDataList[1],
                      color: AppConstants.STANDARD_WHITE,
                      size: 30.w,
                    )
                  ],
                ),
                //Speech to Text/Translation Label
                AutoSizeText(
                  headerLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.kodchasan(color: AppConstants.STANDARD_WHITE, fontSize: 22.w, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          HorizontalDivider(
            horMargin: 1.w,
            verMargin: 10.h,
            dividerHeight: 4.h,
            dividerBorderRad: 2.h,
          ),
          // ASR/Translation Output Container
          Expanded(
            flex: 6,
            child: BaseOutputContainer(outputOfASROrTranslation: outputOfASROrTranslation),
          )
        ],
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  final double horMargin;
  final double verMargin;
  final double dividerHeight;
  final double dividerBorderRad;

  const HorizontalDivider({
    Key? key,
    required this.horMargin,
    required this.verMargin,
    required this.dividerHeight,
    required this.dividerBorderRad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horMargin, vertical: verMargin),
      height: dividerHeight,
      decoration: BoxDecoration(
        color: AppConstants.STANDARD_WHITE,
        borderRadius: BorderRadius.circular(dividerBorderRad),
      ),
    );
  }
}

class VerticalDivider extends StatelessWidget {
  final double horMargin;
  final double verMargin;
  final double dividerWidth;
  final double dividerBorderRad;

  const VerticalDivider({
    Key? key,
    required this.horMargin,
    required this.verMargin,
    required this.dividerWidth,
    required this.dividerBorderRad,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horMargin, vertical: verMargin),
      width: dividerWidth,
      decoration: BoxDecoration(
        color: AppConstants.STANDARD_WHITE,
        borderRadius: BorderRadius.circular(dividerBorderRad),
      ),
    );
  }
}

// Container to show ASR/Translation Output
class BaseOutputContainer extends StatelessWidget {
  final MODEL_TYPES outputOfASROrTranslation;
  const BaseOutputContainer({
    required this.outputOfASROrTranslation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h, top: 10.h),
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(color: AppConstants.STANDARD_WHITE.withAlpha(240), borderRadius: BorderRadius.circular(25.h)),
      child: Align(
        alignment: Alignment.topLeft,
        child: outputOfASROrTranslation == MODEL_TYPES.ASR ? const ASROutput() : const TransOutput(),
      ),
    );
  }
}

class ASROutput extends StatelessWidget {
  const ASROutput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        SpeechToSpeechController _speechToSpeechController = Get.find<SpeechToSpeechController>();
        return _appUIController.isASRResponseGenerated
            ? GestureDetector(
                onTap: () {
                  FlutterClipboard.copy(_speechToSpeechController.asrResponseText).then((_) {
                    showSnackbar(title: 'Success', message: AppConstants.CLIPBOARD_TEXT_COPY_SUCCESS);
                  });
                },
                child: SingleChildScrollView(
                  child: AutoSizeText(_speechToSpeechController.asrResponseText,
                      //To avoid StepGranuality issue with AutoSizeText, use toInt().toDouble()
                      minFontSize: (20.w).toInt().toDouble(),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      // overflowReplacement: Text(textToShow),
                      style: GoogleFonts.kodchasan(color: AppConstants.STANDARD_BLACK, fontSize: 25.w)),
                ),
              )
            : Icon(Icons.multitrack_audio_rounded, color: AppConstants.STANDARD_BLACK, size: 25.w);
      },
    );
  }
}

class TransOutput extends StatelessWidget {
  const TransOutput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        SpeechToSpeechController _speechToSpeechController = Get.find<SpeechToSpeechController>();
        return _appUIController.isTransResponseGenerated
            ? GestureDetector(
                onTap: () {
                  FlutterClipboard.copy(_speechToSpeechController.transResponseText).then((_) {
                    showSnackbar(title: 'Success', message: AppConstants.CLIPBOARD_TEXT_COPY_SUCCESS);
                  });
                },
                child: SingleChildScrollView(
                  child: AutoSizeText(_speechToSpeechController.transResponseText,
                      //To avoid StepGranuality issue with AutoSizeText, use toInt().toDouble()
                      minFontSize: (20.w).toInt().toDouble(),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                      // overflowReplacement: Text(textToShow),
                      style: GoogleFonts.kodchasan(color: AppConstants.STANDARD_BLACK, fontSize: 25.w)),
                ),
              )
            : Icon(Icons.text_fields_rounded, color: AppConstants.STANDARD_BLACK, size: 25.w);
      },
    );
  }
}

class SourceTargetLanguageSelect extends StatelessWidget {
  final LANG_DROP_DOWN_TYPE dropdownType;

  const SourceTargetLanguageSelect({
    required this.dropdownType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dropdownLabel =
        dropdownType == LANG_DROP_DOWN_TYPE.sourceLanguage ? AppConstants.SOURCE_DROPDOWN_LABEL : AppConstants.TARGET_DROPDOWN_LABEL;
    Widget sourceOrTargetDropDownWidget = dropdownType == LANG_DROP_DOWN_TYPE.sourceLanguage ? const SourceDropDown() : const TargetDropDown();
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            dropdownLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.kodchasan(fontSize: 25.h, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w700),
          ),
          5.verticalSpace,
          Expanded(child: sourceOrTargetDropDownWidget)
        ],
      ),
    );
  }
}

class SourceDropDown extends StatelessWidget {
  const SourceDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(builder: (_appUIController) {
      bool isActive = !_appUIController.isTTSOutputPlaying;
      String snackbarMsg = isActive ? '' : AppConstants.OUTPUT_PLAYING_ERROR_MSG;

      Color currentColor = isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7);

      return InkWell(
        onTap: () {
          LanguageModelController languageModelController = Get.find();
          !isActive
              ? showSnackbar(title: 'Error', message: snackbarMsg)
              : Get.bottomSheet(
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 0.38.sh,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppConstants.STANDARD_BLACK.withOpacity(0.97),
                      ),
                      child: GridView.builder(
                        itemCount: languageModelController.allAvailableSourceLanguages.length,
                        itemBuilder: (context, index) {
                          String eachSourceLanguage = languageModelController.allAvailableSourceLanguages.elementAt(index);
                          return InkWell(
                            onTap: () {
                              languageModelController.changeSelectedSourceLangAndCalcTargetLangs(selectedSourceLanguageName: eachSourceLanguage);
                              // Delay for better User Experience. User tap shows a splash effect.
                              Future.delayed(const Duration(milliseconds: 300)).then((_) => Get.back());
                            },
                            child: Center(
                              child: AutoSizeText(
                                eachSourceLanguage,
                                minFontSize: (15.w).toInt().toDouble(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.kodchasan(fontSize: 25.w, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w300),
                              ),
                            ),
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2,
                        ),
                      ),
                    ),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                );
        },
        splashColor: AppConstants.STANDARD_BLACK,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: AutoSizeText(
                _appUIController.selectedSourceLangNameInUI.isEmpty
                    ? AppConstants.DEFAULT_SELECT_DROPDOWN_LABEL
                    : _appUIController.selectedSourceLangNameInUI,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.kodchasan(fontSize: 22.w, color: currentColor, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: currentColor,
              size: 35.w,
            ),
          ],
        ),
      );
    });
  }
}

class TargetDropDown extends StatelessWidget {
  const TargetDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        bool isActive = _appUIController.selectedSourceLangNameInUI.isNotEmpty;
        String snackbarMsg = AppConstants.SELECT_SOURCE_LANG_ERROR_MSG;
        if (isActive) {
          isActive = !_appUIController.isTTSOutputPlaying;
          snackbarMsg = AppConstants.OUTPUT_PLAYING_ERROR_MSG;
        }
        Color currentColor = isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7);

        return InkWell(
          onTap: () {
            LanguageModelController languageModelController = Get.find();
            !isActive
                ? showSnackbar(title: 'Error', message: snackbarMsg)
                : Get.bottomSheet(
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 0.38.sh,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppConstants.STANDARD_BLACK.withOpacity(0.97),
                        ),
                        child: GridView.builder(
                          itemCount: languageModelController.availableTargetLangsForSelectedSourceLang.length,
                          itemBuilder: (context, index) {
                            String eachTargetLanguage = languageModelController.availableTargetLangsForSelectedSourceLang.elementAt(index);
                            return InkWell(
                              onTap: () {
                                _appUIController.changeTargetLanguage(selectedTargetLanguageName: eachTargetLanguage);
                                // Delay for better User Experience. User tap shows a splash effect.
                                Future.delayed(const Duration(milliseconds: 300)).then((_) => Get.back());
                              },
                              child: Center(
                                child: AutoSizeText(
                                  eachTargetLanguage,
                                  minFontSize: (15.w).toInt().toDouble(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.kodchasan(fontSize: 25.w, color: AppConstants.STANDARD_WHITE, fontWeight: FontWeight.w300),
                                ),
                              ),
                            );
                          },
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2,
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  );
          },
          splashColor: AppConstants.STANDARD_BLACK,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: AutoSizeText(
                  _appUIController.selectedTargetLangNameInUI.isEmpty
                      ? AppConstants.DEFAULT_SELECT_DROPDOWN_LABEL
                      : _appUIController.selectedTargetLangNameInUI,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.kodchasan(fontSize: 22.w, color: currentColor, fontWeight: FontWeight.w500),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: currentColor,
                size: 35.w,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MaleGenderSelectButton extends StatelessWidget {
  const MaleGenderSelectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        bool isActive = !(_appUIController.selectedGenderInUI == GENDER.female);
        if (isActive) {
          isActive = _appUIController.isMaleTTSAvailable;
        }
        return ElevatedButton.icon(
          onPressed: isActive
              ? () {}
              : () {
                  if (_appUIController.isMaleTTSAvailable) {
                    _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.male);
                  } else {
                    showSnackbar(title: 'Error', message: AppConstants.MALE_FEMALE_TTS_UNAVAILABLE.replaceFirst('%replaceContent%', 'Male'));
                  }
                },
          icon: Icon(
            Icons.male_rounded,
            color: isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7),
            size: 25.w,
          ),
          label: AutoSizeText(
            'Male',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: (20.w).toInt().toDouble(),
            style: GoogleFonts.kodchasan(
                color: isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7),
                fontSize: 20.w,
                fontWeight: FontWeight.w700),
          ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(AppConstants.STANDARD_BLACK),
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 15.h, bottom: 15.h, left: 1.w, right: 1.w),
            ),
          ),
        );
      },
    );
  }
}

class FemaleGenderSelectButton extends StatelessWidget {
  const FemaleGenderSelectButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        bool isActive = _appUIController.selectedGenderInUI == GENDER.female;
        if (isActive) {
          isActive = _appUIController.isFemaleTTSAvailable;
        }
        return ElevatedButton.icon(
          onPressed: isActive
              ? () {}
              : () {
                  if (_appUIController.isFemaleTTSAvailable) {
                    _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
                  } else {
                    showSnackbar(title: 'Error', message: AppConstants.MALE_FEMALE_TTS_UNAVAILABLE.replaceFirst('%replaceContent%', 'Female'));
                  }
                },
          icon: Icon(
            Icons.female_rounded,
            color: isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7),
            size: 25.w,
          ),
          label: AutoSizeText(
            'Female',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            minFontSize: (20.w).toInt().toDouble(),
            style: GoogleFonts.kodchasan(
                color: isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7),
                fontSize: 20.w,
                fontWeight: FontWeight.w700),
          ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(AppConstants.STANDARD_BLACK),
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 15.h, bottom: 15.h, left: 1.w, right: 1.w),
            ),
          ),
        );
      },
    );
  }
}

class RecordStopButton extends StatelessWidget {
  final List<IconData> iconList;
  final List<String> labelList;

  const RecordStopButton({
    required this.iconList,
    required this.labelList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        bool isActive = _appUIController.selectedTargetLangNameInUI.isNotEmpty;
        if (isActive) {
          isActive = !_appUIController.isTTSOutputPlaying;
        }
        if (isActive) {
          isActive = !_appUIController.hasSpeechToSpeechRequestsInitiated;
        }
        IconData currentIcon = _appUIController.isUserRecording ? iconList[1] : iconList[0];
        String currentLabel = _appUIController.isUserRecording ? labelList[1] : labelList[0];
        Color currentColor = isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7);

        dynamic onPressMethod = !_appUIController.isUserRecording
            ? () async {
                await Get.find<RecorderController>().record();
                if (!_appUIController.isUserRecording) {
                  showSnackbar(title: 'Error', message: 'User Voice not recording!');
                }
              }
            : () async {
                await Get.find<RecorderController>().stop();
              };

        return ElevatedButton.icon(
          onPressed: isActive
              ? onPressMethod
              : () {
                  showSnackbar(
                      title: 'Error',
                      message: _appUIController.isTTSOutputPlaying
                          ? AppConstants.OUTPUT_PLAYING_ERROR_MSG
                          : _appUIController.selectedTargetLangNameInUI.isEmpty
                              ? AppConstants.SELECT_TARGET_LANG_ERROR_MSG
                              : _appUIController.hasSpeechToSpeechRequestsInitiated
                                  ? AppConstants.NETWORK_REQS_IN_PROGRESS_ERROR_MSG
                                  : '');
                },
          icon: Icon(
            currentIcon,
            color: currentColor,
            size: 40.w,
          ),
          label: AutoSizeText(
            currentLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            maxFontSize: (30.w).toInt().toDouble(),
            style: GoogleFonts.kodchasan(color: currentColor, fontSize: 30.w, fontWeight: FontWeight.w700),
          ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(AppConstants.STANDARD_BLACK),
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 5.h, bottom: 5.h, left: 5.w, right: 5.w),
            ),
          ),
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  final List<IconData> iconsList;
  final List<String> labelsList;

  const PlayButton({
    required this.iconsList,
    required this.labelsList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUIController>(
      builder: (_appUIController) {
        bool isActive = _appUIController.isTTSResponseFileGenerated;
        if (isActive) {
          isActive = !_appUIController.isTTSOutputPlaying;
        }
        Color currentColor = isActive ? AppConstants.STANDARD_WHITE : AppConstants.STANDARD_OFF_WHITE.withOpacity(0.7);
        IconData currentIcon = _appUIController.isTTSOutputPlaying ? iconsList[1] : iconsList[0];
        String currentLabel = _appUIController.isTTSOutputPlaying ? labelsList[1] : labelsList[0];

        dynamic onPressMethod = _appUIController.isTTSOutputPlaying
            ? () {
                showSnackbar(title: 'Error', message: AppConstants.OUTPUT_PLAYING_ERROR_MSG);
              }
            : () async {
                await Get.find<RecorderController>().playback();
              };

        return _appUIController.hasTTSRequestInitiated
            ? Center(child: SpinKitWave(color: AppConstants.STANDARD_OFF_WHITE, size: 50.w))
            : ElevatedButton.icon(
                onPressed: isActive
                    ? onPressMethod
                    : () {
                        showSnackbar(
                            title: 'Error',
                            message: _appUIController.isTTSOutputPlaying
                                ? AppConstants.OUTPUT_PLAYING_ERROR_MSG
                                : !_appUIController.isTTSResponseFileGenerated
                                    ? AppConstants.TTS_NOT_GENERATED_ERROR_MSG
                                    : '');
                      },
                icon: Icon(
                  currentIcon,
                  color: currentColor,
                  size: 40.w,
                ),
                label: AutoSizeText(
                  currentLabel,
                  maxLines: 1,
                  maxFontSize: (30.w).toInt().toDouble(),
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.kodchasan(color: currentColor, fontSize: 30.w, fontWeight: FontWeight.w700),
                ),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(AppConstants.STANDARD_BLACK),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(top: 5.h, bottom: 5.h, left: 5.w, right: 5.w),
                  ),
                ),
              );
      },
    );
  }
}

class SnackBarFormattedText extends StatelessWidget {
  final String text;
  final GETX_SNACK_BAR titleOrMessage;

  const SnackBarFormattedText({
    Key? key,
    required this.text,
    required this.titleOrMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = titleOrMessage == GETX_SNACK_BAR.title
        ? GoogleFonts.kodchasan(color: AppConstants.STANDARD_WHITE, fontSize: 30.w, fontWeight: FontWeight.w700)
        : GoogleFonts.comfortaa(color: AppConstants.STANDARD_WHITE, fontSize: 20.w);
    return AutoSizeText(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle);
  }
}

class SnackBarFormattedIcon extends StatelessWidget {
  const SnackBarFormattedIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.error_outline_rounded,
      color: AppConstants.STANDARD_WHITE,
      size: 30.w,
    );
  }
}

void showSnackbar({required String title, required String message}) {
  Get.snackbar(
    '',
    '',
    titleText: SnackBarFormattedText(
      text: title,
      titleOrMessage: GETX_SNACK_BAR.title,
    ),
    messageText: SnackBarFormattedText(
      text: message,
      titleOrMessage: GETX_SNACK_BAR.message,
    ),
    icon: const SnackBarFormattedIcon(),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppConstants.STANDARD_BLACK.withOpacity(0.2),
    borderRadius: 10.w,
    margin: EdgeInsets.all(20.w),
    barBlur: 40,
    overlayColor: AppConstants.STANDARD_BLACK.withOpacity(0.80),
    overlayBlur: 1,
    colorText: AppConstants.STANDARD_WHITE,
    duration: const Duration(seconds: 4),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}
