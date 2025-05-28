
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp.dart';
import '../../features/auth/domain/usecases/login_with_otp.dart';
import '../../features/auth/domain/usecases/login_with_pin.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/mqtt/mqtt_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      sendOtpUseCase: sl(),
      loginWithOtpUseCase: sl(),
      loginWithPinUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => LoginWithOtp(sl()));
  sl.registerLazySingleton(() => LoginWithPin(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      mqttService: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton(() => MqttService());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
