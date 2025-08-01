import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';

import '../services/data_service.dart';
import '../l10n/app_localizations.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'product_details_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final Category category;
  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _products = [];

  bool _isLoading = true;
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; });
    final allProducts = await DataService.getProducts();
    
    setState(() {
      _products = allProducts.where((p) => p.categoryId == widget.category.id).toList();

      _isLoading = false;
    });
  }

  Future<void> _addProduct() async {
    final result = await showDialog<Product>(
      context: context,
              builder: (context) => AddProductDialog(
          category: widget.category,
        ),
    );
    if (result != null) {
      await DataService.addProduct(result);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final lightPurple = Color(0xFFF3F0FF);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        title: Row(
          children: [
            widget.category.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.category.imagePath!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    IconData(widget.category.iconCodePoint, fontFamily: 'MaterialIcons'),
                    color: purple,
                    size: 32,
                  ),
            const SizedBox(width: 12),
            Text(
              _selectedLanguage == 'ar' ? widget.category.nameAr : widget.category.nameEn,
              style: TextStyle(color: purple, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: purple),
            tooltip: l10n.add_product,
            onPressed: _addProduct,
          ),
        ],
        iconTheme: IconThemeData(color: purple),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: purple))
          : _products.isEmpty
              ? Center(
                  child: Text(
                    l10n.no_products_in_category,
                    style: TextStyle(color: purple, fontSize: 18),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ProductCard(
                      product: product,
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: product,
                      
                            ),
                          ),
                        );
                        if (updated != null) _loadData();
                      },
                    );
                  },
                ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: purple.withOpacity(0.07),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: purple.withOpacity(0.08)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            product.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      product.imagePath!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: purple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.image, color: purple, size: 32),
                  ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: purple),
                  ),
                  if (product.price != null)
                    Text(
                      l10n.price_with_currency(product.price.toString(), product.currency ?? ''),
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: purple, size: 18),
          ],
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  final Category category;
  const AddProductDialog({super.key, required this.category});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _priceController = TextEditingController();
  final _currencyController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedUnit;
  String? _imagePath;
  String? _videoPath;
  bool _isSaving = false;

  final List<String> _units = ['كيلو', 'باكيت', 'لتر', 'كارتونة', 'زجاجة'];

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
    return AlertDialog(
      title: Text(l10n.add_product, style: TextStyle(color: purple)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // صورة المنتج
              GestureDetector(
                onTap: _pickImage,
                child: _imagePath == null
                    ? Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: purple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.add_a_photo, color: purple, size: 32),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_imagePath!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              // فيديو المنتج
              GestureDetector(
                onTap: _pickVideo,
                child: _videoPath == null
                    ? Container(
                        width: 80,
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameArController,
                decoration: InputDecoration(
                  labelText: l10n.product_name_ar,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.enter_product_name_ar : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameEnController,
                decoration: InputDecoration(
                  labelText: l10n.product_name_en,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.enter_product_name_en : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: l10n.price,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? l10n.enter_price : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _currencyController,
                decoration: InputDecoration(
                  labelText: l10n.currency,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.enter_currency : null,
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
                validator: (value) => value == null || value.isEmpty ? l10n.choose_unit : null,
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : () async {
            if (_formKey.currentState!.validate()) {
              setState(() { _isSaving = true; });
              final product = Product(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: _nameArController.text.trim(),
                nameEn: _nameEnController.text.trim(),
                categoryId: widget.category.id,
                imagePath: _imagePath,
                videoPath: _videoPath,
                price: double.tryParse(_priceController.text),
                currency: _currencyController.text.trim(),
                unit: _selectedUnit!,
                template: '', // سيتم تعيين القالب من صفحة القوالب
                description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
              );
              setState(() { _isSaving = false; });
              Navigator.pop(context, product);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7C3AED)),
          child: _isSaving ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(l10n.add),
        ),
      ],
    );
  }
} 