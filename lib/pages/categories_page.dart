import 'package:flutter/material.dart';
import './category_register_page.dart';
import '../models/categories_model.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final List<CategoriesModel> categoriesList = [
    CategoriesModel(
        //Trocar essa lista fixa por uma com os fetches do firebase
        id: "0",
        title: "Fast Food",
        icon: Icons.brunch_dining_outlined),
    CategoriesModel(id: "1", title: "Cinema", icon: Icons.music_note_outlined),
    CategoriesModel(id: "2", title: "Reforma", icon: Icons.build),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Categorias",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              categoriesList.isEmpty
                  ? Column(
                      children: [
                        const Center(
                          heightFactor: 18,
                          child: Text(
                            'Nenhuma Transação Cadastrada!',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                        ),
                        const SizedBox(height: 40),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            height: 40,
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) =>
                                            CategoryRegisterPage()));
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Nova Transação',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(8, 85, 255, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: categoriesList.length,
                      itemBuilder: (ctx, index) {
                        final categoryCard = categoriesList[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  const Color.fromRGBO(8, 85, 255, 1),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      categoryCard.icon,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            title: Text(categoryCard.title),
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 120),
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => CategoryRegisterPage()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Nova Transação',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(8, 85, 255, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
