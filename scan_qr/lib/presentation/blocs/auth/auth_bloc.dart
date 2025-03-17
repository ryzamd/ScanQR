import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_qr/domain/usescases/register_usecase.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_event.dart';
import 'package:scan_qr/presentation/blocs/auth/auth_state.dart';
import 'package:scan_qr/domain/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final RegisterUseCase registerUseCase;

  AuthBloc({
    required this.authRepository,
    required this.registerUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        username: event.username,
        password: event.password,
      );
      emit(LoginSuccess(user));
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final success = await authRepository.register(
        name: event.name,
        phoneNumber: event.phoneNumber,
        gender: event.gender,
        username: event.username,
        password: event.password,
        image: event.image,
        department: event.department,
        position: event.position,
      );
      
      if (success) {
        emit(RegisterSuccess());
      } else {
        emit(AuthError('Registration failed'));
      }
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }
}