import 'languages.dart';

class LanguageAr extends BaseLanguage {
  @override
  String get language => 'لغة';

  @override
  String get badRequest => '400: طلب سيء';

  @override
  String get forbidden => '403: ممنوع';

  @override
  String get pageNotFound => '404: الصفحة غير موجودة';

  @override
  String get tooManyRequests => '429:طلبات كثيرة جداً';

  @override
  String get internalServerError => '500: خطأ داخلي في الخادم';

  @override
  String get badGateway => '502 مدخل غير صالح';

  @override
  String get serviceUnavailable => '503: الخدمة غير متاحة';

  @override
  String get gatewayTimeout => '504: مهلة البوابة';

  @override
  String get gallery => 'معرض';

  @override
  String get camera => 'آلة تصوير';

  @override
  String get editProfile => 'تحرير الملف الشخصي';

  @override
  String get reload => 'إعادة تحميل';

  @override
  String get pressBackAgainToExitApp => 'اضغط مرة أخرى للخروج من التطبيق';

  @override
  String get invalidUrl => 'عنوان URL غير صالح';

  @override
  String get cancel => 'يلغي';

  @override
  String get delete => 'يمسح';

  @override
  String get demoUserCannotBeGrantedForThis =>
      'لا يمكن منح المستخدم التجريبي لهذا الإجراء';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get yourInternetIsNotWorking => 'الإنترنت الخاص بك لا يعمل';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get wouldYouLikeToSetProfilePhotoAs =>
      'هل ترغب في تعيين هذه الصورة كصورة ملفك الشخصي؟';

  @override
  String get yourConfirmPasswordDoesnT =>
      'تأكيد كلمة المرور الخاصة بك لا يتطابق مع كلمة المرور!';

  @override
  String get yes => 'نعم';

  @override
  String get submit => 'يُقدِّم';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get emailIsARequiredField => 'البريد الإلكتروني هو حقل مطلوب';

  @override
  String get pleaseEnterValidEmailAddress =>
      'يرجى إدخال عنوان بريد إلكتروني صالح!!';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get explore => 'يستكشف';

  @override
  String get settings => 'إعدادات';

  @override
  String get rateNow => 'قيم الآن';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get rememberMe => 'تذكرنى';

  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get signUp => 'اشتراك';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get notifications => 'إشعارات';

  @override
  String get signInFailed => 'فشل تسجيل الدخول';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get stayTunedNoNew => 'ابقوا متابعين! لا توجد إشعارات جديدة.';

  @override
  String get noNewNotificationsAt =>
      'لا توجد إشعارات جديدة في الوقت الراهن. سنبقيك على اطلاع عندما يكون هناك تحديث';

  @override
  String get walkthroughTitle1 =>
      'شاهد على أي جهاز: استمتع بالمحتوى الخاص بنا أينما ذهبت!';

  @override
  String get walkthroughDesp1 => 'البث عبر جميع الأجهزة دون رسوم إضافية.';

  @override
  String get walkthroughTitle2 =>
      'التنزيل والانطلاق: يمكنك الوصول إلى المحتوى الخاص بك في أي مكان وفي أي وقت وعلى أي جهاز';

  @override
  String get walkthroughDesp2 =>
      'قم بتنزيل المحتوى والاستمتاع به أثناء التنقل، في أي مكان وفي أي وقت.';

  @override
  String get walkthroughTitle3 =>
      'استمتع بالحرية دون التزامات أو متاعب - انضم إلينا اليوم!';

  @override
  String get walkthroughDesp3 => 'انضم إلينا بدون أي متاعب وبدون عقود مطلوبة.';

  @override
  String get lblSkip => 'يتخطى';

  @override
  String get lblNext => 'التالي';

  @override
  String get lblGetStarted => 'ابدأ';

  @override
  String get optionTitle => 'اكتشف أفضل العروض مع الأنواع المخصصة لتفضيلاتك.';

  @override
  String get optionDesp =>
      'استكشف العروض المنسقة عبر الأنواع المصممة لتناسب تفضيلات المشاهدة الخاصة بك.';

