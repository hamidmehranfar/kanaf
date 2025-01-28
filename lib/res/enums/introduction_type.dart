enum IntroductionType{
  fromGoogle,
  fromKanafApp,
  fromFriends,
  fromSMS,
  others
}

//FIXME fix here
IntroductionType convertToIntroductionType(String? type){
  switch(type){
    case "fromGoogle":
      return IntroductionType.fromGoogle;
    default:
      return IntroductionType.others;
  }
}