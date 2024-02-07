import 'package:behome/models/expense_model.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/expense_service.dart';
import 'package:behome/widgets/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({Key? key}) : super(key: key);

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  final formKey = GlobalKey<FormState>();
  final amount = TextEditingController();

  String titulo = '';
  String residente = '';
  String categoria = '';
  bool isRecorrente = false;

  ExpenseService firestoreService = ExpenseService();

  void _submitExpense(String homeId, String personId) async {
    try {
      double doubleAmount = double.parse(amount.text);

      ExpenseModel newExpense = ExpenseModel(
        amount: doubleAmount,
        categoryID: categoria, 
        date: DateTime.now(),
        personId: personId, 
        personName: residente,
        title: titulo,
        homeId: homeId,
      );

      await firestoreService.createExpense(newExpense);

      Fluttertoast.showToast(
        msg: "Gasto adicionado com sucesso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context); // Navigate back
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro ao adicionar gasto: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);

    // Check if the user is not null
    if (authService.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String userId = authService.user!.uid;

    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Novo Gasto',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Adicionando o texto "Valor" na cor cinza
                  ],
                ),
              ),
              // Campos de texto
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        validator: FormValidators.amount,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Valor',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) => titulo = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Titulo',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) => residente = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Residente',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) => categoria = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Categoria',
                        ),
                      ),
                      const SizedBox(height: 10),
                      // CupertinoSwitch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recorrente',
                            style: TextStyle(color: Colors.black),
                          ),
                          CupertinoSwitch(
                            value: isRecorrente,
                            onChanged: (value) {
                              setState(() {
                                isRecorrente = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Ative esta opção caso o gasto seja fixo todos os meses.',
                        style: TextStyle(
                            color: Color.fromARGB(255, 145, 145, 145)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _submitExpense(userId);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Adicionar Gasto'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
