class APIEndPoints {
  static const String appConfiguration = 'app-configuration';

  //Auth & User
  static const String register = 'register';
  static const String socialLogin = 'social-login';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String deviceLogout = 'device-logout';

  static const String deviceLogoutNoAuth = 'device-logout-data';
  static const String changePassword = 'change-password';
  static const String forgotPassword = 'forgot-password';
  static const String userDetail = 'user-detail';
  static const String updateProfile = 'update-profile';
  static const String deleteUserAccount = 'delete-account';
  static const String logOutAll = 'logout-all';
  static const String logOutAllNoAuth = 'logout-all-data';
  static const String getNotification = 'notification-list';
  static const String removeNotification = 'notification-remove';
  static const String clearAllNotification = 'notification-deleteall';

  //home choose service api
  static const String dashboardDetails = 'dashboard-detail';
  static const String dashboardDetailsOtherData = 'dashboard-detail-data';
  static const String genresDetails = 'genre-list';
  static const String movie = 'movie';
  static const String tvShow = 'tv_show';
  static const String video = 'video';
  static const String actorDetails = 'castcrew-list';
  static const String watchList = 'watch-list';
  static const String deleteWatchList = 'delete-watchlist';
  static const String deleteDownloads = 'delete-download';
  static const String videoList = 'video-list';
  static const String planLists = 'plan-list';
  static const String movieLists = 'movie-list';
  static const String channelList = 'channel-list';
  static const String tvShowList = 'tvshow-list';
  static const String liveTvDashboard = 'livetv-dashboard';
  static const String liveTvDetails = 'livetv-details';
  static const String episodeList = 'episode-list';
  static const String movieDetails = 'movie-details';
  static const String videoDetails = 'video-details';
  static const String episodeDetails = 'episode-details';
  static const String tvShowDetails = 'tvshow-details';
  static const String saveRating = 'save-rating';
  static const String deleteRating = 'delete-rating';
  static const String saveDownload = 'save-download';
  static const String saveContinueWatch = 'save-continuewatch';
  static const String saveLikes = 'save-likes';
  static const String searchList = 'search-list';
  static const String getSearchMovie = 'get-search';
  static const String comingSoon = 'coming-soon';
  static const String saveWatchlist = 'save-watchlist';
  static const String saveEntertainmentViews = 'save-entertainment-views';

  static const String profileDetails = 'profile-details';
  static const String accountSetting = 'account-setting';
  static const String reviewDetails = 'get-rating';
  static const String editProfile = 'update-profile';
  static const String saveReminder = 'save-reminder';
  static const String saveSubscriptionDetails = 'save-subscription-details';
  static const String subscriptionHistory = 'user-subscription_histroy';
  static const String cancelSubscription = 'cancle-subscription';
  static const String pageList = 'page-list';

  // Continue Watching Api
  static const String continueWatchList = 'continuewatch-list';
  static const String deleteContinueWatch = 'delete-continuewatch';

  // watch profile
  static const String getWatchingProfileList = 'user-profile-list';
  static const String editWatchingProfile = 'save-userprofile';
  static const String deleteWatchingProfile = 'delete-userprofile';

  // search
  static const String saveSearch = 'save-search';
  static const String deleteSearch = 'delete-search';
  static const String saveEntertainmentCompletedView = 'save-watch-content';

  static const String faqList = 'faq-list';
  static const String changePin = 'change-pin';
  static const String sendOtp = 'send-otp';
  static const String verifyOtp = 'verify-otp';
  static const String verifyPin = 'verify-pin';
  static const String updateParentalLock = 'update-parental-lock';
  static const String bannerList= 'banner-data';

  // Coupon Api
  static const String couponList = 'coupon-list';


  // QR Code Scan Link TV
  static const String linkTv = 'tv/confrim-session';

  //Rental
  static const String rentedContentList = 'unlocked-content';
  static const String payPerViewList = 'v2/pay-per-view-list';
  static const String startDate = 'start-date';
  static const String rentalHistory = 'transaction-history';
  static const String saveRentDetails = 'save-payment-pay-per-view';

}