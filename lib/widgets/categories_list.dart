import 'package:behome/models/category_model.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/category_service.dart';
import '../models/icons_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({
    super.key,
  });

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    CategoryService firestoreService = CategoryService();

    // Check if the user is not null
    if (authService.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String userId = authService.user!.uid;

    void showEditCategoryForm(BuildContext context, CategoryModel category) {
      final titleController = TextEditingController(text: category.title);
      final formKey = GlobalKey<FormState>();

      showDialog(
          context: context,
          builder: (context) {
            var iconController = null;
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
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
                      const SizedBox(height: 20),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: 320,
                          child: DropdownButton<IconData>(
                            value: iconController,
                            hint: const Text("Ícone da Categoria"),
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
                                  iconController = value!;
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Salvar'),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            String iconName = IconsListModel()
                                .getList
                                .entries
                                .where((entry) => entry.value == iconController)
                                .map((entry) => entry.key)
                                .toString();
                            CategoryModel updatedCategory = CategoryModel(
                                id: category.id, // Keep the same ID
                                title: titleController.text.toString(),
                                icon: iconName.toString(),
                                homeId: category.homeId);
                            await CategoryService()
                                .updateCategory(updatedCategory);

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            });
          });
    }

    return StreamBuilder<List<CategoryModel>>(
      stream: firestoreService.readCategories(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          return const Center(child: Text('Ocorreu algum erro!'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: const Text(
                  'Nenhuma Categoria Registrada!',
                  style: TextStyle(
                    color: Color.fromRGBO(8, 85, 255, 1),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        }

        List<CategoryModel> categories = snapshot.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  CategoryModel category = categories[index];
                  return Card(
                    child: ListTile(
                      title: Text(category.title),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromRGBO(8, 85, 255, 1),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                IconsListModel().getList[category
                                    .icon //gambiarra pq a chave da lista tava sendo armazenada entre () por agm motivo
                                    .toString()
                                    .substring(1,
                                        category.icon.toString().length - 1)],
                                color: Colors.white,
                              )),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 50,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: ElevatedButton(
                                onPressed: () async {
                                  showEditCategoryForm(context, category);
                                },
                                child: const Icon(Icons.edit,
                                    size: 15, color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final confirmDelete = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirmação'),
                                      content: const Text(
                                          'Deseja realmente deletar essa categoria?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Sim'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Não'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirmDelete) {
                                    CategoryService()
                                        .deleteCategory(category.id.toString());
                                  }
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
