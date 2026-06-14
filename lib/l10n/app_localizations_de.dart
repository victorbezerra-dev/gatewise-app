// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get authIotPill => 'IoT-Automatisierungsplattform';

  @override
  String get authTagline => 'Das Tor zu intelligenten Umgebungen.';

  @override
  String get authSubtitle =>
      'Verbinden, automatisieren und sichern Sie jede Umgebung, in jedem Maßstab, intelligent.';

  @override
  String get authLoginButton => 'Mit GateWise anmelden';

  @override
  String get authNoAccount => 'Noch kein Konto?';

  @override
  String get authSignUp => 'Registrieren';

  @override
  String authLoginFailed(Object error) {
    return 'Anmeldung fehlgeschlagen: $error';
  }

  @override
  String get splashTaglinePart1 => 'Verbinden, automatisieren und schützen.';

  @override
  String get splashTaglinePart2 => 'In jedem Maßstab';

  @override
  String get splashConnecting => 'Sichere Verbindung wird hergestellt';

  @override
  String get splashLoadingText => 'wird geladen';

  @override
  String get navOrgs => 'Orgs';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navProfile => 'Profil';

  @override
  String get wsAccessOpened => 'Zugang gewährt – Labor geöffnet!';

  @override
  String get wsAccessFailed =>
      'Beim Öffnen des Schlosses ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut oder kontaktieren Sie den Support.';

  @override
  String get wsConnectionError => 'Serververbindungsfehler.';

  @override
  String get profileTitle => 'Mein Profil';

  @override
  String get profileSectionAccount => 'Kontodaten';

  @override
  String get profileLabelName => 'Name';

  @override
  String get profileLabelEmail => 'E-Mail';

  @override
  String get profileLabelRegistration => 'Kennung';

  @override
  String get profileSectionDevice => 'Gerät';

  @override
  String get profileLabelModel => 'Modell';

  @override
  String get profileLabelManufacturer => 'Hersteller';

  @override
  String get profileLabelSystem => 'System';

  @override
  String get profileGuestName => 'GateWise-Benutzer';

  @override
  String get profileNoEmail => 'Keine E-Mail angegeben';

  @override
  String get profileLogout => 'Abmelden';

  @override
  String get profileErrorLoad => 'Fehler beim Laden des Profils';

  @override
  String get profileRetry => 'Erneut versuchen';

  @override
  String get profileNotFound => 'Benutzer nicht gefunden';

  @override
  String get profileNotFoundMessage =>
      'Bitte melden Sie sich erneut an, um Ihre Daten zu aktualisieren.';

  @override
  String get profileSectionLanguage => 'Sprache';

  @override
  String get profileLanguageDialogTitle => 'Sprache auswählen';

  @override
  String get langPt => 'Português (Brasil)';

  @override
  String get langEn => 'English (US)';

  @override
  String get langEs => 'Español (España)';

  @override
  String get langFr => 'Français (France)';

  @override
  String get langDe => 'Deutsch (Deutschland)';

  @override
  String get orgsTitle => 'Organisationen';

  @override
  String get orgsSubtitle =>
      'Verwalten Sie Mitglieder, Einladungen und Zugänge.';

  @override
  String get orgsNewButton => 'Neue Organisation';

  @override
  String get orgsJoinButton => 'Code';

  @override
  String get orgsMineSection => 'Meine Organisationen';

  @override
  String get orgsSection => 'Organisationen';

  @override
  String get orgsActiveStatus => 'Aktive Organisation';

  @override
  String get orgsInactiveStatus => 'Inaktive Organisation';

  @override
  String orgsMemberSince(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String get orgsNoneFound => 'Keine Organisationen gefunden';

  @override
  String get orgsNoneFoundMessage =>
      'Erstellen Sie eine Organisation oder treten Sie einer mit einem Einladungscode bei.';

  @override
  String get orgsErrorLoad => 'Fehler beim Laden der Organisationen';

  @override
  String get orgsCreatedSuccess => 'Organisation erfolgreich erstellt.';

  @override
  String orgsJoinedSuccess(String name) {
    return 'Sie sind $name beigetreten.';
  }

  @override
  String get orgDetailsTitle => 'Organisation';

  @override
  String get orgDetailsErrorLoad => 'Fehler beim Öffnen der Organisation';

  @override
  String get orgDetailsNotFound => 'Organisation nicht gefunden';

  @override
  String get orgDetailsNotFoundMessage =>
      'Die angeforderten Daten konnten nicht gefunden werden.';

  @override
  String get orgTabSpaces => 'Bereiche';

  @override
  String get orgTabMembers => 'Mitglieder';

  @override
  String get orgTabInvites => 'Einladungen';

  @override
  String get orgManageButton => 'Verwalten';

  @override
  String get orgSpacesSection => 'Organisationsbereiche';

  @override
  String get orgSpacesUnavailable => 'Bereiche nicht verfügbar';

  @override
  String get orgSpacesUnavailableMessage =>
      'Bereiche konnten nicht geladen werden.';

  @override
  String get orgSpacesNone => 'Keine Bereiche registriert';

  @override
  String get orgSpacesNoneMessage =>
      'Fügen Sie Bereiche hinzu, um den Zugang zu Türen zu steuern.';

  @override
  String get orgMembersUnavailable => 'Mitglieder nicht verfügbar';

  @override
  String get orgMembersNone => 'Keine Mitglieder gefunden';

  @override
  String get orgMembersNoneMessage =>
      'Diese Organisation hat noch keine Mitglieder.';

  @override
  String get orgInvitesSection => 'Aktive Einladungen';

  @override
  String get orgInvitesNewButton => 'Neu';

  @override
  String get orgInvitesNone => 'Keine aktiven Einladungen';

  @override
  String get orgInvitesNoneMessage =>
      'Erstellen Sie Einladungen, damit neue Mitglieder beitreten können.';

  @override
  String get orgInvitesUnavailable => 'Einladungen nicht verfügbar';

  @override
  String get orgUpdated => 'Organisation aktualisiert.';

  @override
  String get orgDeleteTitle => 'Organisation löschen?';

  @override
  String orgDeleteMessage(String name) {
    return 'Diese Aktion löscht $name.';
  }

  @override
  String get orgDeleteConfirm => 'Löschen';

  @override
  String get orgDeleteSuccess => 'Organisation gelöscht.';

  @override
  String get orgRemoveMemberTitle => 'Mitglied entfernen?';

  @override
  String orgRemoveMemberMessage(String name) {
    return '$name aus der Organisation entfernen?';
  }

  @override
  String get orgRemoveMemberConfirm => 'Entfernen';

  @override
  String get orgRemoveMemberSuccess => 'Mitglied entfernt.';

  @override
  String orgChangeRoleTitle(String name) {
    return 'Rolle von $name ändern';
  }

  @override
  String get orgChangeRoleSelectSpace =>
      'Wählen Sie mindestens einen Bereich aus';

  @override
  String orgChangeRoleSuccess(String name, String role) {
    return 'Rolle von $name zu $role aktualisiert.';
  }

  @override
  String get orgNoSpacesError =>
      'Keine Bereiche in dieser Organisation gefunden.';

  @override
  String orgSelectSpaceDialog(String name) {
    return '$name aus welchem Bereich entfernen?';
  }

  @override
  String get orgRemoveFromSpaceTitle => 'Bereichsverwalter entfernen?';

  @override
  String orgRemoveFromSpaceMessage(String name, String space) {
    return '$name als Verwalter von \"$space\" entfernen?\n\nFalls keine weiteren Zugänge oder verwalteten Bereiche vorhanden sind, wird der Benutzer automatisch aus der Organisation entfernt.';
  }

  @override
  String get orgRemoveFromSpaceConfirm => 'Entfernen';

  @override
  String orgRemoveFromSpaceSuccess(String name, String space) {
    return '$name aus \"$space\" entfernt.';
  }

  @override
  String get orgRevokeInviteTitle => 'Einladung widerrufen?';

  @override
  String orgRevokeInviteMessage(String code) {
    return 'Der Code $code funktioniert danach nicht mehr.';
  }

  @override
  String get orgRevokeInviteConfirm => 'Widerrufen';

  @override
  String get orgRevokeInviteSuccess => 'Einladung widerrufen.';

  @override
  String get orgRemoveSpaceTitle => 'Bereich entfernen?';

  @override
  String orgRemoveSpaceMessageLast(String space, String code) {
    return 'Beim Entfernen von \"$space\" wird Einladung $code deaktiviert.';
  }

  @override
  String orgRemoveSpaceMessage(String space, String code) {
    return '\"$space\" aus Einladung $code entfernen?';
  }

  @override
  String get orgRemoveSpaceConfirm => 'Entfernen';

  @override
  String get orgRemoveSpaceSuccessDeactivated =>
      'Bereich entfernt. Einladung deaktiviert.';

  @override
  String get orgRemoveSpaceSuccess => 'Bereich entfernt.';

  @override
  String orgInviteCreated(String code) {
    return 'Einladung $code erstellt und kopiert.';
  }

  @override
  String get thisSpace => 'diesen Bereich';

  @override
  String get orgFormNewTitle => 'Neue Organisation';

  @override
  String get orgFormEditTitle => 'Organisation bearbeiten';

  @override
  String get orgFormNewSubtitle =>
      'Richten Sie eine neue Organisation zur Verwaltung von Mitgliedern und Einladungen ein.';

  @override
  String get orgFormEditSubtitle =>
      'Aktualisieren Sie die Daten und den Status Ihrer Organisation.';

  @override
  String get orgFormNameLabel => 'Name';

  @override
  String get orgFormNameHint => 'z. B. GateWise Labor';

  @override
  String get orgFormDescLabel => 'Beschreibung';

  @override
  String get orgFormDescHint => 'Details zur Organisation';

  @override
  String get orgFormStatusLabel => 'Organisationsstatus';

  @override
  String get orgFormStatusActive => 'Aktiv und für Mitglieder verfügbar.';

  @override
  String get orgFormStatusInactive => 'Vorübergehend inaktiv.';

  @override
  String get orgFormSaveButton => 'Organisation speichern';

  @override
  String get joinTitle => 'Per Einladung beitreten';

  @override
  String get joinCodeLabel => 'Einladungscode';

  @override
  String get joinCodeHint => 'ABC12345';

  @override
  String get joinButton => 'Organisation beitreten';

  @override
  String get inviteFormTitle => 'Einladung erstellen';

  @override
  String get inviteFormRoleLabel => 'Rolle';

  @override
  String get inviteFormExpiresLabel => 'Läuft ab in Tagen';

  @override
  String get inviteFormExpiresHint => 'Leer = kein Ablauf';

  @override
  String get inviteFormMaxUsesLabel => 'Maximale Nutzungen';

  @override
  String get inviteFormMaxUsesHint => 'Leer = unbegrenzt';

  @override
  String get inviteFormStartsAtLabel => 'Zugangsbeginn des Mitglieds';

  @override
  String get inviteFormExpiresAtLabel => 'Zugangsablauf des Mitglieds';

  @override
  String get inviteFormSpacesManagerLabel => 'Bereiche des Managers *';

  @override
  String get inviteFormSpacesLabel => 'Bereiche *';

  @override
  String get inviteFormGenerateButton => 'Einladung generieren';

  @override
  String get inviteFormSelectSpaceManager =>
      'Wählen Sie mindestens einen Bereich für den Manager aus.';

  @override
  String get inviteFormSelectSpace =>
      'Wählen Sie mindestens einen Bereich aus.';

  @override
  String get inviteFormSpacesLoadError =>
      'Bereiche konnten nicht geladen werden.';

  @override
  String get inviteFormNoSpaces => 'Keine Bereiche registriert.';

  @override
  String get inviteFormDateNotSet => 'Nicht festgelegt';

  @override
  String get spacesTitle => 'Bereiche';

  @override
  String get spacesHeroPill => 'BEREICHE';

  @override
  String get spacesHeroTitle => 'Ihre Bereiche verwalten';

  @override
  String get spacesHeroDescOwner =>
      'Überwachen Sie Türen, registrieren Sie Umgebungen und verwalten Sie Zugänge in einer sicheren, vernetzten Oberfläche.';

  @override
  String get spacesHeroDescMember =>
      'Sehen und nutzen Sie die in Ihrer Organisation verfügbaren Bereiche.';

  @override
  String get spacesMetricTotal => 'Gesamt';

  @override
  String get spacesMetricActive => 'Aktiv';

  @override
  String get spacesMetricPaused => 'Pausiert';

  @override
  String get spacesNewButton => 'Neuer Bereich';

  @override
  String get spacesOrgSection => 'Organisationsbereiche';

  @override
  String spacesCountPill(int count) {
    return '$count registriert';
  }

  @override
  String get spacesErrorLoad => 'Fehler beim Laden der Bereiche';

  @override
  String get spacesNone => 'Keine Bereiche gefunden';

  @override
  String get spacesNoneMessage =>
      'Erstellen Sie den ersten Bereich, um den Türzugang zu steuern.';

  @override
  String get spaceDetailsTitle => 'Bereich';

  @override
  String get spaceDetailsErrorLoad => 'Fehler beim Öffnen des Bereichs';

  @override
  String get spaceDetailsNotFound => 'Bereich nicht gefunden';

  @override
  String get spaceDetailsNotFoundMessage =>
      'Die angeforderten Daten konnten nicht gefunden werden.';

  @override
  String get spaceDeviceSection => 'Gerät';

  @override
  String get spaceDeviceHardware => 'ESP32-Hardware';

  @override
  String get spaceDeviceDesc =>
      'RSA-Schlüssel zum Flashen auf das Gerät generieren.';

  @override
  String get spaceDeviceProvisionButton => 'Gerät bereitstellen';

  @override
  String get spaceDeviceBackendKeyButton => 'Öffentlicher Serverschlüssel';

  @override
  String get spaceGrantsSection => 'Zugriffsanfragen';

  @override
  String get spaceGrantsRequestButton => 'Anfragen';

  @override
  String get spaceGrantsUnavailable => 'Anfragen nicht verfügbar';

  @override
  String get spaceGrantsNone => 'Keine Anfragen';

  @override
  String get spaceGrantsNoneMessage =>
      'Zugriffsanfragen erscheinen hier zur Genehmigung.';

  @override
  String get spaceGrantsApproveTitle => 'Zugriff genehmigen?';

  @override
  String spaceGrantsApproveMessage(String name) {
    return '$name den Zugriff auf diesen Bereich genehmigen?';
  }

  @override
  String get spaceGrantsApproveConfirm => 'Genehmigen';

  @override
  String get spaceGrantsApproveSuccess => 'Zugriff genehmigt.';

  @override
  String get spaceGrantsCannotApprove => 'Genehmigung nicht möglich.';

  @override
  String get spaceGrantsRejectTitle => 'Zugriff ablehnen?';

  @override
  String spaceGrantsRejectMessage(String name) {
    return 'Anfrage von $name ablehnen?';
  }

  @override
  String get spaceGrantsRejectConfirm => 'Ablehnen';

  @override
  String get spaceGrantsRejectSuccess => 'Zugriff abgelehnt.';

  @override
  String get spaceGrantsCannotReject => 'Ablehnung nicht möglich.';

  @override
  String get spaceGrantsDeleteTitle => 'Zugriff löschen?';

  @override
  String spaceGrantsDeleteMessage(String name) {
    return 'Zugriffseintrag von $name löschen?';
  }

  @override
  String spaceGrantsDeleteMessageLast(String name) {
    return 'Zugriffseintrag von $name löschen?\n\nDies ist der letzte Zugriff dieses Benutzers in diesem Bereich. Falls keine weiteren Organisationsverknüpfungen bestehen, wird er automatisch entfernt.';
  }

  @override
  String get spaceGrantsDeleteConfirm => 'Löschen';

  @override
  String get spaceGrantsDeleteSuccess => 'Eintrag gelöscht.';

  @override
  String get spaceGrantsCannotRemove => 'Entfernen nicht möglich.';

  @override
  String get spaceGrantsCannotSend => 'Anfrage konnte nicht gesendet werden.';

  @override
  String get spaceGrantsSentSuccess => 'Anfrage erfolgreich gesendet.';

  @override
  String get spaceDeleteTitle => 'Bereich löschen?';

  @override
  String spaceDeleteMessage(String name) {
    return 'Diese Aktion löscht \"$name\" dauerhaft.';
  }

  @override
  String get spaceDeleteConfirm => 'Löschen';

  @override
  String get spaceDeleteSuccess => 'Bereich gelöscht.';

  @override
  String get spaceUpdated => 'Bereich aktualisiert.';

  @override
  String get spaceProvisionTitle => 'Gerät neu bereitstellen?';

  @override
  String spaceProvisionMessage(String name) {
    return 'Für den ESP32 von \"$name\" werden neue RSA-Schlüssel generiert. Wenn bereits ein Gerät konfiguriert ist, wird es getrennt.';
  }

  @override
  String get spaceProvisionConfirm => 'Fortfahren';

  @override
  String get spaceBackendKeySheetTitle => 'Öffentlicher Serverschlüssel';

  @override
  String get spaceBackendKeyError =>
      'Öffentlicher Serverschlüssel konnte nicht abgerufen werden.';

  @override
  String get spacePendingMessage => 'Ihre Anfrage wartet auf Genehmigung.';

  @override
  String get spacePendingChip => 'AUSSTEHEND';

  @override
  String get spacePendingButton => 'Wartet auf Genehmigung';

  @override
  String get spaceRejectedMessage => 'Ihre Zugriffsanfrage wurde abgelehnt.';

  @override
  String get spaceRejectedChip => 'ABGELEHNT';

  @override
  String get spaceRejectedButton => 'Erneut anfragen';

  @override
  String get spaceNoAccessMessage =>
      'Sie haben keinen Zugriff auf diesen Bereich.';

  @override
  String get spaceRequestAccessButton => 'Zugriff anfragen';

  @override
  String get spaceMyAccess => 'Mein Zugriff';

  @override
  String get spaceAuthorizedChip => 'AUTORISIERT';

  @override
  String get spaceAccessInfo =>
      'Modul mit Zugangskontrolle verbunden. Aktivieren Sie das Schloss nur, wenn Sie sich in der Nähe der autorisierten Umgebung befinden.';

  @override
  String get spaceEnterButton => 'Bereich betreten';

  @override
  String get spaceOpeningButton => 'Tür wird geöffnet...';

  @override
  String get spaceCommandError => 'Befehl konnte nicht gesendet werden.';

  @override
  String get spaceOpenError => 'Fehler beim Öffnen des Bereichs.';

  @override
  String get spaceLoadAccessError => 'Fehler beim Laden des Zugriffs';

  @override
  String get spaceFormNewTitle => 'Neuer Bereich';

  @override
  String get spaceFormEditTitle => 'Bereich bearbeiten';

  @override
  String get spaceFormNewSubtitle =>
      'Richten Sie einen neuen Bereich zur Steuerung des Türzugangs ein.';

  @override
  String get spaceFormEditSubtitle =>
      'Aktualisieren Sie die Daten und den Status des Bereichs.';

  @override
  String get spaceFormNameLabel => 'Name';

  @override
  String get spaceFormNameHint => 'z. B. Labor 66';

  @override
  String get spaceFormDescLabel => 'Beschreibung';

  @override
  String get spaceFormDescHint => 'Details zum Bereich';

  @override
  String get spaceFormStatusLabel => 'Bereichsstatus';

  @override
  String get spaceFormStatusActive => 'Aktiv und verfügbar.';

  @override
  String get spaceFormStatusInactive => 'Vorübergehend inaktiv.';

  @override
  String get spaceFormSaveButton => 'Bereich speichern';

  @override
  String get requestAccessTitle => 'Zugriff anfragen';

  @override
  String requestAccessSubtitle(String name) {
    return 'Geben Sie den Grund für den Zugriff auf \"$name\" an.';
  }

  @override
  String get requestAccessReasonLabel => 'Grund';

  @override
  String get requestAccessReasonHint =>
      'z. B. Ich benötige Zugriff für Projekt X';

  @override
  String get requestAccessButton => 'Anfrage senden';

  @override
  String get provisionTitle => 'Gerät bereitstellen';

  @override
  String get provisionLoading => 'RSA-Schlüssel werden generiert...';

  @override
  String get provisionErrorTitle => 'Bereitstellungsfehler';

  @override
  String get provisionSuccessTitle => 'Gerät bereitgestellt';

  @override
  String get provisionSuccessSubtitle =>
      'Laden Sie die Schlüssel herunter und flashen Sie sie auf den ESP32.';

  @override
  String get provisionWarningTitle =>
      'Achtung: Privaten Schlüssel jetzt sichern';

  @override
  String get provisionWarningMessage =>
      'Der private Schlüssel des ESP32 wird nicht auf unseren Servern gespeichert. Wenn Sie diesen Bildschirm schließen, ohne ihn zu sichern, müssen Sie ein neues Schlüsselpaar generieren und die Hardware neu konfigurieren.';

  @override
  String get provisionBackendKeyTitle => 'Öffentlicher Serverschlüssel';

  @override
  String get provisionBackendKeyDesc =>
      'Der ESP32 verwendet diesen Schlüssel, um zu verifizieren, dass MQTT-Befehle vom GateWise-Server stammen. Er ist für alle Bereiche identisch.';

  @override
  String get provisionBackendKeyBadge => 'ERNEUT HERUNTERLADBAR';

  @override
  String get provisionBackendKeyNote =>
      'Dieser Schlüssel ist öffentlich und kann jederzeit über die Bereichseinstellungen erneut abgerufen werden.';

  @override
  String get provisionDeviceKeyTitle => 'Privater ESP32-Schlüssel';

  @override
  String get provisionDeviceKeyDesc =>
      'Identifiziert dieses Gerät im System. Der ESP32 verwendet ihn zum Signieren von Ereignissen, die an den Server gesendet werden.';

  @override
  String get provisionDeviceKeyBadge => 'NICHT BEI UNS GESPEICHERT';

  @override
  String get provisionViewMore => 'Mehr anzeigen';

  @override
  String get provisionViewLess => 'Weniger anzeigen';

  @override
  String get provisionCopyButton => 'Kopieren';

  @override
  String get provisionCopiedButton => 'Kopiert!';

  @override
  String get provisionGoToSpaceButton => 'Zum Bereich';

  @override
  String get provisionErrorGenKeys =>
      'Fehler beim Generieren der Geräteschlüssel.';

  @override
  String get keyExportSaveTitle => 'Auf Gerät speichern';

  @override
  String get keyExportSaveDesc =>
      'Speichert die .pem-Datei im lokalen Speicher';

  @override
  String get keyExportShareTitle => 'Teilen';

  @override
  String get keyExportShareDesc => 'Öffnet das Systemfreigabe-Menü';

  @override
  String keyExportSaved(String path) {
    return 'Gespeichert unter: $path';
  }

  @override
  String keyExportError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historyNone => 'Keine Zugriffsprotokolle';

  @override
  String get historyNoneMessage =>
      'Wenn Sie auf eine Umgebung zugreifen, wird der Eintrag hier angezeigt.';

  @override
  String get memberYou => 'Sie';

  @override
  String get memberUnnamed => 'Unbenannter Benutzer';

  @override
  String get memberActionChangeRole => 'Rolle ändern';

  @override
  String get memberActionRemoveFromSpace => 'Aus Bereich entfernen';

  @override
  String get memberActionRemove => 'Mitglied entfernen';

  @override
  String get grantUnnamed => 'Unbenannter Benutzer';

  @override
  String get grantApprove => 'Genehmigen';

  @override
  String get grantReject => 'Ablehnen';

  @override
  String get grantRemove => 'Entfernen';

  @override
  String get userTypeProfessor => 'Dozent';

  @override
  String get userTypeStudent => 'Student';

  @override
  String get userTypeAdmin => 'Administrator';

  @override
  String get userTypeVisitor => 'Besucher';

  @override
  String get userTypeUnknown => 'Nicht angegeben';

  @override
  String get roleOwner => 'Eigentümer';

  @override
  String get roleManager => 'Verwalter';

  @override
  String get roleMember => 'Mitglied';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionConfirm => 'Bestätigen';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionGenericError =>
      'Aktion konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut.';

  @override
  String get noDate => 'kein Datum';

  @override
  String get formValidationName => 'Bitte geben Sie einen Namen ein.';

  @override
  String get formValidationReason => 'Bitte geben Sie einen Grund ein.';
}
