import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../services/data_service.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  List<Product> _products = [];
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _titleController.text = 'عرض المنتجات';
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await DataService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _sendToDisplay() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار منتج للعرض')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('display').doc('screen1').set({
        'title': _titleController.text.trim(),
        'text': '${_selectedProduct!.name}\nالسعر: ${_selectedProduct!.price} ${_selectedProduct!.currency}\nالوحدة: ${_selectedProduct!.unit}',
        'timestamp': FieldValue.serverTimestamp(),
        'backgroundColor': '#7C3AED',
        'textColor': '#FFFFFF',
        'fontSize': 32,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال المنتج للشاشة بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الإرسال: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendRandomProduct() async {
    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد منتجات متاحة')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final randomProduct = _products[DateTime.now().millisecondsSinceEpoch % _products.length];
      await FirebaseFirestore.instance.collection('display').doc('screen1').set({
        'title': 'منتج عشوائي',
        'text': '${randomProduct.name}\nالسعر: ${randomProduct.price} ${randomProduct.currency}\nالوحدة: ${randomProduct.unit}',
        'timestamp': FieldValue.serverTimestamp(),
        'backgroundColor': '#4CAF50',
        'textColor': '#FFFFFF',
        'fontSize': 28,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم عرض منتج عشوائي!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الإرسال: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearDisplay() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('display').doc('screen1').set({
        'title': '',
        'text': '',
        'timestamp': FieldValue.serverTimestamp(),
        'backgroundColor': '#000000',
        'textColor': '#FFFFFF',
        'fontSize': 32,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم مسح الشاشة!'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في المسح: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جهاز التحكم'),
        backgroundColor: Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 200,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إعدادات الشاشة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'عنوان الشاشة',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'اختر منتج للعرض',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_products.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'لا توجد منتجات متاحة',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return ListTile(
                                title: Text(product.name),
                                subtitle: Text('${product.price} ${product.currency} - ${product.unit}'),
                                selected: _selectedProduct?.id == product.id,
                                onTap: () {
                                  setState(() {
                                    _selectedProduct = product;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _sendToDisplay,
                icon: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.send),
                label: Text(_isLoading ? 'جاري الإرسال...' : 'عرض المنتج على الشاشة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _sendRandomProduct,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('منتج عشوائي'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _clearDisplay,
                      icon: const Icon(Icons.clear),
                      label: const Text('مسح الشاشة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تعليمات الاستخدام:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• اختر منتج من القائمة واضغط "عرض المنتج على الشاشة"\n'
                            '• استخدم "منتج عشوائي" لعرض منتج عشوائي\n'
                            '• استخدم "مسح الشاشة" لتنظيف العرض\n'
                            '• تأكد من أن جهاز العرض متصل بالإنترنت',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
