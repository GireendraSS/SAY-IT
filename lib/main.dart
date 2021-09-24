import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'shareservice.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'saved.dart';
import 'dart:io';
import 'api.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'only speak',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _launchEmail() async {
    launch(
        "mailto:muskanludhiyani@gmail.com?subject=Issue regarding OnlySpeak&body=I have been facing an issue.");
  }

    String display="";

  int selected_tone = 0;
  Color a = Colors.purple;
  Color b = Colors.blue;
  Color c = Colors.purple;
  Color d = Colors.blue;
  Color e = Colors.black;
  Color f = Colors.black;
  double _val = 1;
  double currval = 1;
  double currval2 = 1;
  double _pitch = 1;
  String _text = '';
  bool _loading = false;

  Future getval() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _val = prefs.getDouble('_val') ?? 1;
      _pitch = prefs.getDouble('_pitch') ?? 1;
      currval = _val;
      currval2 = _pitch;
    });
  }

  Future saveval() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('_val', _val);
      prefs.setDouble('_pitch', _pitch);
    });
  }

  Future speak(String s) async {

    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(_pitch);
    await flutterTts.setSpeechRate(_val);
    await flutterTts.speak(s);
  }

  showOverlay(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
        builder: (context) =>
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/back.jpeg"),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "OnlySpeak",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'racing',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    overlayEntry?.remove();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 45,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GestureDetector(
                              onTap: _launchEmail,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("Report an Issue",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Share this app",
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      color: Colors.white,
                                      fontSize: 20,
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                            child: GestureDetector(
                              onTap: () {
                                launch(
                                    "https://www.driffnotes.com/onlyspeak"
                                        "-about/");
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("About",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        color: Colors.white,
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ));

    overlayState?.insert(overlayEntry);
  }

  String _sharedText = "";

  @override
  void initState() {
    super.initState();
    getval();
    ShareService()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);
    setState(() {
      display=_sharedText;
    });

  }

  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
      display=sharedData;
      speak(_sharedText);
      _sharedText = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "OnlySpeak",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'racing',
                              fontStyle: FontStyle.italic,
                              fontSize: 45,
                            ),
                          ),
                          GestureDetector(
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.black,
                                size: 45,
                              ),
                              onTap: () {
                                showOverlay(context);
                              })
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        display
                        , style: TextStyle(
                        fontSize: 15,
                        fontFamily: "poppins",
                        fontWeight: FontWeight.bold,
                        color: a,
                      ),
                      ),

                    ),

                    Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Speed",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: "poppins",
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Icon(Icons.replay),
                                    onTap: () {
                                      setState(() {
                                        currval = 1;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.black,
                                inactiveTrackColor: Colors.black,
                                trackShape: RectangularSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbColor: Colors.white,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                              ),
                              child: Container(
                                child: Slider(
                                    value: currval.toDouble(),
                                    min: 0.0,
                                    max: 3.0,
                                    divisions: 30,
                                    label:
                                    double.parse((currval).toStringAsFixed(2))
                                        .toString(),
                                    onChanged: (double newValue) {
                                      setState(() {
                                        currval = newValue;
                                      });
                                    },
                                    semanticFormatterCallback: (double newValue) {
                                      return '${newValue.round()} dollars';
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pitch",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: "poppins",
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Icon(Icons.replay),
                                    onTap: () {
                                      setState(() {
                                        currval2 = 1;
                                        print(currval);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.black,
                                inactiveTrackColor: Colors.black,
                                trackShape: RectangularSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbColor: Colors.white,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                              ),
                              child: Container(
                                child: Slider(
                                    value: currval2.toDouble(),
                                    min: 0.5,
                                    max: 2.0,
                                    divisions: 15,
                                    label: double.parse((currval2).toStringAsFixed(
                                        2))
                                        .toString(),
                                    onChanged: (double newValue) {
                                      setState(() {
                                        currval2 = newValue;
                                      });
                                    },
                                    semanticFormatterCallback: (double newValue) {
                                      return '${newValue.round()} dollars';
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(60, 30, 60, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(

                                child: Icon(
                                  Icons.image,
                                ),
                                onTap: () {

                                  pickImage();
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.volume_up,
                                  size: 40,
                                ),
                                onTap: () {
                                  speak(
                                      'OnlySpeak Text To Speech is a mobile app that allows people with ADHD, dyslexia, vision problems, concussions, and other reading difficulties to have any text read out to them using a computer generated text to speech voice.');
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _val = currval;
                                    _pitch = currval2;
                                    print(_pitch);
                                    print(_val);
                                    saveval();
                                  });
                                },
                                child: Text(
                                  "Set",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: "racing",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(
                                context, MaterialPageRoute(
                                 builder: (context) =>
                            saved()));
                          },
                            child: Icon(Icons.games_outlined)),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    )
                  ]),
            )));
  }

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    setImage(File(file.path));
  }

  Future scanText(File image) async {
    final text = await FirebaseMLApi.recogniseText(image);
    setState(() {
      _text = text;
      _loading = false;
    });
    if (_text != null) {
      display=_text;
      speak(_text );
      print(_text);
    }
  }

  void setImage(File newImage) {
    setState(() {
      File image = newImage;
      scanText(image);
    });
  }
}

