import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/device.dart';
import '../services/data_service.dart';
import '../services/qr_service.dart';
import '../services/device_connection_service.dart';
import '../l10n/app_localizations.dart';
import 'qr_scanner_screen.dart';
import 'add_device_screen.dart';
import 'device_details_screen.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<Device> _devices = [];
  bool _isLoading = true;
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final devices = await DataService.getDevices();
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addDevice() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDeviceScreen()),
    );

    if (result == true) {
      _loadDevices();
    }
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (result != null) {
      // Handle QR code result
      _handleQRCodeResult(result);
    }
  }

  void _handleQRCodeResult(String qrData) {
    // Parse QR code data and add device
    try {
      final deviceData = Map<String, dynamic>.from(
        Map.fromEntries(qrData.split('&').map((pair) {
          final parts = pair.split('=');
          return MapEntry(parts[0], parts[1]);
        })),
      );

      final device = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: deviceData['name'] ?? 'جهاز جديد',
        ipAddress: deviceData['ip'] ?? '',
        macAddress: deviceData['mac'] ?? '',
        status: 'متصل',
        lastSeen: DateTime.now(),
      );

      DataService.addDevice(device);
      _loadDevices();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedLanguage == 'ar' ? 'تم إضافة الجهاز بنجاح' : 'Device added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedLanguage == 'ar' ? 'خطأ في قراءة رمز QR' : 'Error reading QR code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteDevice(Device device) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedLanguage == 'ar' ? 'حذف الجهاز' : 'Delete Device'),
        content: Text(
          _selectedLanguage == 'ar' 
            ? 'هل أنت متأكد من حذف هذا الجهاز؟'
            : 'Are you sure you want to delete this device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_selectedLanguage == 'ar' ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              _selectedLanguage == 'ar' ? 'حذف' : 'Delete',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DataService.deleteDevice(device.id);
      _loadDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                Text(
                  l10n.devices,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                // QR Scanner Button
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _scanQRCode,
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 24),
                    tooltip: l10n.scan_qr_code,
                  ),
                ),
                // Add Device Button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _addDevice,
                    icon: const Icon(Icons.add, color: Colors.white, size: 28),
                    tooltip: l10n.add_device,
                  ),
                ),
              ],
            ),
          ),

          // Devices List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                : _devices.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            const SizedBox(height: 16),
                            Text(
                              _selectedLanguage == 'ar' 
                                ? 'لا توجد أجهزة متصلة'
                                : 'No devices connected',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedLanguage == 'ar' 
                                ? 'اضغط على + لإضافة جهاز جديد'
                                : 'Tap + to add a new device',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          final device = _devices[index];
                          return DeviceCard(
                            device: device,
                            selectedLanguage: _selectedLanguage,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeviceDetailsScreen(device: device),
                                ),
                              );
                            },
                            onDelete: () => _deleteDevice(device),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final Device device;
  final String selectedLanguage;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DeviceCard({
    super.key,
    required this.device,
    required this.selectedLanguage,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple[400]!,
                Colors.purple[600]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.devices,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          device.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'IP: ${device.ipAddress}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: device.status == 'متصل' ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  device.status,
                  style: TextStyle(
                    color: device.status == 'متصل' ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: selectedLanguage == 'ar' ? 'حذف الجهاز' : 'Delete Device',
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 