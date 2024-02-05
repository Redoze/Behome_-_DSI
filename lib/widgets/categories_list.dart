import 'package:behome/models/category_model.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/category_service.dart';
import '../models/icons_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    CategoryService firestoreService = CategoryService();

    // Check if the user is not null
    if (authService.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String userId = authService.user!.uid;

    return StreamBuilder<List<CategoryModel>>(
      stream: firestoreService.readCategories(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          return const Center(child: Text('Ocorreu algum erro!'));
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
              heightFactor: 8,
              child: Text(
                'Nenhuma Categoria Registrada!',
                style: TextStyle(
                  color: Color.fromRGBO(8, 85, 255, 1),
                  fontSize: 20,
                ),
              ));
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
                      trailing: Text(category.icon
                          .toString()
                          .substring(1, category.icon.toString().length - 1)),
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
