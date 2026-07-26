enum AccessLogStatus {
  pendingConfirmation(0),
  granted(1),
  noConfirmation(2),
  deniedByPolicy(3);

  const AccessLogStatus(this.statusCode);

  final int statusCode;

  bool get isSuccess => this == granted;
  bool get isFailure => this == deniedByPolicy;
  bool get isPending => this == pendingConfirmation || this == noConfirmation;

  String get label {
    switch (this) {
      case AccessLogStatus.granted:
        return 'Concedido';
      case AccessLogStatus.pendingConfirmation:
        return 'Aguardando';
      case AccessLogStatus.noConfirmation:
        return 'Sem confirmação';
      case AccessLogStatus.deniedByPolicy:
        return 'Negado';
    }
  }

  static AccessLogStatus fromJson(dynamic value) {
    if (value is int) {
      return AccessLogStatus.values.firstWhere(
        (s) => s.statusCode == value,
        orElse: () => AccessLogStatus.deniedByPolicy,
      );
    }
    if (value is String) {
      switch (value.toUpperCase()) {
        case 'PENDING_CONFIRMATION':
          return AccessLogStatus.pendingConfirmation;
        case 'GRANTED':
          return AccessLogStatus.granted;
        case 'NO_CONFIRMATION':
          return AccessLogStatus.noConfirmation;
        case 'DENIED_BY_POLICY':
          return AccessLogStatus.deniedByPolicy;
      }
    }
    return AccessLogStatus.deniedByPolicy;
  }
}
