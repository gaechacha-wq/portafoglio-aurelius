import 'package:flutter/material.dart';

class AureliusSnackBar {
  static void showSuccess(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF4CAF50),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
        ]),
        backgroundColor: const Color(0xFF1C1C1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFF4CAF50),
            width: 1,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showError(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(
            Icons.error_rounded,
            color: Color(0xFFF44336),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
        ]),
        backgroundColor: const Color(0xFF1C1C1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFF44336),
            width: 1,
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  static void showInfo(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(
            Icons.info_rounded,
            color: Color(0xFFD4AF37),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          )),
        ]),
        backgroundColor: const Color(0xFF1C1C1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFD4AF37),
            width: 1,
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