  @override
  String get welcomeBackToStreamIt => 'مرحبًا بك مرة أخرى في StreamIt!';

  @override
  String get weHaveEagerlyAwaitedYourReturn => 'لقد انتظرنا عودتك بفارغ الصبر.';

  @override
  String get dontHaveAnAccount => 'ليس لديك حساب؟ ';

  @override
  String get or => 'أو';

  @override
  String get dontWorryItHappens =>
      'لا تقلق! يحدث ذلك. الرجاء إدخال البريد الإلكتروني المرتبط بحسابك';

  @override
  String get linkSentToYourEmail => 'تم إرسال الرابط إلى بريدك الإلكتروني!';

  @override
  String get checkYourInboxAndChangePassword =>
      'تحقق من صندوق الوارد الخاص بك وقم بتغيير كلمة المرور';

  @override
  String get continues => 'يكمل';

  @override
  String get oTPVerification => 'التحقق من OTP';

  @override
  String get checkYourSmsInboxAndEnterTheCodeYouGet =>
      'تحقق من صندوق الوارد الخاص بالرسائل النصية القصيرة وأدخل الرمز الذي تلقيته.';

  @override
  String get didntGetTheOTP => 'لم تحصل على OTP؟';

  @override
  String get resendOTP => 'إعادة إرسال كلمة المرور لمرة واحدة';

  @override
  String get verify => 'يؤكد';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get notificationDeleted => 'تم حذف الإشعار';

  @override
  String get doYouWantToRemoveNotification => 'هل تريد إزالة الإخطار';

  @override
  String get doYouWantToClearAllNotification => 'هل تريد مسح كافة الإخطارات';

  @override
  String get successfully => 'بنجاح';

  @override
  String get userCancelled => 'تم إلغاء المستخدم';

  @override
  String get appleSigninIsNot => 'Apple SignIn غير متاح لجهازك';

  @override
  String get searchHere => 'ابحث هنا';

  @override
  String get noDataFound => 'لم يتم العثور على بيانات';

  @override
  String get subscribe => 'يشترك';

  @override
  String get subscribeToWatch => 'اشترك للمشاهدة';

  @override
  String get playNow => 'العب الآن';

  @override
  String get continueWatching => 'مواصلة المشاهدة ';

  @override
  String get shareYourThoughtsWithUs => 'شارك أفكارك معنا!';

  @override
  String get weValueYourOpinion => 'نحن نقدر رأيك! شارك بتعليقاتك معنا اليوم.';

  @override
  String get genres => 'الأنواع';

  @override
  String get trailer => 'جَرَّار';

  @override
  String get ua18 => 'ش/أ 18';

  @override
  String get watchNow => 'شاهد الآن';

  @override
  String get cast => 'يلقي';

  @override
  String get directors => 'المديرين';

  @override
  String get reviews => 'التعليقات';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get rating => 'تصنيف';

  @override
  String get justNow => 'الآن';

  @override
  String get daysAgo => 'منذ أيام';

  @override
  String get yesterday => 'أمس';

  @override
  String get ago => 'منذ';

  @override
  String get min => 'دقيقة';

  @override
  String get hr => 'ساعة';

  @override
  String get s => 'ق';

  @override
  String get moreLikeThis => 'المزيد من هذا القبيل';

  @override
  String get shareYourThoughtsOnYourFavoriteMovie =>
      'شارك أفكارك حول فيلمك المفضل';

  @override
  String get rateThisMovie => 'قيم هذا الفيلم';

  @override
  String get rateThisTvShow => 'قيم هذا البرنامج التلفزيوني';

  @override
  String get yourReview => 'مراجعتك';

  @override
  String get edit => 'يحرر';

  @override
  String get close => 'يغلق';

  @override
  String get oppsLooksLikeYouReview =>
      'انتبه! يبدو أنك لم تقم بإضافة أي مراجعة بعد.';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get selectDownloadQuality => 'حدد جودة التنزيل';

  @override
  String get onlyOnWiFi => 'فقط على خدمة الواي فاي';

  @override
  String get download => 'تحميل';

  @override
  String get moviesOf => 'أفلام ';

  @override
  String get season => 'موسم';

