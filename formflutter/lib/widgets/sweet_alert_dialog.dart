import 'package:flutter/material.dart';

enum AlertType {
  success,
  error,
  warning,
  info,
}

class SweetAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final AlertType alertType;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final String confirmText;
  final String cancelText;
  final bool showCancelButton;

  const SweetAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.alertType = AlertType.info,
    this.onConfirm,
    this.onCancel,
    this.confirmText = 'OK',
    this.cancelText = 'BATAL',
    this.showCancelButton = true,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    AlertType alertType = AlertType.info,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'OK',
    String cancelText = 'BATAL',
    bool showCancelButton = true,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SweetAlertDialog(
          title: title,
          content: content,
          alertType: alertType,
          onConfirm: onConfirm,
          onCancel: onCancel,
          confirmText: confirmText,
          cancelText: cancelText,
          showCancelButton: showCancelButton,
        );
      },
    );
  }

  @override
  State<SweetAlertDialog> createState() => _SweetAlertDialogState();
}

class _SweetAlertDialogState extends State<SweetAlertDialog> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getIconData() {
    switch (widget.alertType) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  Color _getIconColor() {
    switch (widget.alertType) {
      case AlertType.success:
        return Colors.green;
      case AlertType.error:
        return Colors.red;
      case AlertType.warning:
        return Colors.orange;
      case AlertType.info:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon animasi
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    _getIconData(),
                    color: _getIconColor(),
                    size: 70,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Judul
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Konten
            Text(
              widget.content,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
          ],
        ),
        actions: [
          if (widget.showCancelButton)
            TextButton(
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!();
                }
                Navigator.of(context).pop(false);
              },
              child: Text(widget.cancelText),
            ),
          ElevatedButton(
            onPressed: () {
              if (widget.onConfirm != null) {
                widget.onConfirm!();
              }
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getIconColor(),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(widget.confirmText),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
