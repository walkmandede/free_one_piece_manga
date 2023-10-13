import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/modules/home_main/v_home_page.dart';
<<<<<<< HEAD
import 'package:free_one_piece_manga/modules/others/v_fuel_price.dart';
=======
import 'package:free_one_piece_manga/modules/manga/c_read_manga_controller.dart';
>>>>>>> refs/remotes/origin/main
import 'package:free_one_piece_manga/utils/app_colors.dart';
import 'package:free_one_piece_manga/utils/localization/language.dart';
import 'package:get/get.dart';
import 'modules/common/c_data_controller.dart';
import 'modules/manga/v_manga_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DataController());
  Get.put(ReadMangaController());

  await Future.delayed(const Duration(seconds: 1));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      translations: Language(),
      locale: const Locale('mm', 'MM'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        primarySwatch: MaterialColor(
          AppColors.primary.value,
          const {
            050: Color.fromRGBO(29, 44, 77, .1),
            100: Color.fromRGBO(29, 44, 77, .2),
            200: Color.fromRGBO(29, 44, 77, .3),
            300: Color.fromRGBO(29, 44, 77, .4),
            400: Color.fromRGBO(29, 44, 77, .5),
            500: Color.fromRGBO(29, 44, 77, .6),
            600: Color.fromRGBO(29, 44, 77, .7),
            700: Color.fromRGBO(29, 44, 77, .8),
            800: Color.fromRGBO(29, 44, 77, .9),
            900: Color.fromRGBO(29, 44, 77, 1),
          },
        ),
        useMaterial3: true,
        fontFamily: 'Nunito',
        fontFamilyFallback: const ["Book"],
      ),
      home: HomePage(),
      // home: Container(),
    );
  }
}
