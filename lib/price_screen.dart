import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
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

  String bitcoinValueInSelectedCurrency = '?';
  //Variable to hold the value and use in Text Widget.

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
                  //Update the Text Widget with the live bitcoin data

                  '1 BTC = $bitcoinValueInSelectedCurrency $selectedCurrency',
                  //Update the currency name depending on the selectedCurrency, the user selected value.

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
