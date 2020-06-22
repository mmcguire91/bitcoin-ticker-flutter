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

  Map<String, String> coinValues = {};
  //Variable to hold the value and use in Text Widget.
  bool isWaiting = false;
  //7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. Hint: You'll need a ternary operator.

  void getData() async {
    //Async method here awaits the coin data from coin_data.dart
    isWaiting = true;
    //7: Second, we set it to true when we initiate the request for prices.
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      //Call the class CoinData() and method getCoinData from coin_data and save that to the local variable data (data type = double)
      //6: Update this method to receive a Map containing the crypto:price key value pairs. Change the data type from double to var to account for the new data retrieval of several items instead of 1
      //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.

      setState(() {
        coinValues = data;
        //update the value of the displayed USD from the local variable "data" to reflect the data retrieved from the API call in class CoinData() and method getCoinData from coin_data
        isWaiting = false;
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

  //BONUS POINTS create a method that loops through the cryptoList and generates a CryptoCard for each.
  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      //created FOR IN loops to cycle through the crypto currencies
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          //display the name based on the FOR loop
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : coinValues[crypto],
          //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data as defined from the FOR loop
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

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
          makeCards(),
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