  @override
  String get episode => 'حلقة ';

  @override
  String get watchlist => 'قائمة المشاهدة';

  @override
  String get searchMoviesShowsAndMore => 'ابحث عن الأفلام والعروض والمزيد';

  @override
  String get trendingMovies => 'الأفلام الرائجة ';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get remindMe => 'ذكرني';

  @override
  String get remind => 'يتذكر';

  @override
  String get readLess => 'اقرأ أقل';

  @override
  String get readMore => '...اقرأ المزيد';

  @override
  String get liveTv => 'البث التلفزيوني المباشر';

  @override
  String get live => 'يعيش';

  @override
  String get profile => 'حساب تعريفي';

  @override
  String get expiringOn => 'تنتهي صلاحيته';

  @override
  String get updrade => 'يرقي';

  @override
  String get subscribeToEnjoyMore => 'اشترك لتستمتع أكثر';

  @override
  String get daysFreeTrail => 'اكتشف الميزات الحصرية اليوم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get helpSupport => 'دعم المساعدة';

  @override
  String get appLanguage => 'لغة التطبيق';

  @override
  String get yourDownloads => 'التنزيلات الخاصة بك';

  @override
  String get subscriptionPlanDeviceConnected => 'خطة الاشتراك، الجهاز متصل';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get version => 'إصدار';

  @override
  String get registeredMobileNumber => 'पंजीकृत मोबाइल नंबर';

  @override
  String get otherDevices => 'أجهزة أخرى';

  @override
  String get yourDevice => 'جهازك';

  @override
  String get lastUsed => 'آخر استخدام';

  @override
  String get proceed => 'يتابع';

  @override
  String get allYourDataWill => 'سيتم حذف جميع بياناتك نهائيًا';

  @override
  String get deleteAccountPermanently => 'حذف الحساب نهائيا؟';

  @override
  String get mobileNumber => 'رقم الهاتف المحمول';

  @override
  String get savechanges => 'حفظ التغييرات';

  @override
  String get loginToStreamit => 'تسجيل الدخول إلى Streamit';

  @override
  String get startWatchingFromWhereYouLeftOff => 'ابدأ المشاهدة من حيث توقفت';

  @override
  String get troubleLoggingIn => 'مشكلة في تسجيل الدخول؟';

  @override
  String get getHelp => 'احصل على المساعدة';

  @override
  String get yourWatchlistIsEmpty => 'قائمة المراقبة الخاصة بك فارغة';

  @override
  String get contentAddedToYourWatchlist =>
      'سيظهر هنا المحتوى المضاف إلى قائمة المراقبة الخاصة بك';

  @override
  String get add => 'يضيف';

  @override
  String get subscribeNowAndDiveInto => 'اشترك الآن وانغمس في البث اللامتناهي';

  @override
  String get pay => 'يدفع';

  @override
  String get next => 'التالي';

  @override
  String get subscrption => 'الاشتراك';

  @override
  String get validUntil => 'صالحة حتى ';

  @override
  String get choosePaymentMethod => 'اختر طريقة الدفع';

  @override
  String get secureCheckoutInSeconds => 'عملية دفع آمنة بنسبة 100% في ثوانٍ';

  @override
  String get proceedPayment => 'المضي قدما في الدفع';

  @override
  String get actors => 'الجهات الفاعلة';

  @override
  String get movies => 'أفلام';

  @override
  String get contentRestrictedAccess => '18+ وصول مقيد للمحتوى';

  @override
  String get areYou18Above => 'هل عمرك 18+ فما فوق؟';

  @override
  String get displayAClearProminentWarning =>
      'اعرض تحذيرًا واضحًا وبارزًا قبل الوصول إلى المحتوى، يفيد بأنه مخصص للبالغين.';

  @override
  String get all => 'الجميع';

  @override
  String get tVShows => 'البرامج التلفزيونية';

  @override
  String get videos => 'فيديوهات';

  @override
  String get newlyAdded => 'أضيفت حديثا';

  @override
  String get free => 'حر';

  @override
  String get phnRequiredText => 'رقم الجوال مطلوب';

