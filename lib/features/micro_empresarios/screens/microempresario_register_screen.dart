import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import 'ine_scanner_screen.dart';

class MicroempresarioRegisterScreen extends StatefulWidget {
  final int userId;
  
  const MicroempresarioRegisterScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MicroempresarioRegisterScreen> createState() => _MicroempresarioRegisterScreenState();
}

class _MicroempresarioRegisterScreenState extends State<MicroempresarioRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellido1Controller = TextEditingController();
  final _apellido2Controller = TextEditingController();
  final _correoController = TextEditingController();
  final _cpostalController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _selectedClientType;
  List<Map<String, dynamic>> _clientTypes = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadClientTypes();
  }

  Future<void> _loadClientTypes() async {
    try {
      developer.log('Cargando tipos de cliente');
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('tipo_cliente')
          .select()
          .order('id_cliente');
      
      developer.log('Tipos de cliente cargados: ${response.length}');
      
      setState(() {
        _clientTypes = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      developer.log('Error al cargar tipos de cliente: $e', error: e);
      setState(() {
        _errorMessage = 'Error al cargar tipos de cliente';
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      developer.log('Registrando nuevo microempresario');
      developer.log('Usuario ID: ${widget.userId}');
      
      final supabase = Supabase.instance.client;
      
      await supabase.from('microempresario').insert({
        'nombre': _nombreController.text,
        'apellido1': _apellido1Controller.text,
        'apellido2': _apellido2Controller.text,
        'correo': _correoController.text,
        'cpostal': int.parse(_cpostalController.text),
        'telefono': _telefonoController.text,
        'cliente': int.parse(_selectedClientType!),
        'password': _passwordController.text,
        'fecharegistros': DateTime.now().toIso8601String(),
        'id_usuario_registro': widget.userId,
        'cantidad_lecciones': 0, // Por defecto, el nuevo microempresario no tiene lecciones completadas
      });

      developer.log('Microempresario registrado exitosamente');

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microempresario registrado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpiar el formulario
      _formKey.currentState!.reset();
      _nombreController.clear();
      _apellido1Controller.clear();
      _apellido2Controller.clear();
      _correoController.clear();
      _cpostalController.clear();
      _telefonoController.clear();
      _passwordController.clear();
      setState(() {
        _selectedClientType = null;
      });

    } catch (e) {
      developer.log('Error al registrar microempresario: $e', error: e);
      setState(() {
        _errorMessage = 'Error al registrar microempresario: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Registro de usuario',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Información personal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Stack(
                    children: [
                      _buildTextField(
                        'Nombre',
                        controller: _nombreController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Por favor ingresa el nombre';
                          }
                          return null;
                        },
                        showCameraIcon: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Primer Apellido',
                    controller: _apellido1Controller,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa el primer apellido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Segundo Apellido',
                    controller: _apellido2Controller,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa el segundo apellido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Código Postal',
                    controller: _cpostalController,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa el código postal';
                      }
                      if (value!.length != 5) {
                        return 'El código postal debe tener 5 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Teléfono',
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa el teléfono';
                      }
                      if (value!.length != 10) {
                        return 'El teléfono debe tener 10 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Correo electrónico',
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa el correo electrónico';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                        return 'Por favor ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Contraseña',
                    controller: _passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Por favor ingresa la contraseña';
                      }
                      if (value!.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Registrar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool isPassword = false,
    TextInputType? keyboardType,
    int? maxLength,
    bool showCameraIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isPassword,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'Inter',
            ),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            counterText: '',
            suffixIcon: showCameraIcon
                ? IconButton(
                    icon: const Icon(Icons.photo_camera, color: Colors.blue),
                    onPressed: () => _navigateToINEScanner(),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _navigateToINEScanner() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => INEScannerScreen(
          onINEDataExtracted: (Map<String, String> ineData) {
            _nombreController.text = ineData['nombre'] ?? '';
            _apellido1Controller.text = ineData['apellido1'] ?? '';
            _apellido2Controller.text = ineData['apellido2'] ?? '';
            _cpostalController.text = ineData['codigoPostal'] ?? '';
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de cliente',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedClientType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: _clientTypes.map((type) {
            return DropdownMenuItem(
              value: type['id_cliente'].toString(),
              child: Text(type['tipo']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedClientType = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona un tipo de cliente';
            }
            return null;
          },
          hint: const Text('Selecciona tipo de cliente'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellido1Controller.dispose();
    _apellido2Controller.dispose();
    _correoController.dispose();
    _cpostalController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 