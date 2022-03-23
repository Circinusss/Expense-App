// ignore_for_file: prefer_const_constructors, deprecated_member_use
import 'package:flutter/services.dart';
import './widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import '../widgets/chart.dart';
import 'models/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      theme: ThemeData(primarySwatch: Colors.purple, accentColor: Colors.amber),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //String titleInput;
  SharedPref sharedPref = SharedPref();

  final List<Transaction> _userTransactions = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((txs) {
      return txs.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key).toString());
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  key() async {
    final prefs = await SharedPreferences.getInstance();
    //print(prefs.getKeys());
    Set a = prefs.getKeys();
    print(a);
    if (a.isNotEmpty) {
      for (int i = 0; i < a.length; i++) {
        List x = json.decode(prefs.getString(a.elementAt(i)).toString());
        addPrevTransaction(x[0].toString(), x[1].toString(),
            double.parse(x[2].toString()), DateTime.parse(x[3].toString()));
      }
      ;
    }
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);
    save(newTx.id.toString(),
        [newTx.id, newTx.title, newTx.amount, newTx.date.toString()]);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void addPrevTransaction(
      String id, String txTitle, double txAmount, DateTime chosenDate) {
    final newTx =
        Transaction(id: id, title: txTitle, amount: txAmount, date: chosenDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
            onTap: () {}, child: NewTransaction(_addNewTransaction));
      },
    );
  }

  void _deleteTransaction(String id) {
    remove(id);
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void initState() {
    super.initState();
    key();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('Expenses'),
      actions: <Widget>[
        IconButton(
            onPressed: () => {
                  setState(() {
                    if (_showChart == false) {
                      _showChart = true;
                    } else {
                      _showChart = false;
                    }
                  })
                },
            icon: Icon(Icons.bar_chart))
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _showChart
              ? Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.25,
                  child: Chart(_recentTransactions))
              : Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.75,
                  child:
                      TransactionList(_userTransactions, _deleteTransaction)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
