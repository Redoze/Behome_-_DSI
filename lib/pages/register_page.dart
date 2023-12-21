import 'package:behome/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/form_validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool isLoading = false;

  // Register Receive the BuildContext
  register(
    BuildContext navigationContext,
  ) async {
    try {
      setState(() => isLoading = true);
      await context.read<AuthService>().register(email.text, password.text);
      Navigator.of(navigationContext).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Conta criada com sucesso!'),
            backgroundColor: Colors.green),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Transparent AppBar
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [   
            const Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Centraliza verticalmente
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(right: 16), // Ajuste conforme necessário
                  child: Image(
                    image: AssetImage('assets/images/logo_behome.png'),
                    width: 40,
                  ),
                ),
                Text(
                  'Crie seu BeHome',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text('Email'),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: FormValidators.email,
                                ),
                                TextFormField(
                                    controller: password,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      label: Text('Senha'),
                                    ),
                                    obscureText: true,
                                    validator: FormValidators.password),
                                TextFormField(
                                  controller: confirmPassword,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    label: Text('Confirmar Senha'),
                                  ),
                                  obscureText: true,
                                  validator: (value) =>
                                      FormValidators.confirmPassword(
                                    value,
                                    password.text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    register(context);
                                  }
                                },
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text('Criar Conta'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
