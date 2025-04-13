import 'package:cryptoflow/models/coin_price.dart';
import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/services/coins_api.dart';
import 'package:cryptoflow/utils.dart';
import 'package:cryptoflow/widgets/coin_icon.dart';
import 'package:cryptoflow/widgets/coin_info.dart';
import 'package:cryptoflow/widgets/price_chart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CryptoDetails extends StatefulWidget {
  final String cryptoId;
  const CryptoDetails({super.key, required this.cryptoId});

  @override
  State<CryptoDetails> createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {
  Crypto? crypto;
  List<CoinPrice> priceHistory = [];

  final timePeriods = [
    "1h",
    "3h",
    "12",
    "24h",
    "7d",
    "30d",
    "3m",
    "1y",
    "3y",
    "5y",
  ];
  final defaultTimePeriod = "7d";

  @override
  void initState() {
    super.initState();
    getCoinData(widget.cryptoId).then((value) {
      if (value != null) {
        setState(() {
          crypto = value;
        });
      }
    });
    getPricesHistory(widget.cryptoId, defaultTimePeriod).then((value) {
      if (value != null) {
        setState(() {
          priceHistory = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crypto View"),
      ),
      body: crypto == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 1500;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CoinIcon(
                              logoUrl: crypto?.logoUrl ?? "",
                              size: 70,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              crypto?.name ?? "",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              crypto?.symbol?.toUpperCase() ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isWideScreen ? 200 : 30),
                        isWideScreen
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: InfoColumn(crypto: crypto!),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      width: double.infinity,
                                      height: 400,
                                      child: PriceChart(
                                          priceHistory: priceHistory),
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    formatPrice(crypto?.price, "\$"),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 400,
                                    child:
                                        PriceChart(priceHistory: priceHistory),
                                  ),
                                  const SizedBox(height: 20),
                                  InfoColumn(crypto: crypto!),
                                ],
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

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
                        e != "halal") // This category don't make any sense.
                    .map((e) => Chip(label: Text(e)))
                    .toList() ??
                [],
          ),
        ),
      ],
    );
  }
}
