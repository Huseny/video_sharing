import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:videoapp/presentation/widgets/custom_appbar.dart';
import 'package:videoapp/routes_config/route_constants.dart';

class RecordVideo extends StatefulWidget {
  const RecordVideo({super.key});

  @override
  State<RecordVideo> createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late VideoPlayerController _videoPlayerController;
  bool isRecording = false;
  bool isPaused = false;
  bool isStopped = false;
  FlickManager? flickManager;
  late XFile videoFile;
  CameraLensDirection _lensDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      CameraDescription(
        name: "0",
        lensDirection: _lensDirection,
        sensorOrientation: 1,
      ),
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: const CustomAppBar(),
            body: Column(children: [
              FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  return Column(children: [
                    isStopped
                        ? FlickVideoPlayer(
                            flickManager: flickManager!,
                          )
                        : snapshot.connectionState == ConnectionState.done
                            ? CameraPreview(_controller)
                            : const Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 10,
                    ),
                    !isStopped
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (_controller.value.isInitialized) {
                                    if (isRecording) {
                                      await _controller.pauseVideoRecording();
                                      setState(() {
                                        isRecording = false;
                                        isPaused = true;
                                      });
                                    } else if (isPaused) {
                                      await _controller.resumeVideoRecording();
                                      setState(() {
                                        isRecording = true;
                                        isPaused = false;
                                      });
                                    } else {
                                      await _controller.startVideoRecording();
                                      setState(() {
                                        isRecording = true;
                                        isPaused = false;
                                      });
                                    }
                                  }
                                },
                                child: Icon(isRecording
                                    ? Icons.pause
                                    : Icons.play_arrow),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_controller.value.isRecordingVideo) {
                                    videoFile =
                                        await _controller.stopVideoRecording();
                                    File file = File(videoFile.path);
                                    _videoPlayerController =
                                        VideoPlayerController.file(file);
                                    flickManager = FlickManager(
                                      autoPlay: false,
                                        videoPlayerController:
                                            _videoPlayerController);
                                    setState(() {
                                      isRecording = false;
                                      isPaused = false;
                                      isStopped = true;
                                    });
                                  }
                                },
                                child: const Icon(Icons.stop),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _lensDirection = _lensDirection ==
                                              CameraLensDirection.back
                                          ? CameraLensDirection.front
                                          : CameraLensDirection.back;
                                    });
                                  },
                                  child: const Icon(Icons.change_circle))
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      GoRouter.of(context).pushNamed(
                                          RouteConstants.share,
                                          pathParameters: {
                                            "path": videoFile.path
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text(
                                      "Post",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                  ]);
                },
              )
            ])));
  }
}
