import 'package:http/http.dart' as http;

String formatPrice(double? price, String symbol) {
  if (price == null) return 'N/A';

  if (price < 0.01 && price > 0) {
    if (price < 0.000001) {
      return '$symbol ${price.toStringAsExponential(2)}';
    }

    String priceStr = price.toString();
    int decimalPos = priceStr.indexOf('.');
    if (decimalPos != -1) {
      int leadingZeros = 0;
      for (int i = decimalPos + 1; i < priceStr.length; i++) {
        if (priceStr[i] == '0') {
          leadingZeros++;
        } else {
          break;
        }
      }
      int significantDigits = leadingZeros + 2;
      return '$symbol ${price.toStringAsFixed(significantDigits)}';
    }
  }
  if (price >= 1000) {
    if (price >= 1000000) {
      if (price >= 1000000000000) {
        return '$symbol ${(price / 1000000000000).toStringAsFixed(2)}T';
      } else if (price >= 1000000000) {
        return '$symbol ${(price / 1000000000).toStringAsFixed(2)}B';
      } else {
        return '$symbol ${(price / 1000000).toStringAsFixed(2)}M';
      }
    } else {
      return '$symbol ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')}';
    }
  }

  return '$symbol ${price.toStringAsFixed(2)}';
}

Future<http.Response> httpGet(Uri url) async {
  Uri requestURl =
      Uri.https("futureofthe.tech", "/proxy", {"url": url.toString()});

  var reponse = await http.get(requestURl);

  return reponse;
}

String toProxyUrl(String url) {
  Uri resultURL = Uri.https("futureofthe.tech", "/proxy", {"url": url});

  return resultURL.toString();
}
