import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Widget> _scoreList = [];

  void _addNewScore() {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    _scoreList = [
      _showScoreBox(context, 'images/dummy.png'),
      _showScoreBox(context, 'images/dummy.png'),
      _showScoreBox(context, 'images/dummy.png'),
      _showScoreBox(context, 'images/dummy.png'),
      _showScoreBox(context, 'images/dummy.png'),
    ];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('DaCapo 練習メニュー'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _scoreList,
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addNewScore,
        tooltip: '新しい楽譜を追加する',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _showScoreBox(BuildContext context, String imageAssetFilePath) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         // （2） 実際に表示するページ(ウィジェット)を指定する
        //         builder: (context) => const PracticePage()));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Image.asset(
            imageAssetFilePath,
          ),
        ),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
