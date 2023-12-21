import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({super.key});

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  String titulo = '';
  String residente = '';
  String categoria = '';
  bool isRecorrente = false;

  adicionarGasto() {
    // .
    // .
    // .
    // Lógica; print para testes.
    print('Titulo: $titulo, Residente: $residente, Categoria: $categoria, Recorrente: $isRecorrente');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Novo Gasto',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Adicionando o texto "Valor" na cor cinza
                    Text(
                      'Valor',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 145, 145, 145),
                      ),
                    ),
                  ],
                ),
              ),
              // Campos de texto
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) => titulo = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Titulo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) => residente = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Residente',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) => categoria = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Categoria',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // CupertinoSwitch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recorrente',
                          style: TextStyle(color: Colors.black),
                        ),
                        CupertinoSwitch(
                          value: isRecorrente,
                          onChanged: (value) {
                            setState(() {
                              isRecorrente = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ative esta opção caso o gasto seja fixo todos os meses.',
                      style: TextStyle(color: Color.fromARGB(255, 145, 145, 145)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: adicionarGasto,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('Adicionar Gasto'),
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
