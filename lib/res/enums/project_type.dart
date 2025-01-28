enum ProjectType{
  sent, receive
}

ProjectType convertToProjectType(String type){
  if(type == "sent") {
    return ProjectType.sent;
  } else {
    return ProjectType.receive;
  }
}