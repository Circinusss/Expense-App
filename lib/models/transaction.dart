class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        amount = json['amount'],
        date = json['date'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'amount': amount, 'date': date};
}
