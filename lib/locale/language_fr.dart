import 'languages.dart';

class LanguageFr extends BaseLanguage {
  @override
  String get language => 'Langue';

  @override
  String get badRequest => '400 : requête incorrecte';

  @override
  String get forbidden => '403:Interdit';

  @override
  String get pageNotFound => '404 : page introuvable';

  @override
  String get tooManyRequests => '429 : Trop de demandes';

  @override
  String get internalServerError => '500 : erreur de serveur interne';

  @override
  String get badGateway => '502 Mauvaise passerelle';

  @override
  String get serviceUnavailable => '503 : Service indisponible';

  @override
  String get gatewayTimeout => '504 : expiration du délai de passerelle';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Caméra';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get reload => 'Recharger';

  @override
  String get pressBackAgainToExitApp =>
      "Appuyez à nouveau pour quitter l'application";

  @override
  String get invalidUrl => 'URL invalide';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get demoUserCannotBeGrantedForThis =>
      "L'utilisateur démo ne peut pas être autorisé pour cette action";

  @override
  String get somethingWentWrong => "Quelque chose s'est mal passé";

  @override
  String get yourInternetIsNotWorking => 'Votre Internet ne fonctionne pas';

  @override
  String get profileUpdatedSuccessfully => 'Profil mis à jour avec succès';

  @override
  String get wouldYouLikeToSetProfilePhotoAs =>
      'Souhaitez-vous définir cette photo comme photo de profil ?';

  @override
  String get yourConfirmPasswordDoesnT =>
      'Votre mot de passe de confirmation ne correspond pas au mot de passe !';

  @override
  String get yes => 'Oui';

  @override
  String get submit => 'Soumettre';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom de famille';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmez le mot de passe';

  @override
  String get email => 'E-mail';

  @override
  String get emailIsARequiredField => "L'e-mail est un champ obligatoire";

  @override
  String get pleaseEnterValidEmailAddress =>
      "S'il vous plaît, mettez une adresse email valide!!";

  @override
  String get signIn => 'Se connecter';

  @override
  String get explore => 'Explorer';

  @override
  String get settings => 'Paramètres';

  @override
  String get rateNow => 'Évaluez maintenant';

  @override
  String get logout => 'Déconnexion';

  @override
  String get rememberMe => 'Souviens-toi de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signUp => "S'inscrire";

  @override
  String get alreadyHaveAnAccount => 'Vous avez déjà un compte ?';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get notifications => 'Notifications';

  @override
  String get signInFailed => 'Échec de la connexion';

  @override
  String get logIn => 'SE CONNECTER';

  @override
  String get stayTunedNoNew =>
      "Restez à l'écoute! Aucune nouvelle notification.";

  @override
  String get noNewNotificationsAt =>
      "Aucune nouvelle notification pour le moment. Nous vous tiendrons au courant lorsqu'il y aura une mise à jour";

  @override
  String get walkthroughTitle1 =>
      "Regardez sur n'importe quel appareil : profitez de notre contenu où que vous alliez !";

  @override
  String get walkthroughDesp1 =>
      'Diffusez sur tous les appareils sans frais supplémentaires.';

  @override
  String get walkthroughTitle2 =>
      "Téléchargez et partez : accédez à votre contenu n'importe où, n'importe quand, sur n'importe quel appareil";

  @override
  String get walkthroughDesp2 =>
      "Téléchargez et profitez du contenu en déplacement, n'importe où et à tout moment.";

  @override
  String get walkthroughTitle3 =>
      "Profitez de la liberté sans engagements ni tracas - Rejoignez-nous dès aujourd'hui !";

  @override
  String get walkthroughDesp3 => 'Rejoignez-nous sans tracas et sans contrat.';

  @override
  String get lblSkip => 'Sauter';

  @override
  String get lblNext => 'Suivant';

  @override
  String get lblGetStarted => 'Commencer';

