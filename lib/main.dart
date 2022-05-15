// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, unused_local_variable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // para pedir permições
    final statuses = [
      Permission.storage,
    ].request();
// para ver em tela cheia
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Minha Aplicação'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final pages = PageView(
      controller: _controller,
      children: [
        HomeWidget(),
        PhotosWidget(),
      ],
    );
    return pages;
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTapDown: _onTapDown,
          child: Image.asset(
            'assets\\images\\home1.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

_onTapDown(TapDownDetails details) {
  var x = details.globalPosition.dx;
  var y = details.globalPosition.dy;
  print('${details.localPosition}');

  int dx = (x / 80).floor();
  int dy = ((y - 180) / 100).floor();

  int posicao = dy * 5 + dx;

  print("results: x=$x y=$y $dx $dy $posicao");
  _save(posicao);
}

_save(int posicao) async {
  var appDocDir = await getTemporaryDirectory();
  String savePath = appDocDir.path + "/efeito-$posicao.jpg";
  debugPrint(savePath);
  await Dio().download(
      "https://github.com/christianoleon/magic_tricks/blob/main/assets/images/teste.jpg",
      savePath);
  print("saved!");
  final result = await ImageGallerySaver.saveFile(savePath);
  print(result);
}

class PhotosWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: _openGallery,
          child: Image.asset(
            'assets\\images\\home2.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

void _openGallery() {
  print("abrindo a galeria");
  final intent = AndroidIntent(
    action: 'action_view',
    type: 'image/*',
    flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  intent.launch();
}
