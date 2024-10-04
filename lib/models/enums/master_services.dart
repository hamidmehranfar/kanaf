enum MasterServices{
  master,
  opticalLine,
  painter
}

String convertServiceToString(MasterServices service){
  if(service == MasterServices.master){
    return "اوستا کار";
  }
  else if(service == MasterServices.opticalLine){
    return "لاین نوری";
  }
  else{
    return "نقاش";
  }
}