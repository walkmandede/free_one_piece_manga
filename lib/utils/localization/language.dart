import 'dart:ui';
import 'package:get/get.dart';

import 'language_data.dart';

enum AppLanguage { mm, en, th }

class Language extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'mm': myanmar,
        'en': english,
        'th': english,
      };

  Map<String, String> myanmar = {};

  Map<String, String> english = {};
}

bool xEnLang() {
  return Get.locale!.languageCode == 'en';
}

Future<void> updateLanguage({required AppLanguage appLanguage}) async{
  await Get.updateLocale(Locale(appLanguage.name));
}

extension AppLanguageConvert on String{
  String al(){
    var result = this;
    print(LanguageData.data());
    try{
      switch(Get.locale!.languageCode){
        case 'mm' : result = LanguageData.data()[this]![AppLanguage.mm]??this;break;
        case 'en' : result = LanguageData.data()[this]![AppLanguage.en]??this;break;
        case 'th' : result = LanguageData.data()[this]![AppLanguage.th]??this;break;
      }
    }
    catch(e){
      print(e);
      null;
    }
    print(result);
    return result;
  }

}
