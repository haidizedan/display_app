import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الإعدادات';

  @override
  String get display => 'العرض';

  @override
  String get templates => 'القوالب';

  @override
  String get about => 'حول';

  @override
  String get app_version => 'إصدار التطبيق';

  @override
  String get local_wifi => 'الواي فاي المحلي';

  @override
  String get local_ip => 'IP المحلي';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get account => 'الحساب';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logout_confirm => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get version => 'الإصدار';

  @override
  String get add => 'إضافة';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get welcome => 'مرحباً بك في تطبيق إدارة شاشات العرض';

  @override
  String get enter_username => 'يرجى إدخال اسم المستخدم';

  @override
  String get enter_password => 'يرجى إدخال كلمة المرور';

  @override
  String get use_default_credentials => 'استخدم بيانات الدخول الافتراضية';

  @override
  String get devices => 'الأجهزة';

  @override
  String get scan_qr_code => 'مسح رمز QR';

  @override
  String get add_device => 'إضافة جهاز جديد';

  @override
  String get categories => 'الأقسام';

  @override
  String get add_category => 'إضافة قسم';

  @override
  String get category_name_ar => 'اسم القسم (عربي)';

  @override
  String get enter_category_name_ar => 'يرجى إدخال اسم القسم بالعربية';

  @override
  String get category_name_en => 'اسم القسم (إنجليزي)';

  @override
  String get enter_category_name_en => 'يرجى إدخال اسم القسم بالإنجليزية';

  @override
  String get choose_icon => 'اختر الأيقونة';

  @override
  String get add_product => 'إضافة منتج';

  @override
  String get no_products_in_category => 'لا توجد منتجات في هذا القسم';

  @override
  String price_with_currency(Object currency, Object price) {
    return 'السعر: $price $currency';
  }

  @override
  String get product_name_ar => 'اسم المنتج (عربي)';

  @override
  String get enter_product_name_ar => 'يرجى إدخال اسم المنتج بالعربية';

  @override
  String get product_name_en => 'اسم المنتج (إنجليزي)';

  @override
  String get enter_product_name_en => 'يرجى إدخال اسم المنتج بالإنجليزية';

  @override
  String get price => 'السعر';

  @override
  String get enter_price => 'يرجى إدخال السعر';

  @override
  String get currency => 'العملة';

  @override
  String get enter_currency => 'يرجى إدخال العملة';

  @override
  String get unit => 'الوحدة';

  @override
  String get choose_unit => 'اختر الوحدة';

  @override
  String get template => 'القالب';

  @override
  String get choose_template => 'اختر القالب';

  @override
  String get product_description_optional => 'وصف المنتج (اختياري)';

  @override
  String get video_selected => 'تم اختيار فيديو';

  @override
  String get product_details => 'تفاصيل المنتج';

  @override
  String get save_changes => 'حفظ التعديلات';

  @override
  String get template1_title => 'قالب 1: فيديو فقط';

  @override
  String get template1_desc => 'شاشة كاملة فيديو فقط مع نص اختياري';

  @override
  String get template2_title => 'قالب 2: صورة فقط';

  @override
  String get template2_desc => 'صورة من منتج + سعر قبل وبعد التخفيض + نص اختياري';

  @override
  String get template3_title => 'قالب 3: بيانات منتج';

  @override
  String get template3_desc => 'صورة + باركود + اسم + سعر + سعر بعد تخفيض + وصف';

  @override
  String get template4_title => 'قالب 4: منتجان';

  @override
  String get template4_desc => 'صورتان لمنتجين + سعر وسعر بعد تخفيض ووصف واسم المنتجين';

  @override
  String get edit_template1 => 'تعديل قالب 1';

  @override
  String get choose_product_for_video => 'اختر منتج لاستخدام الفيديو الخاص به';

  @override
  String get text_appears_above_video => 'نص يظهر فوق الفيديو (اختياري)';

  @override
  String get choose_video_from_product_to_display_here => 'اختر فيديو من منتج لعرضه هنا';

  @override
  String get close => 'إغلاق';

  @override
  String get edit_template2 => 'تعديل قالب 2';

  @override
  String get choose_product_for_image => 'اختر منتج لاستخدام صورته';

  @override
  String get price_before_discount => 'السعر قبل التخفيض';

  @override
  String get price_after_discount => 'السعر بعد التخفيض';

  @override
  String get optional_text => 'نص اختياري';

  @override
  String get choose_image_from_product_to_display_here => 'اختر صورة من منتج لعرضها هنا';

  @override
  String get before => 'قبل';

  @override
  String get after => 'بعد';

  @override
  String get edit_template3 => 'تعديل قالب 3';

  @override
  String get choose_product => 'اختر منتج';

  @override
  String get product_barcode => 'باركود المنتج';

  @override
  String get product_name => 'اسم المنتج';

  @override
  String get after_discount => 'بعد التخفيض';

  @override
  String get choose_product_to_display_its_data => 'اختر منتج لعرض بياناته';

  @override
  String get barcode => 'باركود';

  @override
  String get edit_template4 => 'تعديل قالب 4';

  @override
  String get product1 => 'منتج 1';

  @override
  String get product2 => 'منتج 2';

  @override
  String get price_after_discount1 => 'سعر بعد تخفيض 1';

  @override
  String get price_after_discount2 => 'سعر بعد تخفيض 2';

  @override
  String get qr_instruction => 'قم بتوجيه الكاميرا نحو رمز QR';

  @override
  String get qr_auto_read => 'سيتم قراءة البيانات تلقائياً';

  @override
  String get manual_entry => 'إدخال يدوي';

  @override
  String get device_data_entry => 'إدخال بيانات الجهاز';

  @override
  String get device_data_hint => 'بيانات الجهاز (name=Device&ip=192.168.1.100&mac=AA:BB:CC:DD:EE:FF)';

  @override
  String get login_failed => 'فشل تسجيل الدخول. يرجى التحقق من البيانات.';

  @override
  String get sign_up => 'تسجيل حساب جديد';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enter_email => 'أدخل البريد الإلكتروني';

  @override
  String get invalid_email => 'البريد الإلكتروني غير صالح';

  @override
  String get password => 'كلمة المرور';

  @override
  String get weak_password => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get enter_confirm_password => 'أدخل تأكيد كلمة المرور';

  @override
  String get passwords_do_not_match => 'كلمتا المرور غير متطابقتين';

  @override
  String get dont_have_account => 'ليس لديك حساب؟';

  @override
  String get sign_up_success => 'تم إنشاء الحساب بنجاح!';
}
