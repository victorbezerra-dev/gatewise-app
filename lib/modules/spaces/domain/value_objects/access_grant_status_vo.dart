enum AccessGrantStatus {
  pending('Pending'),
  granted('Granted'),
  rejected('Rejected');

  const AccessGrantStatus(this.apiValue);

  final String apiValue;

  String get label {
    switch (this) {
      case AccessGrantStatus.pending:
        return 'Pendente';
      case AccessGrantStatus.granted:
        return 'Autorizado';
      case AccessGrantStatus.rejected:
        return 'Rejeitado';
    }
  }

  static AccessGrantStatus fromJson(dynamic value) {
    if (value is String) {
      return AccessGrantStatus.values.firstWhere(
        (s) => s.apiValue.toLowerCase() == value.toLowerCase(),
        orElse: () => AccessGrantStatus.pending,
      );
    }
    if (value is int && value < AccessGrantStatus.values.length) {
      return AccessGrantStatus.values[value];
    }
    return AccessGrantStatus.pending;
  }
}
