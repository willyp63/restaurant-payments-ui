import 'package:mimos/utils/forms/form.utils.dart';

MMSInputValidator requiredValidator = (dynamic value) {
  if (value == null) { return MMSInputErrorCode.empty; }
  if (value == '') { return MMSInputErrorCode.empty; }
  if (value == false) { return MMSInputErrorCode.empty; }

  return null;
};
