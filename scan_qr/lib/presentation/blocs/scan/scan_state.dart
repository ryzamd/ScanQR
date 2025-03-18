abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanActive extends ScanState {
  final List<List<String>> scannedData;
  final bool cameraActive;

  ScanActive({required this.scannedData, required this.cameraActive});

  ScanActive copyWith({List<List<String>>? scannedData, bool? cameraActive}) {
    return ScanActive(
      scannedData: scannedData ?? this.scannedData,
      cameraActive: cameraActive ?? this.cameraActive,
    );
  }
}

class ScanSaving extends ScanState {
  final List<List<String>> scannedData;
  final bool cameraActive;

  ScanSaving({required this.scannedData, required this.cameraActive});
}

class ScanSaveSuccess extends ScanState {
  final String filePath;
  final bool cameraActive;

  ScanSaveSuccess({required this.filePath, required this.cameraActive});
}

class ScanError extends ScanState {
  final String message;
  final List<List<String>> scannedData;
  final bool cameraActive;

  ScanError({
    required this.message,
    required this.scannedData,
    required this.cameraActive,
  });
}
