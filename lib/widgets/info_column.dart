import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/utils.dart';
import 'package:cryptoflow/widgets/coin_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoColumn extends StatelessWidget {
  final Crypto crypto;

  const InfoColumn({super.key, required this.crypto});

  final defaultInfoValueStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoinInfo(
          name: "Price",
          value: Text(
            formatPrice(crypto.price, "\$"),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CoinInfo(
          name: "Market Cap",
          value: Text(
            formatPrice(crypto.marketCap, "\$"),
            style: defaultInfoValueStyle,
          ),
        ),
        CoinInfo(
          name: "Market Cap Rank",
          value: Text(
            crypto.marketCapRank.toString(),
            style: defaultInfoValueStyle,
          ),
        ),
        CoinInfo(
          name: "24H Volume",
          value: Text(
            formatPrice(crypto.volume, "\$"),
            style: defaultInfoValueStyle,
          ),
        ),
        CoinInfo(
          name: "Circulating Supply",
          value: Text(
            formatPrice(crypto.circulatingSupply, crypto.symbol ?? ""),
            style: defaultInfoValueStyle,
          ),
        ),
        CoinInfo(
          name: "Max Supply",
          value: Text(
            formatPrice(crypto.totalSupply, crypto.symbol ?? ""),
            style: defaultInfoValueStyle,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Info:",
          style: const TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        CoinInfo(
          name: "Website",
          value: InkWell(
            onTap: () {
              launchUrl(Uri.parse(crypto.website ?? ""));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(crypto.website ?? ""),
              ),
            ),
          ),
        ),
        CoinInfo(
          name: "Categories",
          value: Wrap(
            spacing: 8,
            children: crypto.categories
                    ?.where((e) =>
                        e != "halal") // This category doesn't make any sense.
                    .map((e) => Chip(label: Text(e)))
                    .toList() ??
                [],
          ),
        ),
        CoinInfo(
          name: "Description",
          value: Text(
            crypto.description ?? "",
          ),
        ),
      ],
    );
  }
}
