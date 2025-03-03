enum DegreeType {
  noDegree,
  diploma,
  postGraduateDiploma,
  bachelors,
  masters,
  phd,
}

DegreeType convertStringToDegree(String degree) {
  switch (degree) {
    case 'بدون مدرک':
      return DegreeType.noDegree;
    case 'دیپلم':
      return DegreeType.diploma;
    case 'فوق دیپلم':
      return DegreeType.postGraduateDiploma;
    case 'لیسانس':
      return DegreeType.bachelors;
    case 'فوق لیسانس':
      return DegreeType.masters;
    case 'دکتری':
      return DegreeType.phd;
    default:
      return DegreeType.noDegree;
  }
}

String convertDegreeToString(DegreeType type) {
  switch (type) {
    case DegreeType.noDegree:
      return 'بدون مدرک';
    case DegreeType.diploma:
      return 'دیپلم';
    case DegreeType.postGraduateDiploma:
      return 'فوق دیپلم';
    case DegreeType.bachelors:
      return 'لیسانس';
    case DegreeType.masters:
      return 'فوق لیسانس';
    case DegreeType.phd:
      return 'دکتری';
  }
}
