import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/provider/tasks.dart';

class TaskForm extends StatefulWidget {
  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, String?> _formData = {};
  String address = '';
  double? latitude;
  double? longitude;
  Position? _currentLocation;
  bool servicePermission = false;
  late LocationPermission permission;
  String _currentAddress = "";

  void _loadFormData(Task? task) {
    if (task != null) {
      _formData['id'] = task.id;
      _formData['name'] = task.name;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final task = ModalRoute.of(context)?.settings.arguments as Task?;
    _loadFormData(task);
  }

  Future<void> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {}
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    setState(() async {
      _currentLocation = await Geolocator.getCurrentPosition();
      await _getAddressFromCoordinates();
    });
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Tarefa'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final formState = _form.currentState;
              if (formState != null && formState.validate()) {
                formState.save();
                final now = DateTime.now();
                final location = _currentAddress;
                Provider.of<Tasks>(context, listen: false).put(Task(
                  id: _formData['id'] ?? '',
                  name: _formData['name'] ?? '',
                  createdAt: now,
                  location: location,
                ));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: _formData['name'],
                  decoration:
                      const InputDecoration(labelText: 'Nome da Tarefa'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Tarefa inválida';
                    }
                    if (value.trim().length < 3) {
                      return 'Tarefa muito pequena. No mínimo 3 caracteres.';
                    }
                    return null;
                  },
                  onSaved: (value) => _formData['name'] = value,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Coordenadas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  _currentLocation != null
                      ? "Latitude = ${_currentLocation!.latitude}, Longitude = ${_currentLocation!.longitude} "
                      : "Clique em obter localização para obter as coordenadas",
                ),
                const SizedBox(height: 10),
                const Text(
                  'Endereço',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(_currentAddress),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _getCurrentLocation(),
                  child: const Text('Obter Localização'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}