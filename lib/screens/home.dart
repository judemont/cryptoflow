import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/screens/crypto_details.dart';
import 'package:cryptoflow/services/coins_api.dart';
import 'package:cryptoflow/widgets/cryptocard.dart';
import 'package:flutter/material.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    _scrollController = ScrollController();
    getListings().then((value) {
      if (value != null) {
        setState(() {
          cryptoList = value;
        });
      }
    });
    super.initState();
  }

  void updateList() {
    getListings(search: searchText, order: orderBy, orderDirection: order)
        .then((value) {
      if (value != null) {
        setState(() {
          cryptoList = value;
        });
      }
    });
  }

  List orders = [
    {
      "name": "Market Cap",
      "value": "marketCap",
      "icon": Icon(Icons.pie_chart),
    },
    {
      "name": "24h Volume",
      "value": "24hVolume",
      "icon": Icon(Icons.currency_exchange)
    },
    {
      "name": "Price Change 24h",
      "value": "change",
      "icon": Icon(Icons.show_chart)
    },
    {
      "name": "Last listed",
      "value": "listedAt",
      "icon": Icon(Icons.rocket_launch)
    }
  ];
  List<Crypto> cryptoList = [];
  String searchText = "";
  String orderBy = "marketCap";
  String order = "desc";
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = (MediaQuery.of(context).size.width ~/ 450).toInt();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("CryptoFlow"),
        ),
        body: WebSmoothScroll(
            scrollSpeed: 0.8,
            scrollAnimationLength: 100,
            controller: _scrollController,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              child: Column(children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  "CryptoFlow",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SearchBar(
                    padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 20)),
                    hintText: "Search for a coin",
                    leading: const Icon(Icons.search),
                    onChanged: (value) {
                      if (value.length < 3) {
                        setState(() {
                          searchText = "";
                        });
                        return;
                      }

                      setState(() {
                        searchText = value;
                      });
                      updateList();
                    },
                    onSubmitted: (value) {
                      setState(() {
                        searchText = value;
                      });
                      updateList();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownMenu(
                            menuStyle: MenuStyle(),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(),
                            ),
                            enableSearch: false,
                            trailingIcon: const Icon(Icons.sort),
                            initialSelection: orders[0]["value"],
                            onSelected: (value) {
                              setState(() {
                                orderBy = value;
                                if (!["change"].contains(orderBy)) {
                                  order = "desc";
                                }
                              });
                              updateList();
                            },
                            dropdownMenuEntries: orders.map((e) {
                              return DropdownMenuEntry(
                                leadingIcon: e["icon"],
                                label: e["name"],
                                value: e["value"],
                              );
                            }).toList(growable: false))),
                    Visibility(
                      visible: ["change"].contains(orderBy),
                      child: IconButton(
                        icon: Icon(
                          order == "asc"
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            order = order == "asc" ? "desc" : "asc";
                          });
                          updateList();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width / 5),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount > 0 ? crossAxisCount : 1,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 40,
                    mainAxisExtent: 200,
                  ),
                  shrinkWrap: true,
                  itemCount: cryptoList.length,
                  itemBuilder: (context, index) {
                    return CryptoCard(
                      crypto: cryptoList[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CryptoDetails(
                                  cryptoId: cryptoList[index].id!)),
                        );
                      },
                    );
                  },
                )
              ]),
            )));
  }
}
