import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel("flutter_example", "Flutter examples",importance: Importance.high, description: "Push notification using firebase");

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

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

  Future<void> initLocalNotification() async{
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
       android: androidInit
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings);
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }
  Future<void> _getToken() async{
    String? token = await _messaging.getToken();
    print("Device Token: $token");
  }

  void initListeners(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if(notification != null && android != null){
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  importance: Importance.high,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher',
                ),
            ),);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
      print("App opened from background: ${message.notification?.title}");
    });
  }

}
