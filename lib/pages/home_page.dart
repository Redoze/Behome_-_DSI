import 'package:behome/services/auth_service.dart';
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

  final totalAmountController = TextEditingController(text: 'R\$0.00');
  final fixedExpensesController = TextEditingController(text: 'R\$0.00');

  String totalAmount = 'R\$0,00';
  String fixedExpenses = 'R\$0,00';
  double initialY = -1;
  double currentY = -1;

  void_onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      currentY = details.localPosition.dy;
    });
  }

  void _onVerticalDragEnd(_) {
    setState(() {
      initialY = currentY;
    });
  }

  void incrementTotalAmount(String value) {
    setState(() {
      totalAmount = value;
    });
  }

  void incrementFixedExpenses(String value) {
    setState(() {
      fixedExpenses = value;
    });
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
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const SizedBox(height: 40),
                IconButton(
                  onPressed: logout,
                  icon: const Icon(Icons.logout, color: Colors.white, size: 40),
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
                          image:
                              AssetImage('assets/images/logo_behome_white.png'),
                          width: 40,
                        ),
                      ),
                      Text(
                        'Crie seu BeHome',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      //Total amount
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Gastos Totais",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      totalAmount,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      // Fixed expenses
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Gastos Fixos",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      totalAmount,
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Expanded(
                    child: DraggableScrollableSheet(
                  maxChildSize: 1.0,
                  minChildSize: 0.9,
                  initialChildSize: 0.9,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        child: ListView(
                          controller: scrollController,
                          padding: EdgeInsets.only(top: 15),
                          children: [
                            Padding(
                              // Residents
                              padding: EdgeInsets.all(20),
                              child: Container(
                                height: MediaQuery.of(context).size.height * .1,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            // Container for residents
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              // Expenses
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Despesas Recente",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ));
                  },
                ))
              ]))),
    ));
  }
}
