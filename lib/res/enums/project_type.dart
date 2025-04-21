enum ProjectType { sent, received }

ProjectType convertToProjectType(String type) {
  if (type == "sent") {
    return ProjectType.sent;
  } else {
    return ProjectType.received;
  }
}