  @override
  String get optionTitle =>
      'Découvrez les meilleures émissions avec des genres adaptés à vos préférences.';

  @override
  String get optionDesp =>
      'Explorez des émissions sélectionnées dans tous les genres, adaptées à vos préférences de visionnage.';

  @override
  String get welcomeBackToStreamIt => 'Bienvenue sur StreamIt !';

  @override
  String get weHaveEagerlyAwaitedYourReturn =>
      'Nous attendions avec impatience votre retour.';

  @override
  String get dontHaveAnAccount => "Vous n'avez pas de compte ? ";

  @override
  String get or => 'OU';

  @override
  String get dontWorryItHappens =>
      "Ne t'inquiète pas! ça arrive. veuillez saisir l'email associé à votre compte";

  @override
  String get linkSentToYourEmail => 'Lien envoyé à votre Email!';

  @override
  String get checkYourInboxAndChangePassword =>
      'Vérifiez votre boîte de réception et changez le mot de passe';

  @override
  String get continues => 'Continuer';

  @override
  String get oTPVerification => 'Vérification OTP';

  @override
  String get checkYourSmsInboxAndEnterTheCodeYouGet =>
      'Vérifiez votre boîte de réception SMS et entrez le code que vous avez reçu.';

  @override
  String get didntGetTheOTP => 'Vous n’avez pas obtenu l’OTP ?';

  @override
  String get resendOTP => 'Renvoyer OTP';

  @override
  String get verify => 'Vérifier';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get notificationDeleted => 'Notification supprimée';

  @override
  String get doYouWantToRemoveNotification =>
      'Voulez-vous supprimer la notification';

  @override
  String get doYouWantToClearAllNotification =>
      'Voulez-vous effacer toutes les notifications';

  @override
  String get successfully => 'Avec succès';

  @override
  String get userCancelled => 'Utilisateur annulé';

  @override
  String get appleSigninIsNot =>
      "Apple SignIn n'est pas disponible pour votre appareil";

  @override
  String get searchHere => 'Rechercher ici';

  @override
  String get noDataFound => 'Aucune donnée trouvée';

  @override
  String get subscribe => "S'abonner";

  @override
  String get subscribeToWatch => 'Abonnez-vous pour regarder';

  @override
  String get playNow => 'Jouez maintenant';

  @override
  String get continueWatching => 'Continuer à regarder ';

  @override
  String get shareYourThoughtsWithUs => 'Partagez vos réflexions avec nous !';

  @override
  String get weValueYourOpinion =>
      "Nous apprécions votre avis ! Partagez vos commentaires avec nous aujourd'hui.";

  @override
  String get genres => 'Genre';

  @override
  String get trailer => 'BANDE-ANNONCE';

  @override
  String get ua18 => 'U/A 18';

  @override
  String get watchNow => 'Regarder maintenant';

  @override
  String get cast => 'Moulages';

  @override
  String get directors => 'Directeurs';

  @override
  String get reviews => 'Avis';

  @override
  String get viewAll => 'Tout afficher';

  @override
  String get rating => 'notation';

  @override
  String get justNow => "Tout à l' heure";

  @override
  String get daysAgo => 'il y a quelques jours';

  @override
  String get yesterday => 'Hier';

  @override
  String get ago => 'il y a';

  @override
  String get min => 'min';

  @override
  String get hr => 'heure';

  @override
  String get s => 's';

  @override
  String get moreLikeThis => 'Plus comme ça';

  @override
  String get shareYourThoughtsOnYourFavoriteMovie =>
      'Partagez vos réflexions sur votre film préféré';

  @override
  String get rateThisMovie => 'Notez ce film';

  @override
  String get rateThisTvShow => 'Notez cette émission télévisée';

  @override
  String get yourReview => 'Votre avis';

  @override
  String get edit => 'Modifier';

  @override
  String get close => 'Fermer';

  @override
  String get oppsLooksLikeYouReview =>
      "Oups ! il semble que vous n'ayez pas encore ajouté d'avis.";

