import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('hu')
  ];

  /// Name of home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Title to log in
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Title to log out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Text to sign in
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin;

  /// Text to sign up s new user
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// Asking the user to stay authenticated
  ///
  /// In en, this message translates to:
  /// **'Stay signed in.'**
  String get staylogdin;

  /// Asking if the user has an account
  ///
  /// In en, this message translates to:
  /// **'Do you have an account?'**
  String get doyouhaveacc;

  /// Asking if the user dont have an account
  ///
  /// In en, this message translates to:
  /// **'Do you not have an account?'**
  String get doyounothaveacc;

  /// Text for the username when logging in
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Text for the password when logging in
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Text for the passwordagain  when logging in
  ///
  /// In en, this message translates to:
  /// **'Password again'**
  String get passwordagain;

  /// Text for the first name when signing up
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstname;

  /// Text for the second name when signing up
  ///
  /// In en, this message translates to:
  /// **'Second Name'**
  String get secondname;

  /// Text for the phone number when signing up
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phonenum;

  /// Text for the email address when signing up
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailaddrs;

  /// Error message when too short username
  ///
  /// In en, this message translates to:
  /// **'Username has to be at least 6 characters'**
  String get tooshortusername;

  /// Error message when too short password
  ///
  /// In en, this message translates to:
  /// **'The password has to be at least 6 charecters'**
  String get tooshortpasw;

  /// Error message when password does not match
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match'**
  String get paswnotmatch;

  /// Error when invalid character
  ///
  /// In en, this message translates to:
  /// **'Invalid character'**
  String get invalidchar;

  /// Error when invalid email
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidemail;

  /// Error when invalid phone number
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidphone;

  /// No description provided for @fieldreq.
  ///
  /// In en, this message translates to:
  /// **'Field required'**
  String get fieldreq;

  /// Title for error popup
  ///
  /// In en, this message translates to:
  /// **'An error occured'**
  String get erroroccured;

  /// Cancel text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Log out confirmation text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutconfirm;

  /// Services screen title
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No service message
  ///
  /// In en, this message translates to:
  /// **'No service is available.'**
  String get servicesnotaw;

  /// Text add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Text duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Text desription for the services
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get servicedescription;

  /// Text price
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Title to the popup delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation text for service delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this Service?'**
  String get confirmservicedel;

  /// Text stating service name
  ///
  /// In en, this message translates to:
  /// **'Service Name'**
  String get servicename;

  /// Text stating service type
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get servicetype;

  /// Text stating the comment to a price
  ///
  /// In en, this message translates to:
  /// **'Addition to price'**
  String get comment;

  /// Text stating submit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Menu screen name
  ///
  /// In en, this message translates to:
  /// **''**
  String get menu;

  /// About me screen name
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutme;

  /// Calendar screen name
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @myreservations.
  ///
  /// In en, this message translates to:
  /// **'My Reservations'**
  String get myreservations;

  /// Text stating submit
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get choosedate;

  /// Text stating type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Text stating name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Text stating submitted
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// Text for confirming reservation delete
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this reservation?'**
  String get confirmreservationdel;

  /// Text for confirming appointment delete
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment?'**
  String get confirmappointmentdel;

  /// Text that tells to select a starting time
  ///
  /// In en, this message translates to:
  /// **'Select the starting time'**
  String get selectstarttime;

  /// Text that tells to select the ending time
  ///
  /// In en, this message translates to:
  /// **'Select the ending time'**
  String get selectendtime;

  /// Text telling the time period
  ///
  /// In en, this message translates to:
  /// **'Time period'**
  String get timeperiod;

  /// Erro message when there is no available appointment
  ///
  /// In en, this message translates to:
  /// **'Sorry there is no available appointment for this month yet.'**
  String get noavailableappointment;

  /// Text stating book
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// Asking for confirmation
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirm;

  /// booking confirm info text
  ///
  /// In en, this message translates to:
  /// **'Your booking information'**
  String get bookinginfo;

  /// Text stating date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @finalquestionbooking.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to book this appointment?'**
  String get finalquestionbooking;

  /// No description provided for @startingtimeinval.
  ///
  /// In en, this message translates to:
  /// **'Startingtime is after the ending'**
  String get startingtimeinval;

  /// No description provided for @invalidtimeererror.
  ///
  /// In en, this message translates to:
  /// **'Appointment at this time already exist'**
  String get invalidtimeererror;

  /// Text when there is not available reservation
  ///
  /// In en, this message translates to:
  /// **'You do not have any reservations yet'**
  String get noreservationavailable;

  /// Text stating sercvice
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// Introduction text
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get intro;

  /// hom screen location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// home screen for the county
  ///
  /// In en, this message translates to:
  /// **'County'**
  String get county;

  /// Text for the address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get exactadress;

  /// Contact text
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Short info on the about me screen
  ///
  /// In en, this message translates to:
  /// **'Short Introduction'**
  String get shortintro;

  /// My vision text on the about me screen
  ///
  /// In en, this message translates to:
  /// **'My Vision'**
  String get myvision;

  /// Education text about me screen
  ///
  /// In en, this message translates to:
  /// **'Qualifications'**
  String get educations;

  /// Home Screen editer title
  ///
  /// In en, this message translates to:
  /// **'Edit Home Screen'**
  String get homescreenedit;

  /// Title text for editing
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Subtitle text for editing
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get subtitle;

  /// Text for slogan
  ///
  /// In en, this message translates to:
  /// **'Slogan'**
  String get slogan;

  /// Text for the news
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// Title text for advertisement
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get addvertisement;

  /// Home Screen editer title
  ///
  /// In en, this message translates to:
  /// **'Edit About Me Screen'**
  String get aboutmescreenedit;

  /// The text to edit account details
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editaccount;

  /// The text to change password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changepasw;

  /// No description provided for @newtext.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newtext;

  /// Text saying change
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Confiramtion text for changing password
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to change your password?'**
  String get passwordconfirm;

  /// This is the confirmation for deleting you account
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account with all your data?'**
  String get deleteyouraccount;

  /// Button text for deleting all acount data
  ///
  /// In en, this message translates to:
  /// **'Delete account with all data!'**
  String get deleteaccountbutton;

  /// Error code for not correct username
  ///
  /// In en, this message translates to:
  /// **'The username is not correct!'**
  String get notcorrectusername;

  /// Edit screen title
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get editusers;

  /// No user text
  ///
  /// In en, this message translates to:
  /// **'Users are not available'**
  String get nouseravailable;

  /// Text to bann user
  ///
  /// In en, this message translates to:
  /// **'Bann'**
  String get bann;

  /// Allow user text
  ///
  /// In en, this message translates to:
  /// **'Allow User'**
  String get allowuser;

  /// All user chategory
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get alluser;

  /// Users chategory
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get users;

  /// Banned chategory
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get bannedusers;

  /// Admin chategory
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admins;

  /// access level text
  ///
  /// In en, this message translates to:
  /// **'Accesslevel'**
  String get accesslevel;

  /// teh duration minutes text
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// text for loading
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingtxt;

  /// No description provided for @imgnonavailable.
  ///
  /// In en, this message translates to:
  /// **'Image is not available'**
  String get imgnonavailable;

  /// The text to chage the picture
  ///
  /// In en, this message translates to:
  /// **'Change picture:'**
  String get changepic;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hu': return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
