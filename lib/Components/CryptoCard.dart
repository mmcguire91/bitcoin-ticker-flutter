import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/price_screen.dart';
import 'package:bitcoin_ticker/coin_data.dart';

class CryptoCard extends StatelessWidget {
  CryptoCard({this.cryptoCardText});

  final String cryptoCardText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            cryptoCardText,
            //Update the Text Widget with the live bitcoin data

//            '1 BTC = $bitcoinValueInSelectedCurrency $selectedCurrency',
            //Update the currency name depending on the selectedCurrency, the user selected value.

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