  @override
  String get retry => 'Réessayer';

  @override
  String get selectDownloadQuality =>
      'Sélectionnez la qualité de téléchargement';

  @override
  String get onlyOnWiFi => 'Uniquement en Wi-Fi';

  @override
  String get download => 'Télécharger';

  @override
  String get moviesOf => 'Films de ';

  @override
  String get season => 'Saison';

  @override
  String get episode => 'Épisode ';

  @override
  String get watchlist => 'Liste de surveillance';

  @override
  String get searchMoviesShowsAndMore =>
      'Rechercher des films, des émissions et plus encore';

  @override
  String get trendingMovies => 'Films tendances ';

  @override
  String get comingSoon => 'À venir';

  @override
  String get remindMe => 'Rappelle-moi';

  @override
  String get remind => 'Rappeler';

  @override
  String get readLess => 'Lire moins';

  @override
  String get readMore => '...En savoir plus';

  @override
  String get liveTv => 'Télévision en direct';

  @override
  String get live => 'En direct';

  @override
  String get profile => 'Profil';

  @override
  String get expiringOn => 'Expirant le';

  @override
  String get updrade => 'Mise à niveau';

  @override
  String get subscribeToEnjoyMore => 'Abonnez-vous pour en profiter davantage';

  @override
  String get daysFreeTrail =>
      "Débloquez des fonctionnalités exclusives dès aujourd'hui";

  @override
  String get privacyPolicy => 'politique de confidentialité';

  @override
  String get helpSupport => 'Aide Assistance';

  @override
  String get appLanguage => "Langue de l'application";

  @override
  String get yourDownloads => 'Vos téléchargements';

  @override
  String get subscriptionPlanDeviceConnected =>
      "Plan d'abonnement, appareil connecté";

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get version => 'Version';

  @override
  String get registeredMobileNumber => 'Numéro de portable enregistré';

  @override
  String get otherDevices => 'Autres appareils';

  @override
  String get yourDevice => 'Votre appareil';

  @override
  String get lastUsed => 'Dernière utilisation';

  @override
  String get proceed => 'Procéder';

  @override
  String get allYourDataWill =>
      'Toutes vos données seront définitivement supprimées';

  @override
  String get deleteAccountPermanently => 'Supprimer définitivement le compte ?';

  @override
  String get mobileNumber => 'Numéro de portable';

  @override
  String get savechanges => 'Enregistrer les modifications';

  @override
  String get loginToStreamit => 'Connectez-vous à Streamit';

  @override
  String get startWatchingFromWhereYouLeftOff =>
      'Commencez à regarder là où vous vous étiez arrêté';

  @override
  String get troubleLoggingIn => 'Des difficultés pour vous connecter ?';

  @override
  String get getHelp => "Obtenir de l'aide";

  @override
  String get yourWatchlistIsEmpty => 'Votre liste de surveillance est vide';

  @override
  String get contentAddedToYourWatchlist =>
      'Le contenu ajouté à votre liste de surveillance apparaîtra ici';

  @override
  String get add => 'Ajouter';

  @override
  String get subscribeNowAndDiveInto =>
      'Abonnez-vous maintenant et plongez dans un streaming sans fin';

  @override
  String get pay => 'Payer';

  @override
  String get next => 'Suivant';

  @override
  String get subscrption => 'Abonnement';

  @override
  String get validUntil => "Valable jusqu'au ";

  @override
  String get choosePaymentMethod => 'Choisissez le mode de paiement';

  @override
  String get secureCheckoutInSeconds =>
      'Paiement 100% sécurisé en quelques secondes';

  @override
  String get proceedPayment => 'Procéder au paiement';

  @override
  String get actors => 'Acteurs';

  @override
  String get movies => 'Films';

  @override
  String get contentRestrictedAccess => '18+ Contenu Accès Restreint';

  @override
  String get areYou18Above => 'Avez-vous 18 ans et plus ?';

