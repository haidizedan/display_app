import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get display => 'Display';

  @override
  String get templates => 'Templates';

  @override
  String get about => 'About';

  @override
  String get app_version => 'APP Version';

  @override
  String get local_wifi => 'Local WiFi';

  @override
  String get local_ip => 'Local IP';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get logout_confirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get version => 'Version';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get login => 'Login';

  @override
  String get welcome => 'Welcome to Display Management App';

  @override
  String get enter_username => 'Please enter username';

  @override
  String get enter_password => 'Please enter password';

  @override
  String get use_default_credentials => 'Use default credentials';

  @override
  String get devices => 'Devices';

  @override
  String get scan_qr_code => 'Scan QR Code';

  @override
  String get add_device => 'Add New Device';

  @override
  String get categories => 'Categories';

  @override
  String get add_category => 'Add Category';

  @override
  String get category_name_ar => 'Category Name (Arabic)';

  @override
  String get enter_category_name_ar => 'Please enter category name in Arabic';

  @override
  String get category_name_en => 'Category Name (English)';

  @override
  String get enter_category_name_en => 'Please enter category name in English';

  @override
  String get choose_icon => 'Choose Icon';

  @override
  String get add_product => 'Add Product';

  @override
  String get no_products_in_category => 'No products in this category';

  @override
  String price_with_currency(Object currency, Object price) {
    return 'Price: $price $currency';
  }

  @override
  String get product_name_ar => 'Product Name (Arabic)';

  @override
  String get enter_product_name_ar => 'Please enter product name in Arabic';

  @override
  String get product_name_en => 'Product Name (English)';

  @override
  String get enter_product_name_en => 'Please enter product name in English';

  @override
  String get price => 'Price';

  @override
  String get enter_price => 'Please enter price';

  @override
  String get currency => 'Currency';

  @override
  String get enter_currency => 'Please enter currency';

  @override
  String get unit => 'Unit';

  @override
  String get choose_unit => 'Choose unit';

  @override
  String get template => 'Template';

  @override
  String get choose_template => 'Choose template';

  @override
  String get product_description_optional => 'Product Description (optional)';

  @override
  String get video_selected => 'Video selected';

  @override
  String get product_details => 'Product Details';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get template1_title => 'Template 1: Video Only';

  @override
  String get template1_desc => 'Full screen video only with optional text';

  @override
  String get template2_title => 'Template 2: Image Only';

  @override
  String get template2_desc => 'Product image + price before/after discount + optional text';

  @override
  String get template3_title => 'Template 3: Product Data';

  @override
  String get template3_desc => 'Image + barcode + name + price + after discount + description';

  @override
  String get template4_title => 'Template 4: Two Products';

  @override
  String get template4_desc => 'Two product images + price/after discount + description + names';

  @override
  String get edit_template1 => 'Edit Template 1';

  @override
  String get choose_product_for_video => 'Choose product for video';

  @override
  String get text_appears_above_video => 'Text appears above video (optional)';

  @override
  String get choose_video_from_product_to_display_here => 'Choose a video from a product to display here';

  @override
  String get close => 'Close';

  @override
  String get edit_template2 => 'Edit Template 2';

  @override
  String get choose_product_for_image => 'Choose product for image';

  @override
  String get price_before_discount => 'Price before discount';

  @override
  String get price_after_discount => 'Price after discount';

  @override
  String get optional_text => 'Optional text';

  @override
  String get choose_image_from_product_to_display_here => 'Choose an image from a product to display here';

  @override
  String get before => 'Before';

  @override
  String get after => 'After';

  @override
  String get edit_template3 => 'Edit Template 3';

  @override
  String get choose_product => 'Choose product';

  @override
  String get product_barcode => 'Product barcode';

  @override
  String get product_name => 'Product name';

  @override
  String get after_discount => 'After discount';

  @override
  String get choose_product_to_display_its_data => 'Choose a product to display its data';

  @override
  String get barcode => 'Barcode';

  @override
  String get edit_template4 => 'Edit Template 4';

  @override
  String get product1 => 'Product 1';

  @override
  String get product2 => 'Product 2';

  @override
  String get price_after_discount1 => 'Price after discount 1';

  @override
  String get price_after_discount2 => 'Price after discount 2';

  @override
  String get qr_instruction => 'Point the camera at the QR code';

  @override
  String get qr_auto_read => 'Data will be read automatically';

  @override
  String get manual_entry => 'Manual Entry';

  @override
  String get device_data_entry => 'Device Data Entry';

  @override
  String get device_data_hint => 'Device data (name=Device&ip=192.168.1.100&mac=AA:BB:CC:DD:EE:FF)';

  @override
  String get login_failed => 'Login failed. Please check your credentials.';

  @override
  String get sign_up => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get enter_email => 'Please enter your email';

  @override
  String get invalid_email => 'Invalid email address';

  @override
  String get password => 'Password';

  @override
  String get weak_password => 'Password must be at least 6 characters';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get enter_confirm_password => 'Please confirm your password';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get dont_have_account => 'Don\'t have an account?';

  @override
  String get sign_up_success => 'Account created successfully!';
}
