enum MasterRequestTypes {
  active,
  inProgress,
  inActive,
  pend,
}

MasterRequestTypes convertStringToMasterType(String type) {
  switch (type) {
    case "فعال":
      return MasterRequestTypes.active;
    case 'عدم تایید':
      return MasterRequestTypes.inActive;
    case 'در انتظار تایید':
      return MasterRequestTypes.inProgress;
    case 'معلق':
      return MasterRequestTypes.pend;
    default:
      return MasterRequestTypes.inActive;
  }
}
