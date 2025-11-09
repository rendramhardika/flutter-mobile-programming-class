import 'package:flutter/material.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

class SweetToast {
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    // Hapus toast sebelumnya jika ada
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    // Tentukan warna dan ikon berdasarkan tipe
    final Color backgroundColor;
    final IconData iconData;
    
    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green.shade800;
        iconData = Icons.check_circle;
        break;
      case ToastType.error:
        backgroundColor = Colors.red.shade800;
        iconData = Icons.error;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange.shade800;
        iconData = Icons.warning;
        break;
      case ToastType.info:
        backgroundColor = Colors.blue.shade800;
        iconData = Icons.info;
        break;
    }
    
    // Buat snackbar dengan desain yang lebih menarik
    final snackBar = SnackBar(
      content: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Ikon
            Icon(
              iconData,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 16),
            // Pesan
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onAction,
            )
          : null,
    );
    
    // Tampilkan snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  // Metode khusus untuk notifikasi sukses
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.success,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
  
  // Metode khusus untuk notifikasi error
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.error,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
  
  // Metode khusus untuk notifikasi warning
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.warning,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
  
  // Metode khusus untuk notifikasi info
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onTap,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.info,
      duration: duration,
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
