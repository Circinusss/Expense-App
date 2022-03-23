// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Container(
                height: 200,
                child: Image.asset(
                  'images/empty.png',
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'No Transaction Added Yet!',
                style: TextStyle(color: Colors.white54, fontSize: 25),
              ),
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Colors.black,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.amber,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.amber,
                      radius: 27,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: FittedBox(
                          child: Text(
                              '₹${transactions[index].amount.toStringAsFixed(0)}'),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                      DateFormat('dd/MM/yyyy')
                          .add_jm()
                          .format(transactions[index].date),
                      style: TextStyle(color: Colors.white54)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red.shade900,
                    onPressed: () => deleteTx(transactions[index].id),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
