import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'APP Version'**
  String get app_version;

  /// No description provided for @local_wifi.
  ///
  /// In en, this message translates to:
  /// **'Local WiFi'**
  String get local_wifi;

  /// No description provided for @local_ip.
  ///
  /// In en, this message translates to:
  /// **'Local IP'**
  String get local_ip;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Display Management App'**
  String get welcome;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get enter_username;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get enter_password;

  /// No description provided for @use_default_credentials.
  ///
  /// In en, this message translates to:
  /// **'Use default credentials'**
  String get use_default_credentials;

  /// No description provided for @devices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// No description provided for @scan_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scan_qr_code;

  /// No description provided for @add_device.
  ///
  /// In en, this message translates to:
  /// **'Add New Device'**
  String get add_device;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @category_name_ar.
  ///
  /// In en, this message translates to:
  /// **'Category Name (Arabic)'**
  String get category_name_ar;

  /// No description provided for @enter_category_name_ar.
  ///
  /// In en, this message translates to:
  /// **'Please enter category name in Arabic'**
  String get enter_category_name_ar;

  /// No description provided for @category_name_en.
  ///
  /// In en, this message translates to:
  /// **'Category Name (English)'**
  String get category_name_en;

  /// No description provided for @enter_category_name_en.
  ///
  /// In en, this message translates to:
  /// **'Please enter category name in English'**
  String get enter_category_name_en;

  /// No description provided for @choose_icon.
  ///
  /// In en, this message translates to:
  /// **'Choose Icon'**
  String get choose_icon;

  /// No description provided for @add_product.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get add_product;

  /// No description provided for @no_products_in_category.
  ///
  /// In en, this message translates to:
  /// **'No products in this category'**
  String get no_products_in_category;

  /// No description provided for @price_with_currency.
  ///
  /// In en, this message translates to:
  /// **'Price: {price} {currency}'**
  String price_with_currency(Object currency, Object price);

  /// No description provided for @product_name_ar.
  ///
  /// In en, this message translates to:
  /// **'Product Name (Arabic)'**
  String get product_name_ar;

  /// No description provided for @enter_product_name_ar.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name in Arabic'**
  String get enter_product_name_ar;

  /// No description provided for @product_name_en.
  ///
  /// In en, this message translates to:
  /// **'Product Name (English)'**
  String get product_name_en;

  /// No description provided for @enter_product_name_en.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name in English'**
  String get enter_product_name_en;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enter_price.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get enter_price;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @enter_currency.
  ///
  /// In en, this message translates to:
  /// **'Please enter currency'**
  String get enter_currency;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @choose_unit.
  ///
  /// In en, this message translates to:
  /// **'Choose unit'**
  String get choose_unit;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @choose_template.
  ///
  /// In en, this message translates to:
  /// **'Choose template'**
  String get choose_template;

  /// No description provided for @product_description_optional.
  ///
  /// In en, this message translates to:
  /// **'Product Description (optional)'**
  String get product_description_optional;

  /// No description provided for @video_selected.
  ///
  /// In en, this message translates to:
  /// **'Video selected'**
  String get video_selected;

  /// No description provided for @product_details.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @template1_title.
  ///
  /// In en, this message translates to:
  /// **'Template 1: Video Only'**
  String get template1_title;

  /// No description provided for @template1_desc.
  ///
  /// In en, this message translates to:
  /// **'Full screen video only with optional text'**
  String get template1_desc;

  /// No description provided for @template2_title.
  ///
  /// In en, this message translates to:
  /// **'Template 2: Image Only'**
  String get template2_title;

  /// No description provided for @template2_desc.
  ///
  /// In en, this message translates to:
  /// **'Product image + price before/after discount + optional text'**
  String get template2_desc;

  /// No description provided for @template3_title.
  ///
  /// In en, this message translates to:
  /// **'Template 3: Product Data'**
  String get template3_title;

  /// No description provided for @template3_desc.
  ///
  /// In en, this message translates to:
  /// **'Image + barcode + name + price + after discount + description'**
  String get template3_desc;

  /// No description provided for @template4_title.
  ///
  /// In en, this message translates to:
  /// **'Template 4: Two Products'**
  String get template4_title;

  /// No description provided for @template4_desc.
  ///
  /// In en, this message translates to:
  /// **'Two product images + price/after discount + description + names'**
  String get template4_desc;

  /// No description provided for @edit_template1.
  ///
  /// In en, this message translates to:
  /// **'Edit Template 1'**
  String get edit_template1;

  /// No description provided for @choose_product_for_video.
  ///
  /// In en, this message translates to:
  /// **'Choose product for video'**
  String get choose_product_for_video;

  /// No description provided for @text_appears_above_video.
  ///
  /// In en, this message translates to:
  /// **'Text appears above video (optional)'**
  String get text_appears_above_video;

  /// No description provided for @choose_video_from_product_to_display_here.
  ///
  /// In en, this message translates to:
  /// **'Choose a video from a product to display here'**
  String get choose_video_from_product_to_display_here;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @edit_template2.
  ///
  /// In en, this message translates to:
  /// **'Edit Template 2'**
  String get edit_template2;

  /// No description provided for @choose_product_for_image.
  ///
  /// In en, this message translates to:
  /// **'Choose product for image'**
  String get choose_product_for_image;

  /// No description provided for @price_before_discount.
  ///
  /// In en, this message translates to:
  /// **'Price before discount'**
  String get price_before_discount;

  /// No description provided for @price_after_discount.
  ///
  /// In en, this message translates to:
  /// **'Price after discount'**
  String get price_after_discount;

  /// No description provided for @optional_text.
  ///
  /// In en, this message translates to:
  /// **'Optional text'**
  String get optional_text;

  /// No description provided for @choose_image_from_product_to_display_here.
  ///
  /// In en, this message translates to:
  /// **'Choose an image from a product to display here'**
  String get choose_image_from_product_to_display_here;

  /// No description provided for @before.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get before;

  /// No description provided for @after.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get after;

  /// No description provided for @edit_template3.
  ///
  /// In en, this message translates to:
  /// **'Edit Template 3'**
  String get edit_template3;

  /// No description provided for @choose_product.
  ///
  /// In en, this message translates to:
  /// **'Choose product'**
  String get choose_product;

  /// No description provided for @product_barcode.
  ///
  /// In en, this message translates to:
  /// **'Product barcode'**
  String get product_barcode;

  /// No description provided for @product_name.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get product_name;

  /// No description provided for @after_discount.
  ///
  /// In en, this message translates to:
  /// **'After discount'**
  String get after_discount;

  /// No description provided for @choose_product_to_display_its_data.
  ///
  /// In en, this message translates to:
  /// **'Choose a product to display its data'**
  String get choose_product_to_display_its_data;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @edit_template4.
  ///
  /// In en, this message translates to:
  /// **'Edit Template 4'**
  String get edit_template4;

  /// No description provided for @product1.
  ///
  /// In en, this message translates to:
  /// **'Product 1'**
  String get product1;

  /// No description provided for @product2.
  ///
  /// In en, this message translates to:
  /// **'Product 2'**
  String get product2;

  /// No description provided for @price_after_discount1.
  ///
  /// In en, this message translates to:
  /// **'Price after discount 1'**
  String get price_after_discount1;

  /// No description provided for @price_after_discount2.
  ///
  /// In en, this message translates to:
  /// **'Price after discount 2'**
  String get price_after_discount2;

  /// No description provided for @qr_instruction.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code'**
  String get qr_instruction;

  /// No description provided for @qr_auto_read.
  ///
  /// In en, this message translates to:
  /// **'Data will be read automatically'**
  String get qr_auto_read;

  /// No description provided for @manual_entry.
  ///
  /// In en, this message translates to:
  /// **'Manual Entry'**
  String get manual_entry;

  /// No description provided for @device_data_entry.
  ///
  /// In en, this message translates to:
  /// **'Device Data Entry'**
  String get device_data_entry;

  /// No description provided for @device_data_hint.
  ///
  /// In en, this message translates to:
  /// **'Device data (name=Device&ip=192.168.1.100&mac=AA:BB:CC:DD:EE:FF)'**
  String get device_data_hint;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get login_failed;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enter_email;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalid_email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get weak_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @enter_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get enter_confirm_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dont_have_account;

  /// No description provided for @sign_up_success.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get sign_up_success;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
