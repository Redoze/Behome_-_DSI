import 'package:behome/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/icons_list_model.dart';
import '../services/category_service.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryRegisterPage extends StatefulWidget {
  const CategoryRegisterPage({super.key});

  @override
  State<CategoryRegisterPage> createState() => _CategoryRegisterPageState();
}

class _CategoryRegisterPageState extends State<CategoryRegisterPage> {
  var _iconController = null;
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CategoryService categoryService = CategoryService();

  void _submitCategory(String homeId) async {
    try {
      final String iconName = IconsListModel()
          .getList
          .entries
          .where((entry) => entry.value == _iconController)
          .map((entry) => entry.key)
          .toString();
      // No ID passed at creation time here
      var newCategory = CategoryModel(
          title: titleController.text.toString(),
          icon: iconName.toString(),
          homeId: homeId);

      await categoryService.createCategory(newCategory);

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Erro ao adicionar Categoria: ${e.toString()}",
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
      appBar: AppBar(),
      body: Center(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nova Categoria",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        Form(
                          key: formKey,
                          child: TextFormField(
                            //TITULO DA CATEGORIA
                            controller: titleController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite um nome válido para a categoria.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Nome da Categoria',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FittedBox(
                          //LISTA DE ICONES
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 317,
                            child: DropdownButton<IconData>(
                              value: _iconController,
                              hint: const Text("Icone da Categoria"),
                              items: IconsListModel()
                                  .getList
                                  .entries
                                  .map((iconEntry) {
                                return DropdownMenuItem<IconData>(
                                  value: iconEntry.value,
                                  child: Row(
                                    children: [
                                      Icon(iconEntry.value),
                                      const SizedBox(width: 10),
                                      Text(iconEntry.key),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (IconData? value) {
                                setState(
                                  () {
                                    _iconController = value!;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 220),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            height: 55,
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  _submitCategory(userId);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Adicionar Categoria',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(8, 85, 255, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    maxRadius: 15.0,
                                    backgroundColor:
                                        Color.fromRGBO(8, 85, 255, 1),
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
