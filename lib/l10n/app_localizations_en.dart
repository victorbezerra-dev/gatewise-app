// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authTagline => 'The gateway to intelligent environments.';

  @override
  String get authSubtitle =>
      'Connect, automate, and secure any environment, at any scale, intelligently.';

  @override
  String get authLoginButton => 'Sign in with GateWise';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authSignUp => 'Sign up';

  @override
  String authLoginFailed(Object error) {
    return 'Login failed: $error';
  }

  @override
  String get splashTaglinePart1 => 'Connect, automate, and protect.';

  @override
  String get splashTaglinePart2 => 'At any scale';

  @override
  String get splashConnecting => 'Connecting securely';

  @override
  String get splashLoadingText => 'loading';

  @override
  String get navOrgs => 'Orgs';

  @override
  String get navHistory => 'Access';

  @override
  String get navProfile => 'Profile';

  @override
  String wsAccessOpened(String spaceName) {
    return 'Access granted — $spaceName is open!';
  }

  @override
  String wsAccessFailed(String spaceName) {
    return 'An error occurred while opening the lock at $spaceName. Please try again or contact support.';
  }

  @override
  String get wsConnectionError => 'Server connection error.';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileSectionAccount => 'Account details';

  @override
  String get profileLabelName => 'Name';

  @override
  String get profileLabelEmail => 'Email';

  @override
  String get profileLabelRegistration => 'Registration';

  @override
  String get profileSectionDevice => 'Device';

  @override
  String get profileLabelModel => 'Model';

  @override
  String get profileLabelManufacturer => 'Manufacturer';

  @override
  String get profileLabelSystem => 'System';

  @override
  String get profileGuestName => 'GateWise User';

  @override
  String get profileNoEmail => 'No email provided';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileErrorLoad => 'Error loading profile';

  @override
  String get profileRetry => 'Try again';

  @override
  String get profileNotFound => 'User not found';

  @override
  String get profileNotFoundMessage =>
      'Please sign in again to refresh your data.';

  @override
  String get profileSectionLanguage => 'Language';

  @override
  String get profileLanguageDialogTitle => 'Select language';

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
  String get orgsTitle => 'Organizations';

  @override
  String get orgsSubtitle => 'Manage members, invitations, and access.';

  @override
  String get orgsNewButton => 'New organization';

  @override
  String get orgsJoinButton => 'Code';

  @override
  String get orgsMineSection => 'My organizations';

  @override
  String get orgsSection => 'Organizations';

  @override
  String get orgsActiveStatus => 'Active organization';

  @override
  String get orgsInactiveStatus => 'Inactive organization';

  @override
  String orgsMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get orgsNoneFound => 'No organizations found';

  @override
  String get orgsNoneFoundMessage =>
      'Create an organization or join one using an invite code.';

  @override
  String get orgsErrorLoad => 'Error loading organizations';

  @override
  String get orgsCreatedSuccess => 'Organization created successfully.';

  @override
  String orgsJoinedSuccess(String name) {
    return 'You joined $name.';
  }

  @override
  String orgsJoinSpacesAdded(String name) {
    return 'You are already a member of $name, but got access to new space(s).';
  }

  @override
  String get orgsJoinAlreadyInSpaces =>
      'You already have access to the space(s) in this invite.';

  @override
  String get orgsJoinRoleMismatch =>
      'You are already a member of this organization with a different role.';

  @override
  String get orgAddSpaceByCodeButton => 'By code';

  @override
  String get orgAddSpaceWrongOrgError =>
      'This code belongs to a different organization than the one you\'re viewing. Go to the organizations list to enter it.';

  @override
  String get orgAddSpaceSheetTitle => 'Add new space(s)';

  @override
  String get orgAddSpaceSheetSubtitle =>
      'Enter an invite code to gain access to new space(s) in this organization.';

  @override
  String get orgAddSpaceSheetButton => 'Add space(s)';

  @override
  String get orgDetailsTitle => 'Organization';

  @override
  String get orgDetailsErrorLoad => 'Error opening organization';

  @override
  String get orgDetailsNotFound => 'Organization not found';

  @override
  String get orgDetailsNotFoundMessage => 'Could not find the requested data.';

  @override
  String get orgTabSpaces => 'Spaces';

  @override
  String get orgTabMembers => 'Members';

  @override
  String get orgTabInvites => 'Invites';

  @override
  String get orgManageButton => 'Manage';

  @override
  String get orgSpacesSection => 'Organization spaces';

  @override
  String get orgSpacesUnavailable => 'Spaces unavailable';

  @override
  String get orgSpacesUnavailableMessage => 'Could not load spaces.';

  @override
  String get orgSpacesNone => 'No spaces registered';

  @override
  String get orgSpacesNoneMessage => 'Add spaces to control door access.';

  @override
  String get orgMembersUnavailable => 'Members unavailable';

  @override
  String get orgMembersNone => 'No members found';

  @override
  String get orgMembersNoneMessage =>
      'There are no members in this organization yet.';

  @override
  String get orgInvitesSection => 'Invites';

  @override
  String get orgInvitesNewButton => 'New';

  @override
  String get orgInvitesNone => 'No active invites';

  @override
  String get orgInvitesNoneMessage =>
      'Create invites to allow new members to join.';

  @override
  String get orgInvitesUnavailable => 'Invites unavailable';

  @override
  String get orgUpdated => 'Organization updated.';

  @override
  String get orgDeleteTitle => 'Delete organization?';

  @override
  String orgDeleteMessage(String name) {
    return 'This action will remove $name.';
  }

  @override
  String get orgDeleteConfirm => 'Delete';

  @override
  String get orgDeleteSuccess => 'Organization deleted.';

  @override
  String get orgLeaveButton => 'Leave organization';

  @override
  String get orgLeaveTitle => 'Leave organization?';

  @override
  String orgLeaveMessage(String name) {
    return 'Are you sure you want to leave $name? This action cannot be undone.';
  }

  @override
  String get orgLeaveConfirm => 'Leave';

  @override
  String get orgLeaveSuccess => 'You left the organization.';

  @override
  String get orgLeaveOnlyOwnerError =>
      'You are the only owner of this organization. Transfer ownership or delete the organization before leaving.';

  @override
  String get orgRemoveMemberTitle => 'Remove member?';

  @override
  String orgRemoveMemberMessage(String name) {
    return 'Remove $name from the organization?';
  }

  @override
  String get orgRemoveMemberConfirm => 'Remove';

  @override
  String get orgRemoveMemberSuccess => 'Member removed.';

  @override
  String orgChangeRoleTitle(String name) {
    return 'Change role for $name';
  }

  @override
  String get orgChangeRoleSelectSpace => 'Select at least one space';

  @override
  String orgChangeRoleSuccess(String name, String role) {
    return 'Role for $name updated to $role.';
  }

  @override
  String get orgNoSpacesError => 'No spaces found in this organization.';

  @override
  String orgSelectSpaceDialog(String name) {
    return 'Remove $name from which space?';
  }

  @override
  String get orgRemoveFromSpaceTitle => 'Remove space manager?';

  @override
  String orgRemoveFromSpaceMessage(String name, String space) {
    return 'Remove $name as manager of \"$space\"?\n\nIf there are no other accesses or managed spaces, the user will be automatically removed from the organization.';
  }

  @override
  String get orgRemoveFromSpaceConfirm => 'Remove';

  @override
  String orgRemoveFromSpaceSuccess(String name, String space) {
    return '$name removed from \"$space\".';
  }

  @override
  String get orgRevokeInviteTitle => 'Revoke invite?';

  @override
  String orgRevokeInviteMessage(String code) {
    return 'The code $code will no longer work.';
  }

  @override
  String get orgRevokeInviteConfirm => 'Revoke';

  @override
  String get orgRevokeInviteSuccess => 'Invite revoked.';

  @override
  String get orgRemoveSpaceTitle => 'Remove space?';

  @override
  String orgRemoveSpaceMessageLast(String space, String code) {
    return 'Removing \"$space\" will deactivate invite $code.';
  }

  @override
  String get orgRemoveSpaceConfirm => 'Remove';

  @override
  String get orgRemoveSpaceSuccessDeactivated =>
      'Space removed. Invite deactivated.';

  @override
  String orgInviteCreated(String code) {
    return 'Invite $code created and copied.';
  }

  @override
  String get thisSpace => 'this space';

  @override
  String get orgFormNewTitle => 'New organization';

  @override
  String get orgFormEditTitle => 'Edit organization';

  @override
  String get orgFormNewSubtitle =>
      'Set up a new organization to manage members and invitations.';

  @override
  String get orgFormEditSubtitle =>
      'Update your organization\'s details and status.';

  @override
  String get orgFormNameLabel => 'Name';

  @override
  String get orgFormNameHint => 'e.g. GateWise Laboratory';

  @override
  String get orgFormDescLabel => 'Description';

  @override
  String get orgFormDescHint => 'Details about the organization';

  @override
  String get orgFormStatusLabel => 'Organization status';

  @override
  String get orgFormStatusActive => 'Active and available to members.';

  @override
  String get orgFormStatusInactive => 'Temporarily inactive.';

  @override
  String get orgFormSaveButton => 'Save organization';

  @override
  String get joinTitle => 'Join by invite';

  @override
  String get joinCodeLabel => 'Invite code';

  @override
  String get joinCodeHint => 'ABC12345';

  @override
  String get joinButton => 'Join organization';

  @override
  String get inviteFormTitle => 'Create invite';

  @override
  String get inviteFormRoleLabel => 'Role';

  @override
  String get inviteFormExpiresLabel => 'Expires in days';

  @override
  String get inviteFormExpiresHint => 'Empty = no expiration';

  @override
  String get inviteFormMaxUsesLabel => 'Maximum uses';

  @override
  String get inviteFormMaxUsesHint => 'Empty = unlimited';

  @override
  String get inviteFormStartsAtLabel => 'Member access start';

  @override
  String get inviteFormExpiresAtLabel => 'Member access expiration';

  @override
  String get inviteFormSpacesManagerLabel => 'Manager spaces *';

  @override
  String get inviteFormSpacesLabel => 'Spaces *';

  @override
  String get inviteFormGenerateButton => 'Generate invite';

  @override
  String get inviteFormSelectSpaceManager =>
      'Select at least one space for the Manager.';

  @override
  String get inviteFormSelectSpace => 'Select at least one space.';

  @override
  String get inviteFormSpacesLoadError => 'Could not load spaces.';

  @override
  String get inviteFormNoSpaces => 'No spaces registered.';

  @override
  String get inviteFormDateNotSet => 'Not set';

  @override
  String get spacesTitle => 'Spaces';

  @override
  String get spacesHeroPill => 'SPACES';

  @override
  String get spacesHeroTitle => 'Manage your spaces';

  @override
  String get spacesHeroDescOwner =>
      'Monitor doors, register environments, and manage access in a secure, connected interface.';

  @override
  String get spacesHeroDescMember =>
      'View and access the spaces available in your organization.';

  @override
  String get spacesMetricTotal => 'Total';

  @override
  String get spacesMetricActive => 'Active';

  @override
  String get spacesMetricPaused => 'Paused';

  @override
  String get spacesNewButton => 'New space';

  @override
  String get spacesOrgSection => 'Organization spaces';

  @override
  String spacesCountPill(int count) {
    return '$count registered';
  }

  @override
  String get spacesErrorLoad => 'Error loading spaces';

  @override
  String get spacesNone => 'No spaces found';

  @override
  String get spacesNoneMessage =>
      'Create the first space to control door access.';

  @override
  String get spaceDetailsTitle => 'Space';

  @override
  String get spaceDetailsErrorLoad => 'Error opening space';

  @override
  String get spaceDetailsNotFound => 'Space not found';

  @override
  String get spaceDetailsNotFoundMessage =>
      'Could not find the requested data.';

  @override
  String get spaceDeviceSection => 'Device';

  @override
  String get spaceDeviceHardware => 'ESP32 Hardware';

  @override
  String get spaceDeviceDesc => 'Generate RSA keys to flash onto the device.';

  @override
  String get spaceDeviceProvisionButton => 'Provision device';

  @override
  String get spaceDeviceBackendKeyButton => 'Backend public key';

  @override
  String get spaceEsp32TutorialTitle => 'How to configure the ESP32';

  @override
  String get spaceEsp32TutorialScan =>
      'Scan the QR code below to access the firmware repository on GitHub:';

  @override
  String spaceEsp32TutorialIdHint(Object id) {
    return 'The ID of this space is $id — use this value as the device identifier in the firmware.';
  }

  @override
  String get spaceEsp32TutorialKeysHint =>
      'Use the keys downloaded above to complete the device security configuration.';

  @override
  String get spaceGrantsSection => 'Access requests';

  @override
  String get spaceGrantsRequestButton => 'Request';

  @override
  String get spaceGrantsUnavailable => 'Requests unavailable';

  @override
  String get spaceGrantsNone => 'No requests';

  @override
  String get spaceGrantsNoneMessage =>
      'Access requests will appear here for approval.';

  @override
  String get spaceGrantsApproveTitle => 'Approve access?';

  @override
  String spaceGrantsApproveMessage(String name) {
    return 'Authorize $name to access this space?';
  }

  @override
  String get spaceGrantsApproveConfirm => 'Approve';

  @override
  String get spaceGrantsApproveSuccess => 'Access approved.';

  @override
  String get spaceGrantsCannotApprove => 'Could not approve.';

  @override
  String get spaceGrantsRejectTitle => 'Reject access?';

  @override
  String spaceGrantsRejectMessage(String name) {
    return 'Reject $name\'s request?';
  }

  @override
  String get spaceGrantsRejectConfirm => 'Reject';

  @override
  String get spaceGrantsRejectSuccess => 'Access rejected.';

  @override
  String get spaceGrantsCannotReject => 'Could not reject.';

  @override
  String get spaceGrantsDeleteTitle => 'Remove access?';

  @override
  String spaceGrantsDeleteMessage(String name) {
    return 'Remove $name\'s access record?';
  }

  @override
  String spaceGrantsDeleteMessageLast(String name) {
    return 'Remove $name\'s access record?\n\nThis is this user\'s last access in this space. If there are no other organization links, they will be removed automatically.';
  }

  @override
  String get spaceGrantsDeleteConfirm => 'Remove';

  @override
  String get spaceGrantsDeleteSuccess => 'Record removed.';

  @override
  String get spaceGrantsCannotRemove => 'Could not remove.';

  @override
  String get spaceGrantsCannotSend => 'Could not send request.';

  @override
  String get spaceGrantsSentSuccess => 'Request sent successfully.';

  @override
  String get spaceDeleteTitle => 'Delete space?';

  @override
  String spaceDeleteMessage(String name) {
    return 'This action will permanently remove \"$name\".';
  }

  @override
  String get spaceDeleteConfirm => 'Delete';

  @override
  String get spaceDeleteSuccess => 'Space deleted.';

  @override
  String get spaceUpdated => 'Space updated.';

  @override
  String get spaceProvisionTitle => 'Re-provision device?';

  @override
  String spaceProvisionMessage(String name) {
    return 'This will generate new RSA keys for the ESP32 of \"$name\". If a device is already configured, it will be disconnected.';
  }

  @override
  String get spaceProvisionConfirm => 'Continue';

  @override
  String get spaceBackendKeySheetTitle => 'Backend public key';

  @override
  String get spaceBackendKeyError => 'Could not retrieve backend public key.';

  @override
  String get spacePendingMessage => 'Your request is awaiting approval.';

  @override
  String get spacePendingChip => 'PENDING';

  @override
  String get spacePendingButton => 'Awaiting approval';

  @override
  String get spaceRejectedMessage => 'Your access request was rejected.';

  @override
  String get spaceRejectedChip => 'REJECTED';

  @override
  String get spaceRejectedButton => 'Request again';

  @override
  String get spaceNoAccessMessage => 'You don\'t have access to this space.';

  @override
  String get spaceRequestAccessButton => 'Request Access';

  @override
  String get spaceAccessLockedChip => 'No access';

  @override
  String get spaceAccessPendingChip => 'Pending';

  @override
  String get spaceMyAccess => 'My access';

  @override
  String get spaceAuthorizedChip => 'AUTHORIZED';

  @override
  String get spaceAccessInfo =>
      'Module connected to access control. Activate the lock only when you are near the authorized environment.';

  @override
  String get spaceEnterButton => 'Enter space';

  @override
  String get spaceOpenButton => 'Open door';

  @override
  String get spaceOpeningButton => 'Opening door...';

  @override
  String dialogOpeningSpace(String spaceName) {
    return 'Opening $spaceName';
  }

  @override
  String get spaceCommandError => 'Could not send command.';

  @override
  String get spaceOpenError => 'Error opening space.';

  @override
  String get membershipExpiredMessage =>
      'Your access to this organization has expired. Please request a new invite.';

  @override
  String get spaceLoadAccessError => 'Error loading access';

  @override
  String get spaceFormNewTitle => 'New space';

  @override
  String get spaceFormEditTitle => 'Edit space';

  @override
  String get spaceFormNewSubtitle =>
      'Set up a new space to control door access.';

  @override
  String get spaceFormEditSubtitle => 'Update the space\'s details and status.';

  @override
  String get spaceFormNameLabel => 'Name';

  @override
  String get spaceFormNameHint => 'e.g. Lab 66';

  @override
  String get spaceFormDescLabel => 'Description';

  @override
  String get spaceFormDescHint => 'Space details';

  @override
  String get spaceFormStatusLabel => 'Space status';

  @override
  String get spaceFormStatusActive => 'Active and available.';

  @override
  String get spaceFormStatusInactive => 'Temporarily inactive.';

  @override
  String get spaceFormSaveButton => 'Save space';

  @override
  String get requestAccessTitle => 'Request access';

  @override
  String requestAccessSubtitle(String name) {
    return 'Provide the reason for accessing \"$name\".';
  }

  @override
  String get requestAccessReasonLabel => 'Reason';

  @override
  String get requestAccessReasonHint => 'e.g. I need access for project X';

  @override
  String get requestAccessButton => 'Submit request';

  @override
  String get provisionTitle => 'Provision device';

  @override
  String get provisionLoading => 'Generating RSA keys...';

  @override
  String get provisionErrorTitle => 'Provisioning error';

  @override
  String get provisionSuccessTitle => 'Device provisioned';

  @override
  String get provisionSuccessSubtitle =>
      'Download the keys and flash them onto the ESP32.';

  @override
  String get provisionWarningTitle => 'Warning: save the private key now';

  @override
  String get provisionWarningMessage =>
      'The ESP32 private key is not stored on our servers. If you close this screen without saving it, you will need to generate a new key pair and reconfigure the hardware.';

  @override
  String get provisionBackendKeyTitle => 'Backend Public Key';

  @override
  String get provisionBackendKeyDesc =>
      'The ESP32 uses this key to verify that MQTT commands come from the GateWise server. It is the same for all spaces.';

  @override
  String get provisionBackendKeyBadge => 'CAN BE DOWNLOADED AGAIN';

  @override
  String get provisionBackendKeyNote =>
      'This key is public and can be retrieved again at any time from the space settings.';

  @override
  String get provisionDeviceKeyTitle => 'ESP32 Private Key';

  @override
  String get provisionDeviceKeyDesc =>
      'Identifies this device in the system. The ESP32 uses it to sign events sent to the server.';

  @override
  String get provisionDeviceKeyBadge => 'NOT STORED BY US';

  @override
  String get provisionViewMore => 'View more';

  @override
  String get provisionViewLess => 'View less';

  @override
  String get provisionCopyButton => 'Copy';

  @override
  String get provisionCopiedButton => 'Copied!';

  @override
  String get provisionGoToSpaceButton => 'Go to space';

  @override
  String get provisionErrorGenKeys => 'Error generating device keys.';

  @override
  String get keyExportSaveTitle => 'Save to device';

  @override
  String get keyExportSaveDesc => 'Saves the .pem file to local storage';

  @override
  String get keyExportShareTitle => 'Share';

  @override
  String get keyExportShareDesc => 'Opens the system share sheet';

  @override
  String keyExportSaved(String path) {
    return 'Saved to: $path';
  }

  @override
  String keyExportError(Object error) {
    return 'Error: $error';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get accessTitle => 'Access';

  @override
  String get historyNone => 'No access records';

  @override
  String get historyNoneMessage =>
      'When you access an environment, the record will appear here.';

  @override
  String get memberYou => 'You';

  @override
  String get memberUnnamed => 'Unnamed user';

  @override
  String get memberActionChangeRole => 'Change role';

  @override
  String get memberActionRemoveFromSpace => 'Remove from space';

  @override
  String get memberActionRemove => 'Remove member';

  @override
  String get grantUnnamed => 'Unnamed user';

  @override
  String get grantApprove => 'Approve';

  @override
  String get grantReject => 'Reject';

  @override
  String get grantRemove => 'Remove';

  @override
  String get userTypeProfessor => 'Professor';

  @override
  String get userTypeStudent => 'Student';

  @override
  String get userTypeAdmin => 'Administrator';

  @override
  String get userTypeVisitor => 'Visitor';

  @override
  String get userTypeUnknown => 'Not specified';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleMember => 'Member';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Close';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionGenericError =>
      'Could not complete the action. Please try again.';

  @override
  String get dialogSuccessDefault => 'Success!';

  @override
  String get dialogErrorDefault => 'Error opening';

  @override
  String get dialogTimeoutTitle => 'Timeout';

  @override
  String get dialogTimeoutDefault =>
      'The operation timed out. No response was received from GateWise. Check if the lock opened, or try again.';

  @override
  String get noDate => 'no date';

  @override
  String get noDescription => 'No description added.';

  @override
  String get statusActive => 'ACTIVE';

  @override
  String get statusInactive => 'INACTIVE';

  @override
  String get statusActiveFem => 'ACTIVE';

  @override
  String get statusInactiveFem => 'INACTIVE';

  @override
  String get grantStatusPending => 'Pending';

  @override
  String get grantStatusGranted => 'Granted';

  @override
  String get grantStatusRejected => 'Rejected';

  @override
  String get formValidationName => 'Please enter a name.';

  @override
  String get formValidationReason => 'Please enter a reason.';

  @override
  String get equipmentsSection => 'Equipment';

  @override
  String get equipmentsAddButton => 'Add';

  @override
  String get equipmentsEmpty => 'No equipment';

  @override
  String get equipmentsEmptyMessage =>
      'This space has no equipment to control yet.';

  @override
  String get equipmentsEmptyManagerMessage =>
      'Add air conditioners, TVs, projectors and other infrared devices.';

  @override
  String get equipmentsLoadError => 'Could not load the equipment';

  @override
  String equipmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices',
      one: '1 device',
      zero: 'No equipment',
    );
    return '$_temp0';
  }

  @override
  String equipmentsOnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count on',
    );
    return '$_temp0';
  }

  @override
  String get equipmentsEntryManagerHint => 'Tap to add the first one';

  @override
  String get equipmentFormRemoteLabel => 'Remote brand';

  @override
  String get equipmentFormRemoteHint =>
      'The brand\'s standard remote buttons are created automatically.';

  @override
  String equipmentFormRemoteButtons(int count) {
    return '$count buttons will be created automatically';
  }

  @override
  String get equipmentFormRemoteNone => 'None (record the buttons)';

  @override
  String get equipmentFormRemoteRequired => 'Pick the brand';

  @override
  String get remoteTitle => 'Remote control';

  @override
  String get remoteVolumeLabel => 'VOL';

  @override
  String get remoteChannelLabel => 'CH';

  @override
  String get remoteNumbersToggle => 'Number pad';

  @override
  String get remoteOtherButtons => 'Other buttons';

  @override
  String get equipmentInactiveBadge => 'Inactive';

  @override
  String get equipmentTypeAirConditioner => 'Air conditioner';

  @override
  String get equipmentTypeTv => 'TV';

  @override
  String get equipmentTypeProjector => 'Projector';

  @override
  String get equipmentTypeFan => 'Fan';

  @override
  String get equipmentTypeLight => 'Lighting';

  @override
  String get equipmentTypeSound => 'Sound';

  @override
  String get equipmentTypeScreen => 'Screen';

  @override
  String get equipmentTypeOther => 'Other';

  @override
  String get equipmentDetailsTitle => 'Equipment';

  @override
  String get equipmentLoadError => 'Could not load the equipment';

  @override
  String equipmentUsageWindow(String start, String end) {
    return 'Usable from $start to $end';
  }

  @override
  String equipmentControllerInfo(String name) {
    return 'Controller: $name';
  }

  @override
  String get equipmentNoControlTitle => 'View only';

  @override
  String get equipmentNoControlMessage =>
      'Ask a manager of this space to let you control the equipment.';

  @override
  String equipmentLastChange(String name, String date) {
    return 'Last changed by $name on $date';
  }

  @override
  String get equipmentCommandOk => 'Command confirmed by the device.';

  @override
  String get equipmentCommandFailed =>
      'The controller could not run the command.';

  @override
  String equipmentCommandFailedReason(String reason) {
    return 'The controller could not run the command: $reason';
  }

  @override
  String get equipmentCommandTimeout =>
      'The controller did not answer. Check that it is powered and online.';

  @override
  String get equipmentUpdated => 'Equipment updated.';

  @override
  String get equipmentDeleted => 'Equipment removed.';

  @override
  String get equipmentDeleteTitle => 'Remove equipment?';

  @override
  String equipmentDeleteMessage(String name) {
    return '\"$name\" will be removed with its buttons and schedules.';
  }

  @override
  String get equipmentErrorForbidden =>
      'You are not allowed to control this equipment.';

  @override
  String get equipmentErrorNotFound => 'Equipment not found.';

  @override
  String get equipmentErrorProtocol =>
      'Pick an air conditioner brand or capture the original remote.';

  @override
  String get equipmentFormNewTitle => 'New equipment';

  @override
  String get equipmentFormEditTitle => 'Edit equipment';

  @override
  String get equipmentFormSubtitle =>
      'Choose which ESP32 controls the device and when it can be used.';

  @override
  String get equipmentFormNameLabel => 'Name';

  @override
  String get equipmentFormNameHint => 'e.g. Room 12 air conditioner';

  @override
  String get equipmentFormTypeLabel => 'Type';

  @override
  String get equipmentFormControllerLabel => 'Controller (ESP32)';

  @override
  String get equipmentFormControllerHint =>
      'The ESP32 whose infrared LED points at the device.';

  @override
  String get equipmentFormNoControllers =>
      'Add a controller to this space before adding equipment.';

  @override
  String get equipmentFormControllerRequired => 'Choose the controller.';

  @override
  String get equipmentFormProtocolTitle => 'Air conditioner brand';

  @override
  String get equipmentFormProtocolHint =>
      'Capture a signal from the original remote to detect the brand, or pick it from the list.';

  @override
  String get equipmentFormLearnButton => 'Capture from the original remote';

  @override
  String equipmentFormLearned(String protocol) {
    return 'Detected: $protocol';
  }

  @override
  String get equipmentFormProtocolLabel => 'Brand / protocol';

  @override
  String get equipmentFormProtocolRequired => 'Choose the device brand.';

  @override
  String get equipmentFormModelLabel => 'Model';

  @override
  String get equipmentFormMinTemperature => 'Min. temp.';

  @override
  String get equipmentFormMaxTemperature => 'Max. temp.';

  @override
  String get equipmentFormTemperatureInvalid =>
      'Use a value between 10 and 35.';

  @override
  String get equipmentFormUsageWindow => 'Limit usage hours';

  @override
  String get equipmentFormUsageWindowHint =>
      'Outside these hours only managers can use the device.';

  @override
  String get equipmentFormUsageStart => 'Start';

  @override
  String get equipmentFormUsageEnd => 'End';

  @override
  String get equipmentFormAutoOff => 'Turn off at the end';

  @override
  String get equipmentFormAutoOffHint =>
      'If it is on, the air conditioner is turned off automatically at the end time.';

  @override
  String get equipmentFormActive => 'Equipment active';

  @override
  String get equipmentFormActiveHint =>
      'Inactive equipment is hidden from members.';

  @override
  String get airConditionerOn => 'ON';

  @override
  String get airConditionerOff => 'Off';

  @override
  String airConditionerAllowedRange(String min, String max) {
    return 'Allowed temperature: $min° to $max°';
  }

  @override
  String get airConditionerModeLabel => 'Mode';

  @override
  String get airConditionerFanLabel => 'Fan';

  @override
  String get airConditionerSwingLabel => 'Air direction';

  @override
  String get airConditionerModeAuto => 'Auto';

  @override
  String get airConditionerModeCool => 'Cool';

  @override
  String get airConditionerModeHeat => 'Heat';

  @override
  String get airConditionerModeDry => 'Dry';

  @override
  String get airConditionerModeFan => 'Fan';

  @override
  String get airConditionerLevelAuto => 'Auto';

  @override
  String get airConditionerLevelOff => 'Off';

  @override
  String get airConditionerFanMin => 'Minimum';

  @override
  String get airConditionerFanLow => 'Low';

  @override
  String get airConditionerFanMedium => 'Medium';

  @override
  String get airConditionerFanHigh => 'High';

  @override
  String get airConditionerFanMax => 'Maximum';

  @override
  String get airConditionerSwingLowest => 'Lowest';

  @override
  String get airConditionerSwingLow => 'Low';

  @override
  String get airConditionerSwingMiddle => 'Middle';

  @override
  String get airConditionerSwingHigh => 'High';

  @override
  String get airConditionerSwingHighest => 'Highest';

  @override
  String get airConditionerSwingLeftMax => 'Far left';

  @override
  String get airConditionerSwingLeft => 'Left';

  @override
  String get airConditionerSwingRight => 'Right';

  @override
  String get airConditionerSwingRightMax => 'Far right';

  @override
  String get airConditionerSwingWide => 'Wide';

  @override
  String get airConditionerTurbo => 'Turbo';

  @override
  String get airConditionerEcono => 'Eco';

  @override
  String get airConditionerQuiet => 'Quiet';

  @override
  String get airConditionerLight => 'Display light';

  @override
  String get buttonsSection => 'Remote buttons';

  @override
  String get buttonsAddButton => 'Record button';

  @override
  String get buttonsEmpty => 'No buttons recorded';

  @override
  String get buttonsEmptyMessage =>
      'Record the buttons of the original remote to use them in the app.';

  @override
  String get buttonCreated => 'Button recorded.';

  @override
  String get buttonDeleteTitle => 'Remove button?';

  @override
  String buttonDeleteMessage(String name) {
    return 'The button \"$name\" will be removed.';
  }

  @override
  String get buttonFormNewTitle => 'New button';

  @override
  String get buttonFormEditTitle => 'Edit button';

  @override
  String get buttonFormSubtitle =>
      'Give the recorded signal a name and an icon.';

  @override
  String get buttonFormNameLabel => 'Button name';

  @override
  String get buttonFormNameHint => 'e.g. Power';

  @override
  String get buttonFormIconLabel => 'Icon';

  @override
  String get schedulesSection => 'Schedules';

  @override
  String get schedulesAddButton => 'Schedule';

  @override
  String get schedulesEmpty => 'No schedules';

  @override
  String get schedulesEmptyMessage =>
      'Turn the device on or off automatically on fixed days and times.';

  @override
  String get scheduleSaved => 'Schedule saved.';

  @override
  String get scheduleDeleteTitle => 'Remove schedule?';

  @override
  String get scheduleDeleteMessage => 'The schedule will stop running.';

  @override
  String get scheduleInactive => 'Paused';

  @override
  String get scheduleEveryDay => 'Every day';

  @override
  String get scheduleWeekdays => 'Weekdays';

  @override
  String scheduleTurnOnAt(String degrees) {
    return 'Turn on at $degrees°';
  }

  @override
  String schedulePress(String name) {
    return 'Press \"$name\"';
  }

  @override
  String get scheduleActionTurnOn => 'Turn on';

  @override
  String get scheduleActionTurnOff => 'Turn off';

  @override
  String get scheduleActionPressButton => 'Press a button';

  @override
  String get scheduleFormNewTitle => 'New schedule';

  @override
  String get scheduleFormEditTitle => 'Edit schedule';

  @override
  String get scheduleFormSubtitle =>
      'Times follow the organization\'s time zone.';

  @override
  String get scheduleFormNameLabel => 'Name (optional)';

  @override
  String get scheduleFormNameHint => 'e.g. Turn off after hours';

  @override
  String get scheduleFormTimeLabel => 'Time';

  @override
  String get scheduleFormActionLabel => 'Action';

  @override
  String get scheduleFormButtonLabel => 'Button';

  @override
  String get scheduleFormNoButtons =>
      'Record a button on this equipment to schedule it.';

  @override
  String scheduleFormTemperature(String degrees) {
    return 'Temperature: $degrees°';
  }

  @override
  String get scheduleFormActive => 'Schedule active';

  @override
  String get scheduleFormDaysRequired => 'Pick at least one day.';

  @override
  String get scheduleFormButtonRequired => 'Choose the button.';

  @override
  String get historySection => 'Command history';

  @override
  String get historyEmpty => 'No commands sent yet.';

  @override
  String historySeeAll(int count) {
    return 'See all ($count)';
  }

  @override
  String get historyAirConditioner => 'Air conditioner command';

  @override
  String get historyButtonPressed => 'Remote button';

  @override
  String get historyLearn => 'Signal capture';

  @override
  String get historySourceManual => 'Manual';

  @override
  String get historySourceSchedule => 'Schedule';

  @override
  String get historySourceAutoOff => 'Automatic turn-off';

  @override
  String get learnTitle => 'Record signal';

  @override
  String get learnSubtitleAirConditioner =>
      'Point the air conditioner\'s remote at the ESP32 and press the power button.';

  @override
  String get learnSubtitleButton =>
      'Point the remote at the ESP32 and press the button you want to record.';

  @override
  String get learnStarting => 'Preparing the controller…';

  @override
  String get learnListening => 'Waiting for the signal';

  @override
  String learnListeningHint(int seconds) {
    return 'Press the button on the remote. $seconds s left.';
  }

  @override
  String get learnCaptured => 'Signal captured';

  @override
  String learnCapturedAirConditioner(String protocol) {
    return 'Air conditioner detected ($protocol).';
  }

  @override
  String learnCapturedButton(String protocol) {
    return '$protocol signal recorded.';
  }

  @override
  String get learnUseSignal => 'Use this signal';

  @override
  String get learnCaptureAgain => 'Capture again';

  @override
  String get learnFailedTitle => 'Could not record';

  @override
  String get learnFailed => 'The controller did not receive any signal.';

  @override
  String get learnTimeout =>
      'No signal received in time. Bring the remote closer to the ESP32 and try again.';

  @override
  String learnNotAirConditioner(String protocol) {
    return 'The signal ($protocol) is not from a supported air conditioner. Pick the brand from the list.';
  }

  @override
  String get learnErrorNotAirConditioner =>
      'The captured signal is not from a supported air conditioner.';

  @override
  String get controllersSection => 'Other controllers';

  @override
  String get controllersAddButton => 'Add';

  @override
  String get controllersEmpty => 'No controllers';

  @override
  String get controllersEmptyMessage =>
      'Add extra ESP32s here to control equipment elsewhere in the space. The lock ESP32 stays on the space screen.';

  @override
  String get controllersLoadError => 'Could not load the controllers';

  @override
  String get spaceDeviceOtherControllersButton => 'Other controllers';

  @override
  String get controllersScreenTitle => 'Space controllers';

  @override
  String get controllerNoKeysBadge => 'No keys';

  @override
  String get controllerNeverSeen => 'Never connected';

  @override
  String get controllerSeenNow => 'Online now';

  @override
  String controllerSeenMinutes(int count) {
    return 'Seen $count min ago';
  }

  @override
  String controllerSeenHours(int count) {
    return 'Seen $count h ago';
  }

  @override
  String controllerSeenDays(int count) {
    return 'Seen $count d ago';
  }

  @override
  String get controllerRotateKeysAction => 'Generate new keys';

  @override
  String get controllerRotateKeysTitle => 'Generate new keys?';

  @override
  String controllerRotateKeysMessage(String name) {
    return 'The ESP32 \"$name\" stops working until it is flashed with the new keys.';
  }

  @override
  String get controllerDeleteTitle => 'Remove controller?';

  @override
  String controllerDeleteMessage(String name) {
    return '\"$name\" will be removed from this space.';
  }

  @override
  String get controllerDeleted => 'Controller removed.';

  @override
  String get controllerUpdated => 'Controller updated.';

  @override
  String get controllerErrorHasEquipments =>
      'Move or remove the equipment of this controller first.';

  @override
  String get controllerErrorWithoutKeys =>
      'Generate the controller keys first.';

  @override
  String get controllerFormNewTitle => 'New controller';

  @override
  String get controllerFormEditTitle => 'Edit controller';

  @override
  String get controllerFormSubtitle =>
      'After saving, put the generated keys in the ESP32\'s firmware.';

  @override
  String get controllerFormNameLabel => 'Name';

  @override
  String get controllerFormNameHint => 'e.g. ESP32 at the back of the room';

  @override
  String get controllerFormCreateButton => 'Create and generate keys';

  @override
  String get provisionFirmwareIdsTitle => 'Firmware identification';

  @override
  String get provisionFirmwareIdsDesc =>
      'Use these values in place of <<SPACE_ID>> and <<CONTROLLER_ID>> in the ESP32 code.';

  @override
  String get orgFormTimeZoneLabel => 'Time zone';

  @override
  String get orgFormTimeZoneHint =>
      'Used for equipment usage hours and schedules.';
}
