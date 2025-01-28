enum MasterServices{
  kanafWorker,
  opticalLineWorker,
  painterWorker,
  electronicWorker,
}

String convertServiceToString(MasterServices service){
  if(service == MasterServices.kanafWorker){
    return "کناف کار";
  }
  else if(service == MasterServices.opticalLineWorker){
    return "لاین نور";
  }
  else if(service == MasterServices.painterWorker){
    return "نقاش ها";
  }
  else{
    return "برق کار ها";
  }
}