import 'package:behome/models/category_model.dart';
import 'package:flutter/material.dart';
import '../models/icons_list_model.dart';

class CategoryRegisterPage extends StatefulWidget {
  const CategoryRegisterPage({super.key});

  @override
  State<CategoryRegisterPage> createState() => _CategoryRegisterPageState();
}

class _CategoryRegisterPageState extends State<CategoryRegisterPage> {
  final _categoryId = 0;
  var _iconController = null;
  final _titleController = TextEditingController();

  void _submitCategory() {
    var _category = CategoryModel(
        id: _categoryId.toString(),
        title: _titleController.text,
        icon: _iconController);

    //Implementar o submit pro firebase aqui

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                        TextField(
                          //TITULO DA CATEGORIA
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Nome da Categoria',
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
                                      Text(iconEntry
                                          .key), // You can customize the text as needed
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
                              onPressed: () => _submitCategory(),
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
