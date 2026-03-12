import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Un widget di base per creare l'effetto "Skeleton Loading" premium,
/// utile da mostrare mentre si aspetta la risposta da Firebase o l'API.
class BaseSkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const BaseSkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // I colori sono pensati per un tema scuro (Dark Theme)
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.15),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
