import 'dart:io';
import './widgets/chart.dart';
import 'package:flutter/cupertino.dart';

import './widgets/newtransaction.dart';

import './models/transaction.dart';
import 'package:flutter/material.dart';

import './widgets/transactionlist.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'OpenSans',
          appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(id: 't1', title: 'New Shoes', amount: 70, date: DateTime.now()),
    // Transaction(id: 't2', title: 'Groceries', amount: 82, date: DateTime.now()),
  ];
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  bool _showchart = false;
  void _addNewTransaction(String title, double amount, DateTime chosendate) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: chosendate,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
   final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
     var  appBar;
   if(Platform.isIOS) appBar =    CupertinoNavigationBar(
      middle: Text('Personal Expenses'),
      trailing: Row(
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context) ,
          )
        ],
      ),
    );
    if(!Platform.isIOS) 
    appBar=AppBar(
      title: Text('Personal Expenses'),
      actions: [
        IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add))
      ],
    );
    final pageBody =SafeArea(
      child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             if(isLandscape) Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart', style: Theme.of(context).textTheme.headline6,),
                  Switch.adaptive(
    
                      value: _showchart,
                      onChanged: (val) {
                        setState(() {
                          _showchart = val;
                        });
                      })
                ],
              ),
              if(!isLandscape)Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.3,
                      child: Chart(_recentTransactions)),
                      if(!isLandscape)Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child:
                          TransactionList(_userTransactions, _deleteTransaction)),
             if(isLandscape) _showchart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child:
                          TransactionList(_userTransactions, _deleteTransaction)),
            ],
          ),
        ),
    );
    return Platform.isIOS? CupertinoPageScaffold(child:pageBody ,navigationBar: appBar,):Scaffold(
      appBar:  appBar,
      body:pageBody ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS?Container():FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
