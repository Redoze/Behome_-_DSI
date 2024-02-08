import 'package:behome/models/expense_model.dart';
import 'package:behome/models/person_model.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/expense_service.dart';
import 'package:behome/services/category_service.dart';
import 'package:behome/widgets/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({super.key});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  final formKey = GlobalKey<FormState>();
  final amount = TextEditingController();

  String titulo = '';
  String residente = '';
  String categoryId = ''; // Modificado de categoria para categoryId
  String personId = ''; // Adicionado para armazenar o ID da pessoa selecionada
  bool isRecorrente = false;

  ExpenseService expenseService = ExpenseService();
  CategoryService categoryService = CategoryService();

  void _submitExpense(String homeId) async {
    try {
      double doubleAmount = double.parse(amount.text);

      ExpenseModel newExpense = ExpenseModel(
        amount: doubleAmount,
        categoryId: categoryId,
        date: DateTime.now(),
        personId: personId, // Usar o ID da pessoa selecionada
        personName: residente,
        title: titulo,
        homeId: homeId,
      );

      await expenseService.createExpense(newExpense);

      Fluttertoast.showToast(
          msg: "Gasto adicionado com sucesso!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context); // Navegar de volta
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Erro ao adicionar gasto: ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon (Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView( 
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 40),
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
                    SizedBox(height: 12),
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
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value) => titulo = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Titulo',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value) => residente = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Residente',
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<PersonModel>>(
                        stream: PersonService().readPersons(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.error != null) {
                            return const Center(
                                child: Text('Ocorreu algum erro!'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('Nenhuma Pessoa Registrada!');
                          }

                          List<PersonModel> persons = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            value: personId.isNotEmpty ? personId : userId, // Por padrão, usa o ID do usuário logado
                            onChanged: (value) {
                              setState(() {
                                personId = value!;
                              });
                            },
                            items: persons.map((person) {
                              return DropdownMenuItem<String>(
                                value: person.id!,
                                child: Text(person.name),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Pessoa',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<CategoryModel>>(
                        stream: categoryService.readCategories(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.error != null) {
                            return const Center(
                                child: Text('Ocorreu algum erro!'));
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('Nenhuma Categoria Registrada!');
                          }

                          List<CategoryModel> categories = snapshot.data!;

                          return DropdownButtonFormField<String>(
                            value: categoryId,
                            onChanged: (value) {
                              setState(() {
                                categoryId = value!;
                              });
                            },
                            items: categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.id!,
                                child: Text(category.title),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Categoria',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
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
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
