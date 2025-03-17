import 'package:get_it/get_it.dart';
import 'package:scan_qr/data/datasources/local/barcode_scanner_source.dart';
import 'package:scan_qr/data/datasources/local/scan_data_local_source.dart';
import 'package:scan_qr/data/repositories/auth_repository_impl.dart';
import 'package:scan_qr/data/repositories/outbound_repository_impl.dart';
import 'package:scan_qr/data/repositories/scan_repository_impl.dart';
import 'package:scan_qr/domain/repositories/auth_repository.dart';
import 'package:scan_qr/domain/repositories/outbound_repository.dart';
import 'package:scan_qr/domain/repositories/scan_repository.dart';
import 'package:scan_qr/domain/usescases/get_outbound_records_usecase.dart';
import 'package:scan_qr/domain/usescases/register_usecase.dart';
import 'package:scan_qr/domain/usescases/save_scan_data_usecase.dart';
import 'package:scan_qr/domain/usescases/scan_barcode_usecase.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_bloc.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_bloc.dart';
import 'package:scan_qr/presentation/blocs/process/process_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';

final getIt = GetIt.instance;

void setupDependencies() {

  getIt.registerLazySingleton<ScanDataLocalSource>(() => ScanDataLocalSource());
  getIt.registerLazySingleton<BarcodeScannerSource>(() => BarcodeScannerSource());


  getIt.registerLazySingleton<ScanRepository>(
    () => ScanRepositoryImpl(getIt<ScanDataLocalSource>())
  );
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<OutboundRepository>(() => OutboundRepositoryImpl());


  getIt.registerLazySingleton(() => SaveScanDataUseCase(getIt<ScanRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetOutboundRecordsUseCase(getIt<OutboundRepository>()));
  getIt.registerLazySingleton(() => ScanBarcodeUseCase());


  getIt.registerFactory(() => AuthBloc(
    authRepository: getIt<AuthRepository>(),
    registerUseCase: getIt<RegisterUseCase>(),
  ));
  
  getIt.registerFactory(() => ScanBloc(
    saveScanDataUseCase: getIt<SaveScanDataUseCase>(),
  ));
  
  getIt.registerFactory(() => OutboundBloc(
    getOutboundRecordsUseCase: getIt<GetOutboundRecordsUseCase>(),
  ));
  
  getIt.registerFactory(() => ProcessBloc());
}