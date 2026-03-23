import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Kashap'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Kashap'**
  String get welcome;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetPasswordButton;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPasswordSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Reset!'**
  String get resetPasswordSuccessTitle;

  /// No description provided for @resetPasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully updated. You can now log in.'**
  String get resetPasswordSuccessMessage;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changePasswordButton;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get changePasswordSuccess;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kashap'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'The easiest way to manage your loans and payments.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works?'**
  String get onboardingHowItWorks;

  /// No description provided for @onboardingHowItWorksDesc.
  ///
  /// In en, this message translates to:
  /// **'Request your loan, receive disbursement, and track installments from the app.'**
  String get onboardingHowItWorksDesc;

  /// No description provided for @onboardingFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get onboardingFeatures;

  /// No description provided for @onboardingFeaturesDesc.
  ///
  /// In en, this message translates to:
  /// **'Payment validation with OCR, real-time tracking, and detailed reports.'**
  String get onboardingFeaturesDesc;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start!'**
  String get onboardingStart;

  /// No description provided for @onboardingStartDesc.
  ///
  /// In en, this message translates to:
  /// **'You are one step away from simplifying your finances.'**
  String get onboardingStartDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @selectUserTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'How will you use Kashap?'**
  String get selectUserTypeTitle;

  /// No description provided for @selectUserTypeDesc.
  ///
  /// In en, this message translates to:
  /// **'Kashap adapts to you. Choose your profile for a personalized experience.'**
  String get selectUserTypeDesc;

  /// No description provided for @userTypeCustomer.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Customer'**
  String get userTypeCustomer;

  /// No description provided for @userTypeCustomerDesc.
  ///
  /// In en, this message translates to:
  /// **'I want to apply for loans and see my installments.'**
  String get userTypeCustomerDesc;

  /// No description provided for @userTypeLender.
  ///
  /// In en, this message translates to:
  /// **'I\'m a Lender'**
  String get userTypeLender;

  /// No description provided for @userTypeLenderDesc.
  ///
  /// In en, this message translates to:
  /// **'I want to manage my portfolio and validate payments.'**
  String get userTypeLenderDesc;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get registerNow;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Kashap'**
  String get registerSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @legalName.
  ///
  /// In en, this message translates to:
  /// **'Legal Name'**
  String get legalName;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @documentNumber.
  ///
  /// In en, this message translates to:
  /// **'Document Number'**
  String get documentNumber;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @lenderType.
  ///
  /// In en, this message translates to:
  /// **'Lender Type'**
  String get lenderType;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms and Conditions'**
  String get acceptTerms;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @lendersTitle.
  ///
  /// In en, this message translates to:
  /// **'Lenders Management'**
  String get lendersTitle;

  /// No description provided for @addLender.
  ///
  /// In en, this message translates to:
  /// **'Add Lender'**
  String get addLender;

  /// No description provided for @editLender.
  ///
  /// In en, this message translates to:
  /// **'Edit Lender'**
  String get editLender;

  /// No description provided for @bankAccounts.
  ///
  /// In en, this message translates to:
  /// **'Bank Accounts'**
  String get bankAccounts;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bankName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get addCustomer;

  /// No description provided for @searchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search customer...'**
  String get searchCustomer;

  /// No description provided for @creditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get creditLimit;

  /// No description provided for @customerDetail.
  ///
  /// In en, this message translates to:
  /// **'Customer Detail'**
  String get customerDetail;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @loans.
  ///
  /// In en, this message translates to:
  /// **'Loans'**
  String get loans;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @noLoans.
  ///
  /// In en, this message translates to:
  /// **'No registered loans'**
  String get noLoans;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No uploaded documents'**
  String get noDocuments;

  /// No description provided for @loanApplications.
  ///
  /// In en, this message translates to:
  /// **'Applications'**
  String get loanApplications;

  /// No description provided for @newLoanApplication.
  ///
  /// In en, this message translates to:
  /// **'New Application'**
  String get newLoanApplication;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @installments.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get installments;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @interestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get interestRate;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @biweekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get biweekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get statusApproved;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @loansTitle.
  ///
  /// In en, this message translates to:
  /// **'My Loans'**
  String get loansTitle;

  /// No description provided for @loanDetail.
  ///
  /// In en, this message translates to:
  /// **'Loan Detail'**
  String get loanDetail;

  /// No description provided for @installmentsSchedule.
  ///
  /// In en, this message translates to:
  /// **'Installments Schedule'**
  String get installmentsSchedule;

  /// No description provided for @nextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next Payment'**
  String get nextPayment;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balance'**
  String get balance;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @paymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTitle;

  /// No description provided for @registerPayment.
  ///
  /// In en, this message translates to:
  /// **'Register Payment'**
  String get registerPayment;

  /// No description provided for @uploadVoucher.
  ///
  /// In en, this message translates to:
  /// **'Upload Voucher'**
  String get uploadVoucher;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get selectFile;

  /// No description provided for @processingVoucher.
  ///
  /// In en, this message translates to:
  /// **'Processing voucher...'**
  String get processingVoucher;

  /// No description provided for @voucherUploaded.
  ///
  /// In en, this message translates to:
  /// **'Voucher uploaded successfully'**
  String get voucherUploaded;

  /// No description provided for @ocrResults.
  ///
  /// In en, this message translates to:
  /// **'Scan Results'**
  String get ocrResults;

  /// No description provided for @detectedAmount.
  ///
  /// In en, this message translates to:
  /// **'Detected Amount'**
  String get detectedAmount;

  /// No description provided for @detectedDate.
  ///
  /// In en, this message translates to:
  /// **'Detected Date'**
  String get detectedDate;

  /// No description provided for @detectedBank.
  ///
  /// In en, this message translates to:
  /// **'Detected Bank'**
  String get detectedBank;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications'**
  String get noNotifications;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitTitle;

  /// No description provided for @exitMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitMessage;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get usersTitle;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addUser;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get admin;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @officer.
  ///
  /// In en, this message translates to:
  /// **'Loan Officer'**
  String get officer;

  /// No description provided for @voucherReview.
  ///
  /// In en, this message translates to:
  /// **'Voucher Review'**
  String get voucherReview;

  /// No description provided for @approvePayment.
  ///
  /// In en, this message translates to:
  /// **'Approve Payment'**
  String get approvePayment;

  /// No description provided for @rejectPayment.
  ///
  /// In en, this message translates to:
  /// **'Reject Payment'**
  String get rejectPayment;

  /// No description provided for @ocrMatch.
  ///
  /// In en, this message translates to:
  /// **'OCR Match'**
  String get ocrMatch;

  /// No description provided for @manualCorrection.
  ///
  /// In en, this message translates to:
  /// **'Manual Correction'**
  String get manualCorrection;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @portfolioSummary.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Summary'**
  String get portfolioSummary;

  /// No description provided for @totalPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Total Portfolio'**
  String get totalPortfolio;

  /// No description provided for @activeLoans.
  ///
  /// In en, this message translates to:
  /// **'Active Loans'**
  String get activeLoans;

  /// No description provided for @delinquencyRate.
  ///
  /// In en, this message translates to:
  /// **'Delinquency Rate'**
  String get delinquencyRate;

  /// No description provided for @collectedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Collected this Month'**
  String get collectedThisMonth;

  /// No description provided for @customerPortal.
  ///
  /// In en, this message translates to:
  /// **'My Portal'**
  String get customerPortal;

  /// No description provided for @myLoans.
  ///
  /// In en, this message translates to:
  /// **'My Loans'**
  String get myLoans;

  /// No description provided for @myInstallments.
  ///
  /// In en, this message translates to:
  /// **'My Installments'**
  String get myInstallments;

  /// No description provided for @myPayments.
  ///
  /// In en, this message translates to:
  /// **'My Payment History'**
  String get myPayments;

  /// No description provided for @nextInstallment.
  ///
  /// In en, this message translates to:
  /// **'Next Installment'**
  String get nextInstallment;

  /// No description provided for @totalDebt.
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get totalDebt;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @noActiveLoans.
  ///
  /// In en, this message translates to:
  /// **'You have no active loans currently'**
  String get noActiveLoans;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @installmentDetail.
  ///
  /// In en, this message translates to:
  /// **'Installment Detail'**
  String get installmentDetail;

  /// No description provided for @daysOverdue.
  ///
  /// In en, this message translates to:
  /// **'Days overdue'**
  String get daysOverdue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
