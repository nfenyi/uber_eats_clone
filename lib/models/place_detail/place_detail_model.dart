// To parse this JSON data, do
//
//     final googlePlaceDetailsResponse = googlePlaceDetailsResponseFromJson(jsonString);

import 'dart:convert';

GooglePlaceDetailsResponse googlePlaceDetailsResponseFromJson(String str) =>
    GooglePlaceDetailsResponse.fromJson(json.decode(str));

String googlePlaceDetailsResponseToJson(GooglePlaceDetailsResponse data) =>
    json.encode(data.toJson());

class GooglePlaceDetailsResponse {
  final List<PlaceResult>? results;
  final String? status;

  GooglePlaceDetailsResponse({
    this.results,
    this.status,
  });

  factory GooglePlaceDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GooglePlaceDetailsResponse(
        results: json["results"] == null
            ? []
            : List<PlaceResult>.from(
                json["results"]!.map((x) => PlaceResult.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
      };
}

class PlaceResult {
  final List<AddressComponent>? addressComponents;
  final String? formattedAddress;
  final Geometry? geometry;
  final List<NavigationPoint>? navigationPoints;
  final String? placeId;
  final PlusCode? plusCode;
  final List<String>? types;

  PlaceResult({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.navigationPoints,
    this.placeId,
    this.plusCode,
    this.types,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) => PlaceResult(
        addressComponents: json["address_components"] == null
            ? []
            : List<AddressComponent>.from(json["address_components"]!
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        navigationPoints: json["navigation_points"] == null
            ? []
            : List<NavigationPoint>.from(json["navigation_points"]!
                .map((x) => NavigationPoint.fromJson(x))),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null
            ? []
            : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "navigation_points": navigationPoints == null
            ? []
            : List<dynamic>.from(navigationPoints!.map((x) => x.toJson())),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class AddressComponent {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class Geometry {
  final PlaceLocation? location;
  final String? locationType;
  final Viewport? viewport;

  Geometry({
    this.location,
    this.locationType,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : PlaceLocation.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: json["viewport"] == null
            ? null
            : Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationType,
        "viewport": viewport?.toJson(),
      };
}

class PlaceLocation {
  final double? lat;
  final double? lng;

  PlaceLocation({
    this.lat,
    this.lng,
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) => PlaceLocation(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  final PlaceLocation? northeast;
  final PlaceLocation? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null
            ? null
            : PlaceLocation.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : PlaceLocation.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class NavigationPoint {
  final NavigationPointLocation? location;

  NavigationPoint({
    this.location,
  });

  factory NavigationPoint.fromJson(Map<String, dynamic> json) =>
      NavigationPoint(
        location: json["location"] == null
            ? null
            : NavigationPointLocation.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
      };
}

class NavigationPointLocation {
  final double? latitude;
  final double? longitude;

  NavigationPointLocation({
    this.latitude,
    this.longitude,
  });

  factory NavigationPointLocation.fromJson(Map<String, dynamic> json) =>
      NavigationPointLocation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

class PlusCode {
  final String? compoundCode;
  final String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}
