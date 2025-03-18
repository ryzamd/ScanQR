import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/dependency_injection/injection.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_bloc.dart';
import 'package:scan_qr/presentation/blocs/outbound/outbound_bloc.dart';
import 'package:scan_qr/presentation/blocs/process/process_bloc.dart';
import 'package:scan_qr/presentation/blocs/scan/scan_bloc.dart';
import 'package:scan_qr/presentation/routes/app_router.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
        BlocProvider<ScanBloc>(create: (_) => getIt<ScanBloc>()),
        BlocProvider<OutboundBloc>(create: (_) => getIt<OutboundBloc>()),
        BlocProvider<ProcessBloc>(create: (_) => getIt<ProcessBloc>()),
      ],
      child: MaterialApp(
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Brunches-RoughSlanted',
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
