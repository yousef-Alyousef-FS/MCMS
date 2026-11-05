import 'package:dartz/dartz.dart';
import 'package:medical_center/core/errors/failure_model.dart';

abstract class BaseUseCase<Result, Params> {
  Future<Either<Failure, Result>> call(Params params);
}

final class NoParams {
  const NoParams();
}
