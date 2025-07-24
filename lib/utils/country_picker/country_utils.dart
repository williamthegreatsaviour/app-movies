import 'country_list.dart';

CountryModel? getCountryByDialCode(String dialCode) {
  RegExp regExp = RegExp(r'\[([^\]]+)\]');

  final index = countryCodes.indexWhere((country) => regExp.firstMatch((country as CountryModel).displayName)!.group(1) == dialCode);
  if (index < 0) return null;
  return CountryModel.fromJson(countryCodes[index]);
}

CountryModel? getCountryByIsoCode(String isoCode) {
  final index = countryCodes.indexWhere((country) => (country as CountryModel).iso2Cc == isoCode);
  if (index < 0) return null;
  return CountryModel.fromJson(countryCodes[index]);
}

bool validatePhoneNumber(String phoneNumber, String dialCode) {
  CountryModel? country = getCountryByDialCode(dialCode);
  if (country == null) return false;
  int length = phoneNumber.length;
  int tempLength = country.fullExampleWithPlusSign.replaceFirst('+${country.e164Cc}', '').length;
  bool lengthValid = length == tempLength;
  bool startingDigitsValid = country.startWithDigit.isEmpty || country.startWithDigit.any((digits) => phoneNumber.startsWith(digits));
  return lengthValid && startingDigitsValid;
}

int getValidPhoneNumberLength(CountryModel country) {
  return country.fullExampleWithPlusSign.replaceFirst('+${country.e164Cc}', '').length;
}

bool validatePhoneNumberByCountry(String phoneNumber, CountryModel country) {
  int length = phoneNumber.length;
  int tempLength = country.fullExampleWithPlusSign.replaceFirst('+${country.e164Cc}', '').length;
  bool lengthValid = length == tempLength;
  bool startingDigitsValid = country.startWithDigit.isEmpty || country.startWithDigit.any((digits) => phoneNumber.startsWith(digits));
  return lengthValid && startingDigitsValid;
}
