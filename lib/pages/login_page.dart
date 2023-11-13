import 'package:behome/pages/register_page.dart';
import 'package:behome/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  login() async {
    try {
      await context.read<AuthService>().login(email.text, password.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/logo_behome.png'),
                  width: 150,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Entrar no BeHome',
                  // Add Bold
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text('Email'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value!.isEmpty
                              ? 'Por favor, insira um email válido'
                              : null,
                        ),
                        TextFormField(
                            controller: password,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              label: Text('Senha'),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Por favor, insira uma senha válida';
                              } else if (value.length < 6) {
                                return 'A senha deve ter pelo menos 6 caracteres';
                              }
                              return null;
                            }),
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
                          login();
                        }
                      },
                      child: const Text('Entrar'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const RegisterPage()));
                      },
                      child: const Text('Criar conta'),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
