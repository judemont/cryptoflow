class Crypto {
  String? id;
  String? name;
  String? symbol;
  double? price;
  String? logoUrl;
  double? priceChangePercentageDay;
  String? description;
  List<String>? categories;
  String? website;
  double? ath;
  DateTime? athDate;
  double? marketCap;
  int? marketCapRank;
  double? dayHigh;
  double? dayLow;
  double? totalSupply;
  double? circulatingSupply;
  double? volume;
  List<double>? sparkline;

  Crypto({
    this.id,
    this.name,
    this.symbol,
    this.price,
    this.logoUrl,
    this.priceChangePercentageDay,
    this.description,
    this.categories,
    this.website,
    this.ath,
    this.athDate,
    this.marketCap,
    this.marketCapRank,
    this.dayHigh,
    this.dayLow,
    this.totalSupply,
    this.circulatingSupply,
    this.volume,
    this.sparkline,
  });
}