  @override
  String get inputMustBeNumberOrDigit => 'يجب أن يكون الإدخال رقمًا أو رقمًا';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get whatYourMobileNo => 'ما هو رقم هاتفك المحمول';

  @override
  String get withAValidMobileNumberYouCanConnectWithStreamit =>
      'باستخدام رقم هاتف محمول صالح، يمكنك الاتصال بـstreamit';

  @override
  String get otpSentToYourSMS => 'تم إرسال OTP إلى الرسائل القصيرة الخاصة بك!';

  @override
  String get checkYourSmsInboxAndVerifyYoourMobile =>
      'تحقق من صندوق الوارد الخاص بك عبر الرسائل القصيرة وتحقق من رقم هاتفك المحمول';

  @override
  String get pleaseTryAgainAfterSomeTime =>
      'يرجى المحاولة مرة أخرى بعد مرور بعض الوقت. لقد استخدمت طلبات التحقق المتعددة!';

  @override
  String get pleaseEnterAValidCode =>
      'الرجاء إدخال كلمة المرور لمرة واحدة (OTP) صالحة';

  @override
  String get pleaseCheckYourMobileInternetConnection =>
      'يرجى التحقق من اتصالك بالإنترنت عبر الهاتف المحمول';

  @override
  String get error => 'خطأ';

  @override
  String get sorryCouldnFindYourSearch => 'عذرًا، لم أتمكن من العثور على بحثك!';

  @override
  String get trySomethingNew => 'جرب شيئًا جديدًا.';

  @override
  String get genresNotAvailable => 'الأنواع غير متوفرة!';

  @override
  String get downloadSuccessfully => 'تم التنزيل بنجاح';

  @override
  String get popularMovies => 'أفلام شعبية';

  @override
  String get confirm => 'يتأكد';

  @override
  String get doYouConfirmThisPlan => 'هل تؤكد خطة الاشتراك هذه: ';

  @override
  String get transactionFailed => 'فشلت الصفقة';

  @override
  String get transactionCancelled => 'تم إلغاء المعاملة';

  @override
  String get no => 'لا';

  @override
  String get lblChangeCountry => 'تغيير البلد';

  @override
  String get logOutAll => 'تسجيل الخروج الكل';

  @override
  String get taxIncluded => 'شامل الضريبة';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get firstNameIsRequiredField => 'الاسم الأول مطلوب';

  @override
  String get lastNameIsRequiredField => 'الاسم الأخير مطلوب';

  @override
  String get passwordIsRequiredField => 'كلمة المرور مطلوبة';

  @override
  String get confirmPasswordIsRequiredField => 'تأكيد كلمة المرور أمر مطلوب';

  @override
  String get pleaseEnterConfirmPassword => 'الرجاء إدخال تأكيد كلمة المرور';

  @override
  String get home => 'بيت';

  @override
  String get search => 'يبحث';

  @override
  String get mobileNumberIsRequiredField => 'رقم الجوال هو حقل مطلوب';

  @override
  String get youHaveAlreadyDownloadedThisMovie =>
      'لقد قمت بالفعل بتنزيل هذا الفيلم';

  @override
  String get imdb => 'موقع آي إم دي بي';

  @override
  String get mb => 'ميغابايت';

  @override
  String get stripePay => 'شريط الدفع';

  @override
  String get razorPay => 'RazorPay';

  @override
  String get payStackPay => 'دفع Paystack';

  @override
  String get paypalPay => 'باي بال الدفع';

  @override
  String get flutterWavePay => 'الدفع FlutterWave';

  @override
  String get contextNotFound => 'السياق غير موجود !!!!';

  @override
  String get verificationFailed => 'فشل التحقق';

  @override
  String get english => 'إنجليزي';

  @override
  String get hour => 'ساعة';

  @override
  String get minute => 'دقيقة';

  @override
  String get sec => 'ثانية';

  @override
  String get videoNotFound => 'لم يتم العثور على الفيديو!!';

  @override
  String get auto => 'آلي';

  @override
  String get recommended => 'مُستَحسَن';

  @override
  String get medium => 'واسطة';

  @override
  String get high => 'عالي';

