import 'package:mimos/utils/forms/form.utils.dart';

final emailExpression = new RegExp(r"(.*)@(.*)\.(.*)");

MMSInputValidator<String> emailValidator = (String value) {
  if (value == null || !emailExpression.hasMatch(value)) {
    return MMSInputErrorCode.invalidEmail;
  }

  return null;
};
