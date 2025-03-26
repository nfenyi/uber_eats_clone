import 'package:freezed_annotation/freezed_annotation.dart';

part 'browse_video_model.freezed.dart';
part 'browse_video_model.g.dart';

@freezed
class BrowseVideo with _$BrowseVideo {
  const factory BrowseVideo(
      {required String id,
      required Object productRef,
      required Object storeRef,
      required String videoUrl}) = _BrowseVideo;

  factory BrowseVideo.fromJson(Map<String, Object?> json) =>
      _$BrowseVideoFromJson(json);
}
