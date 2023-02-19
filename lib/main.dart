import 'dart:convert';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
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
  WebViewController controller = WebViewController();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Map<String, String> headers = new Map();
  bool reload = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(defaultTargetPlatform == TargetPlatform.iOS){
      _googleSignIn = GoogleSignIn(clientId: "726203508641-k66lj87p963qnvpv4m7lphm4hhnd54l4.apps.googleusercontent.com");
    }
    // flutter_webview_android_init();
    flutter_webview_init();
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

  flutter_webview_init(){
    print(headers);
    print("initiating");
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://test.anystuff.rent/"))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onNavigationRequest: (NavigationRequest request) {
            if(request.url.endsWith("/flutter-login")){
              _googleSignIn.signIn().then((value){

                value?.authentication.then((value1) async {
                  http.post(Uri.parse("https://test.anystuff.rent/flutter-login"), headers:{"Content-Type":"application/json"}, body: jsonEncode(<String,String>{
                    'accessToken': value1.accessToken!
                  })).then((value) async{
                    var body = jsonDecode(value.body);
                    print(body);
                    if(value.statusCode == 200 && body["Status"] == "Success"){
                      // setState(() {
                      //   headers = {"sid":body["sid"]};
                      // });
                      headers = {"sid":body["sid"]};
                        reload = true;
                        controller.loadRequest(Uri.parse("https://test.anystuff.rent"), headers: {"sid":body["sid"]});
                        reload = false;
                    }
                    else if(value.statusCode == 400 && body["message"] == "Invalid Email"){
                      controller.loadRequest(Uri.parse("https://test.anystuff.rent/register"), headers: {});
                    }
                    else {
                      print(value);
                    }
                  }).catchError((onError){
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

                }).catchError((onError){
                  print(onError);
                });
              }).catchError((onError){
                print(onError);
              });
              return NavigationDecision.prevent;
            }
            else if(headers["sid"] != null){
              print(headers["sid"]);
              if(!reload) {
                print("setting headers");
                reload = true;
                controller.loadRequest(
                    Uri.parse(request.url), headers: headers);
              }
              else{
                reload = false;
              }
            }
            // controller.loadRequest(Uri.parse(request.url), headers: headers);
            return NavigationDecision.navigate;
          }
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      // body: PlatformWebViewWidget(PlatformWebViewWidgetCreationParams(controller: platformController)).build(context),
      body: WebViewWidget(controller: controller), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
