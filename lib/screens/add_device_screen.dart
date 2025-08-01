import 'package:flutter/material.dart';
import '../models/device.dart';
import '../services/data_service.dart';
import '../services/device_connection_service.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  final _macController = TextEditingController();
  bool _isConnecting = false;
  String _connectionStatus = '';

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _macController.dispose();
    super.dispose();
  }

  Future<void> _connectToDevice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isConnecting = true;
      _connectionStatus = 'جاري الاتصال بالجهاز...';
    });

    try {
      // Simulate device connection
      await Future.delayed(const Duration(seconds: 2));
      
      final device = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        ipAddress: _ipController.text,
        macAddress: _macController.text,
        status: 'متصل',
        lastSeen: DateTime.now(),
      );

      await DataService.addDevice(device);

      setState(() {
        _connectionStatus = 'تم الاتصال بنجاح!';
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'فشل في الاتصال بالجهاز';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple[400]!, Colors.purple[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'إضافة جهاز جديد',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Device Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.devices,
                        size: 64,
                        color: Colors.purple[400],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Device Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم الجهاز',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.devices),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم الجهاز';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // IP Address
                    TextFormField(
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: 'عنوان IP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.wifi),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال عنوان IP';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // MAC Address
                    TextFormField(
                      controller: _macController,
                      decoration: InputDecoration(
                        labelText: 'عنوان MAC (اختياري)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.bluetooth),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Connection Status
                    if (_connectionStatus.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _connectionStatus.contains('نجح') 
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _connectionStatus.contains('نجح') 
                                ? Colors.green 
                                : Colors.red,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _connectionStatus.contains('نجح') 
                                  ? Icons.check_circle 
                                  : Icons.error,
                              color: _connectionStatus.contains('نجح') 
                                  ? Colors.green 
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _connectionStatus,
                                style: TextStyle(
                                  color: _connectionStatus.contains('نجح') 
                                      ? Colors.green 
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Connect Button
                    ElevatedButton(
                      onPressed: _isConnecting ? null : _connectToDevice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: _isConnecting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('جاري الاتصال...'),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.wifi),
                                SizedBox(width: 8),
                                Text(
                                  'الاتصال بالجهاز',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Cancel Button
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 