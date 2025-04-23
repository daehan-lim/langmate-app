import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/exceptions/data_exceptions.dart';
import '../dto/vworld_district_dto.dart';
import '../network/dio_clients.dart';

/// Repository interface for location-related operations.
abstract class LocationRepository {
  /// Gets the district name for a geographical location.
  ///
  /// [latitude] The latitude coordinate.
  /// [longitude] The longitude coordinate.
  /// Returns the district name as a string, or null if not found.
  Future<String?> getDistrictByLocation(double latitude, double longitude);
}

/// Implementation of the LocationRepository using Naver and Vworld APIs.
class LocationRepositoryImpl implements LocationRepository {
  /// Dio client for Vworld API requests
  final Dio _vworldClient = buildVworldDio();

  Future<String?> getDistrictByLocation(
    double longitude,
    double latitude,
  ) async {
    final vworldApiKey = dotenv.env['VWORLD_API_KEY'];
    if (vworldApiKey == null) {
      throw EnvFileException('VWORLD_API_KEY가 .env 파일에 설정되지 않았습니다.');
    }
    try {
      final response = await _vworldClient.get(
        '/data',
        queryParameters: {
          'request': 'GetFeature',
          'key': vworldApiKey,
          'data': 'LT_C_ADEMD_INFO',
          'geomFilter': 'POINT($longitude $latitude)',
          'geometry': false,
          'size': 100,
        },
      );
      if (response.statusCode == 200 &&
          response.data['response']['status'] == 'OK') {
        return VworldDistrictDto.fromJson(response.data)
            .response
            ?.result
            ?.featureCollection
            ?.features
            .first
            .properties
            ?.fullNm;
      }
      throw ApiException(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
