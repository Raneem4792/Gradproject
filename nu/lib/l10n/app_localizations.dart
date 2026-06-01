import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @providerProfile.
  ///
  /// In en, this message translates to:
  /// **'Provider Profile'**
  String get providerProfile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @ordersSummary.
  ///
  /// In en, this message translates to:
  /// **'Orders Summary'**
  String get ordersSummary;

  /// No description provided for @linkedCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Linked Campaigns'**
  String get linkedCampaigns;

  /// No description provided for @userSessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'User session not found'**
  String get userSessionNotFound;

  /// No description provided for @basicInformationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Basic information updated'**
  String get basicInformationUpdated;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @providerId.
  ///
  /// In en, this message translates to:
  /// **'Provider ID'**
  String get providerId;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verified Account'**
  String get verifiedAccount;

  /// No description provided for @providerDetails.
  ///
  /// In en, this message translates to:
  /// **'Provider Details'**
  String get providerDetails;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @providerName.
  ///
  /// In en, this message translates to:
  /// **'Provider Name'**
  String get providerName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @makkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get makkah;

  /// No description provided for @mealProvider.
  ///
  /// In en, this message translates to:
  /// **'Meal Provider'**
  String get mealProvider;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'accepted'**
  String get accepted;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get rejected;

  /// No description provided for @campaigns.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get campaigns;

  /// No description provided for @noLinkedCampaigns.
  ///
  /// In en, this message translates to:
  /// **'No linked campaigns'**
  String get noLinkedCampaigns;

  /// No description provided for @pilgrims.
  ///
  /// In en, this message translates to:
  /// **'Pilgrims'**
  String get pilgrims;

  /// No description provided for @arrivalDate.
  ///
  /// In en, this message translates to:
  /// **'Arrival Date'**
  String get arrivalDate;

  /// No description provided for @arrivalTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Time'**
  String get arrivalTime;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @areYouSureLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areYouSureLogout;

  /// No description provided for @errorLoadingHomeData.
  ///
  /// In en, this message translates to:
  /// **'Error loading home data'**
  String get errorLoadingHomeData;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @noNewRequests.
  ///
  /// In en, this message translates to:
  /// **'No new requests'**
  String get noNewRequests;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderNumber;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @requestsList.
  ///
  /// In en, this message translates to:
  /// **'Requests list'**
  String get requestsList;

  /// No description provided for @newText.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get newText;

  /// No description provided for @newRequests.
  ///
  /// In en, this message translates to:
  /// **'new requests'**
  String get newRequests;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @orderHistory.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get orderHistory;

  /// No description provided for @reviewPreviousOrders.
  ///
  /// In en, this message translates to:
  /// **'Review previous orders'**
  String get reviewPreviousOrders;

  /// No description provided for @performanceAndReports.
  ///
  /// In en, this message translates to:
  /// **'Performance & Reports'**
  String get performanceAndReports;

  /// No description provided for @trackStatsAndInsights.
  ///
  /// In en, this message translates to:
  /// **'Track stats and insights'**
  String get trackStatsAndInsights;

  /// No description provided for @manageMeal.
  ///
  /// In en, this message translates to:
  /// **'Manage Meal'**
  String get manageMeal;

  /// No description provided for @addEditYourMeals.
  ///
  /// In en, this message translates to:
  /// **'Add / edit your meals'**
  String get addEditYourMeals;

  /// No description provided for @manageCampaign.
  ///
  /// In en, this message translates to:
  /// **'Manage Campaign'**
  String get manageCampaign;

  /// No description provided for @updateCampaignSettings.
  ///
  /// In en, this message translates to:
  /// **'Update campaign settings'**
  String get updateCampaignSettings;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @mealDetails.
  ///
  /// In en, this message translates to:
  /// **'Meal Details'**
  String get mealDetails;

  /// No description provided for @kcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kcal;

  /// No description provided for @gramsProtein.
  ///
  /// In en, this message translates to:
  /// **'g protein'**
  String get gramsProtein;

  /// No description provided for @gramsCarbs.
  ///
  /// In en, this message translates to:
  /// **'g carbs'**
  String get gramsCarbs;

  /// No description provided for @gramsFat.
  ///
  /// In en, this message translates to:
  /// **'g fat'**
  String get gramsFat;

  /// No description provided for @mealName.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get mealName;

  /// No description provided for @mealType.
  ///
  /// In en, this message translates to:
  /// **'Meal Type'**
  String get mealType;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'calories'**
  String get calories;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @deleteMealQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete meal?'**
  String get deleteMealQuestion;

  /// No description provided for @areYouSureDeleteMeal.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{mealName}\"?'**
  String areYouSureDeleteMeal(Object mealName);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @manageMeals.
  ///
  /// In en, this message translates to:
  /// **'Manage Meals'**
  String get manageMeals;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'meals'**
  String get meals;

  /// No description provided for @addMeal.
  ///
  /// In en, this message translates to:
  /// **'Add Meal'**
  String get addMeal;

  /// No description provided for @noMealsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No meals added yet'**
  String get noMealsAddedYet;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @providerSessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Provider session not found'**
  String get providerSessionNotFound;

  /// No description provided for @mealAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Meal added successfully!'**
  String get mealAddedSuccessfully;

  /// No description provided for @mealUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Meal updated successfully!'**
  String get mealUpdatedSuccessfully;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @editMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit Meal'**
  String get editMeal;

  /// No description provided for @addNewMeal.
  ///
  /// In en, this message translates to:
  /// **'Add New Meal'**
  String get addNewMeal;

  /// No description provided for @updateMealDetailsBelow.
  ///
  /// In en, this message translates to:
  /// **'Update meal details below.'**
  String get updateMealDetailsBelow;

  /// No description provided for @enterMealInformationBelow.
  ///
  /// In en, this message translates to:
  /// **'Enter meal information below.'**
  String get enterMealInformationBelow;

  /// No description provided for @chooseImageFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Choose Image From Device'**
  String get chooseImageFromDevice;

  /// No description provided for @enterMealName.
  ///
  /// In en, this message translates to:
  /// **'Enter meal name'**
  String get enterMealName;

  /// No description provided for @selectMealType.
  ///
  /// In en, this message translates to:
  /// **'Select Meal Type'**
  String get selectMealType;

  /// No description provided for @writeMealDescription.
  ///
  /// In en, this message translates to:
  /// **'Write meal description'**
  String get writeMealDescription;

  /// No description provided for @nutritionInformation.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Information'**
  String get nutritionInformation;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldIsRequired(Object fieldName);

  /// No description provided for @fieldMustBeValidNumber.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must be a valid number'**
  String fieldMustBeValidNumber(Object fieldName);

  /// No description provided for @mealNameMustNotContainNumbers.
  ///
  /// In en, this message translates to:
  /// **'Meal Name must not contain numbers'**
  String get mealNameMustNotContainNumbers;

  /// No description provided for @mealNameMustNotContainSymbols.
  ///
  /// In en, this message translates to:
  /// **'Meal Name must not contain symbols'**
  String get mealNameMustNotContainSymbols;

  /// No description provided for @mealNameMustBeArabicOrEnglishOnly.
  ///
  /// In en, this message translates to:
  /// **'Meal Name must be either Arabic or English only'**
  String get mealNameMustBeArabicOrEnglishOnly;

  /// No description provided for @descriptionMustNotContainSymbols.
  ///
  /// In en, this message translates to:
  /// **'Description must not contain symbols'**
  String get descriptionMustNotContainSymbols;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @highProtein.
  ///
  /// In en, this message translates to:
  /// **'High Protein'**
  String get highProtein;

  /// No description provided for @lowCarb.
  ///
  /// In en, this message translates to:
  /// **'Low Carb'**
  String get lowCarb;

  /// No description provided for @fastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get fastFood;

  /// No description provided for @manageCampaigns.
  ///
  /// In en, this message translates to:
  /// **'Manage Campaigns'**
  String get manageCampaigns;

  /// No description provided for @addCampaign.
  ///
  /// In en, this message translates to:
  /// **'Add Campaign'**
  String get addCampaign;

  /// No description provided for @noCampaignsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No campaigns added yet'**
  String get noCampaignsAddedYet;

  /// No description provided for @campaignAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Campaign added successfully'**
  String get campaignAddedSuccessfully;

  /// No description provided for @campaignUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Campaign updated successfully'**
  String get campaignUpdatedSuccessfully;

  /// No description provided for @campaignDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Campaign deleted successfully'**
  String get campaignDeletedSuccessfully;

  /// No description provided for @failedToAddCampaign.
  ///
  /// In en, this message translates to:
  /// **'Failed to add campaign'**
  String get failedToAddCampaign;

  /// No description provided for @failedToUpdateCampaign.
  ///
  /// In en, this message translates to:
  /// **'Failed to update campaign'**
  String get failedToUpdateCampaign;

  /// No description provided for @failedToDeleteCampaign.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete campaign'**
  String get failedToDeleteCampaign;

  /// No description provided for @deleteCampaignQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete campaign?'**
  String get deleteCampaignQuestion;

  /// No description provided for @areYouSureDeleteCampaign.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{campaignName}\"?'**
  String areYouSureDeleteCampaign(Object campaignName);

  /// No description provided for @arrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival'**
  String get arrival;

  /// No description provided for @editCampaign.
  ///
  /// In en, this message translates to:
  /// **'Edit Campaign'**
  String get editCampaign;

  /// No description provided for @addNewCampaign.
  ///
  /// In en, this message translates to:
  /// **'Add New Campaign'**
  String get addNewCampaign;

  /// No description provided for @updateCampaignDetailsBelow.
  ///
  /// In en, this message translates to:
  /// **'Update campaign details below.'**
  String get updateCampaignDetailsBelow;

  /// No description provided for @enterCampaignInformationBelow.
  ///
  /// In en, this message translates to:
  /// **'Enter campaign information below.'**
  String get enterCampaignInformationBelow;

  /// No description provided for @campaignName.
  ///
  /// In en, this message translates to:
  /// **'Campaign Name'**
  String get campaignName;

  /// No description provided for @enterCampaignName.
  ///
  /// In en, this message translates to:
  /// **'Enter campaign name'**
  String get enterCampaignName;

  /// No description provided for @campaignNumber.
  ///
  /// In en, this message translates to:
  /// **'Campaign Number'**
  String get campaignNumber;

  /// No description provided for @enterCampaignNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter campaign number'**
  String get enterCampaignNumber;

  /// No description provided for @numberOfPilgrims.
  ///
  /// In en, this message translates to:
  /// **'Number of Pilgrims'**
  String get numberOfPilgrims;

  /// No description provided for @enterPilgrimsCount.
  ///
  /// In en, this message translates to:
  /// **'Enter pilgrims count'**
  String get enterPilgrimsCount;

  /// No description provided for @arrivalFrom.
  ///
  /// In en, this message translates to:
  /// **'Arrival From'**
  String get arrivalFrom;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @arrivalDateTime.
  ///
  /// In en, this message translates to:
  /// **'Arrival Date & Time'**
  String get arrivalDateTime;

  /// No description provided for @selectArrivalDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select arrival date & time'**
  String get selectArrivalDateTime;

  /// No description provided for @writeExtraNotesAboutCampaign.
  ///
  /// In en, this message translates to:
  /// **'Write extra notes about the campaign'**
  String get writeExtraNotesAboutCampaign;

  /// No description provided for @campaignNameMustNotContainNumbers.
  ///
  /// In en, this message translates to:
  /// **'Campaign Name must not contain numbers'**
  String get campaignNameMustNotContainNumbers;

  /// No description provided for @campaignNameMustNotContainSymbols.
  ///
  /// In en, this message translates to:
  /// **'Campaign Name must not contain symbols'**
  String get campaignNameMustNotContainSymbols;

  /// No description provided for @campaignNameMustBeArabicOrEnglishOnly.
  ///
  /// In en, this message translates to:
  /// **'Campaign Name must be either Arabic or English only'**
  String get campaignNameMustBeArabicOrEnglishOnly;

  /// No description provided for @campaignNumberMustContainNumbersOnly.
  ///
  /// In en, this message translates to:
  /// **'Campaign Number must contain numbers only'**
  String get campaignNumberMustContainNumbersOnly;

  /// No description provided for @numberOfPilgrimsMustBeValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Number of Pilgrims must be a valid number'**
  String get numberOfPilgrimsMustBeValidNumber;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @pleaseEnterValidPilgrimsCount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid pilgrims count'**
  String get pleaseEnterValidPilgrimsCount;

  /// No description provided for @pleaseSelectArrivalDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select arrival date and time'**
  String get pleaseSelectArrivalDateTime;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Error loading notifications'**
  String get errorLoadingNotifications;

  /// No description provided for @recentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Recent Notifications'**
  String get recentNotifications;

  /// No description provided for @providerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Provider Notifications'**
  String get providerNotifications;

  /// No description provided for @youAreAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up'**
  String get youAreAllCaughtUp;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'unread notifications'**
  String get unreadNotifications;

  /// No description provided for @markAllNotificationsAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all notifications as read'**
  String get markAllNotificationsAsRead;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @newProviderAlertsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'New provider alerts and updates will appear here.'**
  String get newProviderAlertsWillAppearHere;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @selectCampaign.
  ///
  /// In en, this message translates to:
  /// **'Select Campaign'**
  String get selectCampaign;

  /// No description provided for @allCampaigns.
  ///
  /// In en, this message translates to:
  /// **'All Campaigns'**
  String get allCampaigns;

  /// No description provided for @campaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get campaign;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'cancelled'**
  String get cancelled;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get pending;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @allReviews.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get allReviews;

  /// No description provided for @viewReview.
  ///
  /// In en, this message translates to:
  /// **'View Review'**
  String get viewReview;

  /// No description provided for @failedToLoadReviewDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load review details'**
  String get failedToLoadReviewDetails;

  /// No description provided for @reviewDetails.
  ///
  /// In en, this message translates to:
  /// **'Review Details'**
  String get reviewDetails;

  /// No description provided for @pilgrimComment.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim Comment'**
  String get pilgrimComment;

  /// No description provided for @reviewDate.
  ///
  /// In en, this message translates to:
  /// **'Review Date'**
  String get reviewDate;

  /// No description provided for @providerReply.
  ///
  /// In en, this message translates to:
  /// **'Provider Reply'**
  String get providerReply;

  /// No description provided for @replyDate.
  ///
  /// In en, this message translates to:
  /// **'Reply Date'**
  String get replyDate;

  /// No description provided for @noTextProvided.
  ///
  /// In en, this message translates to:
  /// **'No text provided'**
  String get noTextProvided;

  /// No description provided for @noReplyYet.
  ///
  /// In en, this message translates to:
  /// **'No reply yet'**
  String get noReplyYet;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @aiAnalysisUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI analysis is currently unavailable.'**
  String get aiAnalysisUnavailable;

  /// No description provided for @providerIdIsMissing.
  ///
  /// In en, this message translates to:
  /// **'Provider ID is missing'**
  String get providerIdIsMissing;

  /// No description provided for @couldNotOpenPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Could not open PDF report'**
  String get couldNotOpenPdfReport;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @mealAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Meal Acceptance'**
  String get mealAcceptance;

  /// No description provided for @acceptedRequests.
  ///
  /// In en, this message translates to:
  /// **'Accepted requests'**
  String get acceptedRequests;

  /// No description provided for @feedbackAverage.
  ///
  /// In en, this message translates to:
  /// **'Feedback Average'**
  String get feedbackAverage;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average rating'**
  String get averageRating;

  /// No description provided for @orderTrend.
  ///
  /// In en, this message translates to:
  /// **'Order Trend'**
  String get orderTrend;

  /// No description provided for @dailyOrdersLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Daily orders over the last 7 days'**
  String get dailyOrdersLast7Days;

  /// No description provided for @smartSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get smartSuggestions;

  /// No description provided for @pilgrimHealthSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim Health Snapshot'**
  String get pilgrimHealthSnapshot;

  /// No description provided for @commonDietaryHealthIndicators.
  ///
  /// In en, this message translates to:
  /// **'Common dietary and health indicators'**
  String get commonDietaryHealthIndicators;

  /// No description provided for @topRequestedMeals.
  ///
  /// In en, this message translates to:
  /// **'Top Requested Meals'**
  String get topRequestedMeals;

  /// No description provided for @mostOrderedMealsToday.
  ///
  /// In en, this message translates to:
  /// **'Most ordered meals today'**
  String get mostOrderedMealsToday;

  /// No description provided for @updatedRecently.
  ///
  /// In en, this message translates to:
  /// **'Updated recently'**
  String get updatedRecently;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Overview'**
  String get dashboardOverview;

  /// No description provided for @liveData.
  ///
  /// In en, this message translates to:
  /// **'Live Data'**
  String get liveData;

  /// No description provided for @todaysOrders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get todaysOrders;

  /// No description provided for @acceptanceRate.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get acceptanceRate;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @highest.
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// No description provided for @latestReview.
  ///
  /// In en, this message translates to:
  /// **'Latest review'**
  String get latestReview;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average score'**
  String get averageScore;

  /// No description provided for @noSuggestionsAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No suggestions available yet.'**
  String get noSuggestionsAvailableYet;

  /// No description provided for @diabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get diabetes;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @lowSodium.
  ///
  /// In en, this message translates to:
  /// **'Low Sodium'**
  String get lowSodium;

  /// No description provided for @noMealRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No meal requests yet'**
  String get noMealRequestsYet;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @aiDashboardInsights.
  ///
  /// In en, this message translates to:
  /// **'AI Dashboard Insights'**
  String get aiDashboardInsights;

  /// No description provided for @smartAnalysisBasedOnOrders.
  ///
  /// In en, this message translates to:
  /// **'Smart analysis based on orders, meals, ratings, and risks'**
  String get smartAnalysisBasedOnOrders;

  /// No description provided for @generatingAiInsights.
  ///
  /// In en, this message translates to:
  /// **'Generating AI insights...'**
  String get generatingAiInsights;

  /// No description provided for @aiSummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get aiSummary;

  /// No description provided for @feedbackRiskAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Risk Analysis'**
  String get feedbackRiskAnalysis;

  /// No description provided for @smartRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Smart Recommendations'**
  String get smartRecommendations;

  /// No description provided for @noAiSummaryAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No AI summary available yet.'**
  String get noAiSummaryAvailableYet;

  /// No description provided for @noFeedbackRiskAnalysisAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No feedback or risk analysis available yet.'**
  String get noFeedbackRiskAnalysisAvailableYet;

  /// No description provided for @noSmartRecommendationsAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No smart recommendations available yet.'**
  String get noSmartRecommendationsAvailableYet;

  /// No description provided for @mostRequestedMeals.
  ///
  /// In en, this message translates to:
  /// **'Most Requested Meals'**
  String get mostRequestedMeals;

  /// No description provided for @failedToAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept request'**
  String get failedToAcceptRequest;

  /// No description provided for @failedToCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel request'**
  String get failedToCancelRequest;

  /// No description provided for @failedToUpdateRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to update request'**
  String get failedToUpdateRequest;

  /// No description provided for @changeOrderStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Order Status'**
  String get changeOrderStatus;

  /// No description provided for @errorLoadingRequests.
  ///
  /// In en, this message translates to:
  /// **'Error loading requests'**
  String get errorLoadingRequests;

  /// No description provided for @incomingRequests.
  ///
  /// In en, this message translates to:
  /// **'Incoming Requests'**
  String get incomingRequests;

  /// No description provided for @acceptedOrders.
  ///
  /// In en, this message translates to:
  /// **'Accepted Orders'**
  String get acceptedOrders;

  /// No description provided for @noIncomingRequestsYet.
  ///
  /// In en, this message translates to:
  /// **'No incoming requests yet'**
  String get noIncomingRequestsYet;

  /// No description provided for @noAcceptedOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No accepted orders yet'**
  String get noAcceptedOrdersYet;

  /// No description provided for @incoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get incoming;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @mondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sundayShort;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @pilgrim.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim'**
  String get pilgrim;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @browseDailyMeals.
  ///
  /// In en, this message translates to:
  /// **'Browse daily meals'**
  String get browseDailyMeals;

  /// No description provided for @buffet.
  ///
  /// In en, this message translates to:
  /// **'Buffet'**
  String get buffet;

  /// No description provided for @exploreBuffetOptions.
  ///
  /// In en, this message translates to:
  /// **'Explore buffet options'**
  String get exploreBuffetOptions;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @groupService.
  ///
  /// In en, this message translates to:
  /// **'Group Service'**
  String get groupService;

  /// No description provided for @startOrder.
  ///
  /// In en, this message translates to:
  /// **'Start Order'**
  String get startOrder;

  /// No description provided for @viewOptions.
  ///
  /// In en, this message translates to:
  /// **'View Options'**
  String get viewOptions;

  /// No description provided for @unknownMeal.
  ///
  /// In en, this message translates to:
  /// **'Unknown Meal'**
  String get unknownMeal;

  /// No description provided for @tapToViewPreviousOrders.
  ///
  /// In en, this message translates to:
  /// **'Tap to view previous orders'**
  String get tapToViewPreviousOrders;

  /// No description provided for @assalamuAlaikum.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum,'**
  String get assalamuAlaikum;

  /// No description provided for @todaysMeals.
  ///
  /// In en, this message translates to:
  /// **'Today’s Meals'**
  String get todaysMeals;

  /// No description provided for @mealTimesScheduledByCampaign.
  ///
  /// In en, this message translates to:
  /// **'*Meal times are scheduled by your campaign*'**
  String get mealTimesScheduledByCampaign;

  /// No description provided for @askYourAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Ask Your AI Assistant'**
  String get askYourAiAssistant;

  /// No description provided for @noPreviousOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No previous orders yet'**
  String get noPreviousOrdersYet;

  /// No description provided for @errorLoadingMeals.
  ///
  /// In en, this message translates to:
  /// **'Error loading meals'**
  String get errorLoadingMeals;

  /// No description provided for @smartFilters.
  ///
  /// In en, this message translates to:
  /// **'Smart Filters'**
  String get smartFilters;

  /// No description provided for @aiRecommendedMeals.
  ///
  /// In en, this message translates to:
  /// **'AI Recommended Meals'**
  String get aiRecommendedMeals;

  /// No description provided for @allAvailableMeals.
  ///
  /// In en, this message translates to:
  /// **'All Available Meals'**
  String get allAvailableMeals;

  /// No description provided for @selectYourMeal.
  ///
  /// In en, this message translates to:
  /// **'Select Your Meal'**
  String get selectYourMeal;

  /// No description provided for @browseMealsReviewNutrition.
  ///
  /// In en, this message translates to:
  /// **'Browse meals, review nutrition and choose what fits your health needs.'**
  String get browseMealsReviewNutrition;

  /// No description provided for @aiRecommended.
  ///
  /// In en, this message translates to:
  /// **'AI Recommended'**
  String get aiRecommended;

  /// No description provided for @allMeals.
  ///
  /// In en, this message translates to:
  /// **'All Meals'**
  String get allMeals;

  /// No description provided for @providedBy.
  ///
  /// In en, this message translates to:
  /// **'Provided by'**
  String get providedBy;

  /// No description provided for @selectMeal.
  ///
  /// In en, this message translates to:
  /// **'Select Meal'**
  String get selectMeal;

  /// No description provided for @noRecommendedMealsFound.
  ///
  /// In en, this message translates to:
  /// **'No recommended meals found'**
  String get noRecommendedMealsFound;

  /// No description provided for @tryViewingAllMealsInstead.
  ///
  /// In en, this message translates to:
  /// **'Try viewing all meals instead.'**
  String get tryViewingAllMealsInstead;

  /// No description provided for @yourNotifications.
  ///
  /// In en, this message translates to:
  /// **'Your Notifications'**
  String get yourNotifications;

  /// No description provided for @newAlertsAndUpdatesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'New alerts and updates will appear here.'**
  String get newAlertsAndUpdatesWillAppearHere;

  /// No description provided for @errorLoadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders'**
  String get errorLoadingOrders;

  /// No description provided for @previousOrders.
  ///
  /// In en, this message translates to:
  /// **'Previous Orders'**
  String get previousOrders;

  /// No description provided for @yourOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Your Order History'**
  String get yourOrderHistory;

  /// No description provided for @reviewPreviousMealOrders.
  ///
  /// In en, this message translates to:
  /// **'Review your previous meal orders and rate completed meals.'**
  String get reviewPreviousMealOrders;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderId;

  /// No description provided for @reviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reviewed;

  /// No description provided for @rateMeal.
  ///
  /// In en, this message translates to:
  /// **'Rate Meal'**
  String get rateMeal;

  /// No description provided for @submittedMealRequestsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your submitted meal requests will appear here.'**
  String get submittedMealRequestsWillAppearHere;

  /// No description provided for @pilgrimProfile.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim Profile'**
  String get pilgrimProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @personalDetailsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Personal details updated'**
  String get personalDetailsUpdated;

  /// No description provided for @healthProfile.
  ///
  /// In en, this message translates to:
  /// **'Health Profile'**
  String get healthProfile;

  /// No description provided for @healthInformation.
  ///
  /// In en, this message translates to:
  /// **'Health Information'**
  String get healthInformation;

  /// No description provided for @healthInformationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Health information updated'**
  String get healthInformationUpdated;

  /// No description provided for @failedToSaveHealthProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save health profile'**
  String get failedToSaveHealthProfile;

  /// No description provided for @pilgrimId.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim ID'**
  String get pilgrimId;

  /// No description provided for @activeAccount.
  ///
  /// In en, this message translates to:
  /// **'Active Account'**
  String get activeAccount;

  /// No description provided for @noCampaign.
  ///
  /// In en, this message translates to:
  /// **'No Campaign'**
  String get noCampaign;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @healthCondition.
  ///
  /// In en, this message translates to:
  /// **'Health Condition'**
  String get healthCondition;

  /// No description provided for @dietaryPreference.
  ///
  /// In en, this message translates to:
  /// **'Dietary Preference'**
  String get dietaryPreference;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @hypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension'**
  String get hypertension;

  /// No description provided for @heartDisease.
  ///
  /// In en, this message translates to:
  /// **'Heart Disease'**
  String get heartDisease;

  /// No description provided for @asthma.
  ///
  /// In en, this message translates to:
  /// **'Asthma'**
  String get asthma;

  /// No description provided for @kidneyDisease.
  ///
  /// In en, this message translates to:
  /// **'Kidney Disease'**
  String get kidneyDisease;

  /// No description provided for @liverDisease.
  ///
  /// In en, this message translates to:
  /// **'Liver Disease'**
  String get liverDisease;

  /// No description provided for @thyroidDisorder.
  ///
  /// In en, this message translates to:
  /// **'Thyroid Disorder'**
  String get thyroidDisorder;

  /// No description provided for @highCholesterol.
  ///
  /// In en, this message translates to:
  /// **'High Cholesterol'**
  String get highCholesterol;

  /// No description provided for @arthritis.
  ///
  /// In en, this message translates to:
  /// **'Arthritis'**
  String get arthritis;

  /// No description provided for @epilepsy.
  ///
  /// In en, this message translates to:
  /// **'Epilepsy'**
  String get epilepsy;

  /// No description provided for @mobilityIssue.
  ///
  /// In en, this message translates to:
  /// **'Mobility Issue'**
  String get mobilityIssue;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @lowSugar.
  ///
  /// In en, this message translates to:
  /// **'Low Sugar'**
  String get lowSugar;

  /// No description provided for @lowSalt.
  ///
  /// In en, this message translates to:
  /// **'Low Salt'**
  String get lowSalt;

  /// No description provided for @nuts.
  ///
  /// In en, this message translates to:
  /// **'Nuts'**
  String get nuts;

  /// No description provided for @seafood.
  ///
  /// In en, this message translates to:
  /// **'Seafood'**
  String get seafood;

  /// No description provided for @dairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get dairy;

  /// No description provided for @eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get eggs;

  /// No description provided for @gluten.
  ///
  /// In en, this message translates to:
  /// **'Gluten'**
  String get gluten;

  /// No description provided for @soy.
  ///
  /// In en, this message translates to:
  /// **'Soy'**
  String get soy;

  /// No description provided for @sesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get sesame;

  /// No description provided for @shellfish.
  ///
  /// In en, this message translates to:
  /// **'Shellfish'**
  String get shellfish;

  /// No description provided for @wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get wheat;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @diabetic.
  ///
  /// In en, this message translates to:
  /// **'Diabetic'**
  String get diabetic;

  /// No description provided for @allergyTag.
  ///
  /// In en, this message translates to:
  /// **'{allergy} Allergy'**
  String allergyTag(Object allergy);

  /// No description provided for @taste.
  ///
  /// In en, this message translates to:
  /// **'Taste'**
  String get taste;

  /// No description provided for @presentation.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get presentation;

  /// No description provided for @portionSize.
  ///
  /// In en, this message translates to:
  /// **'Portion Size'**
  String get portionSize;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @overallSatisfaction.
  ///
  /// In en, this message translates to:
  /// **'Overall Satisfaction'**
  String get overallSatisfaction;

  /// No description provided for @pleaseSelectAtLeastOneRating.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one rating.'**
  String get pleaseSelectAtLeastOneRating;

  /// No description provided for @reviewSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully'**
  String get reviewSubmittedSuccessfully;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write comment...'**
  String get writeComment;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @userSessionNotFoundLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'User session not found. Please log in again.'**
  String get userSessionNotFoundLoginAgain;

  /// No description provided for @failedToSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit request'**
  String get failedToSubmitRequest;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @mealId.
  ///
  /// In en, this message translates to:
  /// **'Meal ID'**
  String get mealId;

  /// No description provided for @submitDate.
  ///
  /// In en, this message translates to:
  /// **'Submit Date'**
  String get submitDate;

  /// No description provided for @submitTime.
  ///
  /// In en, this message translates to:
  /// **'Submit Time'**
  String get submitTime;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Add Notes'**
  String get addNotes;

  /// No description provided for @optionalNotesForMealRequest.
  ///
  /// In en, this message translates to:
  /// **'Optional notes for your meal request'**
  String get optionalNotesForMealRequest;

  /// No description provided for @writeAnyNoteHere.
  ///
  /// In en, this message translates to:
  /// **'Write any note here...'**
  String get writeAnyNoteHere;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @requestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Request Submitted'**
  String get requestSubmitted;

  /// No description provided for @mealRequestSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your meal request has been submitted successfully.'**
  String get mealRequestSubmittedSuccessfully;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @requestMeal.
  ///
  /// In en, this message translates to:
  /// **'Request Meal'**
  String get requestMeal;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @smartPlatformForServingPilgrims.
  ///
  /// In en, this message translates to:
  /// **'Smart platform for serving pilgrims'**
  String get smartPlatformForServingPilgrims;

  /// No description provided for @chooseAccountTypeAndFillDetails.
  ///
  /// In en, this message translates to:
  /// **'Choose your account type and fill in your details'**
  String get chooseAccountTypeAndFillDetails;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @fullNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Arabic or English letters only, 3 to 50 characters'**
  String get fullNameHelper;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumber;

  /// No description provided for @enterYourPilgrimId.
  ///
  /// In en, this message translates to:
  /// **'Enter your pilgrim ID'**
  String get enterYourPilgrimId;

  /// No description provided for @enterYourProviderId.
  ///
  /// In en, this message translates to:
  /// **'Enter your provider ID'**
  String get enterYourProviderId;

  /// No description provided for @idNumberHelper.
  ///
  /// In en, this message translates to:
  /// **'Numbers only, 6 to 20 digits'**
  String get idNumberHelper;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'8-20 chars, uppercase, lowercase, number, special char, English only'**
  String get passwordHelper;

  /// No description provided for @campaignId.
  ///
  /// In en, this message translates to:
  /// **'Campaign ID'**
  String get campaignId;

  /// No description provided for @enterYourCampaignId.
  ///
  /// In en, this message translates to:
  /// **'Enter your campaign ID'**
  String get enterYourCampaignId;

  /// No description provided for @numbersOnly.
  ///
  /// In en, this message translates to:
  /// **'Numbers only'**
  String get numbersOnly;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'Example: name@example.com'**
  String get emailExample;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @nusuqCopyright.
  ///
  /// In en, this message translates to:
  /// **'© NUSUQ 2026 - All rights reserved'**
  String get nusuqCopyright;

  /// No description provided for @integratedSystemForServingPilgrims.
  ///
  /// In en, this message translates to:
  /// **'Integrated system for serving pilgrims'**
  String get integratedSystemForServingPilgrims;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterYourPhoneNumber;

  /// No description provided for @phoneHelper.
  ///
  /// In en, this message translates to:
  /// **'Choose country code, then enter the local number only'**
  String get phoneHelper;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @fullNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 3 characters'**
  String get fullNameTooShort;

  /// No description provided for @fullNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Full name must not exceed 50 characters'**
  String get fullNameTooLong;

  /// No description provided for @fullNameNoNumbers.
  ///
  /// In en, this message translates to:
  /// **'Full name must not contain numbers'**
  String get fullNameNoNumbers;

  /// No description provided for @fullNameArabicOrEnglishOnly.
  ///
  /// In en, this message translates to:
  /// **'Full name must be Arabic only or English only'**
  String get fullNameArabicOrEnglishOnly;

  /// No description provided for @pleaseEnterPilgrimId.
  ///
  /// In en, this message translates to:
  /// **'Please enter your pilgrim ID'**
  String get pleaseEnterPilgrimId;

  /// No description provided for @pleaseEnterProviderId.
  ///
  /// In en, this message translates to:
  /// **'Please enter your provider ID'**
  String get pleaseEnterProviderId;

  /// No description provided for @idMustNotContainSpaces.
  ///
  /// In en, this message translates to:
  /// **'ID must not contain spaces'**
  String get idMustNotContainSpaces;

  /// No description provided for @idNumbersOnly.
  ///
  /// In en, this message translates to:
  /// **'ID must contain numbers only'**
  String get idNumbersOnly;

  /// No description provided for @idTooShort.
  ///
  /// In en, this message translates to:
  /// **'ID number is too short'**
  String get idTooShort;

  /// No description provided for @idTooLong.
  ///
  /// In en, this message translates to:
  /// **'ID number is too long'**
  String get idTooLong;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'Password must not contain spaces'**
  String get passwordNoSpaces;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must not exceed 20 characters'**
  String get passwordTooLong;

  /// No description provided for @passwordNeedsUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordNeedsUppercase;

  /// No description provided for @passwordNeedsLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordNeedsLowercase;

  /// No description provided for @passwordNeedsNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordNeedsNumber;

  /// No description provided for @passwordNeedsSpecial.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordNeedsSpecial;

  /// No description provided for @passwordEnglishOnly.
  ///
  /// In en, this message translates to:
  /// **'Password must use English letters, numbers, and symbols only'**
  String get passwordEnglishOnly;

  /// No description provided for @pleaseEnterCampaignId.
  ///
  /// In en, this message translates to:
  /// **'Please enter your campaign ID'**
  String get pleaseEnterCampaignId;

  /// No description provided for @campaignIdNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'Campaign ID must not contain spaces'**
  String get campaignIdNoSpaces;

  /// No description provided for @campaignIdNumbersOnly.
  ///
  /// In en, this message translates to:
  /// **'Campaign ID must contain numbers only'**
  String get campaignIdNumbersOnly;

  /// No description provided for @campaignIdTooLong.
  ///
  /// In en, this message translates to:
  /// **'Campaign ID is too long'**
  String get campaignIdTooLong;

  /// No description provided for @campaignIdGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Campaign ID must be greater than 0'**
  String get campaignIdGreaterThanZero;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @phoneNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'Phone number must not contain spaces'**
  String get phoneNoSpaces;

  /// No description provided for @phoneDigitsOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone number must contain digits only'**
  String get phoneDigitsOnly;

  /// No description provided for @enterLocalNumberOnly.
  ///
  /// In en, this message translates to:
  /// **'Enter the local number only'**
  String get enterLocalNumberOnly;

  /// No description provided for @phoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get phoneTooShort;

  /// No description provided for @phoneTooLong.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too long'**
  String get phoneTooLong;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @emailNoSpaces.
  ///
  /// In en, this message translates to:
  /// **'Email must not contain spaces'**
  String get emailNoSpaces;

  /// No description provided for @emailTooLong.
  ///
  /// In en, this message translates to:
  /// **'Email is too long'**
  String get emailTooLong;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @campaignIdDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'The campaign ID does not exist. Please enter a valid campaign ID.'**
  String get campaignIdDoesNotExist;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyRegistered;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered.'**
  String get phoneAlreadyRegistered;

  /// No description provided for @pilgrimIdAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This pilgrim ID is already registered.'**
  String get pilgrimIdAlreadyRegistered;

  /// No description provided for @providerIdAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This provider ID is already registered.'**
  String get providerIdAlreadyRegistered;

  /// No description provided for @unableToConnectToServer.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please make sure the backend is running.'**
  String get unableToConnectToServer;

  /// No description provided for @somethingWentWrongCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while creating the account. Please review your data and try again.'**
  String get somethingWentWrongCreatingAccount;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @enterIdAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your ID and password to access your account'**
  String get enterIdAndPassword;

  /// No description provided for @enterYourIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your ID number'**
  String get enterYourIdNumber;

  /// No description provided for @loginPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'8 to 20 characters, no spaces'**
  String get loginPasswordHelper;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @pleaseEnterYourId.
  ///
  /// In en, this message translates to:
  /// **'Please enter your ID'**
  String get pleaseEnterYourId;

  /// No description provided for @incorrectIdOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect ID or password.'**
  String get incorrectIdOrPassword;

  /// No description provided for @enterBothIdAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter both ID and password.'**
  String get enterBothIdAndPassword;

  /// No description provided for @somethingWentWrongDuringLogin.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong during login. Please try again.'**
  String get somethingWentWrongDuringLogin;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterCodeAndCreateNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email and create a new password'**
  String get enterCodeAndCreateNewPassword;

  /// No description provided for @enterEmailToReceiveResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset code'**
  String get enterEmailToReceiveResetCode;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @enter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit code'**
  String get enter6DigitCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds} s'**
  String resendInSeconds(Object seconds);

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get reEnterNewPassword;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changeEmail;

  /// No description provided for @codeSentToYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Code sent to your email'**
  String get codeSentToYourEmail;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @pleaseEnterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the reset code'**
  String get pleaseEnterResetCode;

  /// No description provided for @codeMustBe6Digits.
  ///
  /// In en, this message translates to:
  /// **'Code must be 6 digits'**
  String get codeMustBe6Digits;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordNeedsLetter.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one letter'**
  String get passwordNeedsLetter;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @quickQuestions.
  ///
  /// In en, this message translates to:
  /// **'Quick Questions'**
  String get quickQuestions;

  /// No description provided for @quickQuestionHealthProfileMeals.
  ///
  /// In en, this message translates to:
  /// **'What meals match my health profile?'**
  String get quickQuestionHealthProfileMeals;

  /// No description provided for @quickQuestionLowSugarMeal.
  ///
  /// In en, this message translates to:
  /// **'Suggest a low-sugar meal.'**
  String get quickQuestionLowSugarMeal;

  /// No description provided for @quickQuestionTodayMealSchedule.
  ///
  /// In en, this message translates to:
  /// **'What is today’s meal schedule?'**
  String get quickQuestionTodayMealSchedule;

  /// No description provided for @quickQuestionHighProteinOptions.
  ///
  /// In en, this message translates to:
  /// **'Show me high-protein options.'**
  String get quickQuestionHighProteinOptions;

  /// No description provided for @aiWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum 👋 I’m your AI assistant. I can help you choose meals, explain nutrition, and suggest options based on your health profile.'**
  String get aiWelcomeMessage;

  /// No description provided for @aiChatSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Sorry, something went wrong. Please try again.'**
  String get aiChatSomethingWentWrong;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @askSomething.
  ///
  /// In en, this message translates to:
  /// **'Ask something...'**
  String get askSomething;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @fullNameNoSymbols.
  ///
  /// In en, this message translates to:
  /// **'Full name must not contain symbols'**
  String get fullNameNoSymbols;

  /// No description provided for @peanuts.
  ///
  /// In en, this message translates to:
  /// **'Peanuts'**
  String get peanuts;

  /// No description provided for @milk.
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get milk;

  /// No description provided for @fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// No description provided for @completeHealthProfileForAiMeals.
  ///
  /// In en, this message translates to:
  /// **'Complete your health profile to get AI recommended meals'**
  String get completeHealthProfileForAiMeals;

  /// No description provided for @completeHealthProfileFirstThenTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please complete your health profile first, then try again.'**
  String get completeHealthProfileFirstThenTryAgain;

  /// No description provided for @mealsAreNotCurrentlyAvailableForYourCampaign.
  ///
  /// In en, this message translates to:
  /// **'Meals are not currently available for your campaign'**
  String get mealsAreNotCurrentlyAvailableForYourCampaign;

  /// No description provided for @yourCampaignProviderHasNotAddedMealsYet.
  ///
  /// In en, this message translates to:
  /// **'Your campaign provider has not added meals yet.'**
  String get yourCampaignProviderHasNotAddedMealsYet;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @adminId.
  ///
  /// In en, this message translates to:
  /// **'Admin ID'**
  String get adminId;

  /// No description provided for @systemAdmin.
  ///
  /// In en, this message translates to:
  /// **'System Admin'**
  String get systemAdmin;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmMessage;

  /// No description provided for @failedToLoadAdminProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load admin profile'**
  String get failedToLoadAdminProfile;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get admin;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @manageAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage Accounts'**
  String get manageAccounts;

  /// No description provided for @viewAndManageUsers.
  ///
  /// In en, this message translates to:
  /// **'View and manage users'**
  String get viewAndManageUsers;

  /// No description provided for @monitorOrders.
  ///
  /// In en, this message translates to:
  /// **'Monitor Orders'**
  String get monitorOrders;

  /// No description provided for @trackMealOrders.
  ///
  /// In en, this message translates to:
  /// **'Track meal orders'**
  String get trackMealOrders;

  /// No description provided for @createAndManageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Create and manage alerts'**
  String get createAndManageAlerts;

  /// No description provided for @createNotification.
  ///
  /// In en, this message translates to:
  /// **'Create Notification'**
  String get createNotification;

  /// No description provided for @sendNotifications.
  ///
  /// In en, this message translates to:
  /// **'Send Notifications'**
  String get sendNotifications;

  /// No description provided for @createAlertsForPilgrimsAndProviders.
  ///
  /// In en, this message translates to:
  /// **'Create alerts for pilgrims and providers'**
  String get createAlertsForPilgrimsAndProviders;

  /// No description provided for @arabicTitle.
  ///
  /// In en, this message translates to:
  /// **'Arabic Title'**
  String get arabicTitle;

  /// No description provided for @englishTitle.
  ///
  /// In en, this message translates to:
  /// **'English Title'**
  String get englishTitle;

  /// No description provided for @enterArabicTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic title'**
  String get enterArabicTitle;

  /// No description provided for @enterEnglishTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter English title'**
  String get enterEnglishTitle;

  /// No description provided for @notificationType.
  ///
  /// In en, this message translates to:
  /// **'Notification Type'**
  String get notificationType;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @announcement.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get announcement;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @recipients.
  ///
  /// In en, this message translates to:
  /// **'Recipients'**
  String get recipients;

  /// No description provided for @allPilgrims.
  ///
  /// In en, this message translates to:
  /// **'All Pilgrims'**
  String get allPilgrims;

  /// No description provided for @allProviders.
  ///
  /// In en, this message translates to:
  /// **'All Providers'**
  String get allProviders;

  /// No description provided for @specificNotificationHint.
  ///
  /// In en, this message translates to:
  /// **'For a specific pilgrim or provider, send the notification directly from Manage Accounts.'**
  String get specificNotificationHint;

  /// No description provided for @arabicMessage.
  ///
  /// In en, this message translates to:
  /// **'Arabic Message'**
  String get arabicMessage;

  /// No description provided for @englishMessage.
  ///
  /// In en, this message translates to:
  /// **'English Message'**
  String get englishMessage;

  /// No description provided for @enterArabicMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic message'**
  String get enterArabicMessage;

  /// No description provided for @enterEnglishMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter English message'**
  String get enterEnglishMessage;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @notificationSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Notification sent successfully'**
  String get notificationSentSuccessfully;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @accountInformationUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account information updated successfully'**
  String get accountInformationUpdatedSuccessfully;

  /// No description provided for @failedToUpdateAccountInformation.
  ///
  /// In en, this message translates to:
  /// **'Failed to update account information'**
  String get failedToUpdateAccountInformation;

  /// No description provided for @accountActivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account activated successfully'**
  String get accountActivatedSuccessfully;

  /// No description provided for @accountDeactivatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deactivated successfully'**
  String get accountDeactivatedSuccessfully;

  /// No description provided for @failedToUpdateAccountStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update account status'**
  String get failedToUpdateAccountStatus;

  /// No description provided for @sendNotificationTo.
  ///
  /// In en, this message translates to:
  /// **'Send Notification to'**
  String get sendNotificationTo;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @pleaseFillAllNotificationFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all notification fields'**
  String get pleaseFillAllNotificationFields;

  /// No description provided for @failedToSendNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed to send notification'**
  String get failedToSendNotification;

  /// No description provided for @failedToLoadAccounts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load accounts.'**
  String get failedToLoadAccounts;

  /// No description provided for @registeredProviders.
  ///
  /// In en, this message translates to:
  /// **'Registered Providers'**
  String get registeredProviders;

  /// No description provided for @providersCampaignsAndPilgrims.
  ///
  /// In en, this message translates to:
  /// **'Providers, campaigns, and pilgrims'**
  String get providersCampaignsAndPilgrims;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// No description provided for @notify.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notify;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @noCampaignsRegisteredForThisProvider.
  ///
  /// In en, this message translates to:
  /// **'No campaigns registered for this provider.'**
  String get noCampaignsRegisteredForThisProvider;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get no;

  /// No description provided for @expected.
  ///
  /// In en, this message translates to:
  /// **'expected'**
  String get expected;

  /// No description provided for @registered.
  ///
  /// In en, this message translates to:
  /// **'registered'**
  String get registered;

  /// No description provided for @noPilgrimsRegisteredUnderThisCampaign.
  ///
  /// In en, this message translates to:
  /// **'No pilgrims registered under this campaign.'**
  String get noPilgrimsRegisteredUnderThisCampaign;

  /// No description provided for @noAccountsFound.
  ///
  /// In en, this message translates to:
  /// **'No accounts found'**
  String get noAccountsFound;

  /// No description provided for @registeredAccountsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Registered providers, campaigns, and pilgrims will appear here.'**
  String get registeredAccountsWillAppearHere;

  /// No description provided for @adminAlerts.
  ///
  /// In en, this message translates to:
  /// **'Admin Alerts'**
  String get adminAlerts;

  /// No description provided for @failedToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedToLoadNotifications;

  /// No description provided for @noMessage.
  ///
  /// In en, this message translates to:
  /// **'No message'**
  String get noMessage;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @failedToLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders.'**
  String get failedToLoadOrders;

  /// No description provided for @campaignOrders.
  ///
  /// In en, this message translates to:
  /// **'Campaign Orders'**
  String get campaignOrders;

  /// No description provided for @campaignOrdersAndProviders.
  ///
  /// In en, this message translates to:
  /// **'Campaign orders and providers'**
  String get campaignOrdersAndProviders;

  /// No description provided for @noOrdersFoundUnderThisCampaign.
  ///
  /// In en, this message translates to:
  /// **'No orders found under this campaign.'**
  String get noOrdersFoundUnderThisCampaign;

  /// No description provided for @noDate.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get noDate;

  /// No description provided for @mealOrdersWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Meal orders will appear here grouped by campaign and provider.'**
  String get mealOrdersWillAppearHere;
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
