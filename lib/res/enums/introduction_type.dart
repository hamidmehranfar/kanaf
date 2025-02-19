enum IntroductionType{
  fromGoogle,
  fromKanafApp,
  fromFriends,
  fromSMS,
  others,
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

String convertIntroductionToString(IntroductionType type){
  switch(type){
    case IntroductionType.fromSMS:
      return 'از طریق پیامک';
    case IntroductionType.fromGoogle:
      return 'از طریق جستجو گوگل';
    case IntroductionType.fromKanafApp:
      return 'از طریق اپلیکیشن کنافکار';
    case IntroductionType.fromFriends:
      return 'از طریق دوستان و همکاران';
    case IntroductionType.others:
      return 'سایر';
  }
}

int convertIntroductionToIndex(IntroductionType type){
  switch(type){
    case IntroductionType.fromGoogle:
      return 1;
    case IntroductionType.fromKanafApp:
      return 2;
    case IntroductionType.fromFriends:
      return 3;
    case IntroductionType.fromSMS:
      return 4;
    case IntroductionType.others:
      return 5;
  }
}