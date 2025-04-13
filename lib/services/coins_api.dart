import 'dart:convert';

import 'package:cryptoflow/models/coin_price.dart';
import 'package:cryptoflow/models/currency.dart';
import 'package:cryptoflow/models/crypto.dart';
import 'package:cryptoflow/utils.dart';

Future<List<Crypto>?> getListings({
  order = "marketCap",
  List<String>? ids,
  String? search,
  String orderDirection = "desc",
  int offset = 0,
  int limit = 50,
}) async {
  Map<String, dynamic> queryParams = {
    "orderBy": order,
    "limit": limit.toString(),
    "orderDirection": orderDirection,
    "offset": offset.toString()
  };

  if (ids != null) {
    queryParams["uuids"] = ids.join(",");
  }

  if (search != null) {
    queryParams["search"] = search;
  }

  Uri url = Uri.https('api.coinranking.com', "/v2/coins", queryParams);

  try {
    var response = await httpGet(url);
    var responseJson = json.decode(response.body);

    if (responseJson["status"] != "success") {
      return null;
    }

    var listing = responseJson["data"]["coins"];
    List<Crypto> cryptoList = [];
    for (var crypto in listing) {
      cryptoList.add(Crypto(
        id: crypto["uuid"],
        name: crypto["name"],
        symbol: crypto["symbol"],
        price: double.tryParse(crypto["price"] ?? ""),
        logoUrl: toProxyUrl(crypto["iconUrl"]),
        priceChangePercentageDay: double.tryParse(crypto["change"] ?? ""),
        sparkline: crypto["sparkline"]
            .map<double>((e) => double.tryParse(e.toString()) ?? 0)
            .toList(),
      ));
    }

    return cryptoList;
  } catch (e) {
    return null;
  }
}

Future<List<CoinPrice>?> getPricesHistory(
    String coinId, String timePeriod) async {
  Map<String, dynamic> queryParams = {"timePeriod": timePeriod};

  Uri url =
      Uri.https('api.coinranking.com', "/v2/coin/$coinId/history", queryParams);

  try {
    var response = await httpGet(url);
    var responseJson = json.decode(response.body);

    if (responseJson["status"] != "success") {
      return null;
    }

    var pricesHistoryData = responseJson["data"]["history"];
    List<CoinPrice> pricesHistory = [];

    for (var data in pricesHistoryData) {
      pricesHistory.add(CoinPrice(
        dateTime: DateTime.fromMillisecondsSinceEpoch(data["timestamp"] * 1000),
        price: double.tryParse(data["price"] ?? ""),
      ));
    }

    return pricesHistory;
  } catch (e) {
    return null;
  }
}

Future<Crypto?> getCoinData(String id) async {
  Uri url = Uri.https('api.coinranking.com', "/v2/coin/$id");

  try {
    var response = await httpGet(url);
    var responseJson = json.decode(response.body);

    if (responseJson["status"] != "success") {
      return null;
    }

    var responseData = responseJson["data"]["coin"];
    return Crypto(
      id: responseData["uuid"],
      name: responseData["name"],
      symbol: responseData["symbol"],
      price: double.tryParse(responseData["price"] ?? ""),
      logoUrl: toProxyUrl(responseData["iconUrl"]),
      priceChangePercentageDay: double.tryParse(responseData["change"] ?? ""),
      description: responseData["description"],
      categories: responseData["tags"].cast<String>(),
      website: responseData["websiteUrl"],
      ath: double.tryParse(responseData["allTimeHigh"]["price"] ?? ""),
      athDate: DateTime.fromMillisecondsSinceEpoch(
          (responseData["allTimeHigh"]["timestamp"] ?? 0) * 1000),
      marketCap: double.tryParse(responseData["marketCap"] ?? ""),
      totalSupply: double.tryParse(responseData["supply"]["max"] ??
          responseData["supply"]["total"] ??
          ""),
      circulatingSupply:
          double.tryParse(responseData["supply"]["circulating"] ?? ""),
      volume: double.tryParse(responseData["24hVolume"] ?? ""),
      sparkline: responseData["sparkline"]
          .map<double>((e) => double.tryParse(e.toString()) ?? 0)
          .toList(),
      marketCapRank: responseData["rank"],
    );
  } catch (e) {
    return null;
  }
}

Future<List<Currency>?> getAvailableCurrencies({
  String? search,
  int offset = 0,
  int limit = 50,
}) async {
  Map<String, dynamic> queryParams = {
    "limit": limit.toString(),
    "offset": offset.toString()
  };

  if (search != null) {
    queryParams["search"] = search;
  }

  Uri url =
      Uri.https('api.coinranking.com', "/v2/reference-currencies", queryParams);

  try {
    var response = await httpGet(url);
    var responseJson = json.decode(response.body);

    if (responseJson["status"] != "success") {
      return null;
    }

    var data = responseJson["data"];
    List<Currency> currencies = [];
    for (var currency in data["currencies"]) {
      currencies.add(Currency(
        id: currency["uuid"],
        type: currency["type"],
        name: currency["name"],
        symbol: currency["symbol"],
        iconUrl: currency["iconUrl"],
        sign: currency["sign"],
      ));
    }

    return currencies;
  } catch (e) {
    return null;
  }
}
