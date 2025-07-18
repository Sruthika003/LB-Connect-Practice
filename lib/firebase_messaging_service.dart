import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService{
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async{
    await _requestPermission();
     await _getToken();
     initListeners();
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  Future<void> _requestPermission() async{
     NotificationSettings setting = await _messaging.requestPermission(
       alert: true,
       badge: true,
       sound: true
     );
     print('Permission status: ${setting.authorizationStatus}');
  }

  Future<void> _getToken() async{
    String? token = await _messaging.getToken();
    print("Device Token: $token");
  }
  void initListeners(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      print("Foreground message: ${message.notification?.title}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print("App opened from background: ${message.notification?.title}");
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
    await Firebase.initializeApp();
    print("Background message: ${message.messageId}");
  }
}
