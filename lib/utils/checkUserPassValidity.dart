class CheckUserPassValidity {
  static bool checkUserPasswordValidity({required String username,required String password})
  {
    if(username.length>0 && password.length>0)
      return true;
    else
      return false;
  }
}