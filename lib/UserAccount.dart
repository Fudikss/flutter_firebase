class UserAccount{
  String name = "";
  String email = "";
  String _clubName = "";

  static UserAccount? instance;

  static UserAccount? getInstance(){
    if (instance == null) {
      instance = new UserAccount();
    }
    return instance;
  }

  String getName(){
    return name;
  }

  String getEmail(){
    return email;
  }

  String getClubName(){
    return _clubName;
  }

  void setUserAccount1(String name){
    this.name = name;
  }

  void setUserAccount2(String email){
    this.email = email;
  }

  void setClubName(String _clubName){
    this._clubName = _clubName;
  }
}