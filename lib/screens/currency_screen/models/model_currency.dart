class CurrencyPage {
  final String currencyName;
  final String currencySymbol;
  final double currencyRate;

  CurrencyPage(
      {required this.currencyName,
      required this.currencySymbol,
      required this.currencyRate});

  Map<String, dynamic> toMap() {
    return {
      "currencyName": currencyName,
      "currencySymbol": currencySymbol,
      "currencyRate": currencyRate
    };
  }
}
