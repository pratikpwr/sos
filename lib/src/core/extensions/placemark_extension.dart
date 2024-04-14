import 'package:geocoding/geocoding.dart';

extension PlacemarkExt on Placemark {
  String readableAddress() {
    List<String> addressParts = [];

    // Add name if available
    if (name != null && !(name!.contains("+"))) {
      addressParts.add(name!);
    }

    // Add street if available
    if (street != null && !(street!.contains("+"))) {
      addressParts.add(street!);
    }

    // Add street if available
    if (subLocality != null) {
      addressParts.add(subLocality!);
    }

    // Add city and state/province if available
    String cityAndState = '';
    if (locality != null) {
      cityAndState += locality!;
    }
    if (administrativeArea != null) {
      if (cityAndState.isNotEmpty) {
        cityAndState += ', ';
      }
      cityAndState += administrativeArea!;
    }
    if (cityAndState.isNotEmpty) {
      addressParts.add(cityAndState);
    }

    // Add country if available
    if (country != null) {
      addressParts.add(country!);
    }

    // Add postal code if available
    if (postalCode != null) {
      addressParts.add(postalCode!);
    }

    // Join all parts with commas
    return addressParts.join(', ');
  }
}
