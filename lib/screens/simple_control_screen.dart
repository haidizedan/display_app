import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimpleControlScreen extends StatefulWidget {
  const SimpleControlScreen({super.key});

  @override
  State<SimpleControlScreen> createState() => _SimpleControlScreenState();
}

class _SimpleControlScreenState extends State<SimpleControlScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendToDisplay() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال نص للعرض')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('display').doc('screen1').set({
        'title': 'رسالة جديدة',
        'text': _textController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'backgroundColor': '#7C3AED',
        'textColor': '#FFFFFF',
        'fontSize': 32,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال البيانات بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      _textController.clear();
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

  Future<void> _sendTestMessage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('display').doc('screen1').set({
        'title': 'رسالة تجريبية',
        'text': 'مرحباً! هذه رسالة تجريبية من جهاز التحكم',
        'timestamp': FieldValue.serverTimestamp(),
        'backgroundColor': '#4CAF50',
        'textColor': '#FFFFFF',
        'fontSize': 28,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رسالة تجريبية!'),
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
        title: const Text('جهاز التحكم البسيط'),
        backgroundColor: Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      'النص المراد عرضه',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'أدخل النص هنا...',
                        border: OutlineInputBorder(),
                        hintText: 'اكتب النص الذي تريد عرضه على الشاشة',
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
              label: Text(_isLoading ? 'جاري الإرسال...' : 'إرسال للشاشة'),
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
                    onPressed: _isLoading ? null : _sendTestMessage,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('رسالة تجريبية'),
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
                      'تعليمات سريعة:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• اكتب النص واضغط "إرسال للشاشة"\n'
                      '• استخدم "رسالة تجريبية" لاختبار الاتصال\n'
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
    );
  }
} 