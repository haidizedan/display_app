import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/data_service.dart';
import '../l10n/app_localizations.dart';
import 'category_products_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String _selectedLanguage = 'ar';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() { _isLoading = true; });
    final cats = await DataService.getCategories();
    cats.sort((a, b) => a.order.compareTo(b.order));
    setState(() {
      _categories = cats;
      _isLoading = false;
    });
  }

  Future<void> _addCategory() async {
    try {
      print('Opening add category dialog...');
    final result = await showDialog<Category>(
      context: context,
      builder: (context) => AddCategoryDialog(),
    );
    if (result != null) {
        print('Adding category: ${result.nameAr}');
      await DataService.addCategory(result);
        print('Category added, reloading categories...');
      _loadCategories();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة القسم بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error in _addCategory: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء إضافة القسم'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final lightPurple = Color(0xFFF3F0FF);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: lightPurple,
              boxShadow: [
                BoxShadow(
                  color: purple.withOpacity(0.07),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              children: [
                Text(
                  l10n.categories,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _addCategory,
                    icon: Icon(Icons.add, color: Colors.white, size: 28),
                    tooltip: l10n.add_category,
                  ),
                ),
              ],
            ),
          ),
          // الأقسام
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: purple))
                : _categories.isEmpty
                    ? Center(child: Text('لا توجد أقسام', style: TextStyle(fontSize: 18, color: purple)))
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return CategoryCard(
                        category: cat,
                        selectedLanguage: _selectedLanguage,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryProductsScreen(category: cat),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final String selectedLanguage;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.selectedLanguage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            category.imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      category.imagePath!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                    size: 48,
                    color: purple,
                  ),
            const SizedBox(height: 16),
            Text(
              selectedLanguage == 'ar' ? category.nameAr : category.nameEn,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AddCategoryDialog extends StatefulWidget {
  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  int _selectedIcon = Icons.category.codePoint;
  String? _imagePath;

  final List<IconData> _iconOptions = [
    Icons.home,
    Icons.eco,
    Icons.apple,
    Icons.restaurant,
    Icons.set_meal,
    Icons.face,
    Icons.person,
    Icons.medical_services,
    Icons.devices,
    Icons.inventory,
    Icons.category,
  ];

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purple = Color(0xFF7C3AED);
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.add_category, style: TextStyle(color: purple)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameArController,
                decoration: InputDecoration(
                  labelText: l10n.category_name_ar,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.enter_category_name_ar : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameEnController,
                decoration: InputDecoration(
                  labelText: l10n.category_name_en,
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? l10n.enter_category_name_en : null,
              ),
              const SizedBox(height: 16),
              Text(l10n.choose_icon, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _iconOptions.map((icon) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon.codePoint),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _selectedIcon == icon.codePoint ? purple.withOpacity(0.15) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _selectedIcon == icon.codePoint ? purple : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(icon, color: purple, size: 28),
                    ),
                  );
                }).toList(),
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newCat = Category(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nameAr: _nameArController.text.trim(),
                nameEn: _nameEnController.text.trim(),
                iconCodePoint: _selectedIcon,
                imagePath: _imagePath,
                order: 1000, // default order, can be changed
              );
              Navigator.pop(context, newCat);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7C3AED)),
          child: Text(l10n.add),
        ),
      ],
    );
  }
} 