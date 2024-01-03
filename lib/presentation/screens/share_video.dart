import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:videoapp/bloc/video_bloc/video_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_events.dart';
import 'package:videoapp/bloc/video_bloc/video_states.dart';
import 'package:videoapp/presentation/widgets/custom_appbar.dart';
import 'package:videoapp/routes_config/route_constants.dart';

class ShareVideo extends StatefulWidget {
  const ShareVideo({super.key, required this.path});

  final String path;

  @override
  State<ShareVideo> createState() => _ShareVideoState();
}

class _ShareVideoState extends State<ShareVideo> {
  late FlickManager flickManager;
  bool isInitialized = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(
          File(widget.path),
        ),
        autoPlay: false);
    setState(() {
      isInitialized = true;
    });

    BlocProvider.of<VideoBloc>(context).add(InitializeVideoUpload());

    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoBloc, VideoState>(listener: (context, state) {
      if (state is VideoUploadSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Video Uploaded Successfully")));
        while (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
        }
        GoRouter.of(context).pushReplacementNamed(RouteConstants.home);
      } else if (state is VideoUploadFailure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error.toString())));
      }
    }, builder: (context, state) {
      switch (state.runtimeType) {
        case VideoUploading:
          return const PopScope(
              canPop: false,
              child: SafeArea(
                  child: Scaffold(
                appBar: CustomAppBar(),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator()),
                    Text("Uploading Video, Please wait"),
                  ],
                ),
              )));
        default:
          return SafeArea(
              child: Scaffold(
            appBar: const CustomAppBar(),
            body: SingleChildScrollView(
              child: Column(children: [
                isInitialized
                    ? FlickVideoPlayer(flickManager: flickManager)
                    : const CircularProgressIndicator(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 0.5)),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      const Text(
                        "Info",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return "Title cannot be empty";
                        },
                        controller: titleController,
                        decoration: const InputDecoration(
                            hintText: "Title",
                            border: OutlineInputBorder(),
                            fillColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: authorController,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return "Author cannot be empty";
                        },
                        decoration: const InputDecoration(
                            hintText: "Author",
                            border: OutlineInputBorder(),
                            fillColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return "Description cannot be empty";
                        },
                        maxLines: 7,
                        maxLength: 300,
                        decoration: const InputDecoration(
                            hintText: "Description",
                            border: OutlineInputBorder(),
                            fillColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              BlocProvider.of<VideoBloc>(context).add(
                                  UploadVideo(
                                      path: widget.path,
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      author: authorController.text));
                            }
                          },
                          child: const Text("Post"))
                    ]),
                  ),
                )
              ]),
            ),
          ));
      }
    });
  }
}
