import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/data_service.dart';
import '../l10n/app_localizations.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() { _isLoading = true; });
    final products = await DataService.getProducts();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    final templates = [
      {
        'title': l10n.template1_title,
        'desc': l10n.template1_desc,
        'onTap': () => showDialog(
          context: context,
          builder: (_) => Template1Dialog(products: _products),
        ),
      },
      {
        'title': l10n.template2_title,
        'desc': l10n.template2_desc,
        'onTap': () => showDialog(
          context: context,
          builder: (_) => Template2Dialog(products: _products),
        ),
      },
      {
        'title': l10n.template3_title,
        'desc': l10n.template3_desc,
        'onTap': () => showDialog(
          context: context,
          builder: (_) => Template3Dialog(products: _products),
        ),
      },
      {
        'title': l10n.template4_title,
        'desc': l10n.template4_desc,
        'onTap': () => showDialog(
          context: context,
          builder: (_) => Template4Dialog(products: _products),
        ),
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(l10n.templates, style: TextStyle(color: purple)),
        iconTheme: IconThemeData(color: purple),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: purple))
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: templates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, i) {
                final t = templates[i];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                    title: Text(t['title'] as String, style: TextStyle(color: purple, fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(t['desc'] as String, style: TextStyle(color: purple.withOpacity(0.7))),
                    ),
                    trailing: Icon(Icons.edit, color: purple),
                    onTap: t['onTap'] as void Function(),
                  ),
                );
              },
            ),
    );
  }
}

// قالب 1: فيديو فقط مع نص
class Template1Dialog extends StatefulWidget {
  final List<Product> products;
  const Template1Dialog({super.key, required this.products});
  @override
  State<Template1Dialog> createState() => _Template1DialogState();
}
class _Template1DialogState extends State<Template1Dialog> {
  String? _selectedProductId;
  String? _videoPath;
  String? _overlayText;
  final _textController = TextEditingController();
  @override
  void dispose() { _textController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    final videoProducts = widget.products.where((p) => p.videoPath != null && p.videoPath!.isNotEmpty).toList();
    return AlertDialog(
      title: Text(l10n.edit_template1, style: TextStyle(color: purple)),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProductId,
              decoration: InputDecoration(
                labelText: l10n.choose_product_for_video,
                border: OutlineInputBorder(),
              ),
              items: videoProducts.map((p) => DropdownMenuItem(
                value: p.id,
                child: Text(p.name),
              )).toList(),
              onChanged: (val) => setState(() {
                _selectedProductId = val;
                _videoPath = videoProducts.firstWhere((p) => p.id == val).videoPath;
              }),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: l10n.text_appears_above_video,
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _overlayText = val),
            ),
            const SizedBox(height: 24),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: purple.withOpacity(0.08)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _videoPath != null
                      ? Center(
                          child: Icon(Icons.ondemand_video, size: 80, color: purple.withOpacity(0.2)),
                        )
                      : Center(
                          child: Text(l10n.choose_video_from_product_to_display_here, style: TextStyle(color: purple)),
                        ),
                  if (_overlayText != null && _overlayText!.isNotEmpty)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _overlayText!,
                          style: TextStyle(
                            color: purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
      ],
    );
  }
}

// قالب 2: صورة فقط مع سعر قبل وبعد التخفيض ونص اختياري
class Template2Dialog extends StatefulWidget {
  final List<Product> products;
  const Template2Dialog({super.key, required this.products});
  @override
  State<Template2Dialog> createState() => _Template2DialogState();
}
class _Template2DialogState extends State<Template2Dialog> {
  String? _selectedProductId;
  String? _imagePath;
  final _priceBeforeController = TextEditingController();
  final _priceAfterController = TextEditingController();
  final _textController = TextEditingController();
  @override
  void dispose() { _priceBeforeController.dispose(); _priceAfterController.dispose(); _textController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    final imageProducts = widget.products.where((p) => p.imagePath != null && p.imagePath!.isNotEmpty).toList();
    return AlertDialog(
      title: Text(l10n.edit_template2, style: TextStyle(color: purple)),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProductId,
              decoration: InputDecoration(
                labelText: l10n.choose_product_for_image,
                border: OutlineInputBorder(),
              ),
              items: imageProducts.map((p) => DropdownMenuItem(
                value: p.id,
                child: Text(p.name),
              )).toList(),
              onChanged: (val) => setState(() {
                _selectedProductId = val;
                _imagePath = imageProducts.firstWhere((p) => p.id == val).imagePath;
              }),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceBeforeController,
              decoration: InputDecoration(
                labelText: l10n.price_before_discount,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceAfterController,
              decoration: InputDecoration(
                labelText: l10n.price_after_discount,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: l10n.optional_text,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: purple.withOpacity(0.08)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(_imagePath!, width: 120, height: 120, fit: BoxFit.cover),
                        )
                      : Text(l10n.choose_image_from_product_to_display_here, style: TextStyle(color: purple)),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Column(
                      children: [
                        if (_priceBeforeController.text.isNotEmpty)
                          Text('${l10n.before}: ${_priceBeforeController.text}', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.red, fontWeight: FontWeight.bold)),
                        if (_priceAfterController.text.isNotEmpty)
                          Text('${l10n.after}: ${_priceAfterController.text}', style: TextStyle(color: purple, fontWeight: FontWeight.bold)),
                        if (_textController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(_textController.text, style: TextStyle(color: purple)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
      ],
    );
  }
}

// قالب 3: بيانات منتج (صورة + باركود + اسم + سعر + سعر بعد تخفيض + وصف)
class Template3Dialog extends StatefulWidget {
  final List<Product> products;
  const Template3Dialog({super.key, required this.products});
  @override
  State<Template3Dialog> createState() => _Template3DialogState();
}
class _Template3DialogState extends State<Template3Dialog> {
  String? _selectedProductId;
  Product? _selectedProduct;
  final _priceAfterController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  @override
  void dispose() { _priceAfterController.dispose(); _barcodeController.dispose(); _nameController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.edit_template3, style: TextStyle(color: purple)),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProductId,
              decoration: InputDecoration(
                labelText: l10n.choose_product,
                border: OutlineInputBorder(),
              ),
              items: widget.products.map((p) => DropdownMenuItem(
                value: p.id,
                child: Text(p.name),
              )).toList(),
              onChanged: (val) => setState(() {
                _selectedProductId = val;
                _selectedProduct = widget.products.firstWhere((p) => p.id == val);
                _barcodeController.text = _selectedProduct?.id ?? '';
                _nameController.text = _selectedProduct?.name ?? '';
              }),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: l10n.product_barcode,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.product_name,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceAfterController,
              decoration: InputDecoration(
                labelText: l10n.price_after_discount,
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: purple.withOpacity(0.08)),
              ),
              child: _selectedProduct == null
                  ? Center(child: Text(l10n.choose_product_to_display_its_data, style: TextStyle(color: purple)))
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          _selectedProduct!.imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(_selectedProduct!.imagePath!, width: 60, height: 60, fit: BoxFit.cover),
                                )
                              : Container(width: 60, height: 60, color: purple.withOpacity(0.08), child: Icon(Icons.image, color: purple)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_nameController.text, style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                                if (_selectedProduct!.price != null)
                                  Text('${l10n.price}: ${_selectedProduct!.price}', style: TextStyle(color: purple)),
                                if (_priceAfterController.text.isNotEmpty)
                                  Text('${l10n.after_discount}: ${_priceAfterController.text}', style: TextStyle(color: Colors.red)),
                                if (_selectedProduct!.description != null)
                                  Text(_selectedProduct!.description!, style: TextStyle(color: purple.withOpacity(0.7))),
                                // باركود (يدوي)
                                Text('${l10n.barcode}: ${_barcodeController.text}', style: TextStyle(fontSize: 12, color: purple.withOpacity(0.7))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
      ],
    );
  }
}

