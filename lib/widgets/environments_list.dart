import 'package:behome/models/environment_model.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/environment_service.dart';
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
    EnvironmentService firestoreService = EnvironmentService();

    if (authService.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String userId = authService.user!.uid;

    return StreamBuilder<List<EnvironmentModel>>(
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
                  'Nenhum ambiente registrado!',
                  style: TextStyle(
                    color: Color.fromRGBO(8, 85, 255, 1),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        }

        List<EnvironmentModel> categories = snapshot.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  EnvironmentModel environment = categories[index];
                  return Card(
                    child: ListTile(
                      title: Text(environment.title),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromRGBO(8, 85, 255, 1),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                IconsListModel().getList[environment
                                    .icon
                                    .toString()
                                    .substring(1,
                                        environment.icon.toString().length - 1)],
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
                                          'Deseja realmente deletar este ambiente?'),
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
                                    EnvironmentService()
                                        .deleteEnvironment(environment.id.toString());
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
