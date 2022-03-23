// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.purple.shade300,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.black,
      duration: Duration(milliseconds: 400),
      child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white54, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.black,
          elevation: 5,
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Title',
                  ),
                  controller: _titleController,
                  cursorColor: Colors.white,
                  //onChanged: (value) => titleInput = value,
                ),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: 'Amount',
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitData(),
                  //onChanged: (value) => amountInput = value,
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'No Date Chosen!'
                              : 'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FlatButton(
                        onPressed: _presentDatePicker,
                        child: Text('Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        textColor: Colors.amber,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                FloatingActionButton(
                  onPressed: _submitData,
                  child: Icon(Icons.check),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
