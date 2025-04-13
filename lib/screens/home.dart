import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/screens/crypto_details.dart';
import 'package:cryptoflow/services/coins_api.dart';
import 'package:cryptoflow/widgets/cryptocard.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
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
    getListings(search: searchText).then((value) {
      if (value != null) {
        setState(() {
          cryptoList = value;
        });
      }
    });
  }

  List<Crypto> cryptoList = [];
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = (MediaQuery.of(context).size.width ~/ 450).toInt();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("CryptoFlow"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            SearchBar(
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
                          builder: (context) =>
                              CryptoDetails(cryptoId: cryptoList[index].id!)),
                    );
                  },
                );
              },
            )
          ]),
        ));
  }
}
