import 'package:fitphone/enums/view_states.dart';
import 'package:fitphone/view/password_reset_screen.dart';
import 'package:fitphone/view/setup_screen.dart';
import 'package:fitphone/view_model/session_manager.dart';
import 'package:fitphone/widget/fit_animated_button.dart';
import 'package:fitphone/widget/fit_text_form.dart';
import 'package:fitphone/widget/fit_text_form_protected.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';



class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final SessionManager sessionManager = Provider.of<SessionManager>(context);

    Widget loginForm(){
      return Container(
        child: Column(
          children: <Widget>[
            FitTextForm(icon: SimpleLineIcons.envelope,hint:"Email",onChange: (text) => sessionManager.setLoginEmail(text),text: sessionManager.loginEmail,),
            SizedBox(height: 16),
            FitTextFormProtected(icon: SimpleLineIcons.lock,hint:"Password",onChange:(text) => sessionManager.setLoginPassword(text),
              text: sessionManager.loginPassword,onSuffixTap:(isVisible) =>sessionManager.setLoginPasswordVisibility(!isVisible),
              isPasswordVisible: sessionManager.loginPasswordVisible,),
            SizedBox(height: 16),
            Text(sessionManager.loginErrorMassage,textAlign: TextAlign.center,style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Colors.redAccent
            ),),
            SizedBox(height: 32),
            FitAnimatedButton(buttonText: "Login",onTap:() => sessionManager.loginUser()),
            SizedBox(height: 32),
            FlatButton(
              child: Text("Forgot password ?",style: Theme.of(context).textTheme.subtitle.copyWith(
                  fontWeight: FontWeight.bold
              ),),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetScreen()))),
          ],
        ),
      );
    }


    Widget registrationForm(){
      return Container(
        child: Column(
          children: <Widget>[
            FitTextForm(icon: SimpleLineIcons.user_follow,hint:"Full Name",onChange: (text) => sessionManager.setName(text),text: sessionManager.name),
            SizedBox(height: 16),
            FitTextForm(icon: SimpleLineIcons.envelope,hint: "Email",onChange: (text) => sessionManager.setRegistrationEmail(text),text: sessionManager.registrationEmail),
            SizedBox(height: 16),
            FitTextFormProtected(icon: SimpleLineIcons.lock,hint:"Password",onChange: (text) => sessionManager.setRegistrationPassword(text),text: sessionManager.registrationPassword,
            onSuffixTap: (isVisible) => sessionManager.setRegistrationPasswordVisibility(!isVisible), isPasswordVisible: sessionManager.registrationPasswordVisible,),
            SizedBox(height: 16),
            FitTextForm(icon: SimpleLineIcons.shield,hint:"Passcode",onChange: (text) => sessionManager.setPasscode(text),text: sessionManager.passcode),
            SizedBox(height: 16),
            Text(sessionManager.registrationErrorMassage,textAlign: TextAlign.center,style: Theme.of(context).textTheme.subtitle.copyWith(
                color: Colors.redAccent
            ),),
            SizedBox(height: 72),
            FitAnimatedButton(buttonText: "Register",onTap:() => sessionManager.registerUser()),
            //FitAnimatedButton(buttonText: "Register",onTap:() => Navigator.push(context,  MaterialPageRoute(builder: (context) => SetupScreen()))),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 32,right: 32,top: 16,bottom: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 36),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => sessionManager.setViewState(ViewState.Login),
                    child: Text("Login",textAlign: TextAlign.left,style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.bold,
                      color:sessionManager.viewState == ViewState.Login ?  Theme.of(context).textTheme.title.color : Colors.grey,
                    )),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => sessionManager.setViewState(ViewState.Register),
                    child: Text("Register",style: Theme.of(context).textTheme.headline.copyWith(
                      fontWeight: FontWeight.bold,
                      color:sessionManager.viewState == ViewState.Register ?  Theme.of(context).textTheme.title.color : Colors.grey,
                    )),
                  ),
                ],
              ),

              SizedBox(height: 72),
              Consumer(builder: (context,SessionManager sessionManager,_) {
                    switch(sessionManager.viewState) {
                      case ViewState.Login:
                        return loginForm();
                        break;
                      case ViewState.Register:
                        return registrationForm();
                        break;
                      default:
                        return loginForm();
                    }
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
