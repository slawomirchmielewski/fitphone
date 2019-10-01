
class AccountInfo{

  final String accountStatus;

  AccountInfo({this.accountStatus});


  factory AccountInfo.fromMap(Map<String, dynamic> map){
    return AccountInfo(
      accountStatus: map["account status"]
    );
  }


  factory AccountInfo.init(){
    return AccountInfo(
      accountStatus: "Active"
    );
  }



  Map<String,dynamic> toMap(){
    return {
      "account status" :this.accountStatus
    };
  }


}