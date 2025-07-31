import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uber_eats_clone/presentation/services/google_location_model.dart';
import 'package:uber_eats_clone/presentation/services/place_detail_model.dart';
import 'package:uber_eats_clone/presentation/services/service_model.dart';

import '../../env/env.dart';

class GoogleMapsServices {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    contentType: "application/json",
  ));
  final _apiKey = Env.mapsApiKey;
  Future<ServiceResponse> fetchPredictions({
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

      return ServiceResponse(
          response: Result.success, payload: modelledResponse.predictions);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return ServiceResponse(
          response: Result.failure,
          payload:
              'Connection timed out. Reason: Weak Connection or No Data. Try submitting again.',
        );
      }
      return ServiceResponse(
          response: Result.failure, payload: '${e.message}\n${e.response}');
    } catch (e) {
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }

  Future<ServiceResponse> fetchDetailsFromPlaceID({
    required String id,
  }) async {
    try {
      late final Response response;
      late final GooglePlaceDetailsResponse modelledResponse;

      response = await _dio.get(
          "https://maps.googleapis.com/maps/api/geocode/json",
          queryParameters: {'place_id': id, 'key': _apiKey});

      modelledResponse = GooglePlaceDetailsResponse.fromJson(response.data);

      return ServiceResponse(
          response: Result.success, payload: modelledResponse.results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return ServiceResponse(
          response: Result.failure,
          payload:
              'Connection timed out. Reason: Weak Connection or No Data. Try submitting again.',
        );
      }
      return ServiceResponse(
          response: Result.failure, payload: '${e.message}\n${e.response}');
    } catch (e) {
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }

  Future<ServiceResponse> fetchDetailsFromLatlng({
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

      return ServiceResponse(
          response: Result.success, payload: modelledResponse.results);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return ServiceResponse(
          response: Result.failure,
          payload:
              'Connection timed out. Reason: Weak Connection or No Data. Try submitting again.',
        );
      }
      return ServiceResponse(
          response: Result.failure, payload: '${e.message}\n${e.response}');
    } catch (e) {
      return ServiceResponse(response: Result.failure, payload: e.toString());
    }
  }
}
