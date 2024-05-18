import 'dart:convert';

class Provider {
  final int providerId;
  final String providerName;
  final String providerLastName;
  final String providerMail;
  final String providerState;

  Provider({
    required this.providerId,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      providerId: json["providerid"],
      providerName: json["provider_name"],
      providerLastName: json["provider_last_name"],
      providerMail: json["provider_mail"],
      providerState: json["provider_state"],
    );
  }
}


class ProviderList {
  final List<Provider> providers;

  ProviderList({
    required this.providers,
  });

  factory ProviderList.fromJson(String str) {
    final parsedJson = json.decode(str);
    final List<dynamic> providerListJson = parsedJson["Proveedores Listado"];
    final providers = providerListJson.map((json) => Provider.fromJson(json)).toList();
    return ProviderList(providers: providers);
  }
}
