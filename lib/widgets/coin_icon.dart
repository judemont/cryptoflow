import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoinIcon extends StatelessWidget {
  final String logoUrl;
  final double size;
  const CoinIcon({super.key, required this.logoUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return logoUrl.toLowerCase().endsWith(".svg")
        ? SvgPicture.network(
            height: size,
            width: size,
            logoUrl,
            placeholderBuilder: (context) {
              return CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              );
            },
          )
        : Image.network(
            height: size,
            width: size,
            logoUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: Theme.of(context).colorScheme.onPrimary,
              );
            },
          );
  }
}