  @override
  String get low => 'قليل';

  @override
  String get helpSetting => 'المساعدة والإعدادات';

  @override
  String get pleaseConfirmContent => 'يرجى تأكيد الوصول المقيد للمحتوى';

  @override
  String get toWatch => 'للمشاهدة';

  @override
  String get plan => 'يخطط';

  @override
  String get toThe => 'الى';

  @override
  String get noDeviceAvailable => 'لا توجد أجهزة متاحة';

  @override
  String get noItemsToContinueWatching => 'لا توجد عناصر لمواصلة المشاهدة';

  @override
  String get noItemsAddedToTheWatchlist =>
      'لم تتم إضافة أي عناصر إلى قائمة المراقبة';

  @override
  String get ok => 'نعم';

  @override
  String get removeFromContinueWatch => 'هل تريد الإزالة من متابعة المشاهدة؟';

  @override
  String get addedToWatchList => 'تمت إضافة قائمة المشاهدة بنجاح';

  @override
  String get removedFromWatchList => 'تم حذف قائمة المشاهدة بنجاح';

  @override
  String get removeSelectedFromWatchList =>
      'هل تريد إزالة المحتوى المحدد من قائمة المشاهدة الخاصة بك؟';

  @override
  String get removedFromContinueWatch => 'متابعة المشاهدة المحذوفة بنجاح';

  @override
  String get pleaseEnterAValidMobileNo => 'الرجاء إدخال رقم جوال صالح';

  @override
  String get pleaseAddYourReview => 'الرجاء إضافة تقييمك';

  @override
  String get thisMovieIsCurrentlUnavailableToWatch =>
      'هذا الفيلم غير متاح حاليًا للمشاهدة';

  @override
  String get thisVideoIsCurrentlUnavailableToWatch =>
      'هذا الفيديو غير متاح حاليًا للمشاهدة';

  @override
  String get subscriptionHistory => 'تاريخ الاشتراك';

  @override
  String get type => 'يكتب';

  @override
  String get amount => 'كمية';

  @override
  String get cancelPlan => 'إلغاء الخطة';

  @override
  String get device => 'جهاز';

  @override
  String get clear => 'واضح';

  @override
  String get doYouWantToLogoutFrom => 'هل تريد تسجيل الخروج من';

  @override
  String get sAlphabet => 'س';

  @override
  String get eAlphabet => 'ه';

  @override
  String get viewLess => 'عرض أقل';

  @override
  String get removeSelectedFromDownloads =>
      'هل تريد إزالة هذا من التنزيلات الخاصة بك';

  @override
  String get noPaymentMethodsFound => 'لم يتم العثور على طرق الدفع';

  @override
  String get save => 'يحفظ';

  @override
  String get completeProfile => 'أكمل ملفك الشخصي';

  @override
  String get completeProfileSubtitle => 'أخبرنا المزيد عن نفسك للبدء';

  @override
  String get getVerificationCode => 'الحصول على رمز التحقق';

  @override
  String get contentRating => 'تقييم المحتوى';

  @override
  String get profiles => 'الملفات الشخصية';

  @override
  String get addProfile => 'أضف الملف الشخصي';

  @override
  String get clearSearchHistoryConfirmation =>
      'هل تريد مسح سجل البحث الخاص بك؟';

  @override
  String get clearSearchHistorySubtitle =>
      'لا يمكن التراجع عن هذا الإجراء، وسيتم حذف جميع عمليات البحث السابقة نهائيًا.';

  @override
  String get searchingForDevice => 'البحث عن الأجهزة';

  @override
  String get screenCast => 'يلقي الشاشة';

  @override
  String get connectTo => 'الاتصال ب';

  @override
  String get disconnectFrom => 'قطع الاتصال من';

  @override
  String get signInWithGoogle => 'قم بتسجيل الدخول باستخدام جوجل';

  @override
  String get signInWithApple => 'تسجيل الدخول مع أبل';

  @override
  String get whoIsWatching => 'من يراقب؟';

  @override
  String get doYouWantTo => 'هل تريد مسح سجل البحث؟';

  @override
  String get mobile => 'متحرك:';

