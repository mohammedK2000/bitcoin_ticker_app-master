import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String apiKey = '292BAD6A-FE89-450F-AAAA-C20E3A340413';
const String requestHttp = 'https://rest.coinapi.io/v1/exchangerate';


class CoinData {

  Future getCoinData(selectedCurrency) async {
    Map<String, String> cryptoItems = {};

    for (String crypto in cryptoList) {
        var requestURL = Uri.parse(
            '$requestHttp/$crypto/$selectedCurrency?apikey=$apiKey');
        http.Response response = await http.get(requestURL);

        if (response.statusCode == 200) {
          var decoded = jsonDecode(response.body);
          double lastPrice = decoded["rate"];
          cryptoItems[crypto] = lastPrice.toStringAsFixed(0);
        }
    }
    return cryptoItems;
  }

  void getErrorMessage(context, message) {
    return showTopSnackBar(
      context,
      CustomSnackBar.error(
        message: message,
      ),
    );
  }

}