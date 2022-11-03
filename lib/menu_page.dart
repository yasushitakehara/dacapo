import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Widget> _scoreList = [];

  @override
  Widget build(BuildContext context) {
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
        title: Text('Da Capo 練習メニュー'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _scoreList.length,
          itemBuilder: (BuildContext context, int index) {
            return _showScoreBox(context, index, 'images/dummy.png');
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _scoreList.add(
                _showScoreBox(context, _scoreList.length, 'images/dummy.png'));
          });
        },
        tooltip: '新しい楽譜を追加する',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _showScoreBox(
      BuildContext context, int index, String imageAssetFilePath) {
    return InkWell(
      onTap: () {
        print(index);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         // （2） 実際に表示するページ(ウィジェット)を指定する
        //         builder: (context) => const PracticePage()));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("削除確認"),
              content: Text("この楽譜データ[$index]を削除しますか？"),
              actions: <Widget>[
                // ボタン領域
                ElevatedButton(
                  child: Text("いいえ"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text("はい"),
                  onPressed: () {
                    setState(() {
                      _scoreList.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
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