  @override
  String get tablet => 'الكمبيوتر اللوحي: ';

  @override
  String get laptop => 'الكمبيوتر المحمول:';

  @override
  String get supported => 'المدعومة';

  @override
  String get notSupported => 'غير مدعوم';

  @override
  String get freeMovies => 'أفلام مجانية';

  @override
  String get top10 => 'أعلى 10';

  @override
  String get latestMovies => 'أحدث الأفلام';

  @override
  String get topChannels => 'أهم القنوات';

  @override
  String get popularTvShows => 'البرامج التلفزيونية الشعبية';

  @override
  String get popularVideos => 'مقاطع فيديو شعبية';

  @override
  String get popularLanguages => 'اللغات الشعبية';

  @override
  String get trending => 'تتجه';

  @override
  String get trendingInYourCountry => 'تتجه في بلدك';

  @override
  String get favoriteGenres => 'الأنواع المفضلة';

  @override
  String get basedOnYourPreviousWatch => 'بناءً على ساعتك السابقة';

  @override
  String get mostLiked => 'الأكثر إعجابًا';

  @override
  String get mostViewed => 'الأكثر مشاهدة';

  @override
  String get yourFavoritePersonalities => 'شخصياتك المفضلة';

  @override
  String get name => 'اسم';

  @override
  String get nameCannotBeEmpty => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String get update => 'تحديث';

  @override
  String get remove => 'يزيل';

  @override
  String get recentSearch => 'البحث الأخير';

  @override
  String get noRecentSearches => 'لا توجد عمليات بحث حديثة';

  @override
  String get chooseImageSource => 'اختر مصدر الصورة';

  @override
  String get noInternetAvailable => 'لا يوجد إنترنت متاح';

  @override
  String get goToYourDownloads => 'انتقل إلى التنزيلات الخاصة بك';

  @override
  String get bySigningYouAgreeTo => 'بالتوقيع فإنك توافق على';

  @override
  String get lowQuality => 'جودة منخفضة';

  @override
  String get mediumQuality => 'جودة متوسطة';

  @override
  String get highQuality => 'جودة عالية';

  @override
  String get veryHighQuality => 'جودة عالية جدًا';

  @override
  String get ultraQuality => 'جودة فائقة';

  @override
  String get termsConditions => 'الشروط والأحكام';

  @override
  String get ofAll => 'للجميع';

  @override
  String get servicesAnd => 'الخدمات و ';

  @override
  String get newProfileAddedSuccessfully =>
      'تمت إضافة الملف الشخصي الجديد بنجاح';

  @override
  String get doYouWantToDeleteYourReview => 'هل تريد حذف رأيك؟';

  @override
  String get noSearchDataFound => 'لم يتم العثور على بيانات البحث';

  @override
  String get searchHistory => 'سجل البحث';

  @override
  String get youHaveBeenLoggedOutOfYourAccountOn =>
      'لقد تم تسجيل الخروج من حسابك على';

  @override
  String get faqs => 'الأسئلة الشائعة';

  @override
  String get termsOfUse => 'شروط الاستخدام';

  @override
  String get refundAndCancellationPolicy => 'سياسة الاسترداد والإلغاء';

  @override
  String get dataDeletionRequest => 'طلب حذف البيانات';

  @override
  String get aboutUs => 'معلومات عنا';

  @override
  String get total => 'المجموع';

  @override
  String get percentage => 'نسبة مئوية';

  @override
  String get fixed => 'مُثَبَّت';

  @override
  String get android => 'أندرويد';

  @override
  String get ios => 'دائرة الرقابة الداخلية';

  @override
  String get hindi => 'الهندية';

  @override
  String get arabic => 'عربي';

  @override
  String get french => 'فرنسي';

  @override
  String get german => 'الألمانية';

  @override
  String get noFAQsfound => 'لم يتم العثور على أسئلة متكررة';

  @override
  String get tax => 'ضريبة';

  @override
  String get downloadHasBeenStarted => 'لقد بدأ التنزيل';

  @override
  String get yourDeviceIsNot => 'جهازك غير مدعوم بالخطة الحالية';

