import 'dart:convert';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';
import 'package:pat_asl_portal/data/model/dto/class_dto.dart';
import 'base_repository.dart';

class ClassRepository {
  final BaseRepository _baseRepository;

  ClassRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  /// Fetches all assigned classes from the API
  ///
  /// Returns a list of ClassDTO objects
  /// Throws [ApiException] if the request fails
  Future<List<ClassDTO>> fetchAllAssignedClass() async {
    try {
      final response = await _baseRepository.get(EndpointCollection.allClassesEndpoint);

      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch classes' : 'Failed to fetch classes',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map((json) => ClassDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes: ${e.toString()}', 500);
    }
  }
}