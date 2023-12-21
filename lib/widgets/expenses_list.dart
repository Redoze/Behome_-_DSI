import 'package:behome/models/expense_model.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    FirestoreService firestoreService = FirestoreService();

    // Check if the user is not null
    if (authService.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String userId = authService.user!.uid;

    return StreamBuilder<List<ExpenseModel>>(
      stream: firestoreService.readExpenses(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          return const Center(child: Text('Ocorreu algum erro!'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text(
            'Nenhum Gasto Registrado!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ));
        }

        List<ExpenseModel> expenses = snapshot.data!;

        return Expanded(
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              ExpenseModel expense = expenses[index];

              return Card(
                child: ListTile(
                  title: Text(expense.title),
                  subtitle: Text(expense.personName),
                  leading: const CircleAvatar(
                    child: Icon(Icons.attach_money),
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          NumberFormat.currency(
                            locale: 'pt_BR',
                            symbol: 'R\$',
                          ).format(expense.amount),
                          style: const TextStyle(
                            color: Color.fromRGBO(8, 85, 255, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      // Date
                      Text(
                        DateFormat('dd/MM/yyyy').format(expense.date),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
