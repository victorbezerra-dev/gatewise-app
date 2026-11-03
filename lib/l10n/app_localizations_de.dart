// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
  String get navHistory => 'Zugriffe';

  @override
  String get navProfile => 'Profil';

  @override
  String wsAccessOpened(String spaceName) {
    return 'Zugang gewährt – $spaceName geöffnet!';
  }

  @override
  String wsAccessFailed(String spaceName) {
    return 'Beim Öffnen des Schlosses von $spaceName ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut oder kontaktieren Sie den Support.';
  }

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
  String orgsJoinSpacesAdded(String name) {
    return 'Sie sind bereits Mitglied von $name, haben aber Zugang zu neuen Bereichen erhalten.';
  }

  @override
  String get orgsJoinAlreadyInSpaces =>
      'Sie haben bereits Zugang zu den Bereichen dieser Einladung.';

  @override
  String get orgsJoinRoleMismatch =>
      'Sie sind bereits Mitglied dieser Organisation mit einer anderen Rolle.';

  @override
  String get orgAddSpaceByCodeButton => 'Per Code';

  @override
  String get orgAddSpaceWrongOrgError =>
      'Dieser Code gehört zu einer anderen Organisation als der, die Sie gerade ansehen. Gehen Sie zur Organisationsliste, um darauf zuzugreifen.';

  @override
  String get orgAddSpaceSheetTitle => 'Neue(n) Bereich(e) hinzufügen';

  @override
  String get orgAddSpaceSheetSubtitle =>
      'Geben Sie einen Einladungscode ein, um Zugang zu neuen Bereichen dieser Organisation zu erhalten.';

  @override
  String get orgAddSpaceSheetButton => 'Bereich(e) hinzufügen';

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
  String get orgInvitesSection => 'Einladungen';

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
  String get orgLeaveButton => 'Organisation verlassen';

  @override
  String get orgLeaveTitle => 'Organisation verlassen?';

  @override
  String orgLeaveMessage(String name) {
    return 'Möchten Sie $name wirklich verlassen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get orgLeaveConfirm => 'Verlassen';

  @override
  String get orgLeaveSuccess => 'Sie haben die Organisation verlassen.';

  @override
  String get orgLeaveOnlyOwnerError =>
      'Sie sind der einzige Eigentümer dieser Organisation. Übertragen Sie die Eigentümerschaft oder löschen Sie die Organisation, bevor Sie sie verlassen.';

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
  String get orgRemoveSpaceConfirm => 'Entfernen';

  @override
  String get orgRemoveSpaceSuccessDeactivated =>
      'Bereich entfernt. Einladung deaktiviert.';

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
  String get spaceEsp32TutorialTitle => 'So konfigurieren Sie den ESP32';

  @override
  String get spaceEsp32TutorialScan =>
      'Scannen Sie den QR-Code unten, um auf das Firmware-Repository auf GitHub zuzugreifen:';

  @override
  String spaceEsp32TutorialIdHint(Object id) {
    return 'Die ID dieses Space ist $id — verwenden Sie diesen Wert als Gerätekennung in der Firmware.';
  }

  @override
  String get spaceEsp32TutorialKeysHint =>
      'Verwenden Sie die oben heruntergeladenen Schlüssel, um die Sicherheitskonfiguration des Geräts abzuschließen.';

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
  String get spaceAccessLockedChip => 'Kein Zugriff';

  @override
  String get spaceAccessPendingChip => 'Ausstehend';

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
  String get spaceOpenButton => 'Tür öffnen';

  @override
  String get spaceOpeningButton => 'Tür wird geöffnet...';

  @override
  String dialogOpeningSpace(String spaceName) {
    return '$spaceName wird geöffnet';
  }

  @override
  String get spaceCommandError => 'Befehl konnte nicht gesendet werden.';

  @override
  String get spaceOpenError => 'Fehler beim Öffnen des Bereichs.';

  @override
  String get membershipExpiredMessage =>
      'Ihr Zugriff auf diese Organisation ist abgelaufen. Bitte fordern Sie eine neue Einladung an.';

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
  String get accessTitle => 'Zugriffe';

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
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Schließen';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionGenericError =>
      'Aktion konnte nicht abgeschlossen werden. Bitte versuchen Sie es erneut.';

  @override
  String get dialogSuccessDefault => 'Erfolg!';

  @override
  String get dialogErrorDefault => 'Fehler beim Öffnen';

  @override
  String get dialogTimeoutTitle => 'Zeitüberschreitung';

  @override
  String get dialogTimeoutDefault =>
      'Der Vorgang hat das Zeitlimit überschritten. Keine Antwort von GateWise erhalten. Prüfen Sie, ob das Schloss geöffnet wurde, oder versuchen Sie es erneut.';

  @override
  String get noDate => 'kein Datum';

  @override
  String get noDescription => 'Keine Beschreibung hinterlegt.';

  @override
  String get statusActive => 'AKTIV';

  @override
  String get statusInactive => 'INAKTIV';

  @override
  String get statusActiveFem => 'AKTIV';

  @override
  String get statusInactiveFem => 'INAKTIV';

  @override
  String get grantStatusPending => 'Ausstehend';

  @override
  String get grantStatusGranted => 'Autorisiert';

  @override
  String get grantStatusRejected => 'Abgelehnt';

  @override
  String get formValidationName => 'Bitte geben Sie einen Namen ein.';

  @override
  String get formValidationReason => 'Bitte geben Sie einen Grund ein.';

  @override
  String get equipmentsSection => 'Geräte';

  @override
  String get equipmentsAddButton => 'Hinzufügen';

  @override
  String get equipmentsEmpty => 'Keine Geräte';

  @override
  String get equipmentsEmptyMessage =>
      'Dieser Raum hat noch keine steuerbaren Geräte.';

  @override
  String get equipmentsEmptyManagerMessage =>
      'Füge Klimaanlagen, Fernseher, Beamer und andere Infrarotgeräte hinzu.';

  @override
  String get equipmentsLoadError => 'Geräte konnten nicht geladen werden';

  @override
  String equipmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Geräte',
      one: '1 Gerät',
      zero: 'Keine Geräte',
    );
    return '$_temp0';
  }

  @override
  String equipmentsOnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count an',
    );
    return '$_temp0';
  }

  @override
  String get equipmentsEntryManagerHint => 'Tippen, um das erste hinzuzufügen';

  @override
  String get equipmentFormRemoteLabel => 'Marke der Fernbedienung';

  @override
  String get equipmentFormRemoteHint =>
      'Die Tasten der Original-Fernbedienung der Marke werden automatisch angelegt.';

  @override
  String equipmentFormRemoteButtons(int count) {
    return '$count Tasten werden automatisch angelegt';
  }

  @override
  String get equipmentFormRemoteNone => 'Keine (Tasten aufnehmen)';

  @override
  String get equipmentFormRemoteRequired => 'Marke auswählen';

  @override
  String get remoteTitle => 'Fernbedienung';

  @override
  String get remoteVolumeLabel => 'VOL';

  @override
  String get remoteChannelLabel => 'KANAL';

  @override
  String get remoteNumbersToggle => 'Ziffernblock';

  @override
  String get remoteOtherButtons => 'Weitere Tasten';

  @override
  String get equipmentInactiveBadge => 'Inaktiv';

  @override
  String get equipmentTypeAirConditioner => 'Klimaanlage';

  @override
  String get equipmentTypeTv => 'Fernseher';

  @override
  String get equipmentTypeProjector => 'Beamer';

  @override
  String get equipmentTypeFan => 'Ventilator';

  @override
  String get equipmentTypeLight => 'Beleuchtung';

  @override
  String get equipmentTypeSound => 'Audio';

  @override
  String get equipmentTypeScreen => 'Leinwand';

  @override
  String get equipmentTypeOther => 'Sonstiges';

  @override
  String get equipmentDetailsTitle => 'Gerät';

  @override
  String get equipmentLoadError => 'Gerät konnte nicht geladen werden';

  @override
  String equipmentUsageWindow(String start, String end) {
    return 'Nutzbar von $start bis $end';
  }

  @override
  String equipmentControllerInfo(String name) {
    return 'Controller: $name';
  }

  @override
  String get equipmentNoControlTitle => 'Nur Ansicht';

  @override
  String get equipmentNoControlMessage =>
      'Bitte eine verantwortliche Person des Raums, dir die Gerätesteuerung freizugeben.';

  @override
  String equipmentLastChange(String name, String date) {
    return 'Zuletzt geändert von $name am $date';
  }

  @override
  String get equipmentCommandOk => 'Befehl vom Gerät bestätigt.';

  @override
  String get equipmentCommandFailed =>
      'Der Controller konnte den Befehl nicht ausführen.';

  @override
  String equipmentCommandFailedReason(String reason) {
    return 'Der Controller konnte den Befehl nicht ausführen: $reason';
  }

  @override
  String get equipmentCommandTimeout =>
      'Der Controller hat nicht geantwortet. Prüfe, ob er eingeschaltet und verbunden ist.';

  @override
  String get equipmentUpdated => 'Gerät aktualisiert.';

  @override
  String get equipmentDeleted => 'Gerät entfernt.';

  @override
  String get equipmentDeleteTitle => 'Gerät entfernen?';

  @override
  String equipmentDeleteMessage(String name) {
    return '„$name“ wird mit seinen Tasten und Zeitplänen entfernt.';
  }

  @override
  String get equipmentErrorForbidden => 'Du darfst dieses Gerät nicht steuern.';

  @override
  String get equipmentErrorNotFound => 'Gerät nicht gefunden.';

  @override
  String get equipmentErrorProtocol =>
      'Wähle eine Klimaanlagenmarke oder erfasse die Originalfernbedienung.';

  @override
  String get equipmentFormNewTitle => 'Neues Gerät';

  @override
  String get equipmentFormEditTitle => 'Gerät bearbeiten';

  @override
  String get equipmentFormSubtitle =>
      'Lege fest, welcher ESP32 das Gerät steuert und wann es genutzt werden darf.';

  @override
  String get equipmentFormNameLabel => 'Name';

  @override
  String get equipmentFormNameHint => 'z. B. Klimaanlage Raum 12';

  @override
  String get equipmentFormTypeLabel => 'Typ';

  @override
  String get equipmentFormControllerLabel => 'Controller (ESP32)';

  @override
  String get equipmentFormControllerHint =>
      'Der ESP32, dessen Infrarot-LED auf das Gerät zeigt.';

  @override
  String get equipmentFormNoControllers =>
      'Lege zuerst einen Controller in diesem Raum an.';

  @override
  String get equipmentFormControllerRequired => 'Wähle den Controller.';

  @override
  String get equipmentFormProtocolTitle => 'Marke der Klimaanlage';

  @override
  String get equipmentFormProtocolHint =>
      'Erfasse ein Signal der Originalfernbedienung, um die Marke zu erkennen, oder wähle sie aus der Liste.';

  @override
  String get equipmentFormLearnButton => 'Von Originalfernbedienung erfassen';

  @override
  String equipmentFormLearned(String protocol) {
    return 'Erkannt: $protocol';
  }

  @override
  String get equipmentFormProtocolLabel => 'Marke / Protokoll';

  @override
  String get equipmentFormProtocolRequired => 'Wähle die Marke des Geräts.';

  @override
  String get equipmentFormModelLabel => 'Modell';

  @override
  String get equipmentFormMinTemperature => 'Min.-Temp.';

  @override
  String get equipmentFormMaxTemperature => 'Max.-Temp.';

  @override
  String get equipmentFormTemperatureInvalid =>
      'Wert zwischen 10 und 35 verwenden.';

  @override
  String get equipmentFormUsageWindow => 'Nutzungszeiten begrenzen';

  @override
  String get equipmentFormUsageWindowHint =>
      'Außerhalb dieser Zeiten dürfen nur Verantwortliche das Gerät nutzen.';

  @override
  String get equipmentFormUsageStart => 'Beginn';

  @override
  String get equipmentFormUsageEnd => 'Ende';

  @override
  String get equipmentFormAutoOff => 'Am Ende ausschalten';

  @override
  String get equipmentFormAutoOffHint =>
      'Ist sie an, wird die Klimaanlage zur Endzeit automatisch ausgeschaltet.';

  @override
  String get equipmentFormActive => 'Gerät aktiv';

  @override
  String get equipmentFormActiveHint =>
      'Inaktive Geräte sind für Mitglieder ausgeblendet.';

  @override
  String get airConditionerOn => 'AN';

  @override
  String get airConditionerOff => 'Aus';

  @override
  String airConditionerAllowedRange(String min, String max) {
    return 'Erlaubte Temperatur: $min° bis $max°';
  }

  @override
  String get airConditionerModeLabel => 'Modus';

  @override
  String get airConditionerFanLabel => 'Lüfter';

  @override
  String get airConditionerSwingLabel => 'Luftrichtung';

  @override
  String get airConditionerModeAuto => 'Auto';

  @override
  String get airConditionerModeCool => 'Kühlen';

  @override
  String get airConditionerModeHeat => 'Heizen';

  @override
  String get airConditionerModeDry => 'Entfeuchten';

  @override
  String get airConditionerModeFan => 'Lüften';

  @override
  String get airConditionerLevelAuto => 'Auto';

  @override
  String get airConditionerLevelOff => 'Aus';

  @override
  String get airConditionerFanMin => 'Minimum';

  @override
  String get airConditionerFanLow => 'Niedrig';

  @override
  String get airConditionerFanMedium => 'Mittel';

  @override
  String get airConditionerFanHigh => 'Hoch';

  @override
  String get airConditionerFanMax => 'Maximum';

  @override
  String get airConditionerSwingLowest => 'Ganz unten';

  @override
  String get airConditionerSwingLow => 'Unten';

  @override
  String get airConditionerSwingMiddle => 'Mitte';

  @override
  String get airConditionerSwingHigh => 'Oben';

  @override
  String get airConditionerSwingHighest => 'Ganz oben';

  @override
  String get airConditionerSwingLeftMax => 'Ganz links';

  @override
  String get airConditionerSwingLeft => 'Links';

  @override
  String get airConditionerSwingRight => 'Rechts';

  @override
  String get airConditionerSwingRightMax => 'Ganz rechts';

  @override
  String get airConditionerSwingWide => 'Breit';

  @override
  String get airConditionerTurbo => 'Turbo';

  @override
  String get airConditionerEcono => 'Eco';

  @override
  String get airConditionerQuiet => 'Leise';

  @override
  String get airConditionerLight => 'Displaylicht';

  @override
  String get buttonsSection => 'Fernbedienungstasten';

  @override
  String get buttonsAddButton => 'Taste aufnehmen';

  @override
  String get buttonsEmpty => 'Keine Tasten aufgenommen';

  @override
  String get buttonsEmptyMessage =>
      'Nimm die Tasten der Originalfernbedienung auf, um sie in der App zu nutzen.';

  @override
  String get buttonCreated => 'Taste aufgenommen.';

  @override
  String get buttonDeleteTitle => 'Taste entfernen?';

  @override
  String buttonDeleteMessage(String name) {
    return 'Die Taste „$name“ wird entfernt.';
  }

  @override
  String get buttonFormNewTitle => 'Neue Taste';

  @override
  String get buttonFormEditTitle => 'Taste bearbeiten';

  @override
  String get buttonFormSubtitle =>
      'Gib dem aufgenommenen Signal einen Namen und ein Symbol.';

  @override
  String get buttonFormNameLabel => 'Name der Taste';

  @override
  String get buttonFormNameHint => 'z. B. Ein/Aus';

  @override
  String get buttonFormIconLabel => 'Symbol';

  @override
  String get schedulesSection => 'Zeitpläne';

  @override
  String get schedulesAddButton => 'Planen';

  @override
  String get schedulesEmpty => 'Keine Zeitpläne';

  @override
  String get schedulesEmptyMessage =>
      'Schalte das Gerät an festen Tagen und Uhrzeiten automatisch ein oder aus.';

  @override
  String get scheduleSaved => 'Zeitplan gespeichert.';

  @override
  String get scheduleDeleteTitle => 'Zeitplan entfernen?';

  @override
  String get scheduleDeleteMessage =>
      'Der Zeitplan wird nicht mehr ausgeführt.';

  @override
  String get scheduleInactive => 'Pausiert';

  @override
  String get scheduleEveryDay => 'Täglich';

  @override
  String get scheduleWeekdays => 'Werktags';

  @override
  String scheduleTurnOnAt(String degrees) {
    return 'Einschalten auf $degrees°';
  }

  @override
  String schedulePress(String name) {
    return '„$name“ drücken';
  }

  @override
  String get scheduleActionTurnOn => 'Einschalten';

  @override
  String get scheduleActionTurnOff => 'Ausschalten';

  @override
  String get scheduleActionPressButton => 'Taste drücken';

  @override
  String get scheduleFormNewTitle => 'Neuer Zeitplan';

  @override
  String get scheduleFormEditTitle => 'Zeitplan bearbeiten';

  @override
  String get scheduleFormSubtitle =>
      'Die Uhrzeit folgt der Zeitzone der Organisation.';

  @override
  String get scheduleFormNameLabel => 'Name (optional)';

  @override
  String get scheduleFormNameHint => 'z. B. Nach Feierabend ausschalten';

  @override
  String get scheduleFormTimeLabel => 'Uhrzeit';

  @override
  String get scheduleFormActionLabel => 'Aktion';

  @override
  String get scheduleFormButtonLabel => 'Taste';

  @override
  String get scheduleFormNoButtons =>
      'Nimm eine Taste für dieses Gerät auf, um sie zu planen.';

  @override
  String scheduleFormTemperature(String degrees) {
    return 'Temperatur: $degrees°';
  }

  @override
  String get scheduleFormActive => 'Zeitplan aktiv';

  @override
  String get scheduleFormDaysRequired => 'Wähle mindestens einen Tag.';

  @override
  String get scheduleFormButtonRequired => 'Wähle die Taste.';

  @override
  String get historySection => 'Befehlsverlauf';

  @override
  String get historyEmpty => 'Noch keine Befehle gesendet.';

  @override
  String historySeeAll(int count) {
    return 'Alle anzeigen ($count)';
  }

  @override
  String get historyAirConditioner => 'Klimaanlagen-Befehl';

  @override
  String get historyButtonPressed => 'Fernbedienungstaste';

  @override
  String get historyLearn => 'Signalaufnahme';

  @override
  String get historySourceManual => 'Manuell';

  @override
  String get historySourceSchedule => 'Zeitplan';

  @override
  String get historySourceAutoOff => 'Automatische Abschaltung';

  @override
  String get learnTitle => 'Signal aufnehmen';

  @override
  String get learnSubtitleAirConditioner =>
      'Richte die Fernbedienung der Klimaanlage auf den ESP32 und drücke die Ein-Taste.';

  @override
  String get learnSubtitleButton =>
      'Richte die Fernbedienung auf den ESP32 und drücke die Taste, die du aufnehmen möchtest.';

  @override
  String get learnStarting => 'Controller wird vorbereitet…';

  @override
  String get learnListening => 'Warte auf das Signal';

  @override
  String learnListeningHint(int seconds) {
    return 'Drücke die Taste auf der Fernbedienung. Noch $seconds s.';
  }

  @override
  String get learnCaptured => 'Signal erfasst';

  @override
  String learnCapturedAirConditioner(String protocol) {
    return 'Klimaanlage erkannt ($protocol).';
  }

  @override
  String learnCapturedButton(String protocol) {
    return '$protocol-Signal aufgenommen.';
  }

  @override
  String get learnUseSignal => 'Dieses Signal verwenden';

  @override
  String get learnCaptureAgain => 'Erneut erfassen';

  @override
  String get learnFailedTitle => 'Aufnahme fehlgeschlagen';

  @override
  String get learnFailed => 'Der Controller hat kein Signal empfangen.';

  @override
  String get learnTimeout =>
      'Kein Signal rechtzeitig empfangen. Halte die Fernbedienung näher an den ESP32 und versuche es erneut.';

  @override
  String learnNotAirConditioner(String protocol) {
    return 'Das Signal ($protocol) stammt nicht von einer unterstützten Klimaanlage. Wähle die Marke aus der Liste.';
  }

  @override
  String get learnErrorNotAirConditioner =>
      'Das erfasste Signal stammt nicht von einer unterstützten Klimaanlage.';

  @override
  String get controllersSection => 'Weitere Controller';

  @override
  String get controllersAddButton => 'Hinzufügen';

  @override
  String get controllersEmpty => 'Keine Controller';

  @override
  String get controllersEmptyMessage =>
      'Füge hier zusätzliche ESP32 hinzu, um Geräte an anderen Stellen im Raum zu steuern. Der ESP32 des Schlosses bleibt auf dem Raumbildschirm.';

  @override
  String get controllersLoadError => 'Controller konnten nicht geladen werden';

  @override
  String get spaceDeviceOtherControllersButton => 'Weitere Controller';

  @override
  String get controllersScreenTitle => 'Controller des Raums';

  @override
  String get controllerNoKeysBadge => 'Keine Schlüssel';

  @override
  String get controllerNeverSeen => 'Nie verbunden';

  @override
  String get controllerSeenNow => 'Jetzt online';

  @override
  String controllerSeenMinutes(int count) {
    return 'Vor $count Min. gesehen';
  }

  @override
  String controllerSeenHours(int count) {
    return 'Vor $count Std. gesehen';
  }

  @override
  String controllerSeenDays(int count) {
    return 'Vor $count T. gesehen';
  }

  @override
  String get controllerRotateKeysAction => 'Neue Schlüssel erzeugen';

  @override
  String get controllerRotateKeysTitle => 'Neue Schlüssel erzeugen?';

  @override
  String controllerRotateKeysMessage(String name) {
    return 'Der ESP32 „$name“ funktioniert erst wieder, wenn er mit den neuen Schlüsseln geflasht wurde.';
  }

  @override
  String get controllerDeleteTitle => 'Controller entfernen?';

  @override
  String controllerDeleteMessage(String name) {
    return '„$name“ wird aus diesem Raum entfernt.';
  }

  @override
  String get controllerDeleted => 'Controller entfernt.';

  @override
  String get controllerUpdated => 'Controller aktualisiert.';

  @override
  String get controllerErrorHasEquipments =>
      'Verschiebe oder entferne zuerst die Geräte dieses Controllers.';

  @override
  String get controllerErrorWithoutKeys =>
      'Erzeuge zuerst die Schlüssel des Controllers.';

  @override
  String get controllerFormNewTitle => 'Neuer Controller';

  @override
  String get controllerFormEditTitle => 'Controller bearbeiten';

  @override
  String get controllerFormSubtitle =>
      'Übertrage nach dem Speichern die erzeugten Schlüssel in die ESP32-Firmware.';

  @override
  String get controllerFormNameLabel => 'Name';

  @override
  String get controllerFormNameHint => 'z. B. ESP32 hinten im Raum';

  @override
  String get controllerFormCreateButton => 'Erstellen und Schlüssel erzeugen';

  @override
  String get provisionFirmwareIdsTitle => 'Kennung in der Firmware';

  @override
  String get provisionFirmwareIdsDesc =>
      'Verwende diese Werte anstelle von <<SPACE_ID>> und <<CONTROLLER_ID>> im ESP32-Code.';

  @override
  String get orgFormTimeZoneLabel => 'Zeitzone';

  @override
  String get orgFormTimeZoneHint =>
      'Wird für Nutzungszeiten und Zeitpläne der Geräte verwendet.';
}