  @override
  String get displayAClearProminentWarning =>
      "Affichez un avertissement clair et bien visible avant d'accéder au contenu, indiquant qu'il est destiné à un public adulte.";

  @override
  String get all => 'Tous';

  @override
  String get tVShows => 'Émissions de télévision';

  @override
  String get videos => 'Vidéos';

  @override
  String get newlyAdded => 'Récemment ajouté';

  @override
  String get free => 'gratuit';

  @override
  String get phnRequiredText => 'Le numéro de portable est requis';

  @override
  String get inputMustBeNumberOrDigit =>
      "L'entrée doit être un nombre ou un chiffre";

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get whatYourMobileNo => 'Quel est votre numéro de portable';

  @override
  String get withAValidMobileNumberYouCanConnectWithStreamit =>
      'Avec un numéro de mobile valide, vous pouvez vous connecter avec streamit';

  @override
  String get otpSentToYourSMS => 'OTP envoyé à votre SMS !';

  @override
  String get checkYourSmsInboxAndVerifyYoourMobile =>
      'Vérifiez votre boîte de réception SMS et vérifiez votre numéro de mobile';

  @override
  String get pleaseTryAgainAfterSomeTime =>
      'Veuillez réessayer après un certain temps. Vous avez utilisé plusieurs demandes de vérification de temps !';

  @override
  String get pleaseEnterAValidCode => 'Veuillez saisir un OTP valide';

  @override
  String get pleaseCheckYourMobileInternetConnection =>
      'Veuillez vérifier votre connexion Internet mobile';

  @override
  String get error => 'Erreur';

  @override
  String get sorryCouldnFindYourSearch =>
      "Désolé, votre recherche n'a pas été trouvée !";

  @override
  String get trySomethingNew => 'Essayez quelque chose de nouveau.';

  @override
  String get genresNotAvailable => 'Genres non disponibles !';

  @override
  String get downloadSuccessfully => 'Télécharger avec succès';

  @override
  String get popularMovies => 'Films populaires';

  @override
  String get confirm => 'Confirmer';

  @override
  String get doYouConfirmThisPlan =>
      "Confirmez-vous cette formule d'abonnement : ";

  @override
  String get transactionFailed => 'Échec de la transaction';

  @override
  String get transactionCancelled => 'Transaction annulée';

  @override
  String get no => 'Non';

  @override
  String get lblChangeCountry => 'Changer de pays';

  @override
  String get logOutAll => 'Tout déconnecter';

  @override
  String get taxIncluded => 'Taxe Incluse';

  @override
  String get bookNow => 'Réservez maintenant';

  @override
  String get firstNameIsRequiredField => 'Le prénom est obligatoire';

  @override
  String get lastNameIsRequiredField => 'Le nom de famille est obligatoire';

  @override
  String get passwordIsRequiredField => 'Le mot de passe est obligatoire';

  @override
  String get confirmPasswordIsRequiredField =>
      'Confirmer que le mot de passe est obligatoire';

  @override
  String get pleaseEnterConfirmPassword =>
      'Veuillez saisir le mot de passe confirmé';

  @override
  String get home => 'Maison';

  @override
  String get search => 'Recherche';

  @override
  String get mobileNumberIsRequiredField =>
      'Le numéro de portable est un champ obligatoire';

  @override
  String get youHaveAlreadyDownloadedThisMovie =>
      'Vous avez déjà téléchargé ce film';

  @override
  String get imdb => 'BDIM';

  @override
  String get mb => 'Mo';

  @override
  String get stripePay => 'Paiement à rayures';

  @override
  String get razorPay => 'RasoirPay';

  @override
  String get payStackPay => 'Salaire de paie';

  @override
  String get paypalPay => 'Paypal Payer';

  @override
  String get flutterWavePay => 'Paiement FlutterWave';

  @override
  String get contextNotFound => 'contexte introuvable !!!!';

