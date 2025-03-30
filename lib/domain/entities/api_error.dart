enum ErrorType { api, network, unknown }

class AppError {
  final ErrorType type;
  final String message;

  const AppError({required this.type, required this.message});
}
