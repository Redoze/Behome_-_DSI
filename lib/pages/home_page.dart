import 'package:behome/pages/gastos_page.dart';
import 'package:behome/pages/settings_page.dart';
import 'package:behome/services/auth_service.dart';
import 'package:behome/services/expense_service.dart';
import 'package:behome/styles/text_styles.dart';
import 'package:behome/widgets/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(8, 85, 255, 1), // End color
              Color.fromRGBO(8, 85, 255, 1), // Start color
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HomeHeader(
                onSettingsPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const SettingsPage()));
                },
              ),
              const HouseInfo(),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0), // Top left corner radius
                      topRight:
                          Radius.circular(24.0), // Top right corner radius
                    ),
                  ),
                  // You can add padding, margin, etc., as needed.
                  // Add your content or other widgets inside the Container.
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gastos Recentes",
                          style: AppTextStyles.title
                              .copyWith(color: Colors.black54),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const GastosPage()));
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Adicionar Gasto"),
                                Icon(Icons.add),
                              ],
                            )),
                        const ExpensesList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  final VoidCallback
      onSettingsPressed; // Step 1: Define a variable for the function

  const HomeHeader({
    super.key,
    required this.onSettingsPressed, // Require the function to be passed as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Image(
            image: AssetImage('assets/images/logo_behome_white.png'),
            width: 40,
          ),
          const SizedBox(width: 20),
          const Text(
            "Seu BeHome",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onSettingsPressed,
            icon: const Icon(
              Icons.settings,
              size: 28,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class HouseInfo extends StatelessWidget {
  const HouseInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              color: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            const SizedBox(width: 20),
            Text(DateFormat("MMMM").format(DateTime.now()).toString(),
                style: AppTextStyles.label),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {},
              color: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text("Gastos Totais", style: AppTextStyles.title),
        // const Text("RS 3.530,40", style: AppTextStyles.largeTitle),
        const ExpenseTotalValue(),
        const Text("Gastos Fixos", style: AppTextStyles.description),
        const Text("RS 1200,0", style: AppTextStyles.description)
      ],
    );
  }
}

class ExpenseTotalValue extends StatelessWidget {
  const ExpenseTotalValue({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    FirestoreService firestoreService = FirestoreService();

    // Check if the user is not null
    if (authService.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    String homeId = authService.user!.uid;

    return StreamBuilder<double>(
      stream: firestoreService.calculateTotalExpenses(homeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (snapshot.hasError) {
          return Text(
              'Error: ${snapshot.error}'); // Show error message if any error occurs
        }

        if (!snapshot.hasData) {
          return const Text(
              'No data available'); // Handle the case when there's no data
        }

        double totalExpenses = snapshot.data ?? 0;

        return Text(
            NumberFormat.currency(
              locale: 'pt_BR',
              symbol: 'R\$',
            ).format(totalExpenses),
            style: AppTextStyles.largeTitle); // Display the total expenses
      },
    );
  }
}
