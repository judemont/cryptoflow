import 'package:cryptoflow/models/coin_price.dart';
import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/services/coins_api.dart';
import 'package:cryptoflow/utils.dart';
import 'package:cryptoflow/widgets/coin_icon.dart';
import 'package:cryptoflow/widgets/info_column.dart';
import 'package:cryptoflow/widgets/price_chart.dart';
import 'package:cryptoflow/widgets/time_period_buttons.dart';
import 'package:flutter/material.dart';

class CryptoDetails extends StatefulWidget {
  final String cryptoId;
  const CryptoDetails({super.key, required this.cryptoId});

  @override
  State<CryptoDetails> createState() => _CryptoDetailsState();
}

class _CryptoDetailsState extends State<CryptoDetails> {
  Crypto? crypto;
  List<CoinPrice> priceHistory = [];

  void onTimePeriodSelected(String timePeriod) {
    getPricesHistory(widget.cryptoId, timePeriod).then((value) {
      if (value != null) {
        setState(() {
          priceHistory = value;
        });
      }
    });
  }

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
                        SizedBox(height: isWideScreen ? 200 : 50),
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
                                    child: Column(children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 400,
                                        child: PriceChart(
                                            priceHistory: priceHistory),
                                      ),
                                      TimePeriodButtons(
                                        onTimePeriodSelected:
                                            onTimePeriodSelected,
                                      ),
                                    ]),
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
                                  SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 300,
                                    child:
                                        PriceChart(priceHistory: priceHistory),
                                  ),
                                  TimePeriodButtons(
                                    onTimePeriodSelected: onTimePeriodSelected,
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
