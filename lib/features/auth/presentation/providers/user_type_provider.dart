import 'package:flutter/material.dart';

enum UserType { customer, lender, none }

class UserTypeProvider extends ChangeNotifier {
  UserType _selectedType = UserType.none;

  UserType get selectedType => _selectedType;

  void selectType(UserType type) {
    _selectedType = type;
    notifyListeners();
  }

  bool get hasSelection => _selectedType != UserType.none;
  bool get isCustomer => _selectedType == UserType.customer;
  bool get isLender => _selectedType == UserType.lender;
}
