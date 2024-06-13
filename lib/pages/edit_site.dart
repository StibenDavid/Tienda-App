import 'package:flutter/material.dart';
import 'package:shopping_list_app/services/firebase_serviceSite.dart'; // Importa tu servicio de Firebase

class EditSite extends StatefulWidget {
  const EditSite({Key? key}) : super(key: key);

  @override
  State<EditSite> createState() => _EditSiteState();
}

class _EditSiteState extends State<EditSite> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late bool _isUpdating;
  late bool _isNameValid;
  late bool _isDateValid;

  @override
  void initState() {
    super.initState();
    _isUpdating = false;
    _isNameValid = true;
    _isDateValid = true;
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void actualizarSitio() async {
    setState(() {
      _isUpdating = true;
    });

    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String id = arguments['siteId'];
    final String nombre = nameController.text;
    final String fecha = dateController.text;

    if (_validateFields(nombre, fecha)) {
      await updateSite(id, nombre, fecha);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sitio actualizado con éxito')),
      );

      setState(() {
        _isNameValid = true;
        _isDateValid = true;
        _isUpdating = false;
      });
    } else {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  bool _validateFields(String nombre, String fecha) {
    bool isValid = true;

    if (nombre.isEmpty) {
      setState(() {
        _isNameValid = false;
      });
      isValid = false;
    }

    if (fecha.isEmpty) {
      setState(() {
        _isDateValid = false;
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    nameController.text = arguments['name'] ?? '';
    dateController.text = arguments['date'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Sitio"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey[300]!],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24.0),
              TextField(
                controller: TextEditingController(text: arguments['siteId']),
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'ID del sitio',
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nuevo nombre del sitio',
                    errorText: _isNameValid ? null : 'Campo requerido',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Nueva fecha del sitio',
                    errorText: _isDateValid ? null : 'Campo requerido',
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isUpdating ? null : actualizarSitio,
                child: _isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text("Actualizar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
