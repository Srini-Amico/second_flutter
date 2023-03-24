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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
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
  late final FirebaseMessaging _messaging;
  var fcmToken = "";
  WebViewController controller = WebViewController();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  AndroidWebViewController? myAndroidController;
  Map<String, String> headers = Map();
  bool reload = false;
  bool internetFound = false;
  bool fcmSent = false;

  void registrationNotification() async {
    try {
      await Firebase.initializeApp();
      _messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await _messaging.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("User granted permission");
        fcmToken = await _messaging.getToken() ?? "";
        print("fcmToken: ${fcmToken}");
      } else {
        print("User declined notification permission");
        fcmToken = "";
      }

      FirebaseMessaging.onMessage.listen((event) {
        final String message = event.notification?.body ?? "";
        var snackBar = SnackBar(
          content: Text(message),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    }
    catch (ex){
      print("firebase not initialized");
      print(ex);
      fcmToken = "";
    }
  }

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
    print("Handling a background message. ${message}");
  }

  @override
  void initState() {
    // TODO: implement initState

    registrationNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event);
    });

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

  flutterWebViewInit() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://test.anystuff.rent"))
      ..setNavigationDelegate(
          NavigationDelegate(
              onProgress: (int progress) {

              },
              onNavigationRequest: (NavigationRequest request) async {
                String? previousUrl = "";
                await controller.currentUrl().then((value) {
                  previousUrl = value;
                });
                if(previousUrl == request.url){
                  controller.reload();
                  return NavigationDecision.prevent;
                }
                else if (request.url == "about:blank") {
                  return NavigationDecision.prevent;
                }
                else if (request.url.endsWith("/flutter-login")) {
                  _googleSignIn.signIn().then((value) {
                    value?.authentication.then((value1) async {
                      http.post(Uri.parse(
                          "https://test.anystuff.rent/flutter-login"),
                          headers: {"Content-Type": "application/json"},
                          body: jsonEncode(<String, String>{
                            'accessToken': value1.accessToken!,
                            'fcmToken': fcmToken
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
                if(request.url.contains("userid"))
                {
                  final Uri uri = Uri.parse(request.url);
                  final userid = uri.queryParameters["userid"];
                  http.put(Uri.parse("https://test.anystuff.rent/api/users/update/${userid}"),
                      headers: {"Content-Type": "application/json"},
                      body: jsonEncode(<String, String>{
                        'fcmToken': fcmToken
                      })).then((value){
                        print("fcmtoken updated");
                      }).catchError((onError) {
                        print("fcmtoken not updated");
                      });
                }
                return NavigationDecision.navigate;
              }
          )
      );

    if (defaultTargetPlatform == TargetPlatform.android) {
      myAndroidController = controller.platform as AndroidWebViewController;
      myAndroidController?.setOnShowFileSelector((params) async {
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
