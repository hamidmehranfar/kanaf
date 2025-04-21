import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../step_widget.dart';
import '/models/post_item.dart';
import '/controllers/size_controller.dart';
import '/res/enums/media_type.dart';
import '../custom_cached_image.dart';
import '../custom_shimmer.dart';

class DisplayMediaSection extends StatefulWidget {
  final List<PostItem> items;
  final double? radius;

  const DisplayMediaSection({
    super.key,
    required this.items,
    this.radius,
  });

  @override
  State<DisplayMediaSection> createState() => _DisplayMediaSectionState();
}

class _DisplayMediaSectionState extends State<DisplayMediaSection> {
  bool isVideoLoading = false;
  bool isVideoCompleted = false;

  bool isStop = false;

  int itemCurrentIndex = 0;

  Map<String, VideoPlayerController?> controllers = {};

  @override
  void initState() {
    super.initState();
    if ((widget.items.isNotEmpty) &&
        widget.items[itemCurrentIndex].itemType == MediaType.video) {
      fetchVideo(itemCurrentIndex);
    }
  }

  Future<void> fetchVideo(int index) async {
    setState(() {
      isVideoLoading = true;
    });

    String url = widget.items[index].file;

    if (controllers[url] == null) {
      isVideoCompleted = false;
      controllers[url] = VideoPlayerController.networkUrl(Uri.parse(url));

      await controllers[url]!.initialize();

      controllers[url]!.addListener(() {
        if (controllers[url]!.value.isCompleted) {
          setState(() {
            isVideoCompleted = true;
            isStop = true;
          });
        }
      });

      controllers[url]!.play();
    }

    setState(() {
      isVideoLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    controllers.forEach((key, value) {
      value?.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        CarouselSlider(
          items: List.generate(
            widget.items.length,
            (int index) {
              return widget.items[index].itemType == MediaType.image
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                          widget.radius != null ? widget.radius! : 0),
                      child: CustomCachedImage(
                        url: widget.items[index].file,
                        fit: BoxFit.cover,
                        height: 360,
                        width: SizeController.width(context),
                      ),
                    )
                  : SizedBox(
                      height: 360,
                      child: Column(
                        children: [
                          if (isVideoLoading) ...[
                            CustomShimmer(
                              child: Container(
                                height: 355,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface,
                                  borderRadius: widget.radius != null
                                      ? BorderRadius.circular(widget.radius!)
                                      : null,
                                ),
                              ),
                            )
                          ] else ...[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  isStop = !isStop;

                                  setState(() {
                                    if (isVideoCompleted) {
                                      isVideoCompleted = false;
                                      controllers[widget.items[index].file]!
                                          .seekTo(
                                        const Duration(seconds: 0),
                                      );
                                    }
                                    if (isStop) {
                                      controllers[widget.items[index].file]!
                                          .pause();
                                    } else {
                                      controllers[widget.items[index].file]!
                                          .play();
                                    }
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 360,
                                        decoration: BoxDecoration(
                                          borderRadius: widget.radius != null
                                              ? BorderRadius.circular(
                                                  widget.radius!)
                                              : null,
                                          color: Colors.grey
                                              .withValues(alpha: 0.3),
                                        ),
                                        width: double.infinity,
                                        child: AspectRatio(
                                          aspectRatio: controllers[
                                                  widget.items[index].file]!
                                              .value
                                              .aspectRatio,
                                          child: VideoPlayer(
                                            controllers[
                                                widget.items[index].file]!,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Icon(
                                        isStop
                                            ? Icons.play_circle
                                            : Icons.pause_circle,
                                        size: 56,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                          ]
                        ],
                      ),
                    );
            },
          ),
          options: CarouselOptions(
            height: 360,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            initialPage: itemCurrentIndex,
            onPageChanged: (index, changeReason) {
              if (widget.items[index].itemType == MediaType.video) {
                fetchVideo(index);
              }
              setState(() {
                itemCurrentIndex = index;
              });
            },
          ),
        ),
        if ((widget.items.length) > 1) ...[
          const SizedBox(height: 8),
          StepWidget(
            width: 37,
            height: 8,
            selectedIndex: itemCurrentIndex,
            length: widget.items.length,
          ),
        ],
      ],
    );
  }
}
