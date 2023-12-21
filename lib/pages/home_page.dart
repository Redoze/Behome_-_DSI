import 'package:behome/services/auth_service.dart';
import 'package:behome/widgets/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  logout() async {
    try {
      await context.read<AuthService>().logout();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(8, 85, 255, 1),
              Color.fromRGBO(5, 39, 114, 1),
            ],
          )),
          child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: logout,
                    icon:
                        const Icon(Icons.logout, color: Colors.white, size: 40),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center, // Centraliza verticalmente
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: 16), // Ajuste conforme necessário
                          child: Image(
                            image: AssetImage(
                                'assets/images/logo_behome_white.png'),
                            width: 40,
                          ),
                        ),
                        Text(
                          'Seu BeHome',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const ExpensesList()
                ],
              )),
        ),
      ),
    );
  }
}
