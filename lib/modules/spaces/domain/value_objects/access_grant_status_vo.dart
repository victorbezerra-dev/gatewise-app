import 'package:flutter/widgets.dart';
import '../../../../core/l10n/l10n.dart';

enum AccessGrantStatus {
  pending('Pending'),
  granted('Granted'),
  rejected('Rejected');

  const AccessGrantStatus(this.apiValue);

  final String apiValue;

  String label(BuildContext context) {
    switch (this) {
      case AccessGrantStatus.pending:
        return context.l.grantStatusPending;
      case AccessGrantStatus.granted:
        return context.l.grantStatusGranted;
      case AccessGrantStatus.rejected:
        return context.l.grantStatusRejected;
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
