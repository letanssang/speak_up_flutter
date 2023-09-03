import 'package:json_annotation/json_annotation.dart';

part 'dictionary_search_response.g.dart';

@JsonSerializable()
class DictionarySearchResponse {
  final SearchQuery? query;
  final SearchResults? results;

  DictionarySearchResponse({
    required this.query,
    required this.results,
  });

  factory DictionarySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$DictionarySearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DictionarySearchResponseToJson(this);
}

@JsonSerializable()
class SearchQuery {
  final String? letterPattern;
  final String? limit;
  final String? page;

  SearchQuery({
    required this.letterPattern,
    required this.limit,
    required this.page,
  });

  factory SearchQuery.fromJson(Map<String, dynamic> json) =>
      _$SearchQueryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchQueryToJson(this);
}

@JsonSerializable()
class SearchResults {
  final int? total;
  final List<String>? data;

  SearchResults({
    required this.total,
    required this.data,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) =>
      _$SearchResultsFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultsToJson(this);
}
// {
//    "query":{
//       "letterPattern":"^a.{4}$",
//       "limit":100,
//       "page":1
//    },
//    "results":{
//       "total":805,
//       "data":[
//          "aalst",
//          "aalto",
//          "aarau",
//          "aaron",
//          "abaca",
//          "abaci",
//          "aback",
//          "abaco",
//          ...
//          "addax",
//          "adder"
//       ]
//    }
// }
