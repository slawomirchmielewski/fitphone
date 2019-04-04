import 'dart:async';

mixin Validator {

  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Email not formated correctly");
    }
  });

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 6) {
      sink.add(password);
    } else {
      sink.addError("Password should have more then 6 characters");
    }
  });

  var passcodeValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (passcode, sink) {
    if (passcode == "PASSCODE ") {
      sink.add(passcode);
    } else {
      sink.addError("Wrong pascode");
    }
  });
}
