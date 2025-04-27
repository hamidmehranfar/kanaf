enum CalculateType { roof, wall }

CalculateType convertStringToCalculateType(String name) {
  if (name == "سقف") {
    return CalculateType.roof;
  } else {
    return CalculateType.wall;
  }
}

String convertCalculateTypeToString(CalculateType type) {
  switch (type) {
    case CalculateType.roof:
      return "سقف";
    case CalculateType.wall:
      return "دیوار";
  }
}