  @override
  String get pleaseUpgradeToContinue =>
      'يرجى الترقية لمواصلة الاستمتاع بالخدمة';

  @override
  String get cancelled => 'تم الإلغاء';

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get active => 'نشيط';

  @override
  String get connectToWIFI => 'يرجى الاتصال بالواي فاي';

  @override
  String get logoutAllConfirmation =>
      'هل تريد تسجيل الخروج من جميع الأجهزة الأخرى؟';

  @override
  String get share => 'يشارك';

  @override
  String get like => 'يحب';

  @override
  String get pip => 'نقطة';

  @override
  String get videoCast => 'يقذف';

  @override
  String get castingNotSupported => 'الإرسال غير مدعوم في الخطة الحالية.';

  @override
  String get left => "المتبقي";

  @override
  String get loginWithOtp => 'تسجيل الدخول باستخدام OTP';

  @override
  String get loginWithEmail => 'تسجيل الدخول باستخدام البريد الإلكتروني';

  @override
  String get createYourAccount => 'قم بإنشاء حسابك';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get yourNewPasswordMust =>
      'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور السابقة';

  @override
  String get yourOldPasswordDoesnT =>
      'كلمة المرور القديمة الخاصة بك غير صحيحة!';

  @override
  String get yourNewPasswordDoesnT =>
      'كلمة المرور الجديدة لا تتطابق مع تأكيد كلمة المرور!';

  @override
  String get oldAndNewPassword => 'كلمة المرور القديمة والجديدة هي نفسها.';

  @override
  String get yourPasswordHasBeen =>
      'تمت إعادة تعيين كلمة المرور الخاصة بك بنجاح';

  @override
  String get youCanNowLog =>
      'يمكنك الآن تسجيل الدخول إلى حسابك الجديد باستخدام كلمة المرور الجديدة';

  @override
  String get done => 'منتهي';

  @override
  String get oldPassword => 'كلمة المرور القديمة';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get birthdayIsRequired => 'مطلوب عيد ميلاد';

  @override
  String get childrenSProfile => 'ملف تعريف الأطفال';

  @override
  String get madeForKidsUnder12 => 'مصنوعة للأطفال دون سن 12 عامًا';

  @override
  String get otpVerifiedFailed => 'فشل التحقق من OTP';

  @override
  String get otpVerifiedSuccessfully => 'تم التحقق من OTP بنجاح';

  @override
  String get otpSentSuccessfully =>
      'تم إرسال كلمة المرور لمرة واحدة (OTP) بنجاح';

  @override
  String get weHaveSentYouOTPOnYourRegisterEmailAddress =>
      'لقد أرسلنا لك OTP على عنوان بريدك الإلكتروني المسجل';

  @override
  String get otpVerification => 'التحقق من OTP';

  @override
  String get enterPIN => 'أدخل رقم التعريف الشخصي';

  @override
  String get enterYourNewParentalPinForYourKids =>
      'أدخل رقم التعريف الشخصي الجديد الخاص بأطفالك';

  @override
  String get confirmPIN => 'تأكيد رقم التعريف الشخصي';

  @override
  String get setPIN => 'تعيين رقم التعريف الشخصي';

  @override
  String get changePIN => 'تغيير رقم التعريف الشخصي';

  @override
  String get parentalControl => 'الرقابة الأبوية';

  @override
  String get invalidPIN => 'رقم التعريف الشخصي غير صالح';

  @override
  String get kids => 'أطفال';

  @override
  String get enter4DigitParentalControlPIN =>
      'أدخل رقم التعريف الشخصي (PIN) الخاص بالرقابة الأبوية والمكون من 4 أرقام';

  @override
  String get parentalLock => 'قفل الوالدين';

  @override
  String get profileDeletedSuccessfully => 'تم حذف الملف الشخصي بنجاح';

  @override
  String get pinNotMatched => 'رقم التعريف الشخصي غير متطابق';

  @override
  String get pleaseEnterNewPIN => 'الرجاء إدخال رقم التعريف الشخصي الجديد';

  @override
  String get pleaseEnterConfirmPin => 'الرجاء إدخال تأكيد رقم التعريف الشخصي';

