import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device.dart';
import '../models/product.dart';
import '../models/template.dart';
import '../models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show Icons;

class DataService {
  static const String _keyDevices = 'devices';
  static const String _keyProducts = 'products';
  static const String _keyTemplates = 'templates';
  static const String _keyCategories = 'categories';

  // Devices
  static Future<List<Device>> getDevices() async {
    final snapshot = await FirebaseFirestore.instance.collection('devices').get();
    return snapshot.docs.map((doc) => Device.fromJson(doc.data()..['id'] = doc.id)).toList();
  }

  static Future<void> saveDevices(List<Device> devices) async {
    final collection = FirebaseFirestore.instance.collection('devices');
    final batch = FirebaseFirestore.instance.batch();
    // حذف كل الأجهزة القديمة
    final oldDevices = await collection.get();
    for (final doc in oldDevices.docs) {
      batch.delete(doc.reference);
    }
    // إضافة الأجهزة الجديدة
    for (final device in devices) {
      final data = device.toJson();
      batch.set(collection.doc(), data);
    }
    await batch.commit();
  }

  static Future<void> addDevice(Device device) async {
    await FirebaseFirestore.instance.collection('devices').add(device.toJson());
  }

  static Future<void> updateDevice(Device device) async {
    if (device.id.isEmpty) return;
    await FirebaseFirestore.instance.collection('devices').doc(device.id).set(device.toJson());
  }

  static Future<void> deleteDevice(String deviceId) async {
    await FirebaseFirestore.instance.collection('devices').doc(deviceId).delete();
  }

  // Products
  static Future<List<Product>> getProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromJson(doc.data()..['id'] = doc.id)).toList();
  }

  static Future<void> saveProducts(List<Product> products) async {
    final collection = FirebaseFirestore.instance.collection('products');
    final batch = FirebaseFirestore.instance.batch();
    // حذف كل المنتجات القديمة
    final oldProducts = await collection.get();
    for (final doc in oldProducts.docs) {
      batch.delete(doc.reference);
    }
    // إضافة المنتجات الجديدة
    for (final product in products) {
      final data = product.toJson();
      batch.set(collection.doc(), data);
    }
    await batch.commit();
  }

  static Future<void> addProduct(Product product) async {
    await FirebaseFirestore.instance.collection('products').add(product.toJson());
  }

  static Future<void> updateProduct(Product product) async {
    if (product.id.isEmpty) return;
    await FirebaseFirestore.instance.collection('products').doc(product.id).set(product.toJson());
  }

  static Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance.collection('products').doc(productId).delete();
  }

  // Templates
  static Future<List<Template>> getTemplates() async {
    final snapshot = await FirebaseFirestore.instance.collection('templates').get();
    return snapshot.docs.map((doc) => Template.fromJson(doc.data()..['id'] = doc.id)).toList();
  }

  static Future<void> saveTemplates(List<Template> templates) async {
    final collection = FirebaseFirestore.instance.collection('templates');
    final batch = FirebaseFirestore.instance.batch();
    // حذف كل القوالب القديمة
    final oldTemplates = await collection.get();
    for (final doc in oldTemplates.docs) {
      batch.delete(doc.reference);
    }
    // إضافة القوالب الجديدة
    for (final template in templates) {
      final data = template.toJson();
      batch.set(collection.doc(), data);
    }
    await batch.commit();
  }

  static Future<void> initializeDefaultTemplates() async {
    final templates = await getTemplates();
    if (templates.isEmpty) {
      final defaultTemplates = [
        Template(
          id: 'template1',
          name: 'Template 1',
          description: 'video + price tag 1:1, supports 1 goods',
          thumbnail: 'template1_thumb',
          type: 'video',
          maxProducts: 1,
          hasPriceTag: true,
        ),
        Template(
          id: 'template2',
          name: 'Template 2',
          description: 'video + price tag 1:1, supports 2 goods',
          thumbnail: 'template2_thumb',
          type: 'video',
          maxProducts: 2,
          hasPriceTag: true,
        ),
        Template(
          id: 'template3',
          name: 'Template 3',
          description: 'Full screen image, Image poster',
          thumbnail: 'template3_thumb',
          type: 'image',
          isFullScreen: true,
        ),
        Template(
          id: 'template4',
          name: 'Template 4',
          description: 'Full Screen Video, Video Advertising',
          thumbnail: 'template4_thumb',
          type: 'video',
          isFullScreen: true,
        ),
        Template(
          id: 'template5',
          name: 'Template 5',
          description: 'Video + price tag 1:1, tag is the entire image',
          thumbnail: 'template5_thumb',
          type: 'video',
          maxProducts: 1,
          hasPriceTag: true,
        ),
        Template(
          id: 'template6',
          name: 'Template 6',
          description: 'video + price tag 1:1, supports 1 goods, with enlarged font size',
          thumbnail: 'template6_thumb',
          type: 'video',
          maxProducts: 1,
          hasPriceTag: true,
        ),
      ];
      await saveTemplates(defaultTemplates);
    }
  }

  // Categories
  static Future<List<Category>> getCategories() async {
    print('Getting categories from Firestore...');
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    print('Got ${snapshot.docs.length} categories');
    return snapshot.docs.map((doc) => Category.fromJson(doc.data()..['id'] = doc.id)).toList();
  }

  static Future<void> saveCategories(List<Category> categories) async {
    final collection = FirebaseFirestore.instance.collection('categories');
    final batch = FirebaseFirestore.instance.batch();
    // حذف كل الأقسام القديمة
    final oldCategories = await collection.get();
    for (final doc in oldCategories.docs) {
      batch.delete(doc.reference);
    }
    // إضافة الأقسام الجديدة
    for (final category in categories) {
      final data = category.toJson();
      batch.set(collection.doc(), data);
    }
    await batch.commit();
  }

  static Future<void> addCategory(Category category) async {
    print('Adding new category: ${category.nameAr}');
    try {
      await FirebaseFirestore.instance.collection('categories').add(category.toJson());
      print('Category added successfully');
    } catch (e) {
      print('Error adding category: $e');
      throw e; // إعادة رمي الخطأ ليتم معالجته في واجهة المستخدم
    }
  }
} 