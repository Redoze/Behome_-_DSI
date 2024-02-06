import 'package:behome/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/environment_model.dart';
import '../models/icons_list_model.dart';
import '../services/environment_service.dart';
import 'package:behome/widgets/form_validators.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EnvironmentRegisterPage extends StatefulWidget {
  const EnvironmentRegisterPage({super.key});

  @override
  State<EnvironmentRegisterPage> createState() => _EnvironmentRegisterPageState();
}

class _EnvironmentRegisterPageState extends State<EnvironmentRegisterPage> {
  var _iconController = null;
  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  EnvironmentService environmentService = EnvironmentService();

  void _submitEnvironment(String homeId) async {
    try {
      final String iconName = IconsListModel()
          .getList
          .entries
          .where((entry) => entry.value == _iconController)
          .map((entry) => entry.key)
          .toString();
      var newEnvironment = EnvironmentModel(
          title: titleController.text.toString(),
          icon: iconName.toString(),
          homeId: homeId);

      await environmentService.createEnvironment(newEnvironment);

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Erro ao adicionar ambiente: ${e.toString()}",
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
                          "Novo Ambiente",
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
                            controller: titleController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Digite um nome válido para o ambiente.';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Nome do Ambiente',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 317,
                            child: DropdownButton<IconData>(
                              value: _iconController,
                              hint: const Text("Ícone do Ambiente"),
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
                                  _submitEnvironment(userId);
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
                                    'Adicionar Ambiente',
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
