class UserInfo {
  final String userName;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String sirName;
  final int id;
  UserInfo(
      {required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.firstName,
      required this.sirName,
      required this.id});
}

class UserData {
  final String userName;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String sirName;
  final int id;
  final String status;

  UserData(
      {required this.userName,
      required this.email,
      required this.phoneNumber,
      required this.firstName,
      required this.sirName,
      required this.id,
      required this.status});
}
