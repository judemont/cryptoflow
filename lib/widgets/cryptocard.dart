import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/utils.dart';
import 'package:cryptoflow/widgets/coin_icon.dart';
import 'package:cryptoflow/widgets/sparklineChart.dart';
import 'package:flutter/material.dart';

class CryptoCard extends StatefulWidget {
  final Crypto crypto;
  final Function()? onTap;
  const CryptoCard({super.key, required this.crypto, this.onTap});

  @override
  State<CryptoCard> createState() => _CryptoCardState();
}

class _CryptoCardState extends State<CryptoCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceChange = widget.crypto.priceChangePercentageDay ?? 0.0;
    final isPositive = priceChange >= 0;

    return InkWell(
        onTap: widget.onTap,
        onHover: (value) {
          setState(() {
            isHovering = value;
          });
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(isHovering ? 0 : 16)),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 25, bottom: 12),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CoinIcon(logoUrl: widget.crypto.logoUrl ?? ""),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.crypto.name ?? "",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.crypto.symbol?.toUpperCase() ?? "",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatPrice(widget.crypto.price, '\$'),
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            "${isPositive ? "+" : ""}${priceChange.toStringAsFixed(2)}%",
                            style: TextStyle(
                              color: isPositive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  const Divider(),
                  SizedBox(height: 5),
                  SparklineChart(data: widget.crypto.sparkline ?? []),
                ]),
              ),
            )));
  }
}
