// ignore_for_file: non_constant_identifier_names, constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';

enum LANGUAGE_MAP { languageName, languageCode }
enum LANGUAGE {
  english,
  hindi,
  gujarati,
  nepali,
  bengali,
  maithili,
  bhojpuri,
  odia,
  punjabi,
  sinhala,
  marathi,
  tamil,
  kannada,
  dogri,
  sanskrit,
  telugu,
  urdu,
  malayalam,
  assamese,
  rajasthani
}

enum MODEL_TYPES { ASR, TRANSLATION, TTS }

enum LANG_DROP_DOWN_TYPE { sourceLanguage, targetLanguage }

enum GETX_SNACK_BAR { title, message }

enum GENDER { male, female }

class AppConstants {
  static final List<String> TYPES_OF_MODELS_LIST = ['asr', 'translation', 'tts'];

  static final List<String> LANG_CODE_MAP_HELPER = ['language_name', 'language_code'];

  static const String APP_NAME = 'LANGUAVERSE';

  static const String ASR_CALLBACK_AZURE_URL = 'https://meity-dev-asr.ulcacontrib.org/asr/v1/recognize';
  static const String ASR_CALLBACK_CDAC_URL = 'https://cdac.ulcacontrib.org/asr/v1/recognize';
  static const String STS_BASE_URL = 'https://meity-auth.ulcacontrib.org/ulca/apis';

  static const String SEARCH_REQ_URL = '/v0/model/search';
  static const String ASR_REQ_URL = '/asr/v1/model/compute';
  static const String TRANS_REQ_URL = '/v0/model/compute';
  static const String TTS_REQ_URL = '/v0/model/compute';

  static const String IMAGE_ASSETS_PATH = 'assets/images/';

  static const String RECORD_BUTTON_TEXT = 'Record';
  static const String PLAY_BUTTON_TEXT = 'Play';
  static const String PLAYING_BUTTON_TEXT = 'Playing';
  static const String STOP_BUTTON_TEXT = 'Stop';
  static const String SPEECH_TO_TEXT_HEADER_LABEL = 'SPEECH TO TEXT';
  static const String TRANSLATION_HEADER_LABEL = 'TRANSLATION';
  static const String SOURCE_DROPDOWN_LABEL = 'SOURCE';
  static const String TARGET_DROPDOWN_LABEL = 'TARGET';
  static const String DEFAULT_SELECT_DROPDOWN_LABEL = 'Select';

  static const String LOADING_SCREEN_TIP = ' Click to copy the output text!!';

  static const String INITIAL_CURRENT_STATUS_VALUE = 'Initiate new Speech to Speech request !';
  static const String USER_VOICE_RECORDING_STATUS_MSG = 'User voice recording in progress ...';

  static const String SPEECH_RECG_REQ_STATUS_MSG = 'Speech Recoganition for %replaceContent% voice in progress !';
  static const String SPEECH_RECG_SUCCESS_STATUS_MSG = 'Speech Recoganition in %replaceContent% completed !';
  static const String SPEECH_RECG_FAIL_STATUS_MSG = 'Speech Recoganition in %replaceContent% Failed !';

  static const String SEND_TRANS_REQ_STATUS_MSG = 'Translation from %replaceContent1% to %replaceContent2% in progress !';
  static const String TRANS_SUCCESS_STATUS_MSG = 'Translation from %replaceContent1% to %replaceContent2% completed !';
  static const String TRANS_FAIL_STATUS_MSG = 'Translation from %replaceContent1% to %replaceContent2% failed !';

  static const String SEND_TTS_REQ_STATUS_MSG = 'Speech generation in %replaceContent% in progress !';
  static const String TTS_SUCCESS_STATUS_MSG = 'Speech in %replaceContent% generated !';
  static const String TTS_FAIL_STATUS_MSG = 'Speech genration in %replaceContent% failed !';

  static const String OUTPUT_PLAYING_ERROR_MSG = 'Audio Playback in progress !';
  static const String SELECT_SOURCE_LANG_ERROR_MSG = 'Please select a Source Language first !';
  static const String SELECT_TARGET_LANG_ERROR_MSG = 'Please select a Target Language first !';
  static const String TTS_NOT_GENERATED_ERROR_MSG = 'Please generate TTS output first !';
  static const String NETWORK_REQS_IN_PROGRESS_ERROR_MSG = 'Currently processing previous requests !';
  static const String MALE_FEMALE_TTS_UNAVAILABLE = '%replaceContent% voice output is not available !';

