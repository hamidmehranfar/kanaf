enum ProjectType { sent, recieved }

ProjectType convertToProjectType(String type) {
  if (type == "sent") {
    return ProjectType.sent;
  } else {
    return ProjectType.recieved;
  }
}
