import 'package:free_one_piece_manga/utils/app_functions.dart';

class ChapterModel {
  String link;
  List<String> pages;

  ChapterModel({
    required this.link,
    required this.pages,
  });

  factory ChapterModel.fromMap({required Map<String, dynamic> data}) {
    Iterable rawPages = data['pages'];
    return ChapterModel(
        link: data['link'].toString(),
        pages: rawPages.map((e) => e.toString()).toList());
  }

  Map<String, dynamic> toMap() {
    return {'link': link.toString(), 'pages': pages};
  }

  Future<bool> cacheMe({required Function(double) onSuccessEach}) async {
    bool xSuccess = false;
    int i = 0;
    try {
      for (var each in pages) {
        final result = await AppFunctions().preCacheImage(each);
        if (!result) {
          throw Exception();
        } else {
          i = i + 1;
          onSuccessEach(i / pages.length);
        }
      }
      xSuccess = true;
    } catch (e) {
      xSuccess = false;
    }
    return xSuccess;
  }

  bool xLast({required List<String> links}) {
    try {
      return getIndex(links: links) == 0;
    } catch (e) {
      return false;
    }
  }

  int? getIndex({required List<String> links}) {
    try {
      return links.indexOf(link);
    } catch (e) {
      return null;
    }
  }
}
