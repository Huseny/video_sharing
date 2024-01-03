import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:videoapp/presentation/screens/homepage.dart';
import 'package:videoapp/presentation/screens/play_video.dart';
import 'package:videoapp/presentation/screens/record_video.dart';
import 'package:videoapp/presentation/screens/share_video.dart';
import 'package:videoapp/presentation/screens/upload_video.dart';
import 'package:videoapp/repository/models/video_model.dart';
import 'package:videoapp/routes_config/route_constants.dart';

class AppRouterConfig {
  static GoRouter getRoutes() {
    GoRouter routes = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
        ),
        GoRoute(
          path: '/home',
          name: RouteConstants.home,
          pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
        ),
        GoRoute(
          path:
              "/play/:id/:videoUrl/:title/:author/:description/:createdAt/:thumbnailUrl",
          name: RouteConstants.play,
          pageBuilder: (context, state) => MaterialPage(
            child: PlayVideo(
                video: VideoModel.fromJson(
                    jsonDecode(jsonEncode(state.pathParameters)))),
          ),
        ),
        GoRoute(
          path: '/upload',
          name: RouteConstants.upload,
          pageBuilder: (context, state) =>
              const MaterialPage(child: UploadVideo()),
        ),
        GoRoute(
          path: "/record",
          name: RouteConstants.record,
          pageBuilder: (context, state) => const MaterialPage(
            child: RecordVideo(),
          ),
        ),
        GoRoute(
            path: "/share/:path",
            name: RouteConstants.share,
            pageBuilder: (context, state) => MaterialPage(
                  child: ShareVideo(
                    path: state.pathParameters["path"]!,
                  ),
                )),
      ],
    );
    return routes;
  }
}
