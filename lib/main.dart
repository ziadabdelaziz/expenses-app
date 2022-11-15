import 'package:expenses/widgets/new_transaction.dart';
import 'package:expenses/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.blueAccent),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: 't${_userTransactions.length + 1}',
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransactions.insert(0, newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _deleteTransactionMethod(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => id == tx.id);
    });
  }

  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text(
        'Personal Expenses',
        style: TextStyle(
          fontFamily: 'Open sans',
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            startAddNewTransaction(context);
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
    final mediaQeury = MediaQuery.of(context);

    final responsiveSize = mediaQeury.size.height -
        appBar.preferredSize.height -
        mediaQeury.padding.top;

    final isLandScape =
        mediaQeury.orientation == Orientation.landscape;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Show Chart"),
                  Switch(
                    value: _showChart,
                    onChanged: (bool val) {
                      setState(() { 
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandScape)
              Container(
                height: responsiveSize * 0.25,
                child: Chart(_recentTransactions),
              ),
            if (!isLandScape)
              Container(
                height: responsiveSize * 0.75,
                child: TransactionList(
                    _userTransactions, _deleteTransactionMethod),
              ),
            if (isLandScape)
              _showChart
                  ? Container(
                      height: responsiveSize * 0.6,
                      child: Chart(_recentTransactions),
                    )
                  : Container(
                      height: responsiveSize * 0.75,
                      child: TransactionList(
                          _userTransactions, _deleteTransactionMethod),
                    ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          startAddNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
