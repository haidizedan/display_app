import 'package:flutter/material.dart';
import '../models/device.dart';
import '../models/template.dart';
import '../models/product.dart';
import '../services/data_service.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailsScreen({
    super.key,
    required this.device,
  });

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  String? _selectedTemplateId;
  String? _selectedProductId;
  bool _isConnected = true;
  bool _isEditingName = false;
  bool _isSyncing = false;
  List<Template> _templates = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _descController = TextEditingController(text: widget.device.description ?? '');
    _selectedTemplateId = widget.device.templateId;
    _selectedProductId = widget.device.productId;
    _loadData();
  }

  Future<void> _loadData() async {
    final templates = await DataService.getTemplates();
    final products = await DataService.getProducts();
    setState(() {
      _templates = templates;
      _products = products;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _syncDevice() async {
    setState(() { _isSyncing = true; });
    final updated = widget.device.copyWith(
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      templateId: _selectedTemplateId,
      productId: _selectedProductId,
    );
    await DataService.updateDevice(updated);
    setState(() { _isSyncing = false; });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت مزامنة البيانات مع الشاشة بنجاح!'), backgroundColor: Colors.purple),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final lightPurple = Color(0xFFF3F0FF);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // أيقونة الجهاز واسم الجهاز
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      color: lightPurple,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: purple.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: purple.withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(28),
                            child: Icon(
                              Icons.devices,
                              color: purple,
                              size: 56,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _isEditingName
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: TextField(
                                        controller: _nameController,
                                        autofocus: true,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 22, color: purple, fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onSubmitted: (_) => setState(() => _isEditingName = false),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.check, color: purple),
                                      onPressed: () => setState(() => _isEditingName = false),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _nameController.text,
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: purple,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit, color: purple, size: 20),
                                      onPressed: () => setState(() => _isEditingName = true),
                                      tooltip: 'تعديل الاسم',
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _isConnected ? Colors.green : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _isConnected ? 'متصل' : 'غير متصل',
                                style: TextStyle(
                                  color: _isConnected ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // بيانات الجهاز
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _infoCard(
                            icon: Icons.wifi,
                            label: 'IP',
                            value: widget.device.ipAddress,
                            purple: purple,
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            icon: Icons.bluetooth,
                            label: 'MAC',
                            value: widget.device.macAddress,
                            purple: purple,
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            icon: Icons.access_time,
                            label: 'آخر ظهور',
                            value: '${widget.device.lastSeen.day}/${widget.device.lastSeen.month}/${widget.device.lastSeen.year}',
                            purple: purple,
                          ),
                          const SizedBox(height: 12),
                          // وصف الجهاز
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: purple.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: purple.withOpacity(0.08)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.description, color: purple, size: 22),
                                    const SizedBox(width: 10),
                                    Text('الوصف', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 15)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _descController,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'أضف وصف للجهاز...',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // اختيار القالب
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: purple.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: purple.withOpacity(0.08)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.dashboard_customize, color: purple, size: 22),
                                const SizedBox(width: 10),
                                Text('القالب', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: _selectedTemplateId,
                                    isExpanded: true,
                                    hint: Text('اختر القالب'),
                                    items: _templates.map((t) => DropdownMenuItem(
                                      value: t.id,
                                      child: Text(t.name),
                                    )).toList(),
                                    onChanged: (val) => setState(() => _selectedTemplateId = val),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          // اختيار المنتج
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: purple.withOpacity(0.07),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: purple.withOpacity(0.08)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.shopping_bag, color: purple, size: 22),
                                const SizedBox(width: 10),
                                Text('المنتج', style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 15)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: _selectedProductId,
                                    isExpanded: true,
                                    hint: Text('اختر المنتج'),
                                    items: _products.map((p) => DropdownMenuItem(
                                      value: p.id,
                                      child: Text(p.name),
                                    )).toList(),
                                    onChanged: (val) => setState(() => _selectedProductId = val),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // أزرار الإجراءات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSyncing ? null : _syncDevice,
                      icon: _isSyncing
                          ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Icon(Icons.sync, color: Colors.white),
                      label: Text(_isSyncing ? 'جاري المزامنة...' : 'مزامنة مع الشاشة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('حذف الجهاز'),
                            content: const Text('هل أنت متأكد من حذف هذا الجهاز؟'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'حذف',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          await DataService.deleteDevice(widget.device.id);
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: Icon(Icons.delete, color: purple),
                      label: Text('حذف الجهاز', style: TextStyle(color: purple)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: purple, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color purple,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: purple.withOpacity(0.07),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: purple.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: purple, size: 22),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: TextStyle(
              color: purple,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 