import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_eats_clone/models/google_location/google_location_model.dart';
import 'package:uber_eats_clone/models/place_detail/place_detail_model.dart';

import '../../utils/result.dart';

class GoogleMapsServices {
  const GoogleMapsServices._();
  static final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    contentType: "application/json",
  ));
  //TODO: Remove and put in .env file
  static const _apiKey = "AIzaSyD0RD3-1CW7alhs03RMBLPhv8TdiwDKeyQ";
  static Future<Result<List<Prediction>?>> fetchPredictions({
    required String query,
    required LocationData? location,
  }) async {
    try {
      late final Response response;
      late final PredictionsResponse modelledResponse;

      if (location == null) {
        response = await _dio.get(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json",
            queryParameters: {'input': query, 'key': _apiKey});
      } else {
        response = await _dio.get(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json",
            queryParameters: {
              'input': query,
              'location': '${location.latitude}${location.longitude}',
              'radius': 500,
              'key': _apiKey
            });
      }
      // logger.d(location?.latitude);
      modelledResponse = PredictionsResponse.fromJson(response.data);

      return Result.ok(modelledResponse.predictions);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Result.error(
          'Connection timed out. Reason: Weak Connection or No Data. Try submitting again.',
        );
      }
      return Result.error('${e.message}\n${e.response}');
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<List<PlaceResult>?>> fetchDetailsFromPlaceID({
    required String id,
  }) async {
    try {
      late final Response response;
      late final GooglePlaceDetailsResponse modelledResponse;

      response = await _dio.get(
          "https://maps.googleapis.com/maps/api/geocode/json",
          queryParameters: {'place_id': id, 'key': _apiKey});

      modelledResponse = GooglePlaceDetailsResponse.fromJson(response.data);

      return Result.ok(modelledResponse.results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Result.error(
          'Connection timed out. Reason: Weak Connection or No Data. Try submitting again.',
        );
      }
      return Result.error('${e.message}\n${e.response}');
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  static Future<Result<List<PlaceResult>?>> fetchDetailsFromLatlng({
    required LatLng latlng,
  }) async {
    try {
      late final Response response;
      late final GooglePlaceDetailsResponse modelledResponse;

      response = await _dio.get(
          "https://maps.googleapis.com/maps/api/geocode/json",
          queryParameters: {
            'latlng': '${latlng.latitude},${latlng.longitude}',
            'key': _apiKey
          });

      modelledResponse = GooglePlaceDetailsResponse.fromJson(response.data);

      return Result.ok(modelledResponse.results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Result.error(
          'Connection timed out. Reason: Weak Connection or No Data. Try submitting again.',
        );
      }
      return Result.error('${e.message}\n${e.response}');
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