  static const String CLIPBOARD_TEXT_COPY_SUCCESS = 'Text copied to Clipboard!';

  static const String HOMEPAGE_TOP_RIGHT_IMAGE = 'connected_dots_top_right.webp';
  static const String HOMEPAGE_BOTTOM_LEFT_IMAGE = 'connected_dots_bottom_left.webp';

  static const STANDARD_WHITE = Color.fromARGB(255, 240, 240, 240);
  static const STANDARD_OFF_WHITE = Color.fromARGB(255, 90, 90, 90);
  static const STANDARD_BLACK = Color.fromARGB(235, 10, 10, 10);

  static final LANGUAGE_CODE_MAP = {
    'language_codes': [
      {'language_name': 'Urdu', 'language_code': 'ur'},
      {'language_name': 'Odia', 'language_code': 'or'},
      {'language_name': 'Tamil', 'language_code': 'ta'},
      {'language_name': 'Hindi', 'language_code': 'hi'},
      {'language_name': 'Dogri', 'language_code': 'doi'},
      {'language_name': 'Telugu', 'language_code': 'te'},
      {'language_name': 'Nepali', 'language_code': 'ne'},
      {'language_name': 'English', 'language_code': 'en'},
      {'language_name': 'Punjabi', 'language_code': 'pa'},
      {'language_name': 'Sinhala', 'language_code': 'si'},
      {'language_name': 'Marathi', 'language_code': 'mr'},
      {'language_name': 'Kannada', 'language_code': 'kn'},
      {'language_name': 'Bengali', 'language_code': 'bn'},
      {'language_name': 'Sanskrit', 'language_code': 'sa'},
      {'language_name': 'Assamese', 'language_code': 'as'},
      {'language_name': 'Gujarati', 'language_code': 'gu'},
      {'language_name': 'Maithili', 'language_code': 'mai'},
      {'language_name': 'Bhojpuri', 'language_code': 'bho'},
      {'language_name': 'Malayalam', 'language_code': 'ml'},
      {'language_name': 'Rajasthani', 'language_code': 'raj'},
    ]
  };

  static final DEFAULT_MODEL_TYPES = {
    'asr': 'vakyansh',
    'translation': 'indictrans',
    'tts': 'vakyansh',
  };

  static final ASR_PAYLOAD_FORMAT = {
    'modelId': '',
    'task': '',
    'audioContent': '',
    'source': '',
    'inferenceEndPoint': {
      'callbackUrl': '',
      'schema': {
        'request': {
          'config': {
            'language': {'sourceLanguageName': null, 'sourceLanguage': '', 'targetLanguageName': null, 'targetLanguage': null},
            'audioFormat': 'wav',
            'transcriptionFormat': {'value': 'transcript'}
          }
        }
      }
    },
    'userId': null
  };

  static final TRANS_PAYLOAD_FORMAT = {
    'modelId': '',
    'task': '',
    'input': [
      {'source': ''}
    ],
    'userId': null
  };

  static final TTS_PAYLOAD_FORMAT = {
    'modelId': '',
    'task': '',
    'input': [
      {'source': ''}
    ],
    'gender': '',
    'userId': null
  };

  static String getLanguageCodeOrName({required String value, required returnWhat}) {
    // If Language Code is to be returned that means the value received is a language name
    try {
      if (returnWhat == LANGUAGE_MAP.languageCode) {
        var returningLangPair = LANGUAGE_CODE_MAP['language_codes']!
            .firstWhere((eachLanguageCodeNamePair) => eachLanguageCodeNamePair['language_name']!.toLowerCase() == value.toLowerCase());
        return returningLangPair['language_code'] ?? 'No Language Code Found';
      }

      var returningLangPair = LANGUAGE_CODE_MAP['language_codes']!
          .firstWhere((eachLanguageCodeNamePair) => eachLanguageCodeNamePair['language_code']!.toLowerCase() == value.toLowerCase());
      return returningLangPair['language_name'] ?? 'No Language Name Found';
    } catch (e) {
      return 'No Return Value Found';
    }
  }
}
