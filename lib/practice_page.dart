import 'package:flutter/material.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  double _currentSliderValue = 1.0;
  bool _isRecording = false;
  bool _isPlaying = false;

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
        title: Text('DaCapo 練習'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton(
                  child:
                      _isRecording ? Icon(Icons.stop_circle) : Icon(Icons.mic),
                  onPressed: () {
                    setState(() {
                      _isRecording = !_isRecording;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording
                        ? Colors.deepOrangeAccent
                        : Theme.of(context).primaryColor,
                    //onPrimary: Colors.black,
                  ),
                ),
              ),
              const Text('リピート間隔'),
              Expanded(
                child: Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 9.9,
                  divisions: 100,
                  label: _currentSliderValue.toStringAsFixed(1),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
              ),
              const Text('秒後'),
              Container(
                margin: EdgeInsets.all(8),
                child: ElevatedButton(
                  child: _isPlaying
                      ? Icon(Icons.stop_circle)
                      : Icon(Icons.play_circle),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                'images/dummy2.png',
              ),
            ),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
