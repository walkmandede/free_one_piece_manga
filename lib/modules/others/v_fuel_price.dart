
import 'dart:convert';
import 'package:get/get.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:free_one_piece_manga/utils/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

int globalCount = 0;

class FuelPricePage extends StatefulWidget {
  const FuelPricePage({super.key});

  @override
  State<FuelPricePage> createState() => _FuelPricePageState();
}

class _FuelPricePageState extends State<FuelPricePage> {

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  Future<void> initLoad() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    globalCount = sharedPreferences.getInt('localCount')??0;
    setState(() {

    });
  }

  // Future<void> initLoad() async{
  //   var parser = await Chaleno().load('https://www.commerce.gov.mm/my/content/petroleum-price');
  //   if(parser!=null){
  //     // List<Result> results = parser!.getElementsByClassName('comic-thumb-title');
  //     final rawTable = parser!.getElementsByTagName('table')!.first;
  //     final rawTbody = rawTable!.querySelector('tbody')!;
  //     Parser tBodyParser = Parser(rawTbody.innerHTML);
  //     // superPrint(tBodyParser.querySelectorAll('tr'));
  //   }
  //   else{
  //     superPrint('parsing error');
  //   }
  // }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page One'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              globalCount.toString(),
              style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600),
            ),
            20.heightBox(),
            ElevatedButton(
              onPressed: () async{
                globalCount++;
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setInt('localCount', globalCount);
                setState(() {

                });
              },
              child: const Text('Increase Normally'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(()=> PageTwo());
              },
              child: const Text('Next Page'),
            ),

          ],
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({super.key});

  @override
  Widget build(BuildContext context) {

    int count = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Page Two'),
      ),
      body: Center(
        child: Text(
          globalCount.toString(),
          style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

