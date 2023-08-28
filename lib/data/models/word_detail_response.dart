import 'package:json_annotation/json_annotation.dart';
import 'package:speak_up/domain/entities/word_definition/word_definition.dart';

part 'word_detail_response.g.dart';

@JsonSerializable()
class WordDetailResponse {
  @JsonKey(name: 'results')
  List<WordDefinition>? results;

  //pronunciation
  dynamic pronunciation;

  WordDetailResponse({this.results});

  factory WordDetailResponse.initial() => WordDetailResponse();

  factory WordDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$WordDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WordDetailResponseToJson(this);
}
// {
//    "results":[
//       {
//          "definition":"speech you make to yourself",
//          "partOfSpeech":"noun",
//          "synonyms":[
//             "monologue"
//          ],
//          "typeOf":[
//             "speech",
//             "voice communication",
//             "speech communication",
//             "spoken communication",
//             "spoken language",
//             "language",
//             "oral communication"
//          ],
//          "derivation":[
//             "soliloquize"
//          ]
//       },
//       {
//          "definition":"a (usually long) dramatic speech intended to give the illusion of unspoken reflections",
//          "partOfSpeech":"noun",
//          "typeOf":[
//             "actor's line",
//             "speech",
//             "words"
//          ],
//          "derivation":[
//             "soliloquize"
//          ]
//       }
//    ],
//    "syllables":{
//       "count":4,
//       "list":[
//          "so",
//          "lil",
//          "o",
//          "quy"
//       ]
//    },
//    "pronunciation":{
//       "all":"sə'lɪləkwi"
//    }
// }
