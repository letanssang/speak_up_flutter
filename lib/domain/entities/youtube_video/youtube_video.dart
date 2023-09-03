import 'package:json_annotation/json_annotation.dart';

part 'youtube_video.g.dart';

@JsonSerializable()
// white youtube video class get from json below
class YoutubeVideo {
  final int? position;
  final String? title;
  final YoutubeVideoThumbnails? thumbnails;
  final ResourceId? resourceId;
  @JsonKey(name: 'videoOwnerChannelTitle')
  final String? channelTitle;

  YoutubeVideo({
    this.position,
    this.title,
    this.thumbnails,
    this.resourceId,
    this.channelTitle,
  });

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) =>
      _$YoutubeVideoFromJson(json);

  factory YoutubeVideo.initial() => YoutubeVideo(
        position: 0,
        title: '',
        thumbnails: YoutubeVideoThumbnails(),
        resourceId: ResourceId(),
        channelTitle: '',
      );

  Map<String, dynamic> toJson() => _$YoutubeVideoToJson(this);
}

// "snippet": {
// "publishedAt": "2023-08-31T10:05:35Z",
// "channelId": "UCeklYnUXnjKvuHdUMsIu81g",
// "title": "❓ Quick Quiz: 'get on or 'get in'? #shorts",
// "description": "Do you know how to use the English words ‘get on’ and ‘get in’ with transport? Watch the video and then practise by writing an example sentence in the comments 👇👇👇\n\n✔️More Quick Quizzes 👉 https://www.youtube.com/playlist?list=PLcetZ6gSk96-XJN4GMv4fwziyUI1Vb7Uk\n\n🤩🤩🤩 SUBSCRIBE to our YouTube channel for more English videos and podcast English to help you improve your English 👉 https://www.youtube.com/bbclearningenglish\n\nVisit our website 👉 https://www.bbclearningenglish.com\nFollow us on Instagram 👉 https://www.instagram.com/bbclearningenglish\nFollow us on Twitter 👉 https://www.twitter.com/bbcle\nFind us on Facebook 👉 https://www.facebook.com/bbclearningenglish.multimedia\nJoin us on TikTok 👉 https://www.tiktok.com/@bbclearningenglish\n\nGet our app:\nAndroid 👉 https://bit.ly/2PeLcf6  \niPhone 👉 https://apple.co/2wmG2GU \n\nWe like receiving and reading your comments - please use English when you comment 😊\n\n#learnenglish #bbclearningenglish #prepositions #phrasalverbs",
// "thumbnails": {
// "default": {
// "url": "https://i.ytimg.com/vi/V7SPE5yd-vg/default.jpg",
// "width": 120,
// "height": 90
// },
// "medium": {
// "url": "https://i.ytimg.com/vi/V7SPE5yd-vg/mqdefault.jpg",
// "width": 320,
// "height": 180
// },
// "high": {
// "url": "https://i.ytimg.com/vi/V7SPE5yd-vg/hqdefault.jpg",
// "width": 480,
// "height": 360
// },
// "standard": {
// "url": "https://i.ytimg.com/vi/V7SPE5yd-vg/sddefault.jpg",
// "width": 640,
// "height": 480
// },
// "maxres": {
// "url": "https://i.ytimg.com/vi/V7SPE5yd-vg/maxresdefault.jpg",
// "width": 1280,
// "height": 720
// }
// },
// "channelTitle": "Lê Tấn Sang",
// "playlistId": "PLAEavzKq6RQUc8EJHcZZzQP8bsVDE6V4z",
// "position": 0,
// "resourceId": {
// "kind": "youtube#video",
// "videoId": "V7SPE5yd-vg"
// },
// "videoOwnerChannelTitle": "BBC Learning English",
// "videoOwnerChannelId": "UCHaHD477h-FeBbVh9Sh7syA"
// }
@JsonSerializable()
class YoutubeVideoThumbnails {
  @JsonKey(name: 'default')
  final YoutubeVideoThumbnail? defaultThumbnail;
  @JsonKey(name: 'medium')
  final YoutubeVideoThumbnail? mediumThumbnail;
  @JsonKey(name: 'high')
  final YoutubeVideoThumbnail? highThumbnail;
  @JsonKey(name: 'standard')
  final YoutubeVideoThumbnail? standardThumbnail;
  @JsonKey(name: 'maxres')
  final YoutubeVideoThumbnail? maxresThumbnail;

  YoutubeVideoThumbnails({
    this.defaultThumbnail,
    this.mediumThumbnail,
    this.highThumbnail,
    this.standardThumbnail,
    this.maxresThumbnail,
  });

  factory YoutubeVideoThumbnails.fromJson(Map<String, dynamic> json) =>
      _$YoutubeVideoThumbnailsFromJson(json);

  Map<String, dynamic> toJson() => _$YoutubeVideoThumbnailsToJson(this);
}

@JsonSerializable()
class YoutubeVideoThumbnail {
  final String? url;
  final int? width;
  final int? height;

  YoutubeVideoThumbnail({
    this.url,
    this.width,
    this.height,
  });

  factory YoutubeVideoThumbnail.fromJson(Map<String, dynamic> json) =>
      _$YoutubeVideoThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$YoutubeVideoThumbnailToJson(this);
}

@JsonSerializable()
class ResourceId {
  final String? kind;
  final String? videoId;

  ResourceId({
    this.kind,
    this.videoId,
  });

  factory ResourceId.fromJson(Map<String, dynamic> json) =>
      _$ResourceIdFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceIdToJson(this);
}
