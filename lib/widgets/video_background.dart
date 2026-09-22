import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

/// Full-bleed, looping, muted background video for the hero — registers a
/// real HTML <video> element via platform views so the browser handles
/// playback natively (autoplay/loop/cover), rather than routing through a
/// Flutter video codec. Web-only by design: this project has no other
/// build target.
class VideoBackground extends StatefulWidget {
  final String videoUrl;

  const VideoBackground({super.key, required this.videoUrl});

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'hero-bg-video-${identityHashCode(this)}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final video = web.HTMLVideoElement()
        ..src = widget.videoUrl
        ..autoplay = true
        ..loop = true
        ..muted = true
        ..setAttribute('playsinline', 'true')
        ..setAttribute('disablePictureInPicture', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.border = 'none';
      video.play().toDart.catchError((_) => null);
      return video;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: HtmlElementView(viewType: _viewType));
  }
}
