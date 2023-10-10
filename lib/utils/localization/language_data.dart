import 'language.dart';

class LanguageData{
  static Map<String,Map<AppLanguage,String>> data(){
    return {
      "Hello" : {
        AppLanguage.en : "Hello",
        AppLanguage.mm : "ဟဲလို",
        AppLanguage.th : "ยินดีต้อนรับสุขจะ",
      },
      "Something" : {
        AppLanguage.en : "Something",
        AppLanguage.mm : "တစ်ခုခု",
        AppLanguage.th : "กรุ",
      },
      "Chee" : {
        AppLanguage.en : "English Chee",
        AppLanguage.mm : "Myanmar Chee",
        AppLanguage.th : "Thai Chee",
      },
      "Thay" : {
        AppLanguage.en : "English Thay",
        AppLanguage.mm : "Myanmar Thay",
        AppLanguage.th : "Thai Thay",
      },
    };
  }
}