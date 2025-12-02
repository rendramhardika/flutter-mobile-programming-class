/// Model untuk item download
/// Menyimpan informasi tentang file yang sedang/akan didownload
class DownloadItem {
  final String id;
  final String fileName;
  final String url;
  final int totalBytes;
  int downloadedBytes;
  DownloadStatus status;
  DateTime? startTime;
  DateTime? endTime;
  String? errorMessage;

  DownloadItem({
    required this.id,
    required this.fileName,
    required this.url,
    required this.totalBytes,
    this.downloadedBytes = 0,
    this.status = DownloadStatus.pending,
    this.startTime,
    this.endTime,
    this.errorMessage,
  });

  /// Progress dalam persen (0-100)
  double get progressPercent {
    if (totalBytes == 0) return 0.0;
    return (downloadedBytes / totalBytes * 100).clamp(0.0, 100.0);
  }

  /// Kecepatan download dalam bytes per detik
  double get downloadSpeed {
    if (startTime == null || downloadedBytes == 0) return 0.0;
    final elapsed = DateTime.now().difference(startTime!).inSeconds;
    if (elapsed == 0) return 0.0;
    return downloadedBytes / elapsed;
  }

  /// Format ukuran file yang mudah dibaca
  String get formattedSize {
    return _formatBytes(totalBytes);
  }

  /// Format bytes yang sudah didownload
  String get formattedDownloaded {
    return _formatBytes(downloadedBytes);
  }

  /// Format kecepatan download
  String get formattedSpeed {
    final speed = downloadSpeed;
    if (speed < 1024) return '${speed.toInt()} B/s';
    if (speed < 1024 * 1024) return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    return '${(speed / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  /// Estimasi waktu tersisa
  String get estimatedTimeRemaining {
    if (status != DownloadStatus.downloading || downloadSpeed == 0) {
      return '--:--';
    }
    
    final remainingBytes = totalBytes - downloadedBytes;
    final remainingSeconds = remainingBytes / downloadSpeed;
    
    if (remainingSeconds < 60) {
      return '${remainingSeconds.toInt()}s';
    } else if (remainingSeconds < 3600) {
      final minutes = remainingSeconds ~/ 60;
      final seconds = remainingSeconds.toInt() % 60;
      return '${minutes}m ${seconds}s';
    } else {
      final hours = remainingSeconds ~/ 3600;
      final minutes = (remainingSeconds % 3600) ~/ 60;
      return '${hours}h ${minutes}m';
    }
  }

  /// Helper untuk format bytes
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Copy dengan perubahan
  DownloadItem copyWith({
    String? id,
    String? fileName,
    String? url,
    int? totalBytes,
    int? downloadedBytes,
    DownloadStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    String? errorMessage,
  }) {
    return DownloadItem(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      url: url ?? this.url,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Convert ke Map untuk komunikasi dengan service
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fileName': fileName,
      'url': url,
      'totalBytes': totalBytes,
      'downloadedBytes': downloadedBytes,
      'status': status.name,
      'startTime': startTime?.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'errorMessage': errorMessage,
    };
  }

  /// Create dari Map
  factory DownloadItem.fromMap(Map<String, dynamic> map) {
    return DownloadItem(
      id: map['id'] as String,
      fileName: map['fileName'] as String,
      url: map['url'] as String,
      totalBytes: map['totalBytes'] as int,
      downloadedBytes: map['downloadedBytes'] as int? ?? 0,
      status: DownloadStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => DownloadStatus.pending,
      ),
      startTime: map['startTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      endTime: map['endTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int)
          : null,
      errorMessage: map['errorMessage'] as String?,
    );
  }

  @override
  String toString() {
    return 'DownloadItem(id: $id, fileName: $fileName, status: $status, progress: ${progressPercent.toStringAsFixed(1)}%)';
  }
}

/// Status download
enum DownloadStatus {
  pending,     // Menunggu antrian
  downloading, // Sedang download
  paused,      // Di-pause
  completed,   // Selesai
  failed,      // Gagal
  cancelled,   // Dibatalkan
}

/// Extension untuk DownloadStatus
extension DownloadStatusExtension on DownloadStatus {
  /// Nama yang mudah dibaca
  String get displayName {
    switch (this) {
      case DownloadStatus.pending:
        return 'Menunggu';
      case DownloadStatus.downloading:
        return 'Downloading';
      case DownloadStatus.paused:
        return 'Dijeda';
      case DownloadStatus.completed:
        return 'Selesai';
      case DownloadStatus.failed:
        return 'Gagal';
      case DownloadStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  /// Warna untuk UI
  int get colorValue {
    switch (this) {
      case DownloadStatus.pending:
        return 0xFF9E9E9E; // Grey
      case DownloadStatus.downloading:
        return 0xFF2196F3; // Blue
      case DownloadStatus.paused:
        return 0xFFFF9800; // Orange
      case DownloadStatus.completed:
        return 0xFF4CAF50; // Green
      case DownloadStatus.failed:
        return 0xFFF44336; // Red
      case DownloadStatus.cancelled:
        return 0xFF607D8B; // Blue Grey
    }
  }

  /// Apakah download sedang aktif
  bool get isActive => this == DownloadStatus.downloading;

  /// Apakah download bisa di-resume
  bool get canResume => this == DownloadStatus.paused || this == DownloadStatus.failed;

  /// Apakah download bisa di-pause
  bool get canPause => this == DownloadStatus.downloading;

  /// Apakah download sudah selesai (berhasil atau gagal)
  bool get isFinished => this == DownloadStatus.completed || 
                        this == DownloadStatus.failed || 
                        this == DownloadStatus.cancelled;
}
