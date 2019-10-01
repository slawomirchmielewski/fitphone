import 'package:fitphone/enums/session_states.dart';
import 'package:fitphone/enums/view_states.dart';
import 'package:fitphone/utils/firebase_result.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:fitphone/repository/firebase_api.dart';

class SessionManager with ChangeNotifier {

  SessionState _sessionState = SessionState.Uninitialized;
  ViewState _viewState = ViewState.Login;
  bool _register = false;
  String loginErrorMassage = "";
  String registrationErrorMassage = "";

  SessionState get sessionState => _sessionState;
  ViewState get viewState => _viewState;

  String _name  = "";
  String _loginEmail = "";
  String _registrationEmail = "";
  String _resetEmail ="";
  String _loginPassword = "";
  String _registrationPassword = "";
  String _passcode = "";


  bool _loginPasswordVisible = false;
  bool _registrationPasswordVisible = false;

  get name => _name;
  get loginEmail => _loginEmail;
  get loginPassword => _loginPassword;
  get resetEmail => _resetEmail;
  get registrationEmail => _registrationEmail;
  get registrationPassword => _registrationPassword;
  get passcode => _passcode;
  get loginPasswordVisible => _loginPasswordVisible;
  get registrationPasswordVisible => _registrationPasswordVisible;

  _clearTextFields(){
    _name = "";
    _loginEmail = "";
    _loginPassword = "";
    _registrationEmail ="";
    _registrationPassword = "";
    _passcode = "";
    _resetEmail = "";
  }

  setName(String name){
    _name = name;

  }

  setLoginEmail(String email){
    _loginEmail = email;
  }

  setLoginPassword(String password){
    _loginPassword = password;

  }

  setRegistrationEmail(String email){
    _registrationEmail = email;

  }

  setRegistrationPassword(String password){
    _registrationPassword  = password;

  }


  setResetEmail(String email){
    _resetEmail = email;

  }

  setPasscode(String passcode){
    _passcode = passcode;
  }


  setLoginPasswordVisibility(bool isVisible){
    _loginPasswordVisible = isVisible;
     notifyListeners();
  }

  setRegistrationPasswordVisibility(bool isVisible){
    _registrationPasswordVisible = isVisible;
     notifyListeners();
  }


  setViewState(ViewState state){
    _viewState = state;
    notifyListeners();
  }

  setRegisterStatus(bool status){
    _register = status;
    notifyListeners();
  }

  setSessionState(SessionState sessionState){
    _sessionState = sessionState;
  }


  SessionManager(){
    FirebaseAPI().checkLoginUser().listen((firebaseUser) => _onAuthStateChanged(firebaseUser));
  }


  Future<void> _onAuthStateChanged(var firebaseUser) async {
    if (firebaseUser == null) {
      _sessionState = SessionState.Unauthenticated;
    }else if(firebaseUser !=null && _register == true){
      _sessionState = SessionState.Registered;
    }
    else {
      _sessionState = SessionState.Authenticated;
    }
    notifyListeners();
  }

  Future<void> loginUser() async{
    _sessionState = SessionState.Authenticating;
    notifyListeners();
   FirebaseResultCallback result  = await FirebaseAPI().loginUserWithEmailAndPassword(_loginEmail, _loginPassword).then((result) => result).catchError((error) => print(error));

   if(result.success == true){
     _sessionState = SessionState.Authenticated;
    loginErrorMassage = "";
    _clearTextFields();
   }
   else{
     _sessionState = SessionState.Unauthenticated;
     loginErrorMassage = result.error;
   }
    notifyListeners();
  }


  Future<void> registerUser() async{
    _register = true;
    _sessionState = SessionState.Authenticating;
    notifyListeners();
    FirebaseResultCallback result = await FirebaseAPI().registerUserWithEmailAndPassword(_name, _registrationEmail, _registrationPassword, _passcode).then((result) => result).catchError((error) => print(error));

    if(result.success == true){
      _sessionState = SessionState.Registered;
      registrationErrorMassage = "";
      _clearTextFields();
    }
    else{
      _sessionState = SessionState.Unauthenticated;
      registrationErrorMassage = result.error;
    }
    notifyListeners();
  }

  logoutUser() async {
    await FirebaseAPI().signOutUser().catchError((error) => print(error));
    _sessionState = SessionState.Unauthenticated;
  }


  Future<String> sendPasswordResetRequest(String email) async {

    String massage = "";

    if(email != null) {
      FirebaseResultCallback result = await FirebaseAPI().resetPassword(email).then((value) => value);

      if(result.success == true){
        massage = "Reset request sent";
      }
      else{
        massage = "Something went wrong please try again";
      }
    }
    else{
      massage = "Please provide email address";
    }
    return massage;
  }

}