import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform; //only incorporate Platform class

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    //Material design Dropdown list for loop
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
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    //Cupertino Picker For Loop
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0, //size of items
      onSelectedItemChanged: (selectedIndex) {},
      //onSelectedIndex = onChanged, selectedIndex = value
      children: pickerItems,
    );
  }

  //Create a variable to hold the value and use in our Text Widget. Give the variable a starting value of '?' before the data comes back from the async methods.
  String bitcoinValueInUSD = '?';

  //Create an async method here await the coin data from coin_data.dart
  void getData() async {
    try {
      double data = await CoinData().getCoinData();
      //We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        bitcoinValueInUSD = data.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    //Call getData() when the screen loads up
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
          Padding(
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
                  //Update the Text Widget with the live bitcoin data here.
                  '1 BTC = $bitcoinValueInUSD USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