// قالب 4: منتجان (صورتان + سعر وسعر بعد تخفيض ووصف واسم المنتجين)
class Template4Dialog extends StatefulWidget {
  final List<Product> products;
  const Template4Dialog({super.key, required this.products});
  @override
  State<Template4Dialog> createState() => _Template4DialogState();
}
class _Template4DialogState extends State<Template4Dialog> {
  String? _selectedProductId1;
  String? _selectedProductId2;
  Product? _product1;
  Product? _product2;
  final _priceAfter1Controller = TextEditingController();
  final _priceAfter2Controller = TextEditingController();
  @override
  void dispose() { _priceAfter1Controller.dispose(); _priceAfter2Controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.edit_template4, style: TextStyle(color: purple)),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedProductId1,
                    decoration: InputDecoration(
                      labelText: l10n.product1,
                      border: OutlineInputBorder(),
                    ),
                    items: widget.products.map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text(p.name),
                    )).toList(),
                    onChanged: (val) => setState(() {
                      _selectedProductId1 = val;
                      _product1 = widget.products.firstWhere((p) => p.id == val);
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedProductId2,
                    decoration: InputDecoration(
                      labelText: l10n.product2,
                      border: OutlineInputBorder(),
                    ),
                    items: widget.products.map((p) => DropdownMenuItem(
                      value: p.id,
                      child: Text(p.name),
                    )).toList(),
                    onChanged: (val) => setState(() {
                      _selectedProductId2 = val;
                      _product2 = widget.products.firstWhere((p) => p.id == val);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceAfter1Controller,
                    decoration: InputDecoration(
                      labelText: l10n.price_after_discount1,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _priceAfter2Controller,
                    decoration: InputDecoration(
                      labelText: l10n.price_after_discount2,
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: purple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: purple.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _product1 == null
                        ? Center(child: Text(l10n.product1, style: TextStyle(color: purple)))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _product1!.imagePath != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(_product1!.imagePath!, width: 50, height: 50, fit: BoxFit.cover),
                                      )
                                    : Container(width: 50, height: 50, color: purple.withOpacity(0.08), child: Icon(Icons.image, color: purple)),
                                Text(_product1!.name, style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                                if (_product1!.price != null)
                                  Text('${l10n.price}: ${_product1!.price}', style: TextStyle(color: purple)),
                                if (_priceAfter1Controller.text.isNotEmpty)
                                  Text('${l10n.after_discount}: ${_priceAfter1Controller.text}', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                  ),
                  Container(width: 1, color: purple.withOpacity(0.1), height: 120),
                  Expanded(
                    child: _product2 == null
                        ? Center(child: Text(l10n.product2, style: TextStyle(color: purple)))
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _product2!.imagePath != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(_product2!.imagePath!, width: 50, height: 50, fit: BoxFit.cover),
                                      )
                                    : Container(width: 50, height: 50, color: purple.withOpacity(0.08), child: Icon(Icons.image, color: purple)),
                                Text(_product2!.name, style: TextStyle(fontWeight: FontWeight.bold, color: purple)),
                                if (_product2!.price != null)
                                  Text('${l10n.price}: ${_product2!.price}', style: TextStyle(color: purple)),
                                if (_priceAfter2Controller.text.isNotEmpty)
                                  Text('${l10n.after_discount}: ${_priceAfter2Controller.text}', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
      ],
    );
  }
} 