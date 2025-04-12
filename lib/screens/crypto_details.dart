import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/services/coins_api.dart';
import 'package:cryptoflow/utils.dart';
import 'package:cryptoflow/widgets/coin_icon.dart';
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

  @override
  void initState() {
    getCoinData(widget.cryptoId).then((value) {
      if (value != null) {
        setState(() {
          crypto = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const defaultInfoValueStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Crypto view"),
      ),
      body: crypto == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoinIcon(
                      logoUrl: crypto?.logoUrl ?? "",
                      size: 70,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      crypto?.name ?? "",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      crypto?.symbol?.toUpperCase() ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CoinInfo(
                            name: "Price",
                            value: Text(
                              formatPrice(crypto?.price, "\$"),
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          CoinInfo(
                            name: "Market Cap",
                            value: Text(formatPrice(crypto?.marketCap, "\$"),
                                style: defaultInfoValueStyle),
                          ),
                          CoinInfo(
                            name: "Market Cap Rank",
                            value: Text(
                              crypto?.marketCapRank.toString() ?? "",
                              style: defaultInfoValueStyle,
                            ),
                          ),
                          CoinInfo(
                            name: "24H Volume",
                            value: Text(
                              formatPrice(crypto?.volume, "\$"),
                              style: defaultInfoValueStyle,
                            ),
                          ),
                          CoinInfo(
                            name: "Circulating Supply",
                            value: Text(
                              formatPrice(crypto?.circulatingSupply,
                                  crypto?.symbol ?? ""),
                              style: defaultInfoValueStyle,
                            ),
                          ),
                          CoinInfo(
                            name: "Max Supply",
                            value: Text(
                              formatPrice(
                                  crypto?.totalSupply, crypto?.symbol ?? ""),
                              style: defaultInfoValueStyle,
                            ),
                          ),
                          Text("Info :",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              )),
                          // Column(
                          //   spacing: 10,
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       "Description",
                          //       style: defaultInfoValueStyle,
                          //     ),
                          //     Container(
                          //       width: 300,
                          //       child: Text(
                          //         crypto?.description ?? "",
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w400,
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          CoinInfo(
                            name: "Website",
                            value: InkWell(
                                onTap: () {
                                  launchUrl(
                                    Uri.parse(crypto?.website ?? ""),
                                  );
                                },
                                child:
                                    Card(child: Text(crypto?.website ?? ""))),
                          ),
                          CoinInfo(
                              name: "Categories",
                              value: Wrap(children: [
                                ...(crypto?.categories?.map((e) {
                                      return Chip(label: Text(e));
                                    }).toList() ??
                                    []),
                              ]))
                        ])
                  ],
                )
              ]),
            ),
    );
  }
}

class CoinInfo extends StatelessWidget {
  final String name;
  final Widget value;
  const CoinInfo({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        value
      ],
    );
  }
}
