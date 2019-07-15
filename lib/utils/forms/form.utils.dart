final defaultErrorMessage = 'invalid';

enum MMSInputErrorCode {
  empty,
  invalidEmail,
  passwordTooShort,
}

typedef MMSInputValidator<T> = MMSInputErrorCode Function(T value);

class MMSFormController {
  Map<String, MMSInputController> inputs;
  Map<MMSInputErrorCode, String> errorDictionary;
  Map<String, String> errorMessages = {};

  bool get isValid {
    return errorMessages.isEmpty;
  }

  Map<String, dynamic> get value {
    return inputs.map((inputName, input) {
      return new MapEntry(inputName, input.value);
    });
  }

  MMSFormController({this.inputs, this.errorDictionary});

  markAsDirty(String inputName) {
    final input = inputs[inputName];
    if (input != null) {
      input.isDirty = true;
      _validateInput(inputName, input);
    }
  }

  setValue(Map<String, dynamic> value) {
    value.forEach((inputName, inputValue) {
      final input = inputs[inputName];
      if (input != null) {
        input.value = inputValue;

        if (input.isDirty) {
          _validateInput(inputName, input);
        }
      }
    });
  }

  validate() {
    inputs.forEach((inputName, input) { input.isDirty = true; });
    inputs.forEach(_validateInput);
  }

  _validateInput(String inputName, MMSInputController input) {
    input.validate();

    errorMessages.remove(inputName);
    if (input.errorCode != null) {
      String errorMessage = errorDictionary[input.errorCode];
      if (errorMessage == null) { errorMessage = errorDictionary['default']; }
      if (errorMessage == null) { errorMessage = 'invalid'; }
      errorMessages[inputName] = errorMessage;
    }
  }
}

class MMSInputController<T> {
  T value;
  List<MMSInputValidator<T>> validators;
  MMSInputErrorCode errorCode;
  bool isDirty = false;

  MMSInputController({
    T value,
    this.validators = const [],
  });

  validate() {
    errorCode = null;
    this.validators.forEach((validator) {
      final code = validator(value);
      if (code != null) { errorCode = code; }
    });
  }
}
