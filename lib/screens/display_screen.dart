import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  bool _isConnected = false;
  String _lastUpdate = '';

  Color _hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // إضافة alpha channel
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('display')
            .doc('screen1')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorWidget('خطأ في الاتصال: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return _buildLoadingWidget();
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          
          if (data == null || data['text'] == null || data['text'].toString().isEmpty) {
            return _buildEmptyWidget();
          }

          // تحديث حالة الاتصال
          if (!_isConnected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isConnected = true;
              });
            });
          }

          // تحديث آخر تحديث
          if (data['timestamp'] != null) {
            final timestamp = data['timestamp'] as Timestamp;
            _lastUpdate = 'آخر تحديث: ${timestamp.toDate().toString().substring(11, 19)}';
          }

          return _buildDisplayWidget(data);
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'جاري الاتصال...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      color: Colors.red[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'خطأ في الاتصال',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isConnected = false;
                });
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.tv,
              color: Colors.white54,
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              'في انتظار البيانات...',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'سيتم عرض النص هنا عند إرساله من جهاز التحكم',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayWidget(Map<String, dynamic> data) {
    // استخراج البيانات
    final title = data['title']?.toString() ?? '';
    final text = data['text']?.toString() ?? '';
    final backgroundColor = data['backgroundColor']?.toString() ?? '#000000';
    final textColor = data['textColor']?.toString() ?? '#FFFFFF';
    final fontSize = data['fontSize']?.toInt() ?? 32;

    return Container(
      color: _hexToColor(backgroundColor),
      child: SafeArea(
        child: Column(
          children: [
            // شريط الحالة العلوي
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isConnected ? Icons.wifi : Icons.wifi_off,
                        color: _isConnected ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isConnected ? 'متصل' : 'غير متصل',
                        style: TextStyle(
                          color: _isConnected ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _lastUpdate,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // المحتوى الرئيسي
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // العنوان
                      if (title.isNotEmpty) ...[
                        Text(
                          title,
                          style: TextStyle(
                            color: _hexToColor(textColor),
                            fontSize: fontSize * 0.6,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                      ],
                      // النص الرئيسي
                      Text(
                        text,
                        style: TextStyle(
                          color: _hexToColor(textColor),
                          fontSize: fontSize.toDouble(),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // شريط الحالة السفلي
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.screen_share,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'شاشة العرض - جاهزة للاستقبال',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
} 