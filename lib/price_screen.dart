import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;



final String btcCurrency = cryptoList[0];
final String ethCurrency = cryptoList[1];
final String ltcCurrency = cryptoList[2];

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  bool isWaiting = false;
  Map<String, String> coinValues = {};

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for(String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          if(value != null) {
            selectedCurrency = value ;
            getBitcoinData();
          }
        });
      },
    );
  }

  CupertinoPicker? iosPicker() {
    List<Text>  pickerItems = [];
    for(String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (int selectIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectIndex];
          getBitcoinData();
        });
      },
      children: pickerItems,
    );
  }


  void getBitcoinData() async {
    CoinData coinData = CoinData();
    try {
      isWaiting = true;
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e){
        coinData.getErrorMessage(context, "Problem with the get request");
    }
  }


  @override
  void initState() {
    super.initState();
    getBitcoinData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CyrpoCard(cryptoCurrency: 'BTC', value: isWaiting ? '?' : coinValues['BTC']!, selectedCurrency: selectedCurrency,),
                SizedBox(height: 15.0,),
                CyrpoCard(value: isWaiting ? '?' : coinValues['ETH']! , selectedCurrency: selectedCurrency, cryptoCurrency: 'ETH'),
                SizedBox(height: 15.0,),
                CyrpoCard(value: isWaiting ? '?' : coinValues['LTC']! , selectedCurrency: selectedCurrency, cryptoCurrency: 'LTC'),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CyrpoCard extends StatelessWidget {

  CyrpoCard({required this.value, required this.selectedCurrency, required this.cryptoCurrency});

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency = $value $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

