// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get providerProfile => 'Provider Profile';

  @override
  String get settings => 'Settings';

  @override
  String get notification => 'Notification';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get language => 'Language';

  @override
  String get basicInformation => 'Basic Information';

  @override
  String get ordersSummary => 'Orders Summary';

  @override
  String get linkedCampaigns => 'Linked Campaigns';

  @override
  String get userSessionNotFound => 'User session not found';

  @override
  String get basicInformationUpdated => 'Basic information updated';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get providerId => 'Provider ID';

  @override
  String get service => 'Service';

  @override
  String get notAvailable => 'Not available';

  @override
  String get verifiedAccount => 'Verified Account';

  @override
  String get providerDetails => 'Provider Details';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get providerName => 'Provider Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get location => 'Location';

  @override
  String get serviceType => 'Service Type';

  @override
  String get makkah => 'Makkah';

  @override
  String get mealProvider => 'Meal Provider';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get accepted => 'accepted';

  @override
  String get rejected => 'rejected';

  @override
  String get campaigns => 'Campaigns';

  @override
  String get noLinkedCampaigns => 'No linked campaigns';

  @override
  String get pilgrims => 'Pilgrims';

  @override
  String get arrivalDate => 'Arrival Date';

  @override
  String get arrivalTime => 'Arrival Time';

  @override
  String get from => 'From';

  @override
  String get close => 'Close';

  @override
  String get logOut => 'Log Out';

  @override
  String get areYouSureLogout => 'Are you sure you want to log out?';

  @override
  String get errorLoadingHomeData => 'Error loading home data';

  @override
  String get provider => 'Provider';

  @override
  String get noNewRequests => 'No new requests';

  @override
  String get orderNumber => 'Order #';

  @override
  String get services => 'Services';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get requestsList => 'Requests list';

  @override
  String get newText => 'new';

  @override
  String get newRequests => 'new requests';

  @override
  String get viewAll => 'View All';

  @override
  String get orderHistory => 'Order History';

  @override
  String get reviewPreviousOrders => 'Review previous orders';

  @override
  String get performanceAndReports => 'Performance & Reports';

  @override
  String get trackStatsAndInsights => 'Track stats and insights';

  @override
  String get manageMeal => 'Manage Meal';

  @override
  String get addEditYourMeals => 'Add / edit your meals';

  @override
  String get manageCampaign => 'Manage Campaign';

  @override
  String get updateCampaignSettings => 'Update campaign settings';

  @override
  String get error => 'Error';

  @override
  String get mealDetails => 'Meal Details';

  @override
  String get kcal => 'kcal';

  @override
  String get gramsProtein => 'g protein';

  @override
  String get gramsCarbs => 'g carbs';

  @override
  String get gramsFat => 'g fat';

  @override
  String get mealName => 'Meal Name';

  @override
  String get mealType => 'Meal Type';

  @override
  String get description => 'Description';

  @override
  String get calories => 'calories';

  @override
  String get protein => 'Protein';

  @override
  String get carbohydrates => 'Carbohydrates';

  @override
  String get fat => 'Fat';

  @override
  String get deleteMealQuestion => 'Delete meal?';

  @override
  String areYouSureDeleteMeal(Object mealName) {
    return 'Are you sure you want to delete \"$mealName\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get manageMeals => 'Manage Meals';

  @override
  String get meals => 'meals';

  @override
  String get addMeal => 'Add Meal';

  @override
  String get noMealsAddedYet => 'No meals added yet';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get providerSessionNotFound => 'Provider session not found';

  @override
  String get mealAddedSuccessfully => 'Meal added successfully!';

  @override
  String get mealUpdatedSuccessfully => 'Meal updated successfully!';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get editMeal => 'Edit Meal';

  @override
  String get addNewMeal => 'Add New Meal';

  @override
  String get updateMealDetailsBelow => 'Update meal details below.';

  @override
  String get enterMealInformationBelow => 'Enter meal information below.';

  @override
  String get chooseImageFromDevice => 'Choose Image From Device';

  @override
  String get enterMealName => 'Enter meal name';

  @override
  String get selectMealType => 'Select Meal Type';

  @override
  String get writeMealDescription => 'Write meal description';

  @override
  String get nutritionInformation => 'Nutrition Information';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String fieldIsRequired(Object fieldName) {
    return '$fieldName is required';
  }

  @override
  String fieldMustBeValidNumber(Object fieldName) {
    return '$fieldName must be a valid number';
  }

  @override
  String get mealNameMustNotContainNumbers => 'Meal Name must not contain numbers';

  @override
  String get mealNameMustNotContainSymbols => 'Meal Name must not contain symbols';

  @override
  String get mealNameMustBeArabicOrEnglishOnly => 'Meal Name must be either Arabic or English only';

  @override
  String get descriptionMustNotContainSymbols => 'Description must not contain symbols';

  @override
  String get healthy => 'Healthy';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get lunch => 'Lunch';

  @override
  String get dinner => 'Dinner';

  @override
  String get vegetarian => 'Vegetarian';

  @override
  String get highProtein => 'High Protein';

  @override
  String get lowCarb => 'Low Carb';

  @override
  String get fastFood => 'Fast Food';

  @override
  String get manageCampaigns => 'Manage Campaigns';

  @override
  String get addCampaign => 'Add Campaign';

  @override
  String get noCampaignsAddedYet => 'No campaigns added yet';

  @override
  String get campaignAddedSuccessfully => 'Campaign added successfully';

  @override
  String get campaignUpdatedSuccessfully => 'Campaign updated successfully';

  @override
  String get campaignDeletedSuccessfully => 'Campaign deleted successfully';

  @override
  String get failedToAddCampaign => 'Failed to add campaign';

  @override
  String get failedToUpdateCampaign => 'Failed to update campaign';

  @override
  String get failedToDeleteCampaign => 'Failed to delete campaign';

  @override
  String get deleteCampaignQuestion => 'Delete campaign?';

  @override
  String areYouSureDeleteCampaign(Object campaignName) {
    return 'Are you sure you want to delete \"$campaignName\"?';
  }

  @override
  String get arrival => 'Arrival';

  @override
  String get editCampaign => 'Edit Campaign';

  @override
  String get addNewCampaign => 'Add New Campaign';

  @override
  String get updateCampaignDetailsBelow => 'Update campaign details below.';

  @override
  String get enterCampaignInformationBelow => 'Enter campaign information below.';

  @override
  String get campaignName => 'Campaign Name';

  @override
  String get enterCampaignName => 'Enter campaign name';

  @override
  String get campaignNumber => 'Campaign Number';

  @override
  String get enterCampaignNumber => 'Enter campaign number';

  @override
  String get numberOfPilgrims => 'Number of Pilgrims';

  @override
  String get enterPilgrimsCount => 'Enter pilgrims count';

  @override
  String get arrivalFrom => 'Arrival From';

  @override
  String get selectCountry => 'Select country';

  @override
  String get arrivalDateTime => 'Arrival Date & Time';

  @override
  String get selectArrivalDateTime => 'Select arrival date & time';

  @override
  String get writeExtraNotesAboutCampaign => 'Write extra notes about the campaign';

  @override
  String get campaignNameMustNotContainNumbers => 'Campaign Name must not contain numbers';

  @override
  String get campaignNameMustNotContainSymbols => 'Campaign Name must not contain symbols';

  @override
  String get campaignNameMustBeArabicOrEnglishOnly => 'Campaign Name must be either Arabic or English only';

  @override
  String get campaignNumberMustContainNumbersOnly => 'Campaign Number must contain numbers only';

  @override
  String get numberOfPilgrimsMustBeValidNumber => 'Number of Pilgrims must be a valid number';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get pleaseEnterValidPilgrimsCount => 'Please enter a valid pilgrims count';

  @override
  String get pleaseSelectArrivalDateTime => 'Please select arrival date and time';

  @override
  String get notifications => 'Notifications';

  @override
  String get errorLoadingNotifications => 'Error loading notifications';

  @override
  String get recentNotifications => 'Recent Notifications';

  @override
  String get providerNotifications => 'Provider Notifications';

  @override
  String get youAreAllCaughtUp => 'You are all caught up';

  @override
  String get unreadNotifications => 'unread notifications';

  @override
  String get markAllNotificationsAsRead => 'Mark all notifications as read';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get newProviderAlertsWillAppearHere => 'New provider alerts and updates will appear here.';

  @override
  String get date => 'Date';

  @override
  String get meal => 'Meal';

  @override
  String get status => 'Status';

  @override
  String get orders => 'Orders';

  @override
  String get clear => 'Clear';

  @override
  String get noOrdersFound => 'No orders found';

  @override
  String get selectCampaign => 'Select Campaign';

  @override
  String get allCampaigns => 'All Campaigns';

  @override
  String get campaign => 'Campaign';

  @override
  String get all => 'All';

  @override
  String get selectStatus => 'Select Status';

  @override
  String get completed => 'completed';

  @override
  String get cancelled => 'cancelled';

  @override
  String get pending => 'pending';

  @override
  String get unknown => 'Unknown';

  @override
  String get allReviews => 'All Reviews';

  @override
  String get viewReview => 'View Review';

  @override
  String get failedToLoadReviewDetails => 'Failed to load review details';

  @override
  String get reviewDetails => 'Review Details';

  @override
  String get pilgrimComment => 'Pilgrim Comment';

  @override
  String get reviewDate => 'Review Date';

  @override
  String get providerReply => 'Provider Reply';

  @override
  String get replyDate => 'Reply Date';

  @override
  String get noTextProvided => 'No text provided';

  @override
  String get noReplyYet => 'No reply yet';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get aiAnalysisUnavailable => 'AI analysis is currently unavailable.';

  @override
  String get providerIdIsMissing => 'Provider ID is missing';

  @override
  String get couldNotOpenPdfReport => 'Could not open PDF report';

  @override
  String get retry => 'Retry';

  @override
  String get mealAcceptance => 'Meal Acceptance';

  @override
  String get acceptedRequests => 'Accepted requests';

  @override
  String get feedbackAverage => 'Feedback Average';

  @override
  String get averageRating => 'Average rating';

  @override
  String get orderTrend => 'Order Trend';

  @override
  String get dailyOrdersLast7Days => 'Daily orders over the last 7 days';

  @override
  String get smartSuggestions => 'Smart Suggestions';

  @override
  String get pilgrimHealthSnapshot => 'Pilgrim Health Snapshot';

  @override
  String get commonDietaryHealthIndicators => 'Common dietary and health indicators';

  @override
  String get topRequestedMeals => 'Top Requested Meals';

  @override
  String get mostOrderedMealsToday => 'Most ordered meals today';

  @override
  String get updatedRecently => 'Updated recently';

  @override
  String get updated => 'Updated';

  @override
  String get dashboardOverview => 'Dashboard Overview';

  @override
  String get liveData => 'Live Data';

  @override
  String get todaysOrders => 'Today\'s Orders';

  @override
  String get acceptanceRate => 'Acceptance Rate';

  @override
  String get feedback => 'Feedback';

  @override
  String get reviews => 'Reviews';

  @override
  String get average => 'Average';

  @override
  String get highest => 'Highest';

  @override
  String get latestReview => 'Latest review';

  @override
  String get averageScore => 'Average score';

  @override
  String get noSuggestionsAvailableYet => 'No suggestions available yet.';

  @override
  String get diabetes => 'Diabetes';

  @override
  String get allergies => 'Allergies';

  @override
  String get lowSodium => 'Low Sodium';

  @override
  String get noMealRequestsYet => 'No meal requests yet';

  @override
  String get generateReport => 'Generate Report';

  @override
  String get aiDashboardInsights => 'AI Dashboard Insights';

  @override
  String get smartAnalysisBasedOnOrders => 'Smart analysis based on orders, meals, ratings, and risks';

  @override
  String get generatingAiInsights => 'Generating AI insights...';

  @override
  String get aiSummary => 'AI Summary';

  @override
  String get feedbackRiskAnalysis => 'Feedback & Risk Analysis';

  @override
  String get smartRecommendations => 'Smart Recommendations';

  @override
  String get noAiSummaryAvailableYet => 'No AI summary available yet.';

  @override
  String get noFeedbackRiskAnalysisAvailableYet => 'No feedback or risk analysis available yet.';

  @override
  String get noSmartRecommendationsAvailableYet => 'No smart recommendations available yet.';

  @override
  String get mostRequestedMeals => 'Most Requested Meals';

  @override
  String get failedToAcceptRequest => 'Failed to accept request';

  @override
  String get failedToCancelRequest => 'Failed to cancel request';

  @override
  String get failedToUpdateRequest => 'Failed to update request';

  @override
  String get changeOrderStatus => 'Change Order Status';

  @override
  String get errorLoadingRequests => 'Error loading requests';

  @override
  String get incomingRequests => 'Incoming Requests';

  @override
  String get acceptedOrders => 'Accepted Orders';

  @override
  String get noIncomingRequestsYet => 'No incoming requests yet';

  @override
  String get noAcceptedOrdersYet => 'No accepted orders yet';

  @override
  String get incoming => 'Incoming';

  @override
  String get accept => 'Accept';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';

  @override
  String get home => 'Home';

  @override
  String get requests => 'Requests';

  @override
  String get reports => 'Reports';

  @override
  String get account => 'Account';

  @override
  String get pilgrim => 'Pilgrim';

  @override
  String get orderNow => 'Order Now';

  @override
  String get browseDailyMeals => 'Browse daily meals';

  @override
  String get buffet => 'Buffet';

  @override
  String get exploreBuffetOptions => 'Explore buffet options';

  @override
  String get recommended => 'Recommended';

  @override
  String get groupService => 'Group Service';

  @override
  String get startOrder => 'Start Order';

  @override
  String get viewOptions => 'View Options';

  @override
  String get unknownMeal => 'Unknown Meal';

  @override
  String get tapToViewPreviousOrders => 'Tap to view previous orders';

  @override
  String get assalamuAlaikum => 'Assalamu Alaikum,';

  @override
  String get todaysMeals => 'Today’s Meals';

  @override
  String get mealTimesScheduledByCampaign => '*Meal times are scheduled by your campaign*';

  @override
  String get askYourAiAssistant => 'Ask Your AI Assistant';

  @override
  String get noPreviousOrdersYet => 'No previous orders yet';

  @override
  String get errorLoadingMeals => 'Error loading meals';

  @override
  String get smartFilters => 'Smart Filters';

  @override
  String get aiRecommendedMeals => 'AI Recommended Meals';

  @override
  String get allAvailableMeals => 'All Available Meals';

  @override
  String get selectYourMeal => 'Select Your Meal';

  @override
  String get browseMealsReviewNutrition => 'Browse meals, review nutrition and choose what fits your health needs.';

  @override
  String get aiRecommended => 'AI Recommended';

  @override
  String get allMeals => 'All Meals';

  @override
  String get providedBy => 'Provided by';

  @override
  String get selectMeal => 'Select Meal';

  @override
  String get noRecommendedMealsFound => 'No recommended meals found';

  @override
  String get tryViewingAllMealsInstead => 'Try viewing all meals instead.';

  @override
  String get yourNotifications => 'Your Notifications';

  @override
  String get newAlertsAndUpdatesWillAppearHere => 'New alerts and updates will appear here.';

  @override
  String get errorLoadingOrders => 'Error loading orders';

  @override
  String get previousOrders => 'Previous Orders';

  @override
  String get yourOrderHistory => 'Your Order History';

  @override
  String get reviewPreviousMealOrders => 'Review your previous meal orders and rate completed meals.';

  @override
  String get orderId => 'Order ID';

  @override
  String get reviewed => 'Reviewed';

  @override
  String get rateMeal => 'Rate Meal';

  @override
  String get submittedMealRequestsWillAppearHere => 'Your submitted meal requests will appear here.';

  @override
  String get pilgrimProfile => 'Pilgrim Profile';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get personalDetailsUpdated => 'Personal details updated';

  @override
  String get healthProfile => 'Health Profile';

  @override
  String get healthInformation => 'Health Information';

  @override
  String get healthInformationUpdated => 'Health information updated';

  @override
  String get failedToSaveHealthProfile => 'Failed to save health profile';

  @override
  String get pilgrimId => 'Pilgrim ID';

  @override
  String get activeAccount => 'Active Account';

  @override
  String get noCampaign => 'No Campaign';

  @override
  String get preferences => 'Preferences';

  @override
  String get age => 'Age';

  @override
  String get healthCondition => 'Health Condition';

  @override
  String get dietaryPreference => 'Dietary Preference';

  @override
  String get none => 'None';

  @override
  String get hypertension => 'Hypertension';

  @override
  String get heartDisease => 'Heart Disease';

  @override
  String get asthma => 'Asthma';

  @override
  String get kidneyDisease => 'Kidney Disease';

  @override
  String get liverDisease => 'Liver Disease';

  @override
  String get thyroidDisorder => 'Thyroid Disorder';

  @override
  String get highCholesterol => 'High Cholesterol';

  @override
  String get arthritis => 'Arthritis';

  @override
  String get epilepsy => 'Epilepsy';

  @override
  String get mobilityIssue => 'Mobility Issue';

  @override
  String get other => 'Other';

  @override
  String get regular => 'Regular';

  @override
  String get lowSugar => 'Low Sugar';

  @override
  String get lowSalt => 'Low Salt';

  @override
  String get nuts => 'Nuts';

  @override
  String get seafood => 'Seafood';

  @override
  String get dairy => 'Dairy';

  @override
  String get eggs => 'Eggs';

  @override
  String get gluten => 'Gluten';

  @override
  String get soy => 'Soy';

  @override
  String get sesame => 'Sesame';

  @override
  String get shellfish => 'Shellfish';

  @override
  String get wheat => 'Wheat';

  @override
  String get medication => 'Medication';

  @override
  String get diabetic => 'Diabetic';

  @override
  String allergyTag(Object allergy) {
    return '$allergy Allergy';
  }

  @override
  String get taste => 'Taste';

  @override
  String get presentation => 'Presentation';

  @override
  String get portionSize => 'Portion Size';

  @override
  String get temperature => 'Temperature';

  @override
  String get overallSatisfaction => 'Overall Satisfaction';

  @override
  String get pleaseSelectAtLeastOneRating => 'Please select at least one rating.';

  @override
  String get reviewSubmittedSuccessfully => 'Review submitted successfully';

  @override
  String get failed => 'Failed';

  @override
  String get writeComment => 'Write comment...';

  @override
  String get submit => 'Submit';

  @override
  String get userSessionNotFoundLoginAgain => 'User session not found. Please log in again.';

  @override
  String get failedToSubmitRequest => 'Failed to submit request';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get mealId => 'Meal ID';

  @override
  String get submitDate => 'Submit Date';

  @override
  String get submitTime => 'Submit Time';

  @override
  String get addNotes => 'Add Notes';

  @override
  String get optionalNotesForMealRequest => 'Optional notes for your meal request';

  @override
  String get writeAnyNoteHere => 'Write any note here...';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get requestSubmitted => 'Request Submitted';

  @override
  String get mealRequestSubmittedSuccessfully => 'Your meal request has been submitted successfully.';

  @override
  String get done => 'Done';

  @override
  String get requestMeal => 'Request Meal';

  @override
  String get history => 'History';

  @override
  String get smartPlatformForServingPilgrims => 'Smart platform for serving pilgrims';

  @override
  String get chooseAccountTypeAndFillDetails => 'Choose your account type and fill in your details';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get fullNameHelper => 'Arabic or English letters only, 3 to 50 characters';

  @override
  String get idNumber => 'ID Number';

  @override
  String get enterYourPilgrimId => 'Enter your pilgrim ID';

  @override
  String get enterYourProviderId => 'Enter your provider ID';

  @override
  String get idNumberHelper => 'Numbers only, 6 to 20 digits';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get passwordHelper => '8-20 chars, uppercase, lowercase, number, special char, English only';

  @override
  String get campaignId => 'Campaign ID';

  @override
  String get enterYourCampaignId => 'Enter your campaign ID';

  @override
  String get numbersOnly => 'Numbers only';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get emailExample => 'Example: name@example.com';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get nusuqCopyright => '© NUSUQ 2026 - All rights reserved';

  @override
  String get integratedSystemForServingPilgrims => 'Integrated system for serving pilgrims';

  @override
  String get enterYourPhoneNumber => 'Enter your phone number';

  @override
  String get phoneHelper => 'Choose country code, then enter the local number only';

  @override
  String get pleaseEnterFullName => 'Please enter your full name';

  @override
  String get fullNameTooShort => 'Full name must be at least 3 characters';

  @override
  String get fullNameTooLong => 'Full name must not exceed 50 characters';

  @override
  String get fullNameNoNumbers => 'Full name must not contain numbers';

  @override
  String get fullNameArabicOrEnglishOnly => 'Full name must be Arabic only or English only';

  @override
  String get pleaseEnterPilgrimId => 'Please enter your pilgrim ID';

  @override
  String get pleaseEnterProviderId => 'Please enter your provider ID';

  @override
  String get idMustNotContainSpaces => 'ID must not contain spaces';

  @override
  String get idNumbersOnly => 'ID must contain numbers only';

  @override
  String get idTooShort => 'ID number is too short';

  @override
  String get idTooLong => 'ID number is too long';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordNoSpaces => 'Password must not contain spaces';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordTooLong => 'Password must not exceed 20 characters';

  @override
  String get passwordNeedsUppercase => 'Password must contain at least one uppercase letter';

  @override
  String get passwordNeedsLowercase => 'Password must contain at least one lowercase letter';

  @override
  String get passwordNeedsNumber => 'Password must contain at least one number';

  @override
  String get passwordNeedsSpecial => 'Password must contain at least one special character';

  @override
  String get passwordEnglishOnly => 'Password must use English letters, numbers, and symbols only';

  @override
  String get pleaseEnterCampaignId => 'Please enter your campaign ID';

  @override
  String get campaignIdNoSpaces => 'Campaign ID must not contain spaces';

  @override
  String get campaignIdNumbersOnly => 'Campaign ID must contain numbers only';

  @override
  String get campaignIdTooLong => 'Campaign ID is too long';

  @override
  String get campaignIdGreaterThanZero => 'Campaign ID must be greater than 0';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get phoneNoSpaces => 'Phone number must not contain spaces';

  @override
  String get phoneDigitsOnly => 'Phone number must contain digits only';

  @override
  String get enterLocalNumberOnly => 'Enter the local number only';

  @override
  String get phoneTooShort => 'Phone number is too short';

  @override
  String get phoneTooLong => 'Phone number is too long';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get emailNoSpaces => 'Email must not contain spaces';

  @override
  String get emailTooLong => 'Email is too long';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';

  @override
  String get campaignIdDoesNotExist => 'The campaign ID does not exist. Please enter a valid campaign ID.';

  @override
  String get emailAlreadyRegistered => 'This email is already registered.';

  @override
  String get phoneAlreadyRegistered => 'This phone number is already registered.';

  @override
  String get pilgrimIdAlreadyRegistered => 'This pilgrim ID is already registered.';

  @override
  String get providerIdAlreadyRegistered => 'This provider ID is already registered.';

  @override
  String get unableToConnectToServer => 'Unable to connect to the server. Please make sure the backend is running.';

  @override
  String get somethingWentWrongCreatingAccount => 'Something went wrong while creating the account. Please review your data and try again.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get createAccount => 'Create Account';

  @override
  String get password => 'Password';

  @override
  String get logIn => 'Log in';

  @override
  String get enterIdAndPassword => 'Enter your ID and password to access your account';

  @override
  String get enterYourIdNumber => 'Enter your ID number';

  @override
  String get loginPasswordHelper => '8 to 20 characters, no spaces';

  @override
  String get dontHaveAccount => 'Don’t have an account? ';

  @override
  String get pleaseEnterYourId => 'Please enter your ID';

  @override
  String get incorrectIdOrPassword => 'Incorrect ID or password.';

  @override
  String get enterBothIdAndPassword => 'Please enter both ID and password.';

  @override
  String get somethingWentWrongDuringLogin => 'Something went wrong during login. Please try again.';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterCodeAndCreateNewPassword => 'Enter the code sent to your email and create a new password';

  @override
  String get enterEmailToReceiveResetCode => 'Enter your email to receive a password reset code';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get enter6DigitCode => 'Enter 6-digit code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendInSeconds(Object seconds) {
    return 'Resend in $seconds s';
  }

  @override
  String get newPassword => 'New Password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterNewPassword => 'Re-enter new password';

  @override
  String get sendCode => 'Send Code';

  @override
  String get changeEmail => 'Change email';

  @override
  String get codeSentToYourEmail => 'Code sent to your email';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get pleaseEnterResetCode => 'Please enter the reset code';

  @override
  String get codeMustBe6Digits => 'Code must be 6 digits';

  @override
  String get pleaseEnterNewPassword => 'Please enter your new password';

  @override
  String get passwordNeedsLetter => 'Password must contain at least one letter';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get quickQuestions => 'Quick Questions';

  @override
  String get quickQuestionHealthProfileMeals => 'What meals match my health profile?';

  @override
  String get quickQuestionLowSugarMeal => 'Suggest a low-sugar meal.';

  @override
  String get quickQuestionTodayMealSchedule => 'What is today’s meal schedule?';

  @override
  String get quickQuestionHighProteinOptions => 'Show me high-protein options.';

  @override
  String get aiWelcomeMessage => 'Assalamu Alaikum 👋 I’m your AI assistant. I can help you choose meals, explain nutrition, and suggest options based on your health profile.';

  @override
  String get aiChatSomethingWentWrong => 'Sorry, something went wrong. Please try again.';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get askSomething => 'Ask something...';

  @override
  String get typing => 'Typing...';

  @override
  String get fullNameNoSymbols => 'Full name must not contain symbols';

  @override
  String get peanuts => 'Peanuts';

  @override
  String get milk => 'Milk';

  @override
  String get fish => 'Fish';

  @override
  String get completeHealthProfileForAiMeals => 'Complete your health profile to get AI recommended meals';

  @override
  String get completeHealthProfileFirstThenTryAgain => 'Please complete your health profile first, then try again.';

  @override
  String get mealsAreNotCurrentlyAvailableForYourCampaign => 'Meals are not currently available for your campaign';

  @override
  String get yourCampaignProviderHasNotAddedMealsYet => 'Your campaign provider has not added meals yet.';

  @override
  String get role => 'Role';

  @override
  String get administrator => 'Administrator';

  @override
  String get active => 'Active';

  @override
  String get adminId => 'Admin ID';

  @override
  String get systemAdmin => 'System Admin';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to log out?';

  @override
  String get failedToLoadAdminProfile => 'Failed to load admin profile';

  @override
  String get tryAgain => 'Try again';

  @override
  String get admin => 'admin';

  @override
  String get id => 'ID';

  @override
  String get manageAccounts => 'Manage Accounts';

  @override
  String get viewAndManageUsers => 'View and manage users';

  @override
  String get monitorOrders => 'Monitor Orders';

  @override
  String get trackMealOrders => 'Track meal orders';

  @override
  String get createAndManageAlerts => 'Create and manage alerts';

  @override
  String get createNotification => 'Create Notification';

  @override
  String get sendNotifications => 'Send Notifications';

  @override
  String get createAlertsForPilgrimsAndProviders => 'Create alerts for pilgrims and providers';

  @override
  String get arabicTitle => 'Arabic Title';

  @override
  String get englishTitle => 'English Title';

  @override
  String get enterArabicTitle => 'Enter Arabic title';

  @override
  String get enterEnglishTitle => 'Enter English title';

  @override
  String get notificationType => 'Notification Type';

  @override
  String get alert => 'Alert';

  @override
  String get announcement => 'Announcement';

  @override
  String get reminder => 'Reminder';

  @override
  String get recipients => 'Recipients';

  @override
  String get allPilgrims => 'All Pilgrims';

  @override
  String get allProviders => 'All Providers';

  @override
  String get specificNotificationHint => 'For a specific pilgrim or provider, send the notification directly from Manage Accounts.';

  @override
  String get arabicMessage => 'Arabic Message';

  @override
  String get englishMessage => 'English Message';

  @override
  String get enterArabicMessage => 'Enter Arabic message';

  @override
  String get enterEnglishMessage => 'Enter English message';

  @override
  String get sending => 'Sending...';

  @override
  String get sendNotification => 'Send Notification';

  @override
  String get notificationSentSuccessfully => 'Notification sent successfully';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get accountInformationUpdatedSuccessfully => 'Account information updated successfully';

  @override
  String get failedToUpdateAccountInformation => 'Failed to update account information';

  @override
  String get accountActivatedSuccessfully => 'Account activated successfully';

  @override
  String get accountDeactivatedSuccessfully => 'Account deactivated successfully';

  @override
  String get failedToUpdateAccountStatus => 'Failed to update account status';

  @override
  String get sendNotificationTo => 'Send Notification to';

  @override
  String get send => 'Send';

  @override
  String get pleaseFillAllNotificationFields => 'Please fill all notification fields';

  @override
  String get failedToSendNotification => 'Failed to send notification';

  @override
  String get failedToLoadAccounts => 'Failed to load accounts.';

  @override
  String get registeredProviders => 'Registered Providers';

  @override
  String get providersCampaignsAndPilgrims => 'Providers, campaigns, and pilgrims';

  @override
  String get providers => 'Providers';

  @override
  String get notify => 'Notify';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get activate => 'Activate';

  @override
  String get inactive => 'Inactive';

  @override
  String get noCampaignsRegisteredForThisProvider => 'No campaigns registered for this provider.';

  @override
  String get no => 'No.';

  @override
  String get expected => 'expected';

  @override
  String get registered => 'registered';

  @override
  String get noPilgrimsRegisteredUnderThisCampaign => 'No pilgrims registered under this campaign.';

  @override
  String get noAccountsFound => 'No accounts found';

  @override
  String get registeredAccountsWillAppearHere => 'Registered providers, campaigns, and pilgrims will appear here.';

  @override
  String get adminAlerts => 'Admin Alerts';

  @override
  String get failedToLoadNotifications => 'Failed to load notifications';

  @override
  String get noMessage => 'No message';

  @override
  String get accounts => 'Accounts';

  @override
  String get alerts => 'Alerts';

  @override
  String get failedToLoadOrders => 'Failed to load orders.';

  @override
  String get campaignOrders => 'Campaign Orders';

  @override
  String get campaignOrdersAndProviders => 'Campaign orders and providers';

  @override
  String get noOrdersFoundUnderThisCampaign => 'No orders found under this campaign.';

  @override
  String get noDate => 'No date';

  @override
  String get mealOrdersWillAppearHere => 'Meal orders will appear here grouped by campaign and provider.';
}
