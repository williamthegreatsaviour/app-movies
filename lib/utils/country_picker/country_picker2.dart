import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../colors.dart';
import '../empty_error_state_widget.dart';
import 'country_list.dart';

typedef CustomCountryFlagBuilder = Widget Function(Country country);

class CustomCountryListView extends StatefulWidget {
  /// Called when a country is select.
  ///
  /// The country picker passes the new value to the callback.
  final ValueChanged<Country> onSelect;

  /// An optional [showPhoneCode] argument can be used to show phone code.
  final bool showPhoneCode;

  /// An optional [exclude] argument can be used to exclude(remove) one ore more
  /// country from the countries list. It takes a list of country code(iso2).
  /// Note: Can't provide both [exclude] and [countryFilter]
  final List<String>? exclude;

  /// An optional [countryFilter] argument can be used to filter the
  /// list of countries. It takes a list of country code(iso2).
  /// Note: Can't provide both [countryFilter] and [exclude]
  final List<String>? countryFilter;

  /// An optional [favorite] argument can be used to show countries
  /// at the top of the list. It takes a list of country code(iso2).
  final List<String>? favorite;

  /// An optional argument for customizing the
  /// country list bottom sheet.
  final CountryListThemeData? countryListTheme;

  /// An optional argument for initially expanding virtual keyboard
  final bool searchAutofocus;

  /// An optional argument for showing "World Wide" option at the beginning of the list
  final bool showWorldWide;

  /// An optional argument for hiding the search bar
  final bool showSearch;

  /// Custom builder function for flag widget
  final CustomFlagBuilder? customFlagBuilder;

  const CustomCountryListView({
    super.key,
    required this.onSelect,
    this.exclude,
    this.favorite,
    this.countryFilter,
    this.showPhoneCode = false,
    this.countryListTheme,
    this.searchAutofocus = false,
    this.showWorldWide = false,
    this.showSearch = true,
    this.customFlagBuilder,
  }) : assert(
          exclude == null || countryFilter == null,
          'Cannot provide both exclude and countryFilter',
        );

  @override
  State<CustomCountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CustomCountryListView> {
  final CountryService _countryService = CountryService();

  late List<Country> _countryList;
  late List<Country> _filteredList;
  List<Country>? _favoriteList;
  late TextEditingController _searchController;
  late bool _searchAutofocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _countryList = _countryService.getAll();

    _countryList = countryCodes.map((country) => Country.from(json: country)).toList();

    //Remove duplicates country if not use phone code
    if (!widget.showPhoneCode) {
      final ids = _countryList.map((e) => e.countryCode).toSet();
      _countryList.retainWhere((country) => ids.remove(country.countryCode));
    }

    if (widget.favorite != null) {
      _favoriteList = _countryService.findCountriesByCode(widget.favorite!);
    }

    if (widget.exclude != null) {
      _countryList.removeWhere(
        (element) => widget.exclude!.contains(element.countryCode),
      );
    }

    if (widget.countryFilter != null) {
      _countryList.removeWhere(
        (element) => !widget.countryFilter!.contains(element.countryCode),
      );
    }

    _filteredList = <Country>[];
    if (widget.showWorldWide) {
      _filteredList.add(Country.worldWide);
    }
    _filteredList.addAll(_countryList);

    _searchAutofocus = widget.searchAutofocus;
  }

  @override
  Widget build(BuildContext context) {
    final String searchLabel = CountryLocalizations.of(context)?.countryName(countryCode: 'search') ?? 'Search';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select Country",
                style: boldTextStyle(
                  size: 16,
                  color: white,
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    fill: 1,
                    color: white,
                  ))
            ],
          ),
        ),
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: TextField(
              autofocus: _searchAutofocus,
              controller: _searchController,
              style: widget.countryListTheme?.searchTextStyle ?? _defaultTextStyle,
              decoration: widget.countryListTheme?.inputDecoration ??
                  InputDecoration(
                    labelText: searchLabel,
                    hintText: searchLabel,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: const Color(0xFF8C98A8).withValues(alpha: 0.2),
                      ),
                    ),
                  ),
              onChanged: _filterSearchResults,
            ),
          ),
        Expanded(
          child: ListView(
            children: [
              if (_favoriteList != null) ...[
                ..._favoriteList!.map<Widget>((currency) => _listRow(currency)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(thickness: 1),
                ),
              ] else if (_searchController.text.isNotEmpty && _filteredList.isEmpty) ...[
                NoDataWidget(
                  title: locale.value.sorryCouldnFindYourSearch,
                  subTitle: locale.value.trySomethingNew,
                  retryText: "",
                  subTitleTextStyle: primaryTextStyle(size: 12, color: darkGrayTextColor),
                  titleTextStyle: boldTextStyle(size: 16, color: white),
                  imageWidget: const ErrorStateWidget(),
                  onRetry: null,
                ).paddingBottom(32),
              ],
              ..._filteredList.map<Widget>((country) => _listRow(country)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listRow(Country country) {
    final TextStyle textStyle = widget.countryListTheme?.textStyle ?? _defaultTextStyle;

    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Material(
      // Add Material Widget with transparent color
      // so the ripple effect of InkWell will show on tap
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          country.nameLocalized = CountryLocalizations.of(context)?.countryName(countryCode: country.countryCode)?.replaceAll(RegExp(r"\s+"), " ");
          widget.onSelect(country);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: <Widget>[
              Row(
                children: [
                  const SizedBox(width: 20),
                  if (widget.customFlagBuilder == null) _flagWidget(country) else widget.customFlagBuilder!(country),
                  if (widget.showPhoneCode && !country.iswWorldWide) ...[
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 45,
                      child: Text(
                        '${isRtl ? '' : '+'}${country.phoneCode}${isRtl ? '+' : ''}',
                        style: textStyle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ] else
                    const SizedBox(width: 15),
                ],
              ),
              Expanded(
                child: Text(
                  CountryLocalizations.of(context)?.countryName(countryCode: country.countryCode)?.replaceAll(RegExp(r"\s+"), " ") ?? country.name,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flagWidget(Country country) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      // the conditional 50 prevents irregularities caused by the flags in RTL mode
      width: isRtl ? 50 : null,
      child: _emojiText(country),
    );
  }

  Widget _emojiText(Country country) => Text(
        country.iswWorldWide ? '\uD83C\uDF0D' : Utils.countryCodeToEmoji(country.countryCode),
        style: TextStyle(
          fontSize: widget.countryListTheme?.flagSize ?? 25,
          fontFamilyFallback: widget.countryListTheme?.emojiFontFamilyFallback,
        ),
      );

  void _filterSearchResults(String query) {
    List<Country> searchResult = <Country>[];
    final CountryLocalizations? localizations = CountryLocalizations.of(context);

    if (query.isEmpty) {
      searchResult.addAll(_countryList);
    } else {
      searchResult = _countryList.where((c) => c.startsWith(query, localizations)).toList();
    }

    setState(() => _filteredList = searchResult);
  }

  TextStyle get _defaultTextStyle => const TextStyle(fontSize: 16);
}

class Utils {
  static String countryCodeToEmoji(String countryCode) {
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }
}
