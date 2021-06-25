import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_cidscan/flutter_cidscan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var barcode_decoded = 'Barcode';

  @override
  void initState() {
    super.initState();
  }

  void handleInit(Map event) async {
    if (event["body"]["FunctionName"].compareTo('initCaptureID') == 0) {
    }
  }

  void handleLicenseEvent(Map event) async {
    if(event["body"]["FunctionName"].compareTo('onActivationResult') == 0) {
      String value = await FlutterCidscan.decoderVersion();
      print(value);
    }
  }

  Future<void> activateLic() async {
    FlutterCidscan.activateEDKLicense(
        'Ht1DKzM77Kz1lkNHYbtoRAyvx2XVNiHCsT6JRT3hlKoY9IeG5B8TXfftdTG6p+/ynMzm05xvZtdc1OYhC4VGf4S5c2lMILb/lRZIL36xKhAoifeyENSAtFg/NZZTNAdXeETxVEhn9q1VLbRWNqwpxdKY1uwD9MqnZtL1cCoWk6oUD970k4t8nVDjqBNCOlsEc9UP5tG3tbxLkFQjHZueDpVMiDheybFuiFXMJTetAUawoDYvUos0u+jphzmGhhh6d1YWHvPoJS2yeyAhCi8X0wvJkZgBBMgag2EYabxeLlm/X5D5v9AxGXkAq9UaDAxHwMR5o0z6m1SPzO4pXKqeJASRRAGwltPsDH1pFqX0XsUjy/mytjV8B4l7nMYNigMztouH5pCa1abMjW7aauoGeg==',
        //'abcdefgsgsgs',
        'P4I082220190001').listen((event) => { handleLicenseEvent(event) });
  }


  void startScanner() {
    FlutterCidscan.enableAllDecoders(true);
    FlutterCidscan.startCameraPreview();
    FlutterCidscan.startDecoding().listen((event) => { handleDecode(event) });
  }

  void restartScanner() {
    FlutterCidscan.startCameraPreview();
    FlutterCidscan.startDecoding().listen((event) => { handleDecode(event) });
  }

  void handleDecode(Map event) {
    print(event);
    if(event["body"]["FunctionName"].compareTo('receivedDecodedData') == 0) {
      setState(() {
        barcode_decoded = event["body"]["stringValue"];
      });
      FlutterCidscan.stopDecoding();
      FlutterCidscan.stopCameraPreview();
    }
  }

  Future<void> init() async {
    FlutterCidscan.initCaptureID('Wir benötigen die Kamera Berechtigung zum Scannen der Barcodes', false, true).listen((event) => { handleInit(event) });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Stack(
                children: <Widget>[
                  Column(
                      children: <Widget>[
                        Row(
                          children: <Widget> [FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            onPressed: () {init();},
                            child: Text(
                              "Initialize",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          )],
                        ),
                        Row(
                            children: <Widget> [FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {activateLic();},
                              child: Text(
                                "Activate",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            )]
                        ),
                        Row(
                            children: <Widget> [FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(8.0),
                              splashColor: Colors.blueAccent,
                              onPressed: () {startScanner();},
                              child: Text(
                                "Start Scanner",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            )]
                        ),
                        Text(barcode_decoded)
                      ]
                  )
                ]
            )
        ),
      ),
    );
  }
}