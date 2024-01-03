import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videoapp/presentation/widgets/custom_appbar.dart';
import 'package:videoapp/routes_config/route_constants.dart';
import 'package:videoapp/utils/pick_file.dart';

class UploadVideo extends StatelessWidget {
  const UploadVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Permission.storage.status.then((value) async {
                    if (value != PermissionStatus.granted) {
                      await Permission.storage.request();
                    }
                  });
                  File? localVideo =
                      await PickFiles().pickFile(FileType.video, false);
                  if (localVideo != null) {
                    if (context.mounted) {
                      GoRouter.of(context).pushNamed(RouteConstants.share,
                          pathParameters: {"path": localVideo.path});
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Something went wrong!, Please try again")));
                    }
                  }
                },
                child: const Text('Upload from Storage'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushNamed(RouteConstants.record);
                },
                child: const Text('Take Video Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
