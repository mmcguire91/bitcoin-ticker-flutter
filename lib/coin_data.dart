import 'package:http/http.dart' as http;
//requires user to specify package.DataType
import 'dart:convert';
//imports jsonDecode

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

const coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '6EF3769F-22FF-4F28-94F8-27E64A8ED337';

class CoinData {
  //Create the Asynchronous method getCoinData() that returns a Future (the price data).

  Future getCoinData() async {
    //Create a url combining the coinAPIURL with the currencies we're interested, BTC to USD
    String url = '$coinApiUrl/BTC/USD?apikey=$apiKey';
    //Make a GET request to the URL and wait for the response.
    http.Response response = await http.get(url);

    //Check that the request was successful.
    if (response.statusCode == 200) {
      //Use the 'dart:convert' package to decode the JSON data that comes back from coinapi.io.
      var decodedData = jsonDecode(response.body);
      //Get the last price of bitcoin with the key 'last'.
      var lastPrice = decodedData['rate'];
      //Output the lastPrice from the method.
      return lastPrice;
    } else {
      //Handle any errors that occur during the request.
      print(response.statusCode);
      //throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
