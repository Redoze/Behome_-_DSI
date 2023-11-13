import 'package:behome/pages/register_page.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/widgets/form_validators.dart';
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

  bool isLoading = false;

  login() async {
    try {
      setState(() => isLoading = true);
      await context.read<AuthService>().login(email.text, password.text);
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
                          validator: FormValidators.email,
                        ),
                        TextFormField(
                          controller: password,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            label: Text('Senha'),
                          ),
                          obscureText: true,
                          validator: FormValidators.password,
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
                          login();
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Entrar'),
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
                        child: const Text('Criar conta')),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
