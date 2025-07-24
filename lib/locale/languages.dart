import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get language;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get gallery;

  String get camera;

  String get editProfile;

  String get reload;

  String get pressBackAgainToExitApp;

  String get invalidUrl;

  String get cancel;

  String get delete;

  String get demoUserCannotBeGrantedForThis;

  String get somethingWentWrong;

  String get yourInternetIsNotWorking;

  String get profileUpdatedSuccessfully;

  String get wouldYouLikeToSetProfilePhotoAs;

  String get yourConfirmPasswordDoesnT;

  String get yes;

  String get submit;

  String get firstName;

  String get lastName;

  String get password;

  String get confirmPassword;

  String get email;

  String get emailIsARequiredField;

  String get pleaseEnterValidEmailAddress;

  String get signIn;

  String get explore;

  String get settings;

  String get rateNow;

  String get logout;

  String get rememberMe;

  String get forgotPassword;

  String get signUp;

  String get alreadyHaveAnAccount;

  String get deleteAccount;

  String get notifications;

  String get signInFailed;

  String get logIn;

  String get stayTunedNoNew;

  String get noNewNotificationsAt;

  String get walkthroughTitle1;

  String get walkthroughDesp1;

  String get walkthroughTitle2;

  String get walkthroughDesp2;

  String get walkthroughTitle3;

  String get walkthroughDesp3;

  String get lblSkip;

  String get lblNext;

  String get lblGetStarted;

  String get optionTitle;

  String get optionDesp;

  String get welcomeBackToStreamIt;

  String get weHaveEagerlyAwaitedYourReturn;

  String get dontHaveAnAccount;

  String get or;

  String get dontWorryItHappens;

  String get linkSentToYourEmail;

  String get checkYourInboxAndChangePassword;

  String get continues;

  String get oTPVerification;

  String get checkYourSmsInboxAndEnterTheCodeYouGet;

  String get didntGetTheOTP;

  String get resendOTP;

  String get verify;

  String get clearAll;

  String get notificationDeleted;

  String get doYouWantToRemoveNotification;

  String get doYouWantToClearAllNotification;

  String get successfully;

  String get userCancelled;

  String get appleSigninIsNot;

  String get searchHere;

  String get noDataFound;

  String get subscribe;

  String get subscribeToWatch;

  String get playNow;

  String get continueWatching;

  String get shareYourThoughtsWithUs;

  String get weValueYourOpinion;

  String get genres;

  String get trailer;

  String get ua18;

  String get watchNow;

  String get cast;

  String get directors;

  String get reviews;

  String get viewAll;

  String get rating;

  String get justNow;

  String get daysAgo;

  String get yesterday;

  String get ago;

  String get min;

  String get hr;

  String get s;

  String get moreLikeThis;

  String get shareYourThoughtsOnYourFavoriteMovie;

  String get rateThisMovie;

  String get rateThisTvShow;

  String get yourReview;

  String get edit;

  String get close;

  String get oppsLooksLikeYouReview;

  String get retry;

  String get selectDownloadQuality;

  String get onlyOnWiFi;

  String get download;

  String get moviesOf;

  String get season;

  String get episode;

  String get watchlist;

  String get searchMoviesShowsAndMore;

  String get trendingMovies;

  String get comingSoon;

  String get remindMe;

  String get remind;

  String get readLess;

  String get readMore;

  String get liveTv;

  String get live;

  String get profile;

  String get expiringOn;

  String get updrade;

  String get subscribeToEnjoyMore;

  String get daysFreeTrail;

  String get privacyPolicy;

  String get helpSupport;

  String get appLanguage;

  String get yourDownloads;

  String get subscriptionPlanDeviceConnected;

  String get accountSettings;

  String get version;

  String get registeredMobileNumber;

  String get otherDevices;

  String get yourDevice;

  String get lastUsed;

  String get proceed;

  String get allYourDataWill;

  String get deleteAccountPermanently;

  String get mobileNumber;

  String get savechanges;

  String get loginToStreamit;

  String get startWatchingFromWhereYouLeftOff;

  String get troubleLoggingIn;

  String get getHelp;

  String get yourWatchlistIsEmpty;

  String get contentAddedToYourWatchlist;

  String get add;

  String get subscribeNowAndDiveInto;

  String get pay;

  String get next;

  String get subscrption;

  String get validUntil;

  String get choosePaymentMethod;

  String get secureCheckoutInSeconds;

  String get proceedPayment;

  String get actors;

  String get movies;

  String get contentRestrictedAccess;

  String get areYou18Above;

  String get displayAClearProminentWarning;

  String get all;

  String get tVShows;

  String get videos;

  String get newlyAdded;

  String get free;

  String get phnRequiredText;

  String get inputMustBeNumberOrDigit;

  String get dateOfBirth;

  String get whatYourMobileNo;

  String get withAValidMobileNumberYouCanConnectWithStreamit;

  String get otpSentToYourSMS;

  String get checkYourSmsInboxAndVerifyYoourMobile;

  String get pleaseTryAgainAfterSomeTime;

  String get pleaseEnterAValidCode;

  String get pleaseCheckYourMobileInternetConnection;

  String get error;

  String get sorryCouldnFindYourSearch;

  String get trySomethingNew;

  String get genresNotAvailable;

  String get downloadSuccessfully;

  String get popularMovies;

  String get confirm;

  String get doYouConfirmThisPlan;

  String get transactionFailed;

  String get transactionCancelled;

  String get no;

  String get lblChangeCountry;

  String get logOutAll;

  String get taxIncluded;

  String get bookNow;

  String get firstNameIsRequiredField;

  String get lastNameIsRequiredField;

  String get passwordIsRequiredField;

  String get confirmPasswordIsRequiredField;

  String get pleaseEnterConfirmPassword;

  String get home;

  String get search;

  String get mobileNumberIsRequiredField;

  String get youHaveAlreadyDownloadedThisMovie;

  String get imdb;

  String get mb;

  String get stripePay;

  String get razorPay;

  String get payStackPay;

  String get paypalPay;

  String get flutterWavePay;

  String get contextNotFound;

  String get verificationFailed;

  String get english;

  String get hour;

  String get minute;

  String get sec;

  String get videoNotFound;

  String get auto;

  String get recommended;

  String get medium;

  String get high;

  String get low;

  String get helpSetting;

  String get pleaseConfirmContent;

  String get toWatch;

  String get plan;

  String get toThe;

  String get noDeviceAvailable;

  String get noItemsToContinueWatching;

  String get noItemsAddedToTheWatchlist;

  String get ok;

  String get removeFromContinueWatch;

  String get addedToWatchList;

  String get removedFromWatchList;

  String get removeSelectedFromWatchList;

  String get removedFromContinueWatch;

  String get pleaseEnterAValidMobileNo;

  String get pleaseAddYourReview;

  String get thisMovieIsCurrentlUnavailableToWatch;

  String get thisVideoIsCurrentlUnavailableToWatch;

  String get subscriptionHistory;

  String get type;

  String get amount;

  String get cancelPlan;

  String get device;

  String get clear;

  String get doYouWantToLogoutFrom;

  String get sAlphabet;

  String get eAlphabet;

  String get viewLess;

  String get removeSelectedFromDownloads;

  String get noPaymentMethodsFound;

  String get save;

  String get completeProfile;

  String get completeProfileSubtitle;

  String get getVerificationCode;

  String get contentRating;

  String get profiles;

  String get addProfile;

  String get clearSearchHistoryConfirmation;

  String get clearSearchHistorySubtitle;

  String get searchingForDevice;

  String get screenCast;

  String get connectTo;

  String get disconnectFrom;

  String get signInWithGoogle;

  String get signInWithApple;

  String get whoIsWatching;

  String get doYouWantTo;

  String get mobile;

  String get tablet;

  String get laptop;

  String get supported;

  String get notSupported;

  String get freeMovies;

  String get top10;

  String get latestMovies;

  String get topChannels;

  String get popularTvShows;

  String get popularVideos;

  String get popularLanguages;

  String get trending;

  String get trendingInYourCountry;

  String get favoriteGenres;

  String get basedOnYourPreviousWatch;

  String get mostLiked;

  String get mostViewed;

  String get yourFavoritePersonalities;

  String get name;

  String get nameCannotBeEmpty;

  String get update;

  String get remove;

  String get recentSearch;

  String get noRecentSearches;

  String get chooseImageSource;

  String get noInternetAvailable;

  String get goToYourDownloads;

  String get bySigningYouAgreeTo;

  String get lowQuality;

  String get mediumQuality;

  String get highQuality;

  String get veryHighQuality;

  String get ultraQuality;

  String get termsConditions;

  String get ofAll;

  String get servicesAnd;

  String get newProfileAddedSuccessfully;

  String get doYouWantToDeleteYourReview;

  String get noSearchDataFound;

  String get searchHistory;

  String get youHaveBeenLoggedOutOfYourAccountOn;

  String get faqs;

  String get termsOfUse;

  String get refundAndCancellationPolicy;

  String get dataDeletionRequest;

  String get aboutUs;

  String get total;

  String get percentage;

  String get fixed;

  String get android;

  String get ios;

  String get hindi;

  String get arabic;

  String get french;

  String get german;

  String get noFAQsfound;

  String get tax;

  String get downloadHasBeenStarted;

  String get yourDeviceIsNot;

  String get pleaseUpgradeToContinue;

  String get cancelled;

  String get expired;

  String get active;

  String get connectToWIFI;

  String get logoutAllConfirmation;

  String get share;

  String get like;

  String get pip;

  String get videoCast;

  String get castingNotSupported;

  String get left;

  String get loginWithOtp;

  String get loginWithEmail;

  String get createYourAccount;

  String get changePassword;

  String get yourNewPasswordMust;

  String get yourOldPasswordDoesnT;

  String get yourNewPasswordDoesnT;

  String get oldAndNewPassword;

  String get yourPasswordHasBeen;

  String get youCanNowLog;

  String get done;

  String get oldPassword;

  String get newPassword;

  String get confirmNewPassword;

  String get birthdayIsRequired;

  String get childrenSProfile;

  String get madeForKidsUnder12;

  String get otpVerification;

  String get weHaveSentYouOTPOnYourRegisterEmailAddress;

  String get otpVerifiedSuccessfully;

  String get otpSentSuccessfully;

  String get otpVerifiedFailed;

  String get confirmPIN;

  String get enterPIN;

  String get enterYourNewParentalPinForYourKids;

  String get setPIN;

  String get changePIN;

  String get parentalControl;

  String get invalidPIN;

  String get kids;

  String get enter4DigitParentalControlPIN;

  String get parentalLock;

  String get profileDeletedSuccessfully;

  String get pinNotMatched;

  String get pleaseEnterConfirmPin;

  String get pleaseEnterNewPIN;

  String get codeWithColon;

  String get useThisCodeToGet;

  String get off;

  String get expiryDate;

  String get apply;

  String get coupons;

  String get enterCouponCode;

  String get check;

  String get allCoupons;

  String get oopsWeCouldnTFind;

  String get doYouWantToRemoveCoupon;

  String get noSubscriptionHistoryFound;

  String get couponDiscount;

  String get linkTv;

  String get youHaveBeenLoggedOutSuccessfully;

  String get rented;

  String get rent;

  String get rentFor;

  String rentedesc(int availableFor, String duration);

  String youCanWatchThis(int duration);

  String get thisIsANonRefundable;

  String get thisContentIsOnly;

  String get youCanPlayYour;

  String get validity;

  String get days;

  String get watchTime;

  String get hours;

  String get byRentingYouAgreeToOur;

  String get pleaseAgreeToThe;

  String get successfullyRentedMoviesOn;

  String enjoyUntilDays(int days);

  String get beginWatching;

  String doYouConfirmThis(String movieName);

  String get unlockedVideo;

  String get info;

  String get payPerView;

  String get newPinSuccessfullySaved;

  String get successfullyUpdated;

  String get defaultLabel;

  String get quality;

  String get subtitle;

  String get rentDetails;

  String get skip;

  String get nextEpisode;

  String get pleaseSelectPaymentMethod;

  String get tvLinkedSuccessfully;

  String get cameraPermissionDenied;
}