// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get authIotPill => 'Plateforme d\'automatisation IoT';

  @override
  String get authTagline =>
      'La porte d\'entrée vers les environnements intelligents.';

  @override
  String get authSubtitle =>
      'Connectez, automatisez et sécurisez n\'importe quel environnement, à n\'importe quelle échelle, intelligemment.';

  @override
  String get authLoginButton => 'Se connecter avec GateWise';

  @override
  String get authNoAccount => 'Pas encore de compte ?';

  @override
  String get authSignUp => 'S\'inscrire';

  @override
  String authLoginFailed(Object error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get splashTaglinePart1 => 'Connecter, automatiser et protéger.';

  @override
  String get splashTaglinePart2 => 'À toute échelle';

  @override
  String get splashConnecting => 'Connexion sécurisée en cours';

  @override
  String get splashLoadingText => 'chargement';

  @override
  String get navOrgs => 'Orgs';

  @override
  String get navHistory => 'Historique';

  @override
  String get navProfile => 'Profil';

  @override
  String get wsAccessOpened => 'Accès autorisé — Laboratoire ouvert !';

  @override
  String get wsAccessFailed =>
      'Une erreur s\'est produite lors de l\'ouverture du verrou. Réessayez ou contactez le support.';

  @override
  String get wsConnectionError => 'Erreur de connexion au serveur.';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileSectionAccount => 'Données du compte';

  @override
  String get profileLabelName => 'Nom';

  @override
  String get profileLabelEmail => 'E-mail';

  @override
  String get profileLabelRegistration => 'Identifiant';

  @override
  String get profileSectionDevice => 'Appareil';

  @override
  String get profileLabelModel => 'Modèle';

  @override
  String get profileLabelManufacturer => 'Fabricant';

  @override
  String get profileLabelSystem => 'Système';

  @override
  String get profileGuestName => 'Utilisateur GateWise';

  @override
  String get profileNoEmail => 'E-mail non renseigné';

  @override
  String get profileLogout => 'Se déconnecter';

  @override
  String get profileErrorLoad => 'Erreur lors du chargement du profil';

  @override
  String get profileRetry => 'Réessayer';

  @override
  String get profileNotFound => 'Utilisateur introuvable';

  @override
  String get profileNotFoundMessage =>
      'Reconnectez-vous pour actualiser vos données.';

  @override
  String get profileSectionLanguage => 'Langue';

  @override
  String get profileLanguageDialogTitle => 'Choisir la langue';

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
  String get orgsTitle => 'Organisations';

  @override
  String get orgsSubtitle => 'Gérez les membres, les invitations et les accès.';

  @override
  String get orgsNewButton => 'Nouvelle organisation';

  @override
  String get orgsJoinButton => 'Code';

  @override
  String get orgsMineSection => 'Mes organisations';

  @override
  String get orgsSection => 'Organisations';

  @override
  String get orgsActiveStatus => 'Organisation active';

  @override
  String get orgsInactiveStatus => 'Organisation inactive';

  @override
  String orgsMemberSince(String date) {
    return 'Membre depuis le $date';
  }

  @override
  String get orgsNoneFound => 'Aucune organisation trouvée';

  @override
  String get orgsNoneFoundMessage =>
      'Créez une organisation ou rejoignez-en une avec un code d\'invitation.';

  @override
  String get orgsErrorLoad => 'Erreur lors du chargement des organisations';

  @override
  String get orgsCreatedSuccess => 'Organisation créée avec succès.';

  @override
  String orgsJoinedSuccess(String name) {
    return 'Vous avez rejoint $name.';
  }

  @override
  String get orgDetailsTitle => 'Organisation';

  @override
  String get orgDetailsErrorLoad =>
      'Erreur lors de l\'ouverture de l\'organisation';

  @override
  String get orgDetailsNotFound => 'Organisation introuvable';

  @override
  String get orgDetailsNotFoundMessage =>
      'Impossible de localiser les données demandées.';

  @override
  String get orgTabSpaces => 'Espaces';

  @override
  String get orgTabMembers => 'Membres';

  @override
  String get orgTabInvites => 'Invitations';

  @override
  String get orgManageButton => 'Gérer';

  @override
  String get orgSpacesSection => 'Espaces de l\'organisation';

  @override
  String get orgSpacesUnavailable => 'Espaces indisponibles';

  @override
  String get orgSpacesUnavailableMessage =>
      'Impossible de charger les espaces.';

  @override
  String get orgSpacesNone => 'Aucun espace enregistré';

  @override
  String get orgSpacesNoneMessage =>
      'Ajoutez des espaces pour contrôler l\'accès aux portes.';

  @override
  String get orgMembersUnavailable => 'Membres indisponibles';

  @override
  String get orgMembersNone => 'Aucun membre trouvé';

  @override
  String get orgMembersNoneMessage =>
      'Il n\'y a pas encore de membres dans cette organisation.';

  @override
  String get orgInvitesSection => 'Invitations actives';

  @override
  String get orgInvitesNewButton => 'Nouveau';

  @override
  String get orgInvitesNone => 'Aucune invitation active';

  @override
  String get orgInvitesNoneMessage =>
      'Créez des invitations pour permettre à de nouveaux membres de rejoindre l\'organisation.';

  @override
  String get orgInvitesUnavailable => 'Invitations indisponibles';

  @override
  String get orgUpdated => 'Organisation mise à jour.';

  @override
  String get orgDeleteTitle => 'Supprimer l\'organisation ?';

  @override
  String orgDeleteMessage(String name) {
    return 'Cette action supprimera $name.';
  }

  @override
  String get orgDeleteConfirm => 'Supprimer';

  @override
  String get orgDeleteSuccess => 'Organisation supprimée.';

  @override
  String get orgRemoveMemberTitle => 'Retirer le membre ?';

  @override
  String orgRemoveMemberMessage(String name) {
    return 'Retirer $name de l\'organisation ?';
  }

  @override
  String get orgRemoveMemberConfirm => 'Retirer';

  @override
  String get orgRemoveMemberSuccess => 'Membre retiré.';

  @override
  String orgChangeRoleTitle(String name) {
    return 'Modifier le rôle de $name';
  }

  @override
  String get orgChangeRoleSelectSpace => 'Sélectionnez au moins un espace';

  @override
  String orgChangeRoleSuccess(String name, String role) {
    return 'Rôle de $name mis à jour : $role.';
  }

  @override
  String get orgNoSpacesError => 'Aucun espace trouvé dans cette organisation.';

  @override
  String orgSelectSpaceDialog(String name) {
    return 'Retirer $name de quel espace ?';
  }

  @override
  String get orgRemoveFromSpaceTitle =>
      'Retirer l\'administrateur de l\'espace ?';

  @override
  String orgRemoveFromSpaceMessage(String name, String space) {
    return 'Retirer $name en tant qu\'administrateur de « $space » ?\n\nS\'il n\'y a pas d\'autres accès ou espaces gérés, l\'utilisateur sera automatiquement retiré de l\'organisation.';
  }

  @override
  String get orgRemoveFromSpaceConfirm => 'Retirer';

  @override
  String orgRemoveFromSpaceSuccess(String name, String space) {
    return '$name retiré(e) de « $space ».';
  }

  @override
  String get orgRevokeInviteTitle => 'Révoquer l\'invitation ?';

  @override
  String orgRevokeInviteMessage(String code) {
    return 'Le code $code ne fonctionnera plus.';
  }

  @override
  String get orgRevokeInviteConfirm => 'Révoquer';

  @override
  String get orgRevokeInviteSuccess => 'Invitation révoquée.';

  @override
  String get orgRemoveSpaceTitle => 'Retirer l\'espace ?';

  @override
  String orgRemoveSpaceMessageLast(String space, String code) {
    return 'Retirer « $space » désactivera l\'invitation $code.';
  }

  @override
  String orgRemoveSpaceMessage(String space, String code) {
    return 'Retirer « $space » de l\'invitation $code ?';
  }

  @override
  String get orgRemoveSpaceConfirm => 'Retirer';

  @override
  String get orgRemoveSpaceSuccessDeactivated =>
      'Espace retiré. Invitation désactivée.';

  @override
  String get orgRemoveSpaceSuccess => 'Espace retiré.';

  @override
  String orgInviteCreated(String code) {
    return 'Invitation $code créée et copiée.';
  }

  @override
  String get thisSpace => 'cet espace';

  @override
  String get orgFormNewTitle => 'Nouvelle organisation';

  @override
  String get orgFormEditTitle => 'Modifier l\'organisation';

  @override
  String get orgFormNewSubtitle =>
      'Configurez une nouvelle organisation pour gérer membres et invitations.';

  @override
  String get orgFormEditSubtitle =>
      'Mettez à jour les informations et le statut de votre organisation.';

  @override
  String get orgFormNameLabel => 'Nom';

  @override
  String get orgFormNameHint => 'Ex. : Laboratoire GateWise';

  @override
  String get orgFormDescLabel => 'Description';

  @override
  String get orgFormDescHint => 'Détails sur l\'organisation';

  @override
  String get orgFormStatusLabel => 'Statut de l\'organisation';

  @override
  String get orgFormStatusActive => 'Active et disponible pour les membres.';

  @override
  String get orgFormStatusInactive => 'Temporairement inactive.';

  @override
  String get orgFormSaveButton => 'Enregistrer l\'organisation';

  @override
  String get joinTitle => 'Rejoindre par invitation';

  @override
  String get joinCodeLabel => 'Code d\'invitation';

  @override
  String get joinCodeHint => 'ABC12345';

  @override
  String get joinButton => 'Rejoindre l\'organisation';

  @override
  String get inviteFormTitle => 'Créer une invitation';

  @override
  String get inviteFormRoleLabel => 'Rôle';

  @override
  String get inviteFormExpiresLabel => 'Expire dans (jours)';

  @override
  String get inviteFormExpiresHint => 'Vide = sans expiration';

  @override
  String get inviteFormMaxUsesLabel => 'Utilisations maximales';

  @override
  String get inviteFormMaxUsesHint => 'Vide = illimité';

  @override
  String get inviteFormStartsAtLabel => 'Début d\'accès du membre';

  @override
  String get inviteFormExpiresAtLabel => 'Expiration d\'accès du membre';

  @override
  String get inviteFormSpacesManagerLabel => 'Espaces du Manager *';

  @override
  String get inviteFormSpacesLabel => 'Espaces *';

  @override
  String get inviteFormGenerateButton => 'Générer l\'invitation';

  @override
  String get inviteFormSelectSpaceManager =>
      'Sélectionnez au moins un espace pour le Manager.';

  @override
  String get inviteFormSelectSpace => 'Sélectionnez au moins un espace.';

  @override
  String get inviteFormSpacesLoadError => 'Impossible de charger les espaces.';

  @override
  String get inviteFormNoSpaces => 'Aucun espace enregistré.';

  @override
  String get inviteFormDateNotSet => 'Non défini';

  @override
  String get spacesTitle => 'Espaces';

  @override
  String get spacesHeroPill => 'ESPACES';

  @override
  String get spacesHeroTitle => 'Gérez vos espaces';

  @override
  String get spacesHeroDescOwner =>
      'Surveillez les portes, enregistrez les environnements et gérez les accès dans une interface sécurisée et connectée.';

  @override
  String get spacesHeroDescMember =>
      'Visualisez et accédez aux espaces disponibles dans votre organisation.';

  @override
  String get spacesMetricTotal => 'Total';

  @override
  String get spacesMetricActive => 'Actifs';

  @override
  String get spacesMetricPaused => 'En pause';

  @override
  String get spacesNewButton => 'Nouvel espace';

  @override
  String get spacesOrgSection => 'Espaces de l\'organisation';

  @override
  String spacesCountPill(int count) {
    return '$count enregistrés';
  }

  @override
  String get spacesErrorLoad => 'Erreur lors du chargement des espaces';

  @override
  String get spacesNone => 'Aucun espace trouvé';

  @override
  String get spacesNoneMessage =>
      'Créez le premier espace pour contrôler l\'accès aux portes.';

  @override
  String get spaceDetailsTitle => 'Espace';

  @override
  String get spaceDetailsErrorLoad =>
      'Erreur lors de l\'ouverture de l\'espace';

  @override
  String get spaceDetailsNotFound => 'Espace introuvable';

  @override
  String get spaceDetailsNotFoundMessage =>
      'Impossible de localiser les données demandées.';

  @override
  String get spaceDeviceSection => 'Appareil';

  @override
  String get spaceDeviceHardware => 'Matériel ESP32';

  @override
  String get spaceDeviceDesc =>
      'Générez les clés RSA à flasher sur l\'appareil.';

  @override
  String get spaceDeviceProvisionButton => 'Provisionner l\'appareil';

  @override
  String get spaceDeviceBackendKeyButton => 'Clé publique serveur';

  @override
  String get spaceEsp32TutorialTitle => 'Comment configurer l\'ESP32';

  @override
  String get spaceEsp32TutorialScan =>
      'Scannez le QR code ci-dessous pour accéder au dépôt du firmware sur GitHub :';

  @override
  String spaceEsp32TutorialIdHint(Object id) {
    return 'L\'ID de ce space est $id — utilisez cette valeur comme identifiant de l\'appareil dans le firmware.';
  }

  @override
  String get spaceEsp32TutorialKeysHint =>
      'Utilisez les clés téléchargées ci-dessus pour finaliser la configuration de sécurité de l\'appareil.';

  @override
  String get spaceGrantsSection => 'Demandes d\'accès';

  @override
  String get spaceGrantsRequestButton => 'Demander';

  @override
  String get spaceGrantsUnavailable => 'Demandes indisponibles';

  @override
  String get spaceGrantsNone => 'Aucune demande';

  @override
  String get spaceGrantsNoneMessage =>
      'Les demandes d\'accès apparaîtront ici pour approbation.';

  @override
  String get spaceGrantsApproveTitle => 'Approuver l\'accès ?';

  @override
  String spaceGrantsApproveMessage(String name) {
    return 'Autoriser $name à accéder à cet espace ?';
  }

  @override
  String get spaceGrantsApproveConfirm => 'Approuver';

  @override
  String get spaceGrantsApproveSuccess => 'Accès approuvé.';

  @override
  String get spaceGrantsCannotApprove => 'Impossible d\'approuver.';

  @override
  String get spaceGrantsRejectTitle => 'Refuser l\'accès ?';

  @override
  String spaceGrantsRejectMessage(String name) {
    return 'Refuser la demande de $name ?';
  }

  @override
  String get spaceGrantsRejectConfirm => 'Refuser';

  @override
  String get spaceGrantsRejectSuccess => 'Accès refusé.';

  @override
  String get spaceGrantsCannotReject => 'Impossible de refuser.';

  @override
  String get spaceGrantsDeleteTitle => 'Supprimer l\'accès ?';

  @override
  String spaceGrantsDeleteMessage(String name) {
    return 'Supprimer le dossier d\'accès de $name ?';
  }

  @override
  String spaceGrantsDeleteMessageLast(String name) {
    return 'Supprimer le dossier d\'accès de $name ?\n\nC\'est le dernier accès de cet utilisateur dans cet espace. S\'il n\'y a pas d\'autres liens dans l\'organisation, il sera supprimé automatiquement.';
  }

  @override
  String get spaceGrantsDeleteConfirm => 'Supprimer';

  @override
  String get spaceGrantsDeleteSuccess => 'Dossier supprimé.';

  @override
  String get spaceGrantsCannotRemove => 'Impossible de supprimer.';

  @override
  String get spaceGrantsCannotSend => 'Impossible d\'envoyer la demande.';

  @override
  String get spaceGrantsSentSuccess => 'Demande envoyée avec succès.';

  @override
  String get spaceDeleteTitle => 'Supprimer l\'espace ?';

  @override
  String spaceDeleteMessage(String name) {
    return 'Cette action supprimera définitivement « $name ».';
  }

  @override
  String get spaceDeleteConfirm => 'Supprimer';

  @override
  String get spaceDeleteSuccess => 'Espace supprimé.';

  @override
  String get spaceUpdated => 'Espace mis à jour.';

  @override
  String get spaceProvisionTitle => 'Re-provisionner l\'appareil ?';

  @override
  String spaceProvisionMessage(String name) {
    return 'De nouvelles clés RSA seront générées pour l\'ESP32 de « $name ». Si un appareil est déjà configuré, il sera déconnecté.';
  }

  @override
  String get spaceProvisionConfirm => 'Continuer';

  @override
  String get spaceBackendKeySheetTitle => 'Clé publique serveur';

  @override
  String get spaceBackendKeyError =>
      'Impossible de récupérer la clé publique du serveur.';

  @override
  String get spacePendingMessage =>
      'Votre demande est en attente d\'approbation.';

  @override
  String get spacePendingChip => 'EN ATTENTE';

  @override
  String get spacePendingButton => 'En attente d\'approbation';

  @override
  String get spaceRejectedMessage => 'Votre demande d\'accès a été refusée.';

  @override
  String get spaceRejectedChip => 'REFUSÉ';

  @override
  String get spaceRejectedButton => 'Redemander';

  @override
  String get spaceNoAccessMessage => 'Vous n\'avez pas accès à cet espace.';

  @override
  String get spaceRequestAccessButton => 'Demander l\'accès';

  @override
  String get spaceMyAccess => 'Mon accès';

  @override
  String get spaceAuthorizedChip => 'AUTORISÉ';

  @override
  String get spaceAccessInfo =>
      'Module connecté au contrôle d\'accès. Activez le verrou uniquement lorsque vous êtes à proximité de l\'environnement autorisé.';

  @override
  String get spaceEnterButton => 'Entrer dans l\'espace';

  @override
  String get spaceOpeningButton => 'Ouverture en cours...';

  @override
  String get spaceCommandError => 'Impossible d\'envoyer la commande.';

  @override
  String get spaceOpenError => 'Erreur lors de l\'ouverture de l\'espace.';

  @override
  String get spaceLoadAccessError => 'Erreur lors du chargement de l\'accès';

  @override
  String get spaceFormNewTitle => 'Nouvel espace';

  @override
  String get spaceFormEditTitle => 'Modifier l\'espace';

  @override
  String get spaceFormNewSubtitle =>
      'Configurez un nouvel espace pour contrôler l\'accès à la porte.';

  @override
  String get spaceFormEditSubtitle =>
      'Mettez à jour les informations et le statut de l\'espace.';

  @override
  String get spaceFormNameLabel => 'Nom';

  @override
  String get spaceFormNameHint => 'Ex. : Laboratoire 66';

  @override
  String get spaceFormDescLabel => 'Description';

  @override
  String get spaceFormDescHint => 'Détails de l\'espace';

  @override
  String get spaceFormStatusLabel => 'Statut de l\'espace';

  @override
  String get spaceFormStatusActive => 'Actif et disponible.';

  @override
  String get spaceFormStatusInactive => 'Temporairement inactif.';

  @override
  String get spaceFormSaveButton => 'Enregistrer l\'espace';

  @override
  String get requestAccessTitle => 'Demander l\'accès';

  @override
  String requestAccessSubtitle(String name) {
    return 'Indiquez la raison pour accéder à « $name ».';
  }

  @override
  String get requestAccessReasonLabel => 'Motif';

  @override
  String get requestAccessReasonHint =>
      'Ex. : J\'ai besoin d\'accéder pour le projet X';

  @override
  String get requestAccessButton => 'Envoyer la demande';

  @override
  String get provisionTitle => 'Provisionner l\'appareil';

  @override
  String get provisionLoading => 'Génération des clés RSA...';

  @override
  String get provisionErrorTitle => 'Erreur de provisionnement';

  @override
  String get provisionSuccessTitle => 'Appareil provisionné';

  @override
  String get provisionSuccessSubtitle =>
      'Téléchargez les clés et flashez-les sur l\'ESP32.';

  @override
  String get provisionWarningTitle =>
      'Attention : sauvegardez la clé privée maintenant';

  @override
  String get provisionWarningMessage =>
      'La clé privée de l\'ESP32 n\'est pas stockée sur nos serveurs. Si vous fermez cet écran sans la sauvegarder, vous devrez générer une nouvelle paire de clés et reconfigurer le matériel.';

  @override
  String get provisionBackendKeyTitle => 'Clé publique du serveur';

  @override
  String get provisionBackendKeyDesc =>
      'L\'ESP32 utilise cette clé pour vérifier que les commandes MQTT proviennent du serveur GateWise. Elle est identique pour tous les espaces.';

  @override
  String get provisionBackendKeyBadge => 'TÉLÉCHARGEABLE À NOUVEAU';

  @override
  String get provisionBackendKeyNote =>
      'Cette clé est publique et peut être récupérée à tout moment depuis les paramètres de l\'espace.';

  @override
  String get provisionDeviceKeyTitle => 'Clé privée de l\'ESP32';

  @override
  String get provisionDeviceKeyDesc =>
      'Identifie cet appareil dans le système. L\'ESP32 l\'utilise pour signer les événements envoyés au serveur.';

  @override
  String get provisionDeviceKeyBadge => 'NON STOCKÉE PAR NOS SOINS';

  @override
  String get provisionViewMore => 'Voir plus';

  @override
  String get provisionViewLess => 'Voir moins';

  @override
  String get provisionCopyButton => 'Copier';

  @override
  String get provisionCopiedButton => 'Copié !';

  @override
  String get provisionGoToSpaceButton => 'Aller à l\'espace';

  @override
  String get provisionErrorGenKeys =>
      'Erreur lors de la génération des clés de l\'appareil.';

  @override
  String get keyExportSaveTitle => 'Enregistrer sur l\'appareil';

  @override
  String get keyExportSaveDesc =>
      'Enregistre le fichier .pem dans le stockage local';

  @override
  String get keyExportShareTitle => 'Partager';

  @override
  String get keyExportShareDesc => 'Ouvre le menu de partage système';

  @override
  String keyExportSaved(String path) {
    return 'Enregistré dans : $path';
  }

  @override
  String keyExportError(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyNone => 'Aucun accès enregistré';

  @override
  String get historyNoneMessage =>
      'Lorsque vous accéderez à un environnement, l\'entrée apparaîtra ici.';

  @override
  String get memberYou => 'Vous';

  @override
  String get memberUnnamed => 'Utilisateur sans nom';

  @override
  String get memberActionChangeRole => 'Modifier le rôle';

  @override
  String get memberActionRemoveFromSpace => 'Retirer de l\'espace';

  @override
  String get memberActionRemove => 'Retirer le membre';

  @override
  String get grantUnnamed => 'Utilisateur sans nom';

  @override
  String get grantApprove => 'Approuver';

  @override
  String get grantReject => 'Refuser';

  @override
  String get grantRemove => 'Supprimer';

  @override
  String get userTypeProfessor => 'Professeur';

  @override
  String get userTypeStudent => 'Étudiant';

  @override
  String get userTypeAdmin => 'Administrateur';

  @override
  String get userTypeVisitor => 'Visiteur';

  @override
  String get userTypeUnknown => 'Non renseigné';

  @override
  String get roleOwner => 'Propriétaire';

  @override
  String get roleManager => 'Gestionnaire';

  @override
  String get roleMember => 'Membre';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get actionConfirm => 'Confirmer';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get actionGenericError =>
      'Impossible de finaliser l\'action. Veuillez réessayer.';

  @override
  String get noDate => 'sans date';

  @override
  String get formValidationName => 'Veuillez saisir un nom.';

  @override
  String get formValidationReason => 'Veuillez saisir un motif.';
}
