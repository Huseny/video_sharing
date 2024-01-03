import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:videoapp/bloc/video_bloc/video_bloc.dart';
import 'package:videoapp/bloc/video_bloc/video_events.dart';
import 'package:videoapp/bloc/video_bloc/video_states.dart';
import 'package:videoapp/presentation/widgets/custom_shimmer.dart';
import 'package:videoapp/presentation/widgets/video_view.dart';
import 'package:videoapp/repository/models/video_model.dart';
import 'package:videoapp/routes_config/route_constants.dart';

class ShowVideos extends StatefulWidget {
  const ShowVideos({
    super.key,
  });

  @override
  State<ShowVideos> createState() => _ShowVideosState();
}

class _ShowVideosState extends State<ShowVideos> {
  late List<VideoModel>? videos;

  @override
  void initState() {
    BlocProvider.of<VideoBloc>(context).add(LoadVideo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VideoBloc, VideoState>(
      listener: (context, state) {
        if (state is VideoLoadedSuccess) {
          videos = state.props as List<VideoModel>;
        } else if (state is VideoLoadingFailure) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Couldn't load the videos, please try again")));
        } else if (state is VideoInitial) {
          BlocProvider.of<VideoBloc>(context).add(LoadVideo());
        } else if (state is VideoLoading) {
        } else {
          BlocProvider.of<VideoBloc>(context).add(LoadVideo());
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case VideoLoadedSuccess:
            return videos!.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("There are not videos uploaded yet"),
                      ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context)
                                .pushNamed(RouteConstants.upload);
                          },
                          child: const Text("Upload new Video"))
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                    itemCount: videos!.length,
                    itemBuilder: (context, index) {
                      return VideoView(
                        video: videos![index],
                      );
                    },
                  ));
          case VideoLoading:
          case VideoInitial:
            return Expanded(
                child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => const VideoShimmer(),
            ));
          case VideoLoadingFailure:
            return Center(
              child: IconButton(
                  onPressed: () {
                    BlocProvider.of<VideoBloc>(context).add(LoadVideo());
                  },
                  icon: const Icon(Icons.refresh_rounded)),
            );

          default:
            return const VideoShimmer();
        }
      },
    );
  }
}
