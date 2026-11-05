import 'package:dartz/dartz.dart';
import 'package:medical_center/core/errors/error_mapper.dart';
import 'package:medical_center/core/errors/failure_model.dart';

abstract class BaseRepository {
  Future<Either<Failure, T>> execute<T>(
    Future<T> Function() operation, {
    required String errorMessage,
  }) async {
    try {
      return Right(await operation());
    } on Object catch (error, stackTrace) {
      return Left(
        ErrorMapper.fromException(
          error,
          stackTrace,
          message: errorMessage,
        ),
      );
    }
  }
}
