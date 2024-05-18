import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/provider.dart';

class ProviderFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Provider provider;

  ProviderFormProvider(this.provider);

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}