import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'package:bitcoin_ticker/Components/CryptoCard.dart';
import 'dart:io' show Platform; //only incorporate Platform class

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  //Update the default currency to first object in the List from coin_data, the first item in the currencyList.
  String selectedCrypto = cryptoList[0];

  DropdownButton<String> androidDropdown() {
    //Material design Dropdown list for loop (Android UI component)
    List<DropdownMenuItem<String>> dropdownItems = [];
    //empty dropdown list
    for (String currency in currenciesList) {
      //for every currency in list
      var newItem = DropdownMenuItem(
        //create a new dropdown menu item
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
      //add the new menu item to the list of dropdown items
    }
    return DropdownButton<String>(
      //return functionality of material design dropdown lst
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        //when the selected value has changed
        setState(() {
          selectedCurrency = value;
          //set the state to the selected value
          getData();
          //Retrieve the latest data when user selects a value
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    //Cupertino Picker For Loop (iOS UI Component)
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0, //size of items
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        //Save the user selected value of the picker to the property selectedCurrency

        getData();
        //Retrieve the latest data when user selects a value
      },
      //onSelectedIndex = onChanged, selectedIndex = value
      children: pickerItems,
    );
  }

  String bitcoinValueInSelectedCurrency = '?';
  //Variable to hold the value and use in Text Widget.

  //TODO 7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. Hint: You'll need a ternary operator.

  //TODO 6: Update this method to receive a Map containing the crypto:price key value pairs. Then use that map to update the CryptoCards.
  void getData() async {
    //Async method here awaits the coin data from coin_data.dart
    try {
      double data = await CoinData().getCoinData(
          selectedCurrency); //Can't await in a setState() so have to separate it out into two steps.
      //Call the class CoinData() and method getCoinData from coin_data and save that to the local variable data (data type = double)

      setState(() {
        bitcoinValueInSelectedCurrency = data.toStringAsFixed(0);
        //update the value of the displayed USD from the local variable "data" to reflect the data retrieved from the API call in class CoinData() and method getCoinData from coin_data
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    //Call getData() when the screen loads
  }

  //TODO: For bonus points, create a method that loops through the cryptoList and generates a CryptoCard for each.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('🤑 Coin Ticker'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 1: Refactor this Padding Widget into a separate Stateless Widget called CryptoCard, so we can create 3 of them, one for each cryptocurrency.
          // 2: You'll need to able to pass the selectedCurrency, value and cryptoCurrency to the constructor of this CryptoCard Widget.
          // 3: You'll need to use a Column Widget to contain the three CryptoCards.
          Column(
            children: <Widget>[
              //BITCOIN
              CryptoCard(
                cryptoCardText:
                    '1 BTC = $bitcoinValueInSelectedCurrency $selectedCurrency',
              ),
              //ETHEREUM
              CryptoCard(
                cryptoCardText:
                    '1 ETH = $bitcoinValueInSelectedCurrency $selectedCurrency',
              ),
              //LITECOIN
              CryptoCard(
                cryptoCardText:
                    '1 LTC = $bitcoinValueInSelectedCurrency $selectedCurrency',
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropdown() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}
