import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:translation_app/config/app_constants.dart';
import 'package:translation_app/controllers/language_model_controller.dart';
import 'package:translation_app/controllers/app_ui_controller.dart';
import 'package:translation_app/controllers/hardware_requests_controller.dart';
import 'package:translation_app/data/translation_app_api_client.dart';

class SpeechToSpeechController extends GetxController {
  late AppUIController _appUIController;
  late HardwareRequestsController _hardwareRequestsController;
  late TranslationAppAPIClient _translationAppAPIClient;
  late LanguageModelController _languageModelController;

  // String asrResponseText = '';
  // String transResponseText = '';

  late String _asrResponseText;
  String get asrResponseText => _asrResponseText;

  late String _transResponseText;
  String get transResponseText => _transResponseText;

  String _ttsMaleAudioFilePath = '';
  String get ttsMaleAudioFilePath => _ttsMaleAudioFilePath;

  String _ttsFemaleAudioFilePath = '';
  String get ttsFemaleAudioFilePath => _ttsFemaleAudioFilePath;

  @override
  void onInit() {
    super.onInit();
    _appUIController = Get.find();
    _hardwareRequestsController = Get.find();
    _translationAppAPIClient = Get.find();
    _languageModelController = Get.find();
  }

  /*Or can do 2 separate functions. One with async-await and await all methods instead of .then() and then call
  this new method in non-future type method with .then() appearing once!*/

  void sendSpeechToSpeechRequests({required String base64AudioContent}) {
    _sendSpeechToSpeechRequestsInternal(base64AudioContent: base64AudioContent).then((_) {});
  }

  Future _sendSpeechToSpeechRequestsInternal({required String base64AudioContent}) async {
    try {
      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: true);
      _appUIController.changeCurrentRequestStatusForUI(
          newStatus:
              AppConstants.SPEECH_RECG_REQ_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));

      var asrOutputString = await _getASROutput(base64AudioContent: base64AudioContent);

