import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];

  /// No description provided for @authIotPill.
  ///
  /// In pt, this message translates to:
  /// **'Plataforma de automação IoT'**
  String get authIotPill;

  /// No description provided for @authTagline.
  ///
  /// In pt, this message translates to:
  /// **'A porta de entrada para ambientes inteligentes.'**
  String get authTagline;

  /// No description provided for @authSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Conecte, automatize e proteja qualquer ambiente, em qualquer escala, de forma inteligente.'**
  String get authSubtitle;

  /// No description provided for @authLoginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com GateWise'**
  String get authLoginButton;

  /// No description provided for @authNoAccount.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não tem cadastro?'**
  String get authNoAccount;

  /// No description provided for @authSignUp.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre-se'**
  String get authSignUp;

  /// No description provided for @authLoginFailed.
  ///
  /// In pt, this message translates to:
  /// **'Falha no login: {error}'**
  String authLoginFailed(Object error);

  /// No description provided for @splashTaglinePart1.
  ///
  /// In pt, this message translates to:
  /// **'Conectar, automatizar e proteger.'**
  String get splashTaglinePart1;

  /// No description provided for @splashTaglinePart2.
  ///
  /// In pt, this message translates to:
  /// **'Em qualquer escala'**
  String get splashTaglinePart2;

  /// No description provided for @splashConnecting.
  ///
  /// In pt, this message translates to:
  /// **'Conectando com segurança'**
  String get splashConnecting;

  /// No description provided for @splashLoadingText.
  ///
  /// In pt, this message translates to:
  /// **'carregando'**
  String get splashLoadingText;

  /// No description provided for @navOrgs.
  ///
  /// In pt, this message translates to:
  /// **'Orgs'**
  String get navOrgs;

  /// No description provided for @navHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @wsAccessOpened.
  ///
  /// In pt, this message translates to:
  /// **'Acesso autorizado, Laboratório Aberto!'**
  String get wsAccessOpened;

  /// No description provided for @wsAccessFailed.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro ao tentar abrir a fechadura, tente novamente ou fale com o suporte!'**
  String get wsAccessFailed;

  /// No description provided for @wsConnectionError.
  ///
  /// In pt, this message translates to:
  /// **'Erro de conexão com o servidor.'**
  String get wsConnectionError;

  /// No description provided for @profileTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meu Perfil'**
  String get profileTitle;

  /// No description provided for @profileSectionAccount.
  ///
  /// In pt, this message translates to:
  /// **'Dados da conta'**
  String get profileSectionAccount;

  /// No description provided for @profileLabelName.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get profileLabelName;

  /// No description provided for @profileLabelEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get profileLabelEmail;

  /// No description provided for @profileLabelRegistration.
  ///
  /// In pt, this message translates to:
  /// **'Matrícula'**
  String get profileLabelRegistration;

  /// No description provided for @profileSectionDevice.
  ///
  /// In pt, this message translates to:
  /// **'Dispositivo'**
  String get profileSectionDevice;

  /// No description provided for @profileLabelModel.
  ///
  /// In pt, this message translates to:
  /// **'Modelo'**
  String get profileLabelModel;

  /// No description provided for @profileLabelManufacturer.
  ///
  /// In pt, this message translates to:
  /// **'Fabricante'**
  String get profileLabelManufacturer;

  /// No description provided for @profileLabelSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get profileLabelSystem;

  /// No description provided for @profileGuestName.
  ///
  /// In pt, this message translates to:
  /// **'Usuário GateWise'**
  String get profileGuestName;

  /// No description provided for @profileNoEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail não informado'**
  String get profileNoEmail;

  /// No description provided for @profileLogout.
  ///
  /// In pt, this message translates to:
  /// **'Sair da conta'**
  String get profileLogout;

  /// No description provided for @profileErrorLoad.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar perfil'**
  String get profileErrorLoad;

  /// No description provided for @profileRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get profileRetry;

  /// No description provided for @profileNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Usuário não encontrado'**
  String get profileNotFound;

  /// No description provided for @profileNotFoundMessage.
  ///
  /// In pt, this message translates to:
  /// **'Faça login novamente para atualizar seus dados.'**
  String get profileNotFoundMessage;

  /// No description provided for @profileSectionLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get profileSectionLanguage;

  /// No description provided for @profileLanguageDialogTitle.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar idioma'**
  String get profileLanguageDialogTitle;

  /// No description provided for @langPt.
  ///
  /// In pt, this message translates to:
  /// **'Português (Brasil)'**
  String get langPt;

  /// No description provided for @langEn.
  ///
  /// In pt, this message translates to:
  /// **'English (US)'**
  String get langEn;

  /// No description provided for @langEs.
  ///
  /// In pt, this message translates to:
  /// **'Español (España)'**
  String get langEs;

  /// No description provided for @langFr.
  ///
  /// In pt, this message translates to:
  /// **'Français (France)'**
  String get langFr;

  /// No description provided for @langDe.
  ///
  /// In pt, this message translates to:
  /// **'Deutsch (Deutschland)'**
  String get langDe;

  /// No description provided for @orgsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Organizações'**
  String get orgsTitle;

  /// No description provided for @orgsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Gerencie membros, convites e acessos.'**
  String get orgsSubtitle;

  /// No description provided for @orgsNewButton.
  ///
  /// In pt, this message translates to:
  /// **'Nova organização'**
  String get orgsNewButton;

  /// No description provided for @orgsJoinButton.
  ///
  /// In pt, this message translates to:
  /// **'Código'**
  String get orgsJoinButton;

  /// No description provided for @orgsMineSection.
  ///
  /// In pt, this message translates to:
  /// **'Minhas organizações'**
  String get orgsMineSection;

  /// No description provided for @orgsSection.
  ///
  /// In pt, this message translates to:
  /// **'Organizações'**
  String get orgsSection;

  /// No description provided for @orgsActiveStatus.
  ///
  /// In pt, this message translates to:
  /// **'Organização ativa'**
  String get orgsActiveStatus;

  /// No description provided for @orgsInactiveStatus.
  ///
  /// In pt, this message translates to:
  /// **'Organização inativa'**
  String get orgsInactiveStatus;

  /// No description provided for @orgsMemberSince.
  ///
  /// In pt, this message translates to:
  /// **'Membro desde {date}'**
  String orgsMemberSince(String date);

  /// No description provided for @orgsNoneFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma organização encontrada'**
  String get orgsNoneFound;

  /// No description provided for @orgsNoneFoundMessage.
  ///
  /// In pt, this message translates to:
  /// **'Crie uma organização ou entre usando um código de convite.'**
  String get orgsNoneFoundMessage;

  /// No description provided for @orgsErrorLoad.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar organizações'**
  String get orgsErrorLoad;

  /// No description provided for @orgsCreatedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Organização criada com sucesso.'**
  String get orgsCreatedSuccess;

  /// No description provided for @orgsJoinedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Você entrou em {name}.'**
  String orgsJoinedSuccess(String name);

  /// No description provided for @orgDetailsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Organização'**
  String get orgDetailsTitle;

  /// No description provided for @orgDetailsErrorLoad.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao abrir organização'**
  String get orgDetailsErrorLoad;

  /// No description provided for @orgDetailsNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Organização não encontrada'**
  String get orgDetailsNotFound;

  /// No description provided for @orgDetailsNotFoundMessage.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível localizar os dados solicitados.'**
  String get orgDetailsNotFoundMessage;

  /// No description provided for @orgTabSpaces.
  ///
  /// In pt, this message translates to:
  /// **'Espaços'**
  String get orgTabSpaces;

  /// No description provided for @orgTabMembers.
  ///
  /// In pt, this message translates to:
  /// **'Membros'**
  String get orgTabMembers;

  /// No description provided for @orgTabInvites.
  ///
  /// In pt, this message translates to:
  /// **'Convites'**
  String get orgTabInvites;

  /// No description provided for @orgManageButton.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar'**
  String get orgManageButton;

  /// No description provided for @orgSpacesSection.
  ///
  /// In pt, this message translates to:
  /// **'Espaços da organização'**
  String get orgSpacesSection;

  /// No description provided for @orgSpacesUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Espaços indisponíveis'**
  String get orgSpacesUnavailable;

  /// No description provided for @orgSpacesUnavailableMessage.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar os espaços.'**
  String get orgSpacesUnavailableMessage;

  /// No description provided for @orgSpacesNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum espaço cadastrado'**
  String get orgSpacesNone;

  /// No description provided for @orgSpacesNoneMessage.
  ///
  /// In pt, this message translates to:
  /// **'Adicione espaços para controlar o acesso às portas.'**
  String get orgSpacesNoneMessage;

  /// No description provided for @orgMembersUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Membros indisponíveis'**
  String get orgMembersUnavailable;

  /// No description provided for @orgMembersNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum membro encontrado'**
  String get orgMembersNone;

  /// No description provided for @orgMembersNoneMessage.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não há membros nesta organização.'**
  String get orgMembersNoneMessage;

  /// No description provided for @orgInvitesSection.
  ///
  /// In pt, this message translates to:
  /// **'Convites ativos'**
  String get orgInvitesSection;

  /// No description provided for @orgInvitesNewButton.
  ///
  /// In pt, this message translates to:
  /// **'Novo'**
  String get orgInvitesNewButton;

  /// No description provided for @orgInvitesNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum convite ativo'**
  String get orgInvitesNone;

  /// No description provided for @orgInvitesNoneMessage.
  ///
  /// In pt, this message translates to:
  /// **'Crie convites para permitir a entrada de novos membros.'**
  String get orgInvitesNoneMessage;

  /// No description provided for @orgInvitesUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Convites indisponíveis'**
  String get orgInvitesUnavailable;

  /// No description provided for @orgUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Organização atualizada.'**
  String get orgUpdated;

  /// No description provided for @orgDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Deletar organização?'**
  String get orgDeleteTitle;

  /// No description provided for @orgDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Esta ação removerá {name}.'**
  String orgDeleteMessage(String name);

  /// No description provided for @orgDeleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Deletar'**
  String get orgDeleteConfirm;

  /// No description provided for @orgDeleteSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Organização deletada.'**
  String get orgDeleteSuccess;

  /// No description provided for @orgRemoveMemberTitle.
  ///
  /// In pt, this message translates to:
  /// **'Remover membro?'**
  String get orgRemoveMemberTitle;

  /// No description provided for @orgRemoveMemberMessage.
  ///
  /// In pt, this message translates to:
  /// **'Remover {name} da organização?'**
  String orgRemoveMemberMessage(String name);

  /// No description provided for @orgRemoveMemberConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get orgRemoveMemberConfirm;

  /// No description provided for @orgRemoveMemberSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Membro removido.'**
  String get orgRemoveMemberSuccess;

  /// No description provided for @orgChangeRoleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Alterar role de {name}'**
  String orgChangeRoleTitle(String name);

  /// No description provided for @orgChangeRoleSelectSpace.
  ///
  /// In pt, this message translates to:
  /// **'Selecione ao menos um espaço'**
  String get orgChangeRoleSelectSpace;

  /// No description provided for @orgChangeRoleSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Role de {name} atualizado para {role}.'**
  String orgChangeRoleSuccess(String name, String role);

  /// No description provided for @orgNoSpacesError.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum espaço encontrado nesta organização.'**
  String get orgNoSpacesError;

  /// No description provided for @orgSelectSpaceDialog.
  ///
  /// In pt, this message translates to:
  /// **'Remover {name} de qual espaço?'**
  String orgSelectSpaceDialog(String name);

  /// No description provided for @orgRemoveFromSpaceTitle.
  ///
  /// In pt, this message translates to:
  /// **'Remover manager do espaço?'**
  String get orgRemoveFromSpaceTitle;

  /// No description provided for @orgRemoveFromSpaceMessage.
  ///
  /// In pt, this message translates to:
  /// **'Remover {name} como manager de \"{space}\"?\n\nSe não houver outros acessos ou espaços gerenciados, o usuário será removido da organização automaticamente.'**
  String orgRemoveFromSpaceMessage(String name, String space);

  /// No description provided for @orgRemoveFromSpaceConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get orgRemoveFromSpaceConfirm;

  /// No description provided for @orgRemoveFromSpaceSuccess.
  ///
  /// In pt, this message translates to:
  /// **'{name} removido de \"{space}\".'**
  String orgRemoveFromSpaceSuccess(String name, String space);

  /// No description provided for @orgRevokeInviteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Revogar convite?'**
  String get orgRevokeInviteTitle;

  /// No description provided for @orgRevokeInviteMessage.
  ///
  /// In pt, this message translates to:
  /// **'O código {code} deixará de funcionar.'**
  String orgRevokeInviteMessage(String code);

  /// No description provided for @orgRevokeInviteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Revogar'**
  String get orgRevokeInviteConfirm;

  /// No description provided for @orgRevokeInviteSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Convite revogado.'**
  String get orgRevokeInviteSuccess;

  /// No description provided for @orgRemoveSpaceTitle.
  ///
  /// In pt, this message translates to:
  /// **'Remover espaço?'**
  String get orgRemoveSpaceTitle;

  /// No description provided for @orgRemoveSpaceMessageLast.
  ///
  /// In pt, this message translates to:
  /// **'Remover \"{space}\" desativará o convite {code}.'**
  String orgRemoveSpaceMessageLast(String space, String code);

  /// No description provided for @orgRemoveSpaceMessage.
  ///
  /// In pt, this message translates to:
  /// **'Remover \"{space}\" do convite {code}?'**
  String orgRemoveSpaceMessage(String space, String code);

  /// No description provided for @orgRemoveSpaceConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get orgRemoveSpaceConfirm;

  /// No description provided for @orgRemoveSpaceSuccessDeactivated.
  ///
  /// In pt, this message translates to:
  /// **'Espaço removido. Convite desativado.'**
  String get orgRemoveSpaceSuccessDeactivated;

  /// No description provided for @orgRemoveSpaceSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Espaço removido.'**
  String get orgRemoveSpaceSuccess;

  /// No description provided for @orgInviteCreated.
  ///
  /// In pt, this message translates to:
  /// **'Convite {code} criado e copiado.'**
  String orgInviteCreated(String code);

  /// No description provided for @thisSpace.
  ///
  /// In pt, this message translates to:
  /// **'este espaço'**
  String get thisSpace;

  /// No description provided for @orgFormNewTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova organização'**
  String get orgFormNewTitle;

  /// No description provided for @orgFormEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar organização'**
  String get orgFormEditTitle;

  /// No description provided for @orgFormNewSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure uma nova organização para gerenciar membros e convites.'**
  String get orgFormNewSubtitle;

  /// No description provided for @orgFormEditSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Atualize os dados e status da sua organização.'**
  String get orgFormEditSubtitle;

  /// No description provided for @orgFormNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get orgFormNameLabel;

  /// No description provided for @orgFormNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Laboratório GateWise'**
  String get orgFormNameHint;

  /// No description provided for @orgFormDescLabel.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get orgFormDescLabel;

  /// No description provided for @orgFormDescHint.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes sobre a organização'**
  String get orgFormDescHint;

  /// No description provided for @orgFormStatusLabel.
  ///
  /// In pt, this message translates to:
  /// **'Status da organização'**
  String get orgFormStatusLabel;

  /// No description provided for @orgFormStatusActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativa e disponível para membros.'**
  String get orgFormStatusActive;

  /// No description provided for @orgFormStatusInactive.
  ///
  /// In pt, this message translates to:
  /// **'Inativa temporariamente.'**
  String get orgFormStatusInactive;

  /// No description provided for @orgFormSaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar organização'**
  String get orgFormSaveButton;

  /// No description provided for @joinTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar por convite'**
  String get joinTitle;

  /// No description provided for @joinCodeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Código do convite'**
  String get joinCodeLabel;

  /// No description provided for @joinCodeHint.
  ///
  /// In pt, this message translates to:
  /// **'ABC12345'**
  String get joinCodeHint;

  /// No description provided for @joinButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar na organização'**
  String get joinButton;

  /// No description provided for @inviteFormTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar convite'**
  String get inviteFormTitle;

  /// No description provided for @inviteFormRoleLabel.
  ///
  /// In pt, this message translates to:
  /// **'Role'**
  String get inviteFormRoleLabel;

  /// No description provided for @inviteFormExpiresLabel.
  ///
  /// In pt, this message translates to:
  /// **'Expira em dias'**
  String get inviteFormExpiresLabel;

  /// No description provided for @inviteFormExpiresHint.
  ///
  /// In pt, this message translates to:
  /// **'Vazio = sem expiração'**
  String get inviteFormExpiresHint;

  /// No description provided for @inviteFormMaxUsesLabel.
  ///
  /// In pt, this message translates to:
  /// **'Máximo de usos'**
  String get inviteFormMaxUsesLabel;

  /// No description provided for @inviteFormMaxUsesHint.
  ///
  /// In pt, this message translates to:
  /// **'Vazio = ilimitado'**
  String get inviteFormMaxUsesHint;

  /// No description provided for @inviteFormStartsAtLabel.
  ///
  /// In pt, this message translates to:
  /// **'Início do acesso do membro'**
  String get inviteFormStartsAtLabel;

  /// No description provided for @inviteFormExpiresAtLabel.
  ///
  /// In pt, this message translates to:
  /// **'Expiração do acesso do membro'**
  String get inviteFormExpiresAtLabel;

  /// No description provided for @inviteFormSpacesManagerLabel.
  ///
  /// In pt, this message translates to:
  /// **'Espaços do Manager *'**
  String get inviteFormSpacesManagerLabel;

  /// No description provided for @inviteFormSpacesLabel.
  ///
  /// In pt, this message translates to:
  /// **'Espaços *'**
  String get inviteFormSpacesLabel;

  /// No description provided for @inviteFormGenerateButton.
  ///
  /// In pt, this message translates to:
  /// **'Gerar convite'**
  String get inviteFormGenerateButton;

  /// No description provided for @inviteFormSelectSpaceManager.
  ///
  /// In pt, this message translates to:
  /// **'Selecione ao menos um espaço para o Manager.'**
  String get inviteFormSelectSpaceManager;

  /// No description provided for @inviteFormSelectSpace.
  ///
  /// In pt, this message translates to:
  /// **'Selecione ao menos um espaço.'**
  String get inviteFormSelectSpace;

  /// No description provided for @inviteFormSpacesLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar os espaços.'**
  String get inviteFormSpacesLoadError;

  /// No description provided for @inviteFormNoSpaces.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum espaço cadastrado.'**
  String get inviteFormNoSpaces;

  /// No description provided for @inviteFormDateNotSet.
  ///
  /// In pt, this message translates to:
  /// **'Não definido'**
  String get inviteFormDateNotSet;

  /// No description provided for @spacesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Espaços'**
  String get spacesTitle;

  /// No description provided for @spacesHeroPill.
  ///
  /// In pt, this message translates to:
  /// **'ESPAÇOS'**
  String get spacesHeroPill;

  /// No description provided for @spacesHeroTitle.
  ///
  /// In pt, this message translates to:
  /// **'Controle seus espaços'**
  String get spacesHeroTitle;

  /// No description provided for @spacesHeroDescOwner.
  ///
  /// In pt, this message translates to:
  /// **'Monitore portas, cadastre ambientes e gerencie acessos em uma interface segura e conectada.'**
  String get spacesHeroDescOwner;

  /// No description provided for @spacesHeroDescMember.
  ///
  /// In pt, this message translates to:
  /// **'Visualize e acesse os espaços disponíveis na sua organização.'**
  String get spacesHeroDescMember;

  /// No description provided for @spacesMetricTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total'**
  String get spacesMetricTotal;

  /// No description provided for @spacesMetricActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativos'**
  String get spacesMetricActive;

  /// No description provided for @spacesMetricPaused.
  ///
  /// In pt, this message translates to:
  /// **'Pausados'**
  String get spacesMetricPaused;

  /// No description provided for @spacesNewButton.
  ///
  /// In pt, this message translates to:
  /// **'Novo espaço'**
  String get spacesNewButton;

  /// No description provided for @spacesOrgSection.
  ///
  /// In pt, this message translates to:
  /// **'Espaços da organização'**
  String get spacesOrgSection;

  /// No description provided for @spacesCountPill.
  ///
  /// In pt, this message translates to:
  /// **'{count} cadastrados'**
  String spacesCountPill(int count);

  /// No description provided for @spacesErrorLoad.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar espaços'**
  String get spacesErrorLoad;

  /// No description provided for @spacesNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum espaço encontrado'**
  String get spacesNone;

  /// No description provided for @spacesNoneMessage.
  ///
  /// In pt, this message translates to:
  /// **'Crie o primeiro espaço para controlar o acesso às portas.'**
  String get spacesNoneMessage;

  /// No description provided for @spaceDetailsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Espaço'**
  String get spaceDetailsTitle;

  /// No description provided for @spaceDetailsErrorLoad.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao abrir espaço'**
  String get spaceDetailsErrorLoad;

  /// No description provided for @spaceDetailsNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Espaço não encontrado'**
  String get spaceDetailsNotFound;

  /// No description provided for @spaceDetailsNotFoundMessage.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível localizar os dados solicitados.'**
  String get spaceDetailsNotFoundMessage;

  /// No description provided for @spaceDeviceSection.
  ///
  /// In pt, this message translates to:
  /// **'Dispositivo'**
  String get spaceDeviceSection;

  /// No description provided for @spaceDeviceHardware.
  ///
  /// In pt, this message translates to:
  /// **'Hardware ESP32'**
  String get spaceDeviceHardware;

  /// No description provided for @spaceDeviceDesc.
  ///
  /// In pt, this message translates to:
  /// **'Gere as chaves RSA para flashar no dispositivo.'**
  String get spaceDeviceDesc;

  /// No description provided for @spaceDeviceProvisionButton.
  ///
  /// In pt, this message translates to:
  /// **'Provisionar dispositivo'**
  String get spaceDeviceProvisionButton;

  /// No description provided for @spaceDeviceBackendKeyButton.
  ///
  /// In pt, this message translates to:
  /// **'Chave pública do backend'**
  String get spaceDeviceBackendKeyButton;

  /// No description provided for @spaceGrantsSection.
  ///
  /// In pt, this message translates to:
  /// **'Solicitações de acesso'**
  String get spaceGrantsSection;

  /// No description provided for @spaceGrantsRequestButton.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar'**
  String get spaceGrantsRequestButton;

  /// No description provided for @spaceGrantsUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Solicitações indisponíveis'**
  String get spaceGrantsUnavailable;

  /// No description provided for @spaceGrantsNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma solicitação'**
  String get spaceGrantsNone;

  /// No description provided for @spaceGrantsNoneMessage.
  ///
  /// In pt, this message translates to:
  /// **'Solicitações de acesso aparecerão aqui para aprovação.'**
  String get spaceGrantsNoneMessage;

  /// No description provided for @spaceGrantsApproveTitle.
  ///
  /// In pt, this message translates to:
  /// **'Aprovar acesso?'**
  String get spaceGrantsApproveTitle;

  /// No description provided for @spaceGrantsApproveMessage.
  ///
  /// In pt, this message translates to:
  /// **'Autorizar {name} a acessar este espaço?'**
  String spaceGrantsApproveMessage(String name);

  /// No description provided for @spaceGrantsApproveConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Aprovar'**
  String get spaceGrantsApproveConfirm;

  /// No description provided for @spaceGrantsApproveSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Acesso aprovado.'**
  String get spaceGrantsApproveSuccess;

  /// No description provided for @spaceGrantsCannotApprove.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível aprovar.'**
  String get spaceGrantsCannotApprove;

  /// No description provided for @spaceGrantsRejectTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitar acesso?'**
  String get spaceGrantsRejectTitle;

  /// No description provided for @spaceGrantsRejectMessage.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitar a solicitação de {name}?'**
  String spaceGrantsRejectMessage(String name);

  /// No description provided for @spaceGrantsRejectConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitar'**
  String get spaceGrantsRejectConfirm;

  /// No description provided for @spaceGrantsRejectSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Acesso rejeitado.'**
  String get spaceGrantsRejectSuccess;

  /// No description provided for @spaceGrantsCannotReject.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível rejeitar.'**
  String get spaceGrantsCannotReject;

  /// No description provided for @spaceGrantsDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Remover acesso?'**
  String get spaceGrantsDeleteTitle;

  /// No description provided for @spaceGrantsDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Remover o registro de acesso de {name}?'**
  String spaceGrantsDeleteMessage(String name);

  /// No description provided for @spaceGrantsDeleteMessageLast.
  ///
  /// In pt, this message translates to:
  /// **'Remover o registro de acesso de {name}?\n\nEste é o último acesso deste usuário neste espaço. Se não houver outros vínculos na organização, ele será removido automaticamente.'**
  String spaceGrantsDeleteMessageLast(String name);

  /// No description provided for @spaceGrantsDeleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get spaceGrantsDeleteConfirm;

  /// No description provided for @spaceGrantsDeleteSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Registro removido.'**
  String get spaceGrantsDeleteSuccess;

  /// No description provided for @spaceGrantsCannotRemove.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível remover.'**
  String get spaceGrantsCannotRemove;

  /// No description provided for @spaceGrantsCannotSend.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível enviar a solicitação.'**
  String get spaceGrantsCannotSend;

  /// No description provided for @spaceGrantsSentSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Solicitação enviada com sucesso.'**
  String get spaceGrantsSentSuccess;

  /// No description provided for @spaceDeleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Deletar espaço?'**
  String get spaceDeleteTitle;

  /// No description provided for @spaceDeleteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Esta ação removerá \"{name}\" permanentemente.'**
  String spaceDeleteMessage(String name);

  /// No description provided for @spaceDeleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Deletar'**
  String get spaceDeleteConfirm;

  /// No description provided for @spaceDeleteSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Espaço deletado.'**
  String get spaceDeleteSuccess;

  /// No description provided for @spaceUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Espaço atualizado.'**
  String get spaceUpdated;

  /// No description provided for @spaceProvisionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Reprovisionar dispositivo?'**
  String get spaceProvisionTitle;

  /// No description provided for @spaceProvisionMessage.
  ///
  /// In pt, this message translates to:
  /// **'Isso irá gerar novas chaves RSA para o ESP32 de \"{name}\". Se já existe um dispositivo configurado, ele será desconectado.'**
  String spaceProvisionMessage(String name);

  /// No description provided for @spaceProvisionConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get spaceProvisionConfirm;

  /// No description provided for @spaceBackendKeySheetTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chave pública do backend'**
  String get spaceBackendKeySheetTitle;

  /// No description provided for @spaceBackendKeyError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível obter a chave pública do backend.'**
  String get spaceBackendKeyError;

  /// No description provided for @spacePendingMessage.
  ///
  /// In pt, this message translates to:
  /// **'Sua solicitação está aguardando aprovação.'**
  String get spacePendingMessage;

  /// No description provided for @spacePendingChip.
  ///
  /// In pt, this message translates to:
  /// **'AGUARDANDO'**
  String get spacePendingChip;

  /// No description provided for @spacePendingButton.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando aprovação'**
  String get spacePendingButton;

  /// No description provided for @spaceRejectedMessage.
  ///
  /// In pt, this message translates to:
  /// **'Sua solicitação de acesso foi rejeitada.'**
  String get spaceRejectedMessage;

  /// No description provided for @spaceRejectedChip.
  ///
  /// In pt, this message translates to:
  /// **'REJEITADO'**
  String get spaceRejectedChip;

  /// No description provided for @spaceRejectedButton.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar novamente'**
  String get spaceRejectedButton;

  /// No description provided for @spaceNoAccessMessage.
  ///
  /// In pt, this message translates to:
  /// **'Você não tem acesso a este espaço.'**
  String get spaceNoAccessMessage;

  /// No description provided for @spaceRequestAccessButton.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar Acesso'**
  String get spaceRequestAccessButton;

  /// No description provided for @spaceMyAccess.
  ///
  /// In pt, this message translates to:
  /// **'Meu acesso'**
  String get spaceMyAccess;

  /// No description provided for @spaceAuthorizedChip.
  ///
  /// In pt, this message translates to:
  /// **'AUTORIZADO'**
  String get spaceAuthorizedChip;

  /// No description provided for @spaceAccessInfo.
  ///
  /// In pt, this message translates to:
  /// **'Módulo conectado ao controle de acesso. Acione a fechadura apenas quando estiver próximo ao ambiente autorizado.'**
  String get spaceAccessInfo;

  /// No description provided for @spaceEnterButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar no espaço'**
  String get spaceEnterButton;

  /// No description provided for @spaceOpeningButton.
  ///
  /// In pt, this message translates to:
  /// **'Abrindo porta...'**
  String get spaceOpeningButton;

  /// No description provided for @spaceCommandError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível enviar o comando.'**
  String get spaceCommandError;

  /// No description provided for @spaceOpenError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao abrir o espaço.'**
  String get spaceOpenError;

  /// No description provided for @spaceLoadAccessError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar acesso'**
  String get spaceLoadAccessError;

  /// No description provided for @spaceFormNewTitle.
  ///
  /// In pt, this message translates to:
  /// **'Novo espaço'**
  String get spaceFormNewTitle;

  /// No description provided for @spaceFormEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar espaço'**
  String get spaceFormEditTitle;

  /// No description provided for @spaceFormNewSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configure um novo espaço para controlar o acesso à porta.'**
  String get spaceFormNewSubtitle;

  /// No description provided for @spaceFormEditSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Atualize os dados e status do espaço.'**
  String get spaceFormEditSubtitle;

  /// No description provided for @spaceFormNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get spaceFormNameLabel;

  /// No description provided for @spaceFormNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Laboratório 66'**
  String get spaceFormNameHint;

  /// No description provided for @spaceFormDescLabel.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get spaceFormDescLabel;

  /// No description provided for @spaceFormDescHint.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes sobre o espaço'**
  String get spaceFormDescHint;

  /// No description provided for @spaceFormStatusLabel.
  ///
  /// In pt, this message translates to:
  /// **'Status do espaço'**
  String get spaceFormStatusLabel;

  /// No description provided for @spaceFormStatusActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativo e disponível.'**
  String get spaceFormStatusActive;

  /// No description provided for @spaceFormStatusInactive.
  ///
  /// In pt, this message translates to:
  /// **'Inativo temporariamente.'**
  String get spaceFormStatusInactive;

  /// No description provided for @spaceFormSaveButton.
  ///
  /// In pt, this message translates to:
  /// **'Salvar espaço'**
  String get spaceFormSaveButton;

  /// No description provided for @requestAccessTitle.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar acesso'**
  String get requestAccessTitle;

  /// No description provided for @requestAccessSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Informe o motivo para acessar \"{name}\".'**
  String requestAccessSubtitle(String name);

  /// No description provided for @requestAccessReasonLabel.
  ///
  /// In pt, this message translates to:
  /// **'Motivo'**
  String get requestAccessReasonLabel;

  /// No description provided for @requestAccessReasonHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Preciso acessar para o projeto X'**
  String get requestAccessReasonHint;

  /// No description provided for @requestAccessButton.
  ///
  /// In pt, this message translates to:
  /// **'Enviar solicitação'**
  String get requestAccessButton;

  /// No description provided for @provisionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Provisionar dispositivo'**
  String get provisionTitle;

  /// No description provided for @provisionLoading.
  ///
  /// In pt, this message translates to:
  /// **'Gerando chaves RSA...'**
  String get provisionLoading;

  /// No description provided for @provisionErrorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao provisionar'**
  String get provisionErrorTitle;

  /// No description provided for @provisionSuccessTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dispositivo provisionado'**
  String get provisionSuccessTitle;

  /// No description provided for @provisionSuccessSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Baixe as chaves e grave no ESP32.'**
  String get provisionSuccessSubtitle;

  /// No description provided for @provisionWarningTitle.
  ///
  /// In pt, this message translates to:
  /// **'Atenção: salve a chave privada agora'**
  String get provisionWarningTitle;

  /// No description provided for @provisionWarningMessage.
  ///
  /// In pt, this message translates to:
  /// **'A chave privada do ESP32 não é armazenada em nossos servidores. Se você fechar esta tela sem salvá-la, precisará gerar um novo par de chaves e reconfigurar o hardware.'**
  String get provisionWarningMessage;

  /// No description provided for @provisionBackendKeyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chave Pública do Backend'**
  String get provisionBackendKeyTitle;

  /// No description provided for @provisionBackendKeyDesc.
  ///
  /// In pt, this message translates to:
  /// **'O ESP32 usa esta chave para verificar se os comandos MQTT vêm do servidor GateWise. É a mesma para todos os espaços.'**
  String get provisionBackendKeyDesc;

  /// No description provided for @provisionBackendKeyBadge.
  ///
  /// In pt, this message translates to:
  /// **'PODE BAIXAR NOVAMENTE'**
  String get provisionBackendKeyBadge;

  /// No description provided for @provisionBackendKeyNote.
  ///
  /// In pt, this message translates to:
  /// **'Esta chave é pública e pode ser obtida novamente a qualquer momento nas configurações do espaço.'**
  String get provisionBackendKeyNote;

  /// No description provided for @provisionDeviceKeyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chave Privada do ESP32'**
  String get provisionDeviceKeyTitle;

  /// No description provided for @provisionDeviceKeyDesc.
  ///
  /// In pt, this message translates to:
  /// **'Identifica este dispositivo no sistema. O ESP32 a usa para assinar os eventos enviados ao servidor.'**
  String get provisionDeviceKeyDesc;

  /// No description provided for @provisionDeviceKeyBadge.
  ///
  /// In pt, this message translates to:
  /// **'NÃO FICA SALVA CONOSCO'**
  String get provisionDeviceKeyBadge;

  /// No description provided for @provisionViewMore.
  ///
  /// In pt, this message translates to:
  /// **'Ver mais'**
  String get provisionViewMore;

  /// No description provided for @provisionViewLess.
  ///
  /// In pt, this message translates to:
  /// **'Ver menos'**
  String get provisionViewLess;

  /// No description provided for @provisionCopyButton.
  ///
  /// In pt, this message translates to:
  /// **'Copiar'**
  String get provisionCopyButton;

  /// No description provided for @provisionCopiedButton.
  ///
  /// In pt, this message translates to:
  /// **'Copiado!'**
  String get provisionCopiedButton;

  /// No description provided for @provisionGoToSpaceButton.
  ///
  /// In pt, this message translates to:
  /// **'Ir para o espaço'**
  String get provisionGoToSpaceButton;

  /// No description provided for @provisionErrorGenKeys.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao gerar chaves do dispositivo.'**
  String get provisionErrorGenKeys;

  /// No description provided for @keyExportSaveTitle.
  ///
  /// In pt, this message translates to:
  /// **'Salvar no dispositivo'**
  String get keyExportSaveTitle;

  /// No description provided for @keyExportSaveDesc.
  ///
  /// In pt, this message translates to:
  /// **'Salva o arquivo .pem no armazenamento local'**
  String get keyExportSaveDesc;

  /// No description provided for @keyExportShareTitle.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get keyExportShareTitle;

  /// No description provided for @keyExportShareDesc.
  ///
  /// In pt, this message translates to:
  /// **'Abre o compartilhamento do sistema'**
  String get keyExportShareDesc;

  /// No description provided for @keyExportSaved.
  ///
  /// In pt, this message translates to:
  /// **'Salvo em: {path}'**
  String keyExportSaved(String path);

  /// No description provided for @keyExportError.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {error}'**
  String keyExportError(Object error);

  /// No description provided for @historyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get historyTitle;

  /// No description provided for @historyNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum acesso registrado'**
  String get historyNone;

  /// No description provided for @historyNoneMessage.
  ///
  /// In pt, this message translates to:
  /// **'Quando você acessar um ambiente, o registro aparecerá aqui.'**
  String get historyNoneMessage;

  /// No description provided for @memberYou.
  ///
  /// In pt, this message translates to:
  /// **'Você'**
  String get memberYou;

  /// No description provided for @memberUnnamed.
  ///
  /// In pt, this message translates to:
  /// **'Usuário sem nome'**
  String get memberUnnamed;

  /// No description provided for @memberActionChangeRole.
  ///
  /// In pt, this message translates to:
  /// **'Alterar role'**
  String get memberActionChangeRole;

  /// No description provided for @memberActionRemoveFromSpace.
  ///
  /// In pt, this message translates to:
  /// **'Remover de espaço'**
  String get memberActionRemoveFromSpace;

  /// No description provided for @memberActionRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover membro'**
  String get memberActionRemove;

  /// No description provided for @grantUnnamed.
  ///
  /// In pt, this message translates to:
  /// **'Usuário sem nome'**
  String get grantUnnamed;

  /// No description provided for @grantApprove.
  ///
  /// In pt, this message translates to:
  /// **'Aprovar'**
  String get grantApprove;

  /// No description provided for @grantReject.
  ///
  /// In pt, this message translates to:
  /// **'Rejeitar'**
  String get grantReject;

  /// No description provided for @grantRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get grantRemove;

  /// No description provided for @userTypeProfessor.
  ///
  /// In pt, this message translates to:
  /// **'Professor'**
  String get userTypeProfessor;

  /// No description provided for @userTypeStudent.
  ///
  /// In pt, this message translates to:
  /// **'Aluno'**
  String get userTypeStudent;

  /// No description provided for @userTypeAdmin.
  ///
  /// In pt, this message translates to:
  /// **'Administrador'**
  String get userTypeAdmin;

  /// No description provided for @userTypeVisitor.
  ///
  /// In pt, this message translates to:
  /// **'Visitante'**
  String get userTypeVisitor;

  /// No description provided for @userTypeUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Não informado'**
  String get userTypeUnknown;

  /// No description provided for @roleOwner.
  ///
  /// In pt, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleManager.
  ///
  /// In pt, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// No description provided for @roleMember.
  ///
  /// In pt, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @actionCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get actionConfirm;

  /// No description provided for @actionRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get actionRetry;

  /// No description provided for @actionGenericError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir a ação. Tente novamente.'**
  String get actionGenericError;

  /// No description provided for @noDate.
  ///
  /// In pt, this message translates to:
  /// **'sem data'**
  String get noDate;

  /// No description provided for @formValidationName.
  ///
  /// In pt, this message translates to:
  /// **'Informe o nome.'**
  String get formValidationName;

  /// No description provided for @formValidationReason.
  ///
  /// In pt, this message translates to:
  /// **'Informe o motivo.'**
  String get formValidationReason;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
