import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';

import '../services/data_service.dart';
import '../l10n/app_localizations.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _priceController;
  late TextEditingController _currencyController;
  late TextEditingController _descController;
  String? _selectedUnit;

  String? _imagePath;
  String? _videoPath;
  bool _isSaving = false;

  final List<String> _units = ['كيلو', 'باكيت', 'لتر', 'كارتونة', 'زجاجة'];

  @override
  void initState() {
    super.initState();
    _nameArController = TextEditingController(text: widget.product.name);
    _nameEnController = TextEditingController(text: widget.product.nameEn ?? '');
    _priceController = TextEditingController(text: widget.product.price?.toString() ?? '');
    _currencyController = TextEditingController(text: widget.product.currency ?? '');
    _descController = TextEditingController(text: widget.product.description ?? '');
    _selectedUnit = widget.product.unit;

    _imagePath = widget.product.imagePath;
    _videoPath = widget.product.videoPath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _videoPath = picked.path;
      });
    }
  }

  Future<void> _save() async {
    setState(() { _isSaving = true; });
    final updated = widget.product.copyWith(
      name: _nameArController.text.trim(),
      nameEn: _nameEnController.text.trim(),
      price: double.tryParse(_priceController.text),
      currency: _currencyController.text.trim(),
      unit: _selectedUnit,
      template: widget.product.template, // الاحتفاظ بالقيمة الأصلية
      imagePath: _imagePath,
      videoPath: _videoPath,
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
    );
    await DataService.updateProduct(updated);
    setState(() { _isSaving = false; });
    if (mounted) Navigator.pop(context, updated);
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _priceController.dispose();
    _currencyController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F0FF),
        elevation: 0,
        title: Text(l10n.product_details, style: TextStyle(color: purple)),
        iconTheme: IconThemeData(color: purple),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المنتج
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: _imagePath == null
                    ? Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: purple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.add_a_photo, color: purple, size: 36),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_imagePath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // فيديو المنتج
            Center(
              child: GestureDetector(
                onTap: _pickVideo,
                child: _videoPath == null
                    ? Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: purple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.video_library, color: purple, size: 28),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam, color: purple),
                          const SizedBox(width: 8),
                          Text(l10n.video_selected, style: TextStyle(color: purple)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameArController,
              decoration: InputDecoration(
                labelText: l10n.product_name_ar,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameEnController,
              decoration: InputDecoration(
                labelText: l10n.product_name_en,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: l10n.price,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _currencyController,
              decoration: InputDecoration(
                labelText: l10n.currency,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: InputDecoration(
                labelText: l10n.unit,
                border: OutlineInputBorder(),
              ),
              items: _units.map((unit) => DropdownMenuItem(
                value: unit,
                child: Text(unit),
              )).toList(),
              onChanged: (val) => setState(() => _selectedUnit = val),
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: l10n.product_description_optional,
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Icon(Icons.save, color: Colors.white),
              label: Text(l10n.save_changes),
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
          ],
        ),
      ),
    );
  }
} 