      if (asrOutputString.isEmpty) {
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus:
                AppConstants.SPEECH_RECG_FAIL_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));
        throw Exception(MODEL_TYPES.ASR);
      }

      _asrResponseText = asrOutputString;

      _appUIController.changeIsASRResponseGenerated(isASRResponseGenerated: true);
      _appUIController.changeCurrentRequestStatusForUI(
          newStatus:
              AppConstants.SPEECH_RECG_SUCCESS_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedSourceLangNameInUI));

      //Simulated delay of 2 seconds for UX
      await Future.delayed(const Duration(seconds: 1));

      _appUIController.changeCurrentRequestStatusForUI(
          newStatus: AppConstants.SEND_TRANS_REQ_STATUS_MSG
              .toString()
              .replaceFirst('%replaceContent1%', _appUIController.selectedSourceLangNameInUI)
              .replaceFirst('%replaceContent2%', _appUIController.selectedTargetLangNameInUI));

      var transOutputString = await _getTranslationOutput(asrOutputAsTransInputString: asrOutputString);
      if (transOutputString.isEmpty) {
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TRANS_FAIL_STATUS_MSG
                .toString()
                .replaceFirst('%replaceContent1%', _appUIController.selectedSourceLangNameInUI)
                .replaceFirst('%replaceContent2%', _appUIController.selectedTargetLangNameInUI));
        throw Exception(MODEL_TYPES.TRANSLATION);
      }

      _transResponseText = transOutputString;
      _appUIController.changeIsTransResponseGenerated(isTransResponseGenerated: true);
      _appUIController.changeCurrentRequestStatusForUI(
          newStatus: AppConstants.TRANS_SUCCESS_STATUS_MSG
              .toString()
              .replaceFirst('%replaceContent1%', _appUIController.selectedSourceLangNameInUI)
              .replaceFirst('%replaceContent2%', _appUIController.selectedTargetLangNameInUI));

      await Future.delayed(const Duration(seconds: 1));

      _appUIController.changeCurrentRequestStatusForUI(
          newStatus: AppConstants.SEND_TTS_REQ_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: true);

      var ttsResponseList = await _getTTSOutputForBothGender(transOutputAsTTSInputString: transOutputString);

      if (ttsResponseList.isEmpty) {
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_FAIL_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
        throw Exception(MODEL_TYPES.TTS);
      }

      await _hardwareRequestsController.requestPermissions();
      String appDocPath = await _hardwareRequestsController.getAppDirPath();

      var _ttsMaleOutputBase64String = ttsResponseList[0];
      var _ttsFemaleOutputBase64String = ttsResponseList[1];

      if (_ttsMaleOutputBase64String.isNotEmpty) {
        var maleFileAsBytes = base64Decode(_ttsMaleOutputBase64String);
        String maleTTSAudioFileName = '$appDocPath/TTSMaleAudio.wav';
        final maleAudioFile = File(maleTTSAudioFileName);
        await maleAudioFile.writeAsBytes(maleFileAsBytes);
        _ttsMaleAudioFilePath = maleTTSAudioFileName;
        _appUIController.changeIsMaleTTSAvailable(isMaleTTSAvailable: true);
      }

      if (_ttsFemaleOutputBase64String.isNotEmpty) {
        var femaleFileAsBytes = base64Decode(_ttsFemaleOutputBase64String);
        String femaleTTSAudioFileName = '$appDocPath/TTSFemaleAudio.wav';
        final femaleAudioFile = File(femaleTTSAudioFileName);
        await femaleAudioFile.writeAsBytes(femaleFileAsBytes);
        _ttsFemaleAudioFilePath = femaleTTSAudioFileName;
        _appUIController.changeIsFemaleTTSAvailable(isFemaleTTSAvailable: true);
      }

      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
      _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: false);

      if (_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
        _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      } else if (_appUIController.isMaleTTSAvailable && !_appUIController.isFemaleTTSAvailable) {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
        _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.male);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      } else if (!_appUIController.isMaleTTSAvailable && _appUIController.isFemaleTTSAvailable) {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: true);
        _appUIController.changeSelectedGenderForTTSInUI(selectedGenderForTTS: GENDER.female);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_SUCCESS_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      } else {
        _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
        _appUIController.changeCurrentRequestStatusForUI(
            newStatus: AppConstants.TTS_FAIL_STATUS_MSG.toString().replaceFirst('%replaceContent%', _appUIController.selectedTargetLangNameInUI));
      }
    } on Exception {
      _appUIController.changeHasSpeechToSpeechRequestsInitiated(hasSpeechToSpeechRequestsInitiated: false);
      _appUIController.changeHasTTSRequestInitiated(hasTTSRequestInitiated: false);
      _appUIController.changeIsTTSResponseFileGenerated(isTTSResponseFileGenerated: false);
    }
  }

  Future<String> _getASROutput({required String base64AudioContent}) async {
    List<String> availableASRModelsForSelectedLangInUIDefault = [];
    List<String> availableASRModelsForSelectedLangInUI = [];
    bool isAtLeastOneDefaultModelTypeFound = false;
    String selectedSourceLangCodeInUI =
        AppConstants.getLanguageCodeOrName(value: _appUIController.selectedSourceLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

    for (var eachAvailableASRModelData in _languageModelController.availableASRModels.data) {
      if (eachAvailableASRModelData.languages[0].sourceLanguage == selectedSourceLangCodeInUI) {
        if (eachAvailableASRModelData.name
            .toLowerCase()
            .contains(AppConstants.DEFAULT_MODEL_TYPES[AppConstants.TYPES_OF_MODELS_LIST[0]]!.toLowerCase())) {
          availableASRModelsForSelectedLangInUIDefault.add(eachAvailableASRModelData.modelId);
          isAtLeastOneDefaultModelTypeFound = true;
        } else {
          availableASRModelsForSelectedLangInUI.add(eachAvailableASRModelData.modelId);
        }
      }
    }

    //Either select default model (vakyansh for now) or any random model from the available list.
    String asrModelIDToUse = isAtLeastOneDefaultModelTypeFound
        ? availableASRModelsForSelectedLangInUIDefault[Random().nextInt(availableASRModelsForSelectedLangInUIDefault.length)]
        : availableASRModelsForSelectedLangInUI[Random().nextInt(availableASRModelsForSelectedLangInUI.length)];

    //Below two lines so that any changes are made to a new map, not the original format
    var asrPayloadToSend = {};
    asrPayloadToSend.addAll(AppConstants.ASR_PAYLOAD_FORMAT);

    asrPayloadToSend['modelId'] = asrModelIDToUse;
    asrPayloadToSend['task'] = AppConstants.TYPES_OF_MODELS_LIST[0];
    asrPayloadToSend['audioContent'] = base64AudioContent;
    asrPayloadToSend['source'] = selectedSourceLangCodeInUI;
    asrPayloadToSend['inferenceEndPoint']['callbackUrl'] = '${AppConstants.ASR_CALLBACK_AZURE_URL}/$selectedSourceLangCodeInUI';
    asrPayloadToSend['inferenceEndPoint']['schema']['request']['config']['language']['sourceLanguage'] = selectedSourceLangCodeInUI;

    Map<dynamic, dynamic> response = await _translationAppAPIClient.sendASRRequest(asrPayload: asrPayloadToSend);
    if (response.isEmpty) {
      return '';
    }

    return response['source'];
  }

  Future<String> _getTranslationOutput({required String asrOutputAsTransInputString}) async {
    List<String> availableTransModelsForSelectedLangInUIDefault = [];
    List<String> availableTransModelsForSelectedLangInUI = [];
    bool isAtLeastOneDefaultModelTypeFound = false;
    String selectedSourceLangCodeInUI =
        AppConstants.getLanguageCodeOrName(value: _appUIController.selectedSourceLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

    String selectedTargetLangCodeInUI =
        AppConstants.getLanguageCodeOrName(value: _appUIController.selectedTargetLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

    for (var eachAvailableTransModelData in _languageModelController.availableTranslationModels.data) {
      if (eachAvailableTransModelData.languages[0].sourceLanguage == selectedSourceLangCodeInUI &&
          eachAvailableTransModelData.languages[0].targetLanguage == selectedTargetLangCodeInUI) {
        if (eachAvailableTransModelData.name
            .toLowerCase()
            .contains(AppConstants.DEFAULT_MODEL_TYPES[AppConstants.TYPES_OF_MODELS_LIST[1]]!.toLowerCase())) {
          availableTransModelsForSelectedLangInUIDefault.add(eachAvailableTransModelData.modelId);
          isAtLeastOneDefaultModelTypeFound = true;
        } else {
          availableTransModelsForSelectedLangInUI.add(eachAvailableTransModelData.modelId);
        }
      }
    }

    //Either select default model (vakyansh for now) or any random model from the available list.
    String transModelIDToUse = isAtLeastOneDefaultModelTypeFound
        ? availableTransModelsForSelectedLangInUIDefault[Random().nextInt(availableTransModelsForSelectedLangInUIDefault.length)]
        : availableTransModelsForSelectedLangInUI[Random().nextInt(availableTransModelsForSelectedLangInUI.length)];

    //Below two lines so that any changes are made to a new map, not the original format
    var transPayloadToSend = {};
    transPayloadToSend.addAll(AppConstants.TRANS_PAYLOAD_FORMAT);

    transPayloadToSend['modelId'] = transModelIDToUse;
    transPayloadToSend['task'] = AppConstants.TYPES_OF_MODELS_LIST[1];
    transPayloadToSend['input'][0]['source'] = asrOutputAsTransInputString;

    Map<dynamic, dynamic> response = await _translationAppAPIClient.sendTranslationRequest(transPayload: transPayloadToSend);
    if (response.isEmpty) {
      return '';
    }

    return response['outputText'];
  }

  Future<List<String>> _getTTSOutputForBothGender({required String transOutputAsTTSInputString}) async {
    List<String> availableTTSModelsForSelectedLangInUIDefault = [];
    List<String> availableTTSModelsForSelectedLangInUI = [];
    bool isAtLeastOneDefaultModelTypeFound = false;
    String selectedTargetLangCodeInUI =
        AppConstants.getLanguageCodeOrName(value: _appUIController.selectedTargetLangNameInUI, returnWhat: LANGUAGE_MAP.languageCode);

    for (var eachAvailableTTSModelData in _languageModelController.availableTTSModels.data) {
      if (eachAvailableTTSModelData.languages[0].sourceLanguage == selectedTargetLangCodeInUI) {
        if (eachAvailableTTSModelData.name
            .toLowerCase()
            .contains(AppConstants.DEFAULT_MODEL_TYPES[AppConstants.TYPES_OF_MODELS_LIST[2]]!.toLowerCase())) {
          availableTTSModelsForSelectedLangInUIDefault.add(eachAvailableTTSModelData.modelId);
          isAtLeastOneDefaultModelTypeFound = true;
        } else {
          availableTTSModelsForSelectedLangInUI.add(eachAvailableTTSModelData.modelId);
        }
      }
    }

    //Either select default model (vakyansh for now) or any random model from the available list.
    String ttsModelIDToUse = isAtLeastOneDefaultModelTypeFound
        ? availableTTSModelsForSelectedLangInUIDefault[Random().nextInt(availableTTSModelsForSelectedLangInUIDefault.length)]
        : availableTTSModelsForSelectedLangInUI[Random().nextInt(availableTTSModelsForSelectedLangInUI.length)];

    //Below two lines so that any changes are made to a new map, not the original format
    var ttsPayloadToSendForMale = {};
    ttsPayloadToSendForMale.addAll(AppConstants.TTS_PAYLOAD_FORMAT);

    ttsPayloadToSendForMale['modelId'] = ttsModelIDToUse;
    ttsPayloadToSendForMale['task'] = AppConstants.TYPES_OF_MODELS_LIST[2];
    ttsPayloadToSendForMale['input'][0]['source'] = transOutputAsTTSInputString;
    ttsPayloadToSendForMale['gender'] = 'male';

    var ttsPayloadToSendForFemale = {};
    ttsPayloadToSendForFemale.addAll(ttsPayloadToSendForMale);
    ttsPayloadToSendForFemale['gender'] = 'female';

    List<Map<String, dynamic>> responseList =
        await _translationAppAPIClient.sendTTSReqForBothGender(ttsPayloadList: [ttsPayloadToSendForMale, ttsPayloadToSendForFemale]);

    if (responseList.isEmpty) {
      return [];
    }

    return [responseList[0]['output']['outputText'] ?? '', responseList[1]['output']['outputText'] ?? ''];
  }
}
