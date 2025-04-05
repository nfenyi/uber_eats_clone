import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_video_model.freezed.dart';
part 'explore_video_model.g.dart';

@freezed
class ExploreVideo with _$ExploreVideo {
  const factory ExploreVideo(
      {required String id,
      required Object productRef,
      required Object storeRef,
      required String videoUrl}) = _ExploreVideo;

  factory ExploreVideo.fromJson(Map<String, Object?> json) =>
      _$ExploreVideoFromJson(json);
}
