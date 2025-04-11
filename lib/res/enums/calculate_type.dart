enum CalculateType { roof, wall }

CalculateType convertStringToCalculateType(String name) {
  if (name == "سقف") {
    return CalculateType.roof;
  } else {
    return CalculateType.wall;
  }
}
