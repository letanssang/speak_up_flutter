import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/youtube_video/youtube_video.dart';

part 'youtube_playlist_response.g.dart';

@JsonSerializable()
class YoutubePlaylistResponse {
  List<YoutubeItemResponse>? items;

  YoutubePlaylistResponse({this.items});

  factory YoutubePlaylistResponse.fromJson(Map<String, dynamic> json) =>
      _$YoutubePlaylistResponseFromJson(json);

  Map<String, dynamic> toJson() => _$YoutubePlaylistResponseToJson(this);
}

@JsonSerializable()
class YoutubeItemResponse {
  YoutubeVideo? snippet;

  YoutubeItemResponse({this.snippet});

  factory YoutubeItemResponse.fromJson(Map<String, dynamic> json) =>
      _$YoutubeItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$YoutubeItemResponseToJson(this);
}