  @override
  String get verificationFailed => 'Échec de la vérification';

  @override
  String get english => 'Anglais';

  @override
  String get hour => 'heure';

  @override
  String get minute => 'minute';

  @override
  String get sec => 'seconde';

  @override
  String get videoNotFound => 'Vidéo introuvable !!';

  @override
  String get auto => 'Auto';

  @override
  String get recommended => 'Recommandé';

  @override
  String get medium => 'Moyen';

  @override
  String get high => 'Haut';

  @override
  String get low => 'Faible';

  @override
  String get helpSetting => 'Aide et paramétrage';

  @override
  String get pleaseConfirmContent =>
      "Veuillez confirmer l'accès restreint au contenu";

  @override
  String get toWatch => 'À regarder';

  @override
  String get plan => 'Plan';

  @override
  String get toThe => 'Au';

  @override
  String get noDeviceAvailable => 'Aucun appareil disponible';

  @override
  String get noItemsToContinueWatching =>
      'Aucun élément à continuer à regarder';

  @override
  String get noItemsAddedToTheWatchlist =>
      'Aucun élément ajouté à la liste de surveillance';

  @override
  String get ok => "D'accord";

  @override
  String get removeFromContinueWatch =>
      'Voulez-vous supprimer la surveillance continue ?';

  @override
  String get addedToWatchList => 'Liste de surveillance ajoutée avec succès';

  @override
  String get removedFromWatchList =>
      'Liste de surveillance supprimée avec succès';

  @override
  String get removeSelectedFromWatchList =>
      'Voulez-vous supprimer le contenu sélectionné de votre liste de surveillance ?';

  @override
  String get removedFromContinueWatch =>
      'Continuer la montre supprimée avec succès';

  @override
  String get pleaseEnterAValidMobileNo =>
      'Veuillez saisir un numéro de mobile valide';

  @override
  String get pleaseAddYourReview => 'Veuillez ajouter votre note';

  @override
  String get thisMovieIsCurrentlUnavailableToWatch =>
      "Ce film n'est actuellement pas disponible pour regarder";

  @override
  String get thisVideoIsCurrentlUnavailableToWatch =>
      "Cette vidéo n'est actuellement pas disponible pour regarder";

  @override
  String get subscriptionHistory => 'Historique des abonnements';

  @override
  String get type => 'Taper';

  @override
  String get amount => 'Montant';

  @override
  String get cancelPlan => 'Annuler le forfait';

  @override
  String get device => 'Appareil';

  @override
  String get clear => 'Clair';

  @override
  String get doYouWantToLogoutFrom => 'Voulez-vous vous déconnecter de';

  @override
  String get sAlphabet => 'S';

  @override
  String get eAlphabet => 'E';

  @override
  String get viewLess => 'Voir moins';

  @override
  String get removeSelectedFromDownloads =>
      'Voulez-vous supprimer ceci de vos téléchargements';

  @override
  String get noPaymentMethodsFound => 'Aucun mode de paiement trouvé';

  @override
  String get save => 'Sauvegarder';

  @override
  String get completeProfile => 'Complétez votre profil';

  @override
  String get completeProfileSubtitle => 'Parlez-nous de vous pour commencer';

  @override
  String get getVerificationCode => 'Obtenir le code de vérification';

  @override
  String get contentRating => 'Évaluation du contenu';

  @override
  String get profiles => 'Profils';

  @override
  String get addProfile => 'Ajouter un profil';

  @override
  String get clearSearchHistoryConfirmation =>
      'Voulez-vous effacer votre historique de recherche ?';

  @override
  String get clearSearchHistorySubtitle =>
      'Cette action ne peut pas être annulée et toutes les recherches précédentes seront définitivement supprimées.';

  @override
  String get searchingForDevice => "Recherche d'appareils";

  @override
  String get screenCast => "Casting d'écran";

  @override
  String get connectTo => 'Connectez-vous à';

