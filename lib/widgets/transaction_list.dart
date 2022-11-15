import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  const FittedBox(
                    child: Text(
                      'No transactions added yet',
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.05,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    // child: FittedBox(
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                    // ),
                  )
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text("\$${transactions[index].amount}")),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transactions[index].date),
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: MediaQuery.of(context).size.width > 300
                        ? TextButton.icon(
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteTx(transactions[index].id),
                          ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}





// OLD TRANSACTION CODE:

// child: Row(
//   children: [
//     Container(
//       // ignore: sort_child_properties_last
//       child: Text(
//           '\$${transactions[index].amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Theme.of(context).primaryColor,
//           )),
//       margin: const EdgeInsets.symmetric(
//           vertical: 15, horizontal: 15),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Theme.of(context).primaryColor,
//           width: 2,
//         ),
//       ),
//       padding: const EdgeInsets.all(10),
//     ),
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           transactions[index].title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           // 'P${e.date}',
//           DateFormat('yyyy/MM/dd')
//               .format(transactions[index].date),
//           style: TextStyle(
//             fontSize: 11,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     ),
//     const Expanded(
//       child: SizedBox(),
//     ),
//     Container(
//       padding: EdgeInsets.only(right: 20),
//       child: IconButton(
//         icon: const Icon(
//           Icons.delete,
//           color: Colors.red,
//         ),
//         onPressed: () {
//           deleteTx(transactions[index].id);
//         },
//       ),
//     )
//   ],
// ),