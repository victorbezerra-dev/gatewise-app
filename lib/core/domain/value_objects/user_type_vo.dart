enum UserType {
  professor,
  student,
  admin,
  visitor;

  static UserType fromInt(int value) {
    return UserType.values[value];
  }

  static UserType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'professor':
        return UserType.professor;
      case 'student':
        return UserType.student;
      case 'admin':
        return UserType.admin;
      case 'visitor':
        return UserType.visitor;
      default:
        throw Exception('Tipo de usuário desconhecido: $value');
    }
  }

  String get label {
    switch (this) {
      case UserType.professor:
        return 'Professor';
      case UserType.student:
        return 'Aluno';
      case UserType.admin:
        return 'Administrador';
      case UserType.visitor:
        return 'Visitante';
    }
  }
}
