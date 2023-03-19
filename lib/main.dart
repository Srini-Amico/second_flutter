import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as image;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  workmanager_init();
  runApp(const MyApp());
}


workmanager_init(){
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask("anystuff", "order-notification", frequency: Duration(minutes: 15));
}

callbackDispatcher(){
Workmanager().executeTask((taskName, inputData) {
print("callback Dispatcher worked");

FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

// app_icon needs to be a added as a drawable
// resource to the Android head project.
var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
var iOS = const IOSInitializationSettings();

// initialise settings for both Android and iOS device.
var settings = InitializationSettings(android: android, iOS: iOS);
flip.initialize(settings);
_showNotificationWithDefaultSound(flip);
return Future.value(true);
});
}

Future _showNotificationWithDefaultSound(flip) async {

  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'anystuff',
      'rent.anystufff',
      'anystuff.rent',
      importance: Importance.max,
      priority: Priority.high
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics
  );
  print("showing notification");
  await flip.show(0, 'GeeksforGeeks',
      'Your are one step away to connect with GeeksforGeeks',
      platformChannelSpecifics, payload: 'Default_Sound'
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController controller = WebViewController();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  AndroidWebViewController? myAndroidController;
  Map<String, String> headers = Map();
  bool reload = false;
  bool internetFound = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

check_internet();
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _googleSignIn = GoogleSignIn(
          clientId: "726203508641-k66lj87p963qnvpv4m7lphm4hhnd54l4.apps.googleusercontent.com");
    }
    // flutter_webview_android_init();
    flutterWebViewInit();
  }

  check_internet() async{
    var found = await InternetConnectionChecker().hasConnection;
    setState(() {
      internetFound = found;
    });
  }

  // flutter_webview_android_init() {
  //   platformController..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setPlatformNavigationDelegate(AndroidNavigationDelegate(
  //         const PlatformNavigationDelegateCreationParams()
  //     )..setOnProgress((progress) {
  //
  //     })..setOnNavigationRequest((NavigationRequest navigationRequest){
  //       if(navigationRequest.url.endsWith("/flutter-login")){
  //         _googleSignIn.signIn().then((value){
  //
  //           value?.authentication.then((value1) async {
  //             http.post(Uri.parse("https://test.anystuff.rent/flutter-login"), headers:{"Content-Type":"application/json"}, body: jsonEncode(<String,String>{
  //               'accessToken': value1.accessToken!
  //             })).then((value) async{
  //               var body = jsonDecode(value.body);
  //               print(body);
  //               if(value.statusCode == 200 && body["Status"] == "Success"){
  //                 // controller.loadRequest(Uri.parse("https://test.anystuff.rent"), headers: {"sid":body["sid"]});
  //                 platformController.loadRequest(LoadRequestParams(uri: Uri.parse("https://test.anystuff.rent"), headers: {"sid":body["sid"]}));
  //               }
  //               else if(value.statusCode == 400 && body["message"] == "Invalid Email"){
  //                 controller.loadRequest(Uri.parse("https://test.anystuff.rent/register"));
  //               }
  //               else {
  //                 print(value);
  //               }
  //             }).catchError((onError){
  //               print(onError);
  //             });
  //           }).catchError((onError){
  //             print(onError);
  //           });
  //         }).catchError((onError){
  //           print(onError);
  //         });
  //         return NavigationDecision.prevent;
  //       }
  //       return NavigationDecision.navigate;
  //     }))
  //     ..loadRequest(LoadRequestParams(uri: Uri.parse("https://test.anystuff.rent")));
  // }

  flutterWebViewInit() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://test.anystuff.rent/"))
      ..setNavigationDelegate(
          NavigationDelegate(
              onProgress: (int progress) {

              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url == "about:blank") {
                  return NavigationDecision.prevent;
                }
                if (request.url.endsWith("/flutter-login")) {
                  _googleSignIn.signIn().then((value) {
                    value?.authentication.then((value1) async {
                      http.post(Uri.parse(
                          "https://test.anystuff.rent/flutter-login"),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(<String, String>{
                            'accessToken': value1.accessToken!
                          })).then((value) async {
                        var body = jsonDecode(value.body);
                        if (value.statusCode == 200 &&
                            body["Status"] == "Success") {
                          // setState(() {
                          //   headers = {"sid":body["sid"]};
                          // });
                          headers = {"sid": body["sid"]};
                          reload = true;
                          controller.loadRequest(
                              Uri.parse("https://test.anystuff.rent"),
                              headers: {"sid": body["sid"]});
                          reload = false;
                        }
                        else if (value.statusCode == 400 &&
                            body["message"] == "Invalid Email") {
                          controller.loadRequest(
                              Uri.parse("https://test.anystuff.rent/register"),
                              headers: {});
                        }
                        else {
                          print(value);
                        }
                      }).catchError((onError) {
                        print(onError);
                      });

                      // AuthCredential authCredential = GoogleAuthProvider.credential(
                      //   accessToken: value1.accessToken,
                      //   idToken: value1.idToken
                      // );

                      // FirebaseApp firebaseApp = await Firebase.initializeApp(
                      //   options: DefaultFirebaseOptions.currentPlatform,
                      // );
                      // FirebaseAuth auth = FirebaseAuth.instance;
                      // auth.signInWithCredential(authCredential).then((value) async{
                      //   print(value);
                      //   User user = auth.currentUser!;
                      //   print(user);
                      //   String token = await user.getIdToken();
                      //   print(token);
                      //   Map<String, String?> headers = new Map();
                      //   Map<String, String?> body = new Map();
                      //   body["token"] = token;
                      //   http.post(Uri.parse("https://test.anystuff.rent/google-login"), headers:{"Content-Type":"application/json"}, body: jsonEncode(body)).then((value){
                      //     print(value);
                      //   }).catchError((onError){
                      //     print(onError);
                      //   });
                      // }).catchError((onError){
                      //   print(onError);
                      // });

                    }).catchError((onError) {
                      print(onError);
                    });
                  }).catchError((onError) {
                    print(onError);
                  });
                  return NavigationDecision.prevent;
                }
                else if (headers["sid"] != null) {
                  if (!reload) {
                    reload = true;
                    controller.loadRequest(
                        Uri.parse(request.url), headers: headers);
                  }
                  else {
                    reload = false;
                  }
                }
                return NavigationDecision.navigate;
              }
          )
      );

    if (defaultTargetPlatform == TargetPlatform.android) {
      myAndroidController = controller.platform as AndroidWebViewController;
      myAndroidController?.setOnShowFileSelector((params) async {
        // Control and show your picker
        // and return a list of Uris.
        // ImagePicker imagePicker = ImagePicker();
        // var image = await imagePicker.pickImage(source: ImageSource.gallery);
        // var imageString = await image?.readAsString(encoding: base64);
        // print(imageString);
        // Future<List<String>> uriList = Future(() => [imageString!]);
        // Future<List<String>> uriList = Future(() => [image!.path]);
        // String imageString = base64Encode(await image!.readAsBytes());
        // Future<List<String>> uriList = Future(() => [ "data:image/jpeg;base64,$imageString" ]);
        // return uriList; // Uris

        if (params.acceptTypes.any((type) => type == 'image/*')) {
          final picker = ImagePicker();
          final photo = await picker.pickImage(source: ImageSource.gallery);

          if (photo == null) {
            return [];
          }

          final imageData = await photo.readAsBytes();
          final decodedImage = image.decodeImage(imageData)!;
          final scaledImage = image.copyResize(decodedImage, width: 500);
          final jpg = image.encodeJpg(scaledImage, quality: 90);

          final filePath = (await getTemporaryDirectory()).uri.resolve(
            './image_${DateTime
                .now()
                .microsecondsSinceEpoch}.jpg',
          );
          final file = await File.fromUri(filePath).create(recursive: true);
          await file.writeAsBytes(jpg, flush: true);

          return [file.uri.toString()];
        }

        return [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (internetFound) {
      return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(""),
            toolbarHeight: 0,
            backgroundColor: Colors.transparent,
          ),
          // body: PlatformWebViewWidget(PlatformWebViewWidgetCreationParams(controller: platformController)).build(context),
          body: WebViewWidget(
              controller: controller), // This trailing comma makes auto-formatting nicer for build methods.
        ),);
    }
  else{
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anystuff.Rent"),
        backgroundColor: Color(0xFF1D3354),
      ),
      body: Center(
          child: ListView(
            shrinkWrap: true,
              children:<Widget>[const Text("Internet is mandatory to use this application",
      textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25)
      ),
          Container( width: 200, child: TextButton(onPressed: check_internet, child: const Text("Retry", style: TextStyle(fontSize: 18))))]
      ))
    );
  }
}

  Future<bool> _exitApp(BuildContext context) async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
