import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_bloc.dart';
import 'package:videoapp/firebase_options.dart';
import 'package:videoapp/routes_config/router_config.dart';
import 'package:videoapp/utils/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = CustomBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoBloc(),
      child: MaterialApp.router(
        theme: ThemeData.dark(),
        title: "Share Videos",
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouterConfig.getRoutes(),
      ),
    );
  }
}