  @override
  String get codeWithColon => 'أدخل الرمز:';

  @override
  String get useThisCodeToGet => 'استخدم هذا الرمز للحصول على ';

  @override
  String get off => ' عن';

  @override
  String get expiryDate => 'تاريخ انتهاء الصلاحية: ';

  @override
  String get apply => 'يتقدم';

  @override
  String get coupons => 'كوبونات';

  @override
  String get enterCouponCode => 'أدخل رمز القسيمة';

  @override
  String get check => 'يفحص';

  @override
  String get allCoupons => 'جميع القسائم';

  @override
  String get oopsWeCouldnTFind =>
      'أُووبس! لم نتمكن من العثور على أي رموز قسيمة مطابقة';

  @override
  String get doYouWantToRemoveCoupon => 'هل تريد إزالة هذه القسيمة؟';

  @override
  String get noSubscriptionHistoryFound => 'لم يتم العثور على سجل الاشتراك';

  @override
  String get couponDiscount => 'خصم القسيمة ';

  @override
  String get linkTv => 'رابط التلفزيون';

  @override
  String get youHaveBeenLoggedOutSuccessfully => 'تم تسجيل خروجك بنجاح';

  @override
  String get rented => 'مستأجر';

  @override
  String get rent => 'إيجار';

  @override
  String get rentFor => 'إيجار ل';

  @override
  String rentedesc(int availableFor, String duration) =>
      'لديك $availableFor أيام لبدء المشاهدة بعد الاستئجار. سيكون لديك $duration ساعات لإكمالها بعد بدء البث.';

  @override
  String youCanWatchThis(int duration) =>
      'يمكنك مشاهدة هذا المحتوى عدة مرات خلال فترة $duration hours.';

  @override
  String get thisIsANonRefundable => 'هذه معاملة غير قابلة للاسترداد.';

  @override
  String get thisContentIsOnly =>
      'هذا المحتوى متاح للإيجار فقط وليس جزءًا من الاشتراك المميز.';

  @override
  String get youCanPlayYour =>
      'يمكنك تشغيل المحتوى الخاص بك على الأجهزة المدعومة.';

  @override
  String get validity => 'صحة';

  @override
  String get days => 'أيام';

  @override
  String get watchTime => 'وقت المشاهدة';

  @override
  String get hours => 'ساعات';

  @override
  String get byRentingYouAgreeToOur => 'من خلال الإيجار فإنك توافق على شروطنا';

  @override
  String get pleaseAgreeToThe =>
      'يرجى الموافقة على شروط الاستخدام قبل المتابعة.';

  @override
  String get successfullyRentedMoviesOn => 'تم استئجار الأفلام بنجاح';

  @override
  String enjoyUntilDays(int days) => 'استمتع حتى $days أيام';

  @override
  String get beginWatching => 'ابدأ المشاهدة';

  @override
  String doYouConfirmThis(String movieName) =>
      'هل تؤكد هذه الخطة المستأجرة لـ $movieName؟';

  @override
  String get unlockedVideo => 'فيديو مفتوح';

  @override
  String get info => 'معلومات';

  @override
  String get payPerView => 'دالدفع مقابل المشاهدة';

  @override
  String get newPinSuccessfullySaved =>
      'تم حفظ رقم التعريف الشخصي الجديد بنجاح';

  @override
  String get successfullyUpdated => 'تم التحديث بنجاح';

  @override
  String get defaultLabel => 'افتراضي';

  @override
  String get quality => 'جودة';

  @override
  String get subtitle => 'الترجمة الفرعية';

  @override
  String get skip => 'تخطي';

  @override
  String get nextEpisode => 'الحلقة التالية';

  @override
  String get rentDetails => 'تفاصيل الإيجار';

  @override
  String get pleaseSelectPaymentMethod  => 'الرجاء اختيار طريقة الدفع.';

  @override
  String get tvLinkedSuccessfully => 'تم ربط التلفاز بنجاح!';

  @override
  String get cameraPermissionDenied => 'تم رفض إذن الكاميرا. يُرجى تفعيله من الإعدادات.';
}