  @override
  String get disconnectFrom => 'Se déconnecter de';

  @override
  String get signInWithGoogle => 'Connectez-vous avec Google';

  @override
  String get signInWithApple => 'Connectez-vous avec Apple';

  @override
  String get whoIsWatching => 'Qui regarde ?';

  @override
  String get doYouWantTo => "Voulez-vous effacer l'historique de recherche ?";

  @override
  String get mobile => 'Mobile:';

  @override
  String get tablet => 'Tablette: ';

  @override
  String get laptop => 'Ordinateur portable:';

  @override
  String get supported => 'Soutenu';

  @override
  String get notSupported => 'Non pris en charge';

  @override
  String get freeMovies => 'Films gratuits';

  @override
  String get top10 => 'Top 10';

  @override
  String get latestMovies => 'Derniers films';

  @override
  String get topChannels => 'Meilleures chaînes';

  @override
  String get popularTvShows => 'Émissions de télévision populaires';

  @override
  String get popularVideos => 'Vidéos populaires';

  @override
  String get popularLanguages => 'Langues populaires';

  @override
  String get trending => 'Tendance';

  @override
  String get trendingInYourCountry => 'Tendance dans votre pays';

  @override
  String get favoriteGenres => 'Genres préférés';

  @override
  String get basedOnYourPreviousWatch => 'Basé sur votre montre précédente';

  @override
  String get mostLiked => 'Les plus aimés';

  @override
  String get mostViewed => 'Les plus consultés';

  @override
  String get yourFavoritePersonalities => 'Vos personnalités préférées';

  @override
  String get name => 'Nom';

  @override
  String get nameCannotBeEmpty => 'Le nom ne peut pas être vide';

  @override
  String get update => 'Mise à jour';

  @override
  String get remove => 'Retirer';

  @override
  String get recentSearch => 'Recherche récente';

  @override
  String get noRecentSearches => 'Aucune recherche récente';

  @override
  String get chooseImageSource => 'Choisir la source de l\'image';

  @override
  String get noInternetAvailable => 'Pas d\'internet disponible';

  @override
  String get goToYourDownloads => 'Accédez à vos téléchargements';

  @override
  String get bySigningYouAgreeTo => 'En signant, vous acceptez';

  @override
  String get lowQuality => 'Faible qualité';

  @override
  String get mediumQuality => 'Qualité moyenne';

  @override
  String get highQuality => 'Haute qualité';

  @override
  String get veryHighQuality => 'Très haute qualité';

  @override
  String get ultraQuality => 'Ultra qualité';

  @override
  String get termsConditions => 'Conditions générales';

  @override
  String get ofAll => 'de tous';

  @override
  String get servicesAnd => 'Services et ';

  @override
  String get newProfileAddedSuccessfully => 'Nouveau profil ajouté avec succès';

  @override
  String get doYouWantToDeleteYourReview =>
      'Voulez-vous supprimer votre avis ?';

  @override
  String get noSearchDataFound => 'Aucune donnée de recherche trouvée';

  @override
  String get searchHistory => 'Historique de recherche';

  @override
  String get youHaveBeenLoggedOutOfYourAccountOn =>
      'Vous avez été déconnecté de votre compte le';

  @override
  String get faqs => 'FAQ';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get refundAndCancellationPolicy =>
      'Politique de remboursement et d\'annulation';

  @override
  String get dataDeletionRequest => 'Demande de suppression de données';

  @override
  String get aboutUs => 'À propos de nous';

  @override
  String get total => 'Total';

  @override
  String get percentage => 'pourcentage';

  @override
  String get fixed => 'fixé';

  @override
  String get android => 'Androïde';

  @override
  String get ios => 'IOS';

  @override
  String get hindi => 'hindi';

  @override
  String get arabic => 'arabe';

  @override
  String get french => 'Français';

  @override
  String get german => 'Allemand';

  @override
  String get noFAQsfound => 'Aucune FAQ trouvée';

