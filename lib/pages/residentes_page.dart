import 'dart:typed_data';
import 'package:behome/models/person_model.dart';
import 'package:behome/services/person_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddPersonPage extends StatefulWidget {
  const AddPersonPage({Key? key}) : super(key: key);

  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final imagePicker = ImagePicker();
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Pessoa'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da pessoa';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: imageBytes != null
                      ? MemoryImage(imageBytes!)
                      : null,
                  child: imageBytes == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate() && imageBytes != null) {
                    _submitPerson();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Por favor, preencha todos os campos",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: const Text('Salvar Pessoa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  void _submitPerson() async {
    final name = nameController.text;
    final person = PersonModel(
      name: name,
    );

    try {
      await PersonService().createPerson(person);
      Navigator.pop(context); // Voltar para a tela anterior
      Fluttertoast.showToast(
        msg: "Pessoa adicionada com sucesso!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro ao adicionar pessoa: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}

