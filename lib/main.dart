import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:locat/service/notifi_service.dart';
import 'package:wakelock/wakelock.dart';

void backgroundFetchHeadlessTask() async {
  // Implement your background task logic here
  // This function will be executed periodically in the background
  print(
      "Hello from background"); // Print "Hello" when the background task is executed
  // Perform background tasks here
  // For example, make API calls, fetch data, etc.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The following line will enable the Android and iOS wakelock.
  Wakelock.enable();

  // Start background fetch
  await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 60, // Execute task every 60 seconds (1 minute)
        stopOnTerminate:
            false, // Continue background task even if app terminated
        enableHeadless:
            true, // Required for executing backgroundFetchHeadlessTask
        startOnBoot: true, // Start background task when device boots up
      ), (String taskId) async {
    // Implement your background task logic here
    // This function will be executed when app is in background or terminated
    print("[BackgroundFetch] Task received: $taskId");
    // Perform background tasks here
    // For example, make API calls, fetch data, etc.
    BackgroundFetch.finish(taskId);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Background Fetch Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Background Fetch Example'),
        ),
        body: Center(
          child: InkWell(
            onTap: () {
              print("sknajb");
              NotificationService()
                  .showNotification(title: 'Sample title', body: 'It works!');
            },
            child: Text(
              'Background Fetch Example',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