  @override
  String get tax => 'Impôt';

  @override
  String get downloadHasBeenStarted => 'Le téléchargement a commencé';

  @override
  String get yourDeviceIsNot =>
      "Votre appareil n'est pas pris en charge avec le forfait actuel";

  @override
  String get pleaseUpgradeToContinue =>
      'Veuillez effectuer une mise à niveau pour continuer à profiter du service';

  @override
  String get cancelled => 'Annulé';

  @override
  String get expired => 'Expiré';

  @override
  String get active => 'Actif';

  @override
  String get connectToWIFI => 'Veuillez vous connecter au WIFI';

  @override
  String get logoutAllConfirmation =>
      'Voulez-vous vous déconnecter de tous les autres appareils ?';

  @override
  String get share => 'Partager';

  @override
  String get like => 'Comme';

  @override
  String get pip => 'PÉPIN';

  @override
  String get videoCast => 'Casting';

  @override
  String get castingNotSupported =>
      "La diffusion n'est pas prise en charge avec le forfait actuel.";

  @override
  String get left => "Restant";

  @override
  String get loginWithOtp => 'Connectez-vous avec OTP';

  @override
  String get loginWithEmail => 'Connectez-vous avec e-mail';

  @override
  String get createYourAccount => 'Créez votre compte';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get yourNewPasswordMust =>
      'Votre nouveau mot de passe doit être différent de votre précédent mot de passe';

  @override
  String get yourOldPasswordDoesnT =>
      "Votre ancien mot de passe n'est pas correct!";

  @override
  String get yourNewPasswordDoesnT =>
      'Votre nouveau mot de passe ne correspond pas au mot de passe de confirmation!';

  @override
  String get oldAndNewPassword =>
      "L'ancien et le nouveau mot de passe sont identiques.";

  @override
  String get yourPasswordHasBeen =>
      'Votre mot de passe a été réinitialisé avec succès';

  @override
  String get youCanNowLog =>
      'Vous pouvez maintenant vous connecter à votre nouveau compte avec votre nouveau mot de passe';

  @override
  String get done => 'Fait';

  @override
  String get oldPassword => 'Ancien mot de passe';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get birthdayIsRequired => "L'anniversaire est requis";

  @override
  String get codeWithColon => 'Entrez le code :';

  @override
  String get useThisCodeToGet => 'Utilisez ce code pour obtenir ';

  @override
  String get off => ' désactivé';

  @override
  String get expiryDate => "Date d'expiration : ";

  @override
  String get apply => 'Appliquer';

  @override
  String get coupons => 'Coupons';

  @override
  String get enterCouponCode => 'Entrez le code promo';

  @override
  String get check => 'Vérifier';

  @override
  String get allCoupons => 'Tous les coupons';

  @override
  String get oopsWeCouldnTFind =>
      "Oups ! Nous n'avons trouvé aucun code promo correspondant";

  @override
  String get doYouWantToRemoveCoupon => 'Voulez-vous supprimer ce coupon ?';

  @override
  String get noSubscriptionHistoryFound =>
      "Aucun historique d'abonnement trouvé";

  @override
  String get couponDiscount => 'Coupon de réduction ';

  @override
  String get childrenSProfile => 'Profil d\'enfant';

  @override
  String get madeForKidsUnder12 => 'Conçu pour les enfants de moins de 12 ans';

  @override
  String get otpVerifiedFailed => 'La vérification OTP a échoué';

  @override
  String get otpVerifiedSuccessfully => 'OTP vérifié avec succès';

  @override
  String get otpSentSuccessfully => 'OTP envoyé avec succès';

  @override
  String get weHaveSentYouOTPOnYourRegisterEmailAddress =>
      'Nous vous avons envoyé un OTP sur votre adresse e-mail enregistrée';

  @override
  String get otpVerification => 'Vérification OTP';

  @override
  String get enterPIN => 'Entrez le code PIN';

  @override
  String get enterYourNewParentalPinForYourKids =>
      'Entrez votre nouveau code parental pour vos enfants';

  @override
  String get confirmPIN => 'Confirmer le code PIN';

  @override
  String get setPIN => 'Définir le code PIN';

  @override
  String get changePIN => 'Changer le code PIN';

  @override
  String get parentalControl => 'Contrôle parental';

  @override
  String get invalidPIN => 'Code PIN invalide';

  @override
  String get kids => 'ENFANTS';

  @override
  String get enter4DigitParentalControlPIN =>
      'Saisissez le code PIN de contrôle parental à 4 chiffres';

  @override
  String get parentalLock => 'Verrouillage parental';

  @override
  String get profileDeletedSuccessfully => 'Profil supprimé avec succès';

  @override
  String get pinNotMatched => 'Le code PIN ne correspond pas';

  @override
  String get pleaseEnterNewPIN => 'Veuillez saisir un nouveau code PIN';

  @override
  String get pleaseEnterConfirmPin =>
      'Veuillez saisir le code PIN de confirmation';

  @override
  String get linkTv => 'Lien TV';

  @override
  String get youHaveBeenLoggedOutSuccessfully =>
      'Vous avez été déconnecté avec succès';

  @override
  String get rented => 'LOUÉ';

  @override
  String get rent => 'LOUER';

  @override
  String get rentFor => 'Louer pour';

  @override
  String rentedesc(int availableFor, String duration) =>
      'Vous disposez de $availableFor jours pour commencer à regarder une fois la location effectuée. Vous disposerez de $duration heures pour terminer une fois la diffusion commencée.';

  @override
  String youCanWatchThis(int duration) =>
      'Vous pouvez regarder ce contenu plusieurs fois pendant la période de $duration heures.';

  @override
  String get thisIsANonRefundable =>
      'Il sagit dune transaction non remboursable.';

  @override
  String get thisContentIsOnly =>
      'Ce contenu est uniquement disponible à la location et ne fait pas partie de l`abonnement Premium.';

  @override
  String get youCanPlayYour =>
      'Vous pouvez lire votre contenu sur les appareils pris en charge.';

  @override
  String get validity => 'Validité';

  @override
  String get days => 'Jours';

  @override
  String get watchTime => 'Temps de visionnage';

  @override
  String get hours => 'Heures';

  @override
  String get byRentingYouAgreeToOur => 'En louant, vous acceptez nos';

  @override
  String get pleaseAgreeToThe =>
      'Veuillez accepter les conditions d`utilisation avant de continuer.';

  @override
  String get successfullyRentedMoviesOn => 'Films loués avec succès sur';

  @override
  String enjoyUntilDays(int days) => 'Profitez-en jusqu`à $days jours';

  @override
  String get beginWatching => 'Commencer à regarder';

  @override
  String doYouConfirmThis(String movieName) =>
      'Confirmez-vous ce plan loué pour $movieName ';

  @override
  String get unlockedVideo => 'vidéo déverrouillée';

  @override
  String get info => 'Informations';

  @override
  String get payPerView => ' Paiement à la séance';

  @override
  String get newPinSuccessfullySaved =>
      'Nouveau code PIN enregistré avec succès';

  @override
  String get successfullyUpdated => 'Mise à jour réussie';

  @override
  String get defaultLabel => 'Par défaut';

  @override
  String get quality => 'Qualité';

  @override
  String get subtitle => 'Sous-titre';

  @override
  String get skip => 'Passer';

  @override
  String get nextEpisode => 'Épisode suivant';

  @override
  String get rentDetails => 'Détails de la location';

  @override
  String get pleaseSelectPaymentMethod  => 'Veuillez sélectionner un mode de paiement.';

  @override
  String get tvLinkedSuccessfully => 'TV connectée avec succès !';

  @override
  String get cameraPermissionDenied => "Autorisation de la caméra refusée. Veuillez l'activer dans les paramètres.";
}
