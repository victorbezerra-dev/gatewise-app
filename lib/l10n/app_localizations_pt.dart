// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get authTagline => 'A porta de entrada para ambientes inteligentes.';

  @override
  String get authSubtitle =>
      'Conecte, automatize e proteja qualquer ambiente, em qualquer escala, de forma inteligente.';

  @override
  String get authLoginButton => 'Entrar com GateWise';

  @override
  String get authNoAccount => 'Ainda não tem cadastro?';

  @override
  String get authSignUp => 'Cadastre-se';

  @override
  String authLoginFailed(Object error) {
    return 'Falha no login: $error';
  }

  @override
  String get splashTaglinePart1 => 'Conectar, automatizar e proteger.';

  @override
  String get splashTaglinePart2 => 'Em qualquer escala';

  @override
  String get splashConnecting => 'Conectando com segurança';

  @override
  String get splashLoadingText => 'carregando';

  @override
  String get navOrgs => 'Orgs';

  @override
  String get navHistory => 'Acessos';

  @override
  String get navProfile => 'Perfil';

  @override
  String wsAccessOpened(String spaceName) {
    return 'Acesso autorizado, $spaceName aberto!';
  }

  @override
  String wsAccessFailed(String spaceName) {
    return 'Ocorreu um erro ao tentar abrir a fechadura de $spaceName, tente novamente ou fale com o suporte!';
  }

  @override
  String get wsConnectionError => 'Erro de conexão com o servidor.';

  @override
  String get profileTitle => 'Meu Perfil';

  @override
  String get profileSectionAccount => 'Dados da conta';

  @override
  String get profileLabelName => 'Nome';

  @override
  String get profileLabelEmail => 'E-mail';

  @override
  String get profileLabelRegistration => 'Matrícula';

  @override
  String get profileSectionDevice => 'Dispositivo';

  @override
  String get profileLabelModel => 'Modelo';

  @override
  String get profileLabelManufacturer => 'Fabricante';

  @override
  String get profileLabelSystem => 'Sistema';

  @override
  String get profileGuestName => 'Usuário GateWise';

  @override
  String get profileNoEmail => 'E-mail não informado';

  @override
  String get profileLogout => 'Sair da conta';

  @override
  String get profileErrorLoad => 'Erro ao carregar perfil';

  @override
  String get profileRetry => 'Tentar novamente';

  @override
  String get profileNotFound => 'Usuário não encontrado';

  @override
  String get profileNotFoundMessage =>
      'Faça login novamente para atualizar seus dados.';

  @override
  String get profileSectionLanguage => 'Idioma';

  @override
  String get profileLanguageDialogTitle => 'Selecionar idioma';

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
  String get orgsTitle => 'Organizações';

  @override
  String get orgsSubtitle => 'Gerencie membros, convites e acessos.';

  @override
  String get orgsNewButton => 'Nova organização';

  @override
  String get orgsJoinButton => 'Código';

  @override
  String get orgsMineSection => 'Minhas organizações';

  @override
  String get orgsSection => 'Organizações';

  @override
  String get orgsActiveStatus => 'Organização ativa';

  @override
  String get orgsInactiveStatus => 'Organização inativa';

  @override
  String orgsMemberSince(String date) {
    return 'Membro desde $date';
  }

  @override
  String get orgsNoneFound => 'Nenhuma organização encontrada';

  @override
  String get orgsNoneFoundMessage =>
      'Crie uma organização ou entre usando um código de convite.';

  @override
  String get orgsErrorLoad => 'Erro ao carregar organizações';

  @override
  String get orgsCreatedSuccess => 'Organização criada com sucesso.';

  @override
  String orgsJoinedSuccess(String name) {
    return 'Você entrou em $name.';
  }

  @override
  String orgsJoinSpacesAdded(String name) {
    return 'Você já é membro de $name, mas ganhou acesso a novo(s) espaço(s).';
  }

  @override
  String get orgsJoinAlreadyInSpaces =>
      'Você já tem acesso ao(s) espaço(s) deste convite.';

  @override
  String get orgsJoinRoleMismatch =>
      'Você já é membro desta organização com um papel diferente.';

  @override
  String get orgAddSpaceByCodeButton => 'Por código';

  @override
  String get orgAddSpaceWrongOrgError =>
      'Este código pertence a uma organização diferente da que você está visualizando. Acesse a lista de organizações para entrar nela.';

  @override
  String get orgAddSpaceSheetTitle => 'Adicionar novo(s) espaço(s)';

  @override
  String get orgAddSpaceSheetSubtitle =>
      'Insira um código de convite para ganhar acesso a novo(s) espaço(s) desta organização.';

  @override
  String get orgAddSpaceSheetButton => 'Adicionar espaço(s)';

  @override
  String get orgDetailsTitle => 'Organização';

  @override
  String get orgDetailsErrorLoad => 'Erro ao abrir organização';

  @override
  String get orgDetailsNotFound => 'Organização não encontrada';

  @override
  String get orgDetailsNotFoundMessage =>
      'Não foi possível localizar os dados solicitados.';

  @override
  String get orgTabSpaces => 'Espaços';

  @override
  String get orgTabMembers => 'Membros';

  @override
  String get orgTabInvites => 'Convites';

  @override
  String get orgManageButton => 'Gerenciar';

  @override
  String get orgSpacesSection => 'Espaços da organização';

  @override
  String get orgSpacesUnavailable => 'Espaços indisponíveis';

  @override
  String get orgSpacesUnavailableMessage =>
      'Não foi possível carregar os espaços.';

  @override
  String get orgSpacesNone => 'Nenhum espaço cadastrado';

  @override
  String get orgSpacesNoneMessage =>
      'Adicione espaços para controlar o acesso às portas.';

  @override
  String get orgMembersUnavailable => 'Membros indisponíveis';

  @override
  String get orgMembersNone => 'Nenhum membro encontrado';

  @override
  String get orgMembersNoneMessage => 'Ainda não há membros nesta organização.';

  @override
  String get orgInvitesSection => 'Convites';

  @override
  String get orgInvitesNewButton => 'Novo';

  @override
  String get orgInvitesNone => 'Nenhum convite ativo';

  @override
  String get orgInvitesNoneMessage =>
      'Crie convites para permitir a entrada de novos membros.';

  @override
  String get orgInvitesUnavailable => 'Convites indisponíveis';

  @override
  String get orgUpdated => 'Organização atualizada.';

  @override
  String get orgDeleteTitle => 'Deletar organização?';

  @override
  String orgDeleteMessage(String name) {
    return 'Esta ação removerá $name.';
  }

  @override
  String get orgDeleteConfirm => 'Deletar';

  @override
  String get orgDeleteSuccess => 'Organização deletada.';

  @override
  String get orgLeaveButton => 'Sair da organização';

  @override
  String get orgLeaveTitle => 'Sair da organização?';

  @override
  String orgLeaveMessage(String name) {
    return 'Tem certeza que deseja sair de $name? Esta ação não pode ser desfeita.';
  }

  @override
  String get orgLeaveConfirm => 'Sair';

  @override
  String get orgLeaveSuccess => 'Você saiu da organização.';

  @override
  String get orgLeaveOnlyOwnerError =>
      'Você é o único proprietário desta organização. Transfira a titularidade ou exclua a organização antes de sair.';

  @override
  String get orgRemoveMemberTitle => 'Remover membro?';

  @override
  String orgRemoveMemberMessage(String name) {
    return 'Remover $name da organização?';
  }

  @override
  String get orgRemoveMemberConfirm => 'Remover';

  @override
  String get orgRemoveMemberSuccess => 'Membro removido.';

  @override
  String orgChangeRoleTitle(String name) {
    return 'Alterar role de $name';
  }

  @override
  String get orgChangeRoleSelectSpace => 'Selecione ao menos um espaço';

  @override
  String orgChangeRoleSuccess(String name, String role) {
    return 'Role de $name atualizado para $role.';
  }

  @override
  String get orgNoSpacesError => 'Nenhum espaço encontrado nesta organização.';

  @override
  String orgSelectSpaceDialog(String name) {
    return 'Remover $name de qual espaço?';
  }

  @override
  String get orgRemoveFromSpaceTitle => 'Remover manager do espaço?';

  @override
  String orgRemoveFromSpaceMessage(String name, String space) {
    return 'Remover $name como manager de \"$space\"?\n\nSe não houver outros acessos ou espaços gerenciados, o usuário será removido da organização automaticamente.';
  }

  @override
  String get orgRemoveFromSpaceConfirm => 'Remover';

  @override
  String orgRemoveFromSpaceSuccess(String name, String space) {
    return '$name removido de \"$space\".';
  }

  @override
  String get orgRevokeInviteTitle => 'Revogar convite?';

  @override
  String orgRevokeInviteMessage(String code) {
    return 'O código $code deixará de funcionar.';
  }

  @override
  String get orgRevokeInviteConfirm => 'Revogar';

  @override
  String get orgRevokeInviteSuccess => 'Convite revogado.';

  @override
  String get orgRemoveSpaceTitle => 'Remover espaço?';

  @override
  String orgRemoveSpaceMessageLast(String space, String code) {
    return 'Remover \"$space\" desativará o convite $code.';
  }

  @override
  String get orgRemoveSpaceConfirm => 'Remover';

  @override
  String get orgRemoveSpaceSuccessDeactivated =>
      'Espaço removido. Convite desativado.';

  @override
  String orgInviteCreated(String code) {
    return 'Convite $code criado e copiado.';
  }

  @override
  String get thisSpace => 'este espaço';

  @override
  String get orgFormNewTitle => 'Nova organização';

  @override
  String get orgFormEditTitle => 'Editar organização';

  @override
  String get orgFormNewSubtitle =>
      'Configure uma nova organização para gerenciar membros e convites.';

  @override
  String get orgFormEditSubtitle =>
      'Atualize os dados e status da sua organização.';

  @override
  String get orgFormNameLabel => 'Nome';

  @override
  String get orgFormNameHint => 'Ex: Laboratório GateWise';

  @override
  String get orgFormDescLabel => 'Descrição';

  @override
  String get orgFormDescHint => 'Detalhes sobre a organização';

  @override
  String get orgFormStatusLabel => 'Status da organização';

  @override
  String get orgFormStatusActive => 'Ativa e disponível para membros.';

  @override
  String get orgFormStatusInactive => 'Inativa temporariamente.';

  @override
  String get orgFormSaveButton => 'Salvar organização';

  @override
  String get joinTitle => 'Entrar por convite';

  @override
  String get joinCodeLabel => 'Código do convite';

  @override
  String get joinCodeHint => 'ABC12345';

  @override
  String get joinButton => 'Entrar na organização';

  @override
  String get inviteFormTitle => 'Criar convite';

  @override
  String get inviteFormRoleLabel => 'Role';

  @override
  String get inviteFormExpiresLabel => 'Expira em dias';

  @override
  String get inviteFormExpiresHint => 'Vazio = sem expiração';

  @override
  String get inviteFormMaxUsesLabel => 'Máximo de usos';

  @override
  String get inviteFormMaxUsesHint => 'Vazio = ilimitado';

  @override
  String get inviteFormStartsAtLabel => 'Início do acesso do membro';

  @override
  String get inviteFormExpiresAtLabel => 'Expiração do acesso do membro';

  @override
  String get inviteFormSpacesManagerLabel => 'Espaços do Manager *';

  @override
  String get inviteFormSpacesLabel => 'Espaços *';

  @override
  String get inviteFormGenerateButton => 'Gerar convite';

  @override
  String get inviteFormSelectSpaceManager =>
      'Selecione ao menos um espaço para o Manager.';

  @override
  String get inviteFormSelectSpace => 'Selecione ao menos um espaço.';

  @override
  String get inviteFormSpacesLoadError =>
      'Não foi possível carregar os espaços.';

  @override
  String get inviteFormNoSpaces => 'Nenhum espaço cadastrado.';

  @override
  String get inviteFormDateNotSet => 'Não definido';

  @override
  String get spacesTitle => 'Espaços';

  @override
  String get spacesHeroPill => 'ESPAÇOS';

  @override
  String get spacesHeroTitle => 'Controle seus espaços';

  @override
  String get spacesHeroDescOwner =>
      'Monitore portas, cadastre ambientes e gerencie acessos em uma interface segura e conectada.';

  @override
  String get spacesHeroDescMember =>
      'Visualize e acesse os espaços disponíveis na sua organização.';

  @override
  String get spacesMetricTotal => 'Total';

  @override
  String get spacesMetricActive => 'Ativos';

  @override
  String get spacesMetricPaused => 'Pausados';

  @override
  String get spacesNewButton => 'Novo espaço';

  @override
  String get spacesOrgSection => 'Espaços da organização';

  @override
  String spacesCountPill(int count) {
    return '$count cadastrados';
  }

  @override
  String get spacesErrorLoad => 'Erro ao carregar espaços';

  @override
  String get spacesNone => 'Nenhum espaço encontrado';

  @override
  String get spacesNoneMessage =>
      'Crie o primeiro espaço para controlar o acesso às portas.';

  @override
  String get spaceDetailsTitle => 'Espaço';

  @override
  String get spaceDetailsErrorLoad => 'Erro ao abrir espaço';

  @override
  String get spaceDetailsNotFound => 'Espaço não encontrado';

  @override
  String get spaceDetailsNotFoundMessage =>
      'Não foi possível localizar os dados solicitados.';

  @override
  String get spaceDeviceSection => 'Dispositivo';

  @override
  String get spaceDeviceHardware => 'Hardware ESP32';

  @override
  String get spaceDeviceDesc =>
      'Gere as chaves RSA para flashar no dispositivo.';

  @override
  String get spaceDeviceProvisionButton => 'Provisionar dispositivo';

  @override
  String get spaceDeviceBackendKeyButton => 'Chave pública do backend';

  @override
  String get spaceEsp32TutorialTitle => 'Como configurar o ESP32';

  @override
  String get spaceEsp32TutorialScan =>
      'Escaneie o QR code abaixo para acessar o repositório do firmware no GitHub:';

  @override
  String spaceEsp32TutorialIdHint(Object id) {
    return 'O ID deste space é $id — use esse valor como identificador do dispositivo no firmware.';
  }

  @override
  String get spaceEsp32TutorialKeysHint =>
      'Utilize as chaves baixadas acima para finalizar a configuração de segurança do dispositivo.';

  @override
  String get spaceGrantsSection => 'Solicitações de acesso';

  @override
  String get spaceGrantsRequestButton => 'Solicitar';

  @override
  String get spaceGrantsUnavailable => 'Solicitações indisponíveis';

  @override
  String get spaceGrantsNone => 'Nenhuma solicitação';

  @override
  String get spaceGrantsNoneMessage =>
      'Solicitações de acesso aparecerão aqui para aprovação.';

  @override
  String get spaceGrantsApproveTitle => 'Aprovar acesso?';

  @override
  String spaceGrantsApproveMessage(String name) {
    return 'Autorizar $name a acessar este espaço?';
  }

  @override
  String get spaceGrantsApproveConfirm => 'Aprovar';

  @override
  String get spaceGrantsApproveSuccess => 'Acesso aprovado.';

  @override
  String get spaceGrantsCannotApprove => 'Não foi possível aprovar.';

  @override
  String get spaceGrantsRejectTitle => 'Rejeitar acesso?';

  @override
  String spaceGrantsRejectMessage(String name) {
    return 'Rejeitar a solicitação de $name?';
  }

  @override
  String get spaceGrantsRejectConfirm => 'Rejeitar';

  @override
  String get spaceGrantsRejectSuccess => 'Acesso rejeitado.';

  @override
  String get spaceGrantsCannotReject => 'Não foi possível rejeitar.';

  @override
  String get spaceGrantsDeleteTitle => 'Remover acesso?';

  @override
  String spaceGrantsDeleteMessage(String name) {
    return 'Remover o registro de acesso de $name?';
  }

  @override
  String spaceGrantsDeleteMessageLast(String name) {
    return 'Remover o registro de acesso de $name?\n\nEste é o último acesso deste usuário neste espaço. Se não houver outros vínculos na organização, ele será removido automaticamente.';
  }

  @override
  String get spaceGrantsDeleteConfirm => 'Remover';

  @override
  String get spaceGrantsDeleteSuccess => 'Registro removido.';

  @override
  String get spaceGrantsCannotRemove => 'Não foi possível remover.';

  @override
  String get spaceGrantsCannotSend => 'Não foi possível enviar a solicitação.';

  @override
  String get spaceGrantsSentSuccess => 'Solicitação enviada com sucesso.';

  @override
  String get spaceDeleteTitle => 'Deletar espaço?';

  @override
  String spaceDeleteMessage(String name) {
    return 'Esta ação removerá \"$name\" permanentemente.';
  }

  @override
  String get spaceDeleteConfirm => 'Deletar';

  @override
  String get spaceDeleteSuccess => 'Espaço deletado.';

  @override
  String get spaceUpdated => 'Espaço atualizado.';

  @override
  String get spaceProvisionTitle => 'Reprovisionar dispositivo?';

  @override
  String spaceProvisionMessage(String name) {
    return 'Isso irá gerar novas chaves RSA para o ESP32 de \"$name\". Se já existe um dispositivo configurado, ele será desconectado.';
  }

  @override
  String get spaceProvisionConfirm => 'Continuar';

  @override
  String get spaceBackendKeySheetTitle => 'Chave pública do backend';

  @override
  String get spaceBackendKeyError =>
      'Não foi possível obter a chave pública do backend.';

  @override
  String get spacePendingMessage =>
      'Sua solicitação está aguardando aprovação.';

  @override
  String get spacePendingChip => 'AGUARDANDO';

  @override
  String get spacePendingButton => 'Aguardando aprovação';

  @override
  String get spaceRejectedMessage => 'Sua solicitação de acesso foi rejeitada.';

  @override
  String get spaceRejectedChip => 'REJEITADO';

  @override
  String get spaceRejectedButton => 'Solicitar novamente';

  @override
  String get spaceNoAccessMessage => 'Você não tem acesso a este espaço.';

  @override
  String get spaceRequestAccessButton => 'Solicitar Acesso';

  @override
  String get spaceAccessLockedChip => 'Sem acesso';

  @override
  String get spaceAccessPendingChip => 'Aguardando';

  @override
  String get spaceMyAccess => 'Meu acesso';

  @override
  String get spaceAuthorizedChip => 'AUTORIZADO';

  @override
  String get spaceAccessInfo =>
      'Módulo conectado ao controle de acesso. Acione a fechadura apenas quando estiver próximo ao ambiente autorizado.';

  @override
  String get spaceEnterButton => 'Entrar no espaço';

  @override
  String get spaceOpenButton => 'Abrir porta';

  @override
  String get spaceOpeningButton => 'Abrindo porta...';

  @override
  String dialogOpeningSpace(String spaceName) {
    return 'Abrindo $spaceName';
  }

  @override
  String get spaceCommandError => 'Não foi possível enviar o comando.';

  @override
  String get spaceOpenError => 'Erro ao abrir o espaço.';

  @override
  String get membershipExpiredMessage =>
      'Seu acesso a esta organização expirou. Solicite um novo convite.';

  @override
  String get spaceLoadAccessError => 'Erro ao carregar acesso';

  @override
  String get spaceFormNewTitle => 'Novo espaço';

  @override
  String get spaceFormEditTitle => 'Editar espaço';

  @override
  String get spaceFormNewSubtitle =>
      'Configure um novo espaço para controlar o acesso à porta.';

  @override
  String get spaceFormEditSubtitle => 'Atualize os dados e status do espaço.';

  @override
  String get spaceFormNameLabel => 'Nome';

  @override
  String get spaceFormNameHint => 'Ex: Laboratório 66';

  @override
  String get spaceFormDescLabel => 'Descrição';

  @override
  String get spaceFormDescHint => 'Detalhes sobre o espaço';

  @override
  String get spaceFormStatusLabel => 'Status do espaço';

  @override
  String get spaceFormStatusActive => 'Ativo e disponível.';

  @override
  String get spaceFormStatusInactive => 'Inativo temporariamente.';

  @override
  String get spaceFormSaveButton => 'Salvar espaço';

  @override
  String get requestAccessTitle => 'Solicitar acesso';

  @override
  String requestAccessSubtitle(String name) {
    return 'Informe o motivo para acessar \"$name\".';
  }

  @override
  String get requestAccessReasonLabel => 'Motivo';

  @override
  String get requestAccessReasonHint => 'Ex: Preciso acessar para o projeto X';

  @override
  String get requestAccessButton => 'Enviar solicitação';

  @override
  String get provisionTitle => 'Provisionar dispositivo';

  @override
  String get provisionLoading => 'Gerando chaves RSA...';

  @override
  String get provisionErrorTitle => 'Erro ao provisionar';

  @override
  String get provisionSuccessTitle => 'Dispositivo provisionado';

  @override
  String get provisionSuccessSubtitle => 'Baixe as chaves e grave no ESP32.';

  @override
  String get provisionWarningTitle => 'Atenção: salve a chave privada agora';

  @override
  String get provisionWarningMessage =>
      'A chave privada do ESP32 não é armazenada em nossos servidores. Se você fechar esta tela sem salvá-la, precisará gerar um novo par de chaves e reconfigurar o hardware.';

  @override
  String get provisionBackendKeyTitle => 'Chave Pública do Backend';

  @override
  String get provisionBackendKeyDesc =>
      'O ESP32 usa esta chave para verificar se os comandos MQTT vêm do servidor GateWise. É a mesma para todos os espaços.';

  @override
  String get provisionBackendKeyBadge => 'PODE BAIXAR NOVAMENTE';

  @override
  String get provisionBackendKeyNote =>
      'Esta chave é pública e pode ser obtida novamente a qualquer momento nas configurações do espaço.';

  @override
  String get provisionDeviceKeyTitle => 'Chave Privada do ESP32';

  @override
  String get provisionDeviceKeyDesc =>
      'Identifica este dispositivo no sistema. O ESP32 a usa para assinar os eventos enviados ao servidor.';

  @override
  String get provisionDeviceKeyBadge => 'NÃO FICA SALVA CONOSCO';

  @override
  String get provisionViewMore => 'Ver mais';

  @override
  String get provisionViewLess => 'Ver menos';

  @override
  String get provisionCopyButton => 'Copiar';

  @override
  String get provisionCopiedButton => 'Copiado!';

  @override
  String get provisionGoToSpaceButton => 'Ir para o espaço';

  @override
  String get provisionErrorGenKeys => 'Erro ao gerar chaves do dispositivo.';

  @override
  String get keyExportSaveTitle => 'Salvar no dispositivo';

  @override
  String get keyExportSaveDesc => 'Salva o arquivo .pem no armazenamento local';

  @override
  String get keyExportShareTitle => 'Compartilhar';

  @override
  String get keyExportShareDesc => 'Abre o compartilhamento do sistema';

  @override
  String keyExportSaved(String path) {
    return 'Salvo em: $path';
  }

  @override
  String keyExportError(Object error) {
    return 'Erro: $error';
  }

  @override
  String get historyTitle => 'Histórico';

  @override
  String get accessTitle => 'Acessos';

  @override
  String get historyNone => 'Nenhum acesso registrado';

  @override
  String get historyNoneMessage =>
      'Quando você acessar um ambiente, o registro aparecerá aqui.';

  @override
  String get memberYou => 'Você';

  @override
  String get memberUnnamed => 'Usuário sem nome';

  @override
  String get memberActionChangeRole => 'Alterar role';

  @override
  String get memberActionRemoveFromSpace => 'Remover de espaço';

  @override
  String get memberActionRemove => 'Remover membro';

  @override
  String get grantUnnamed => 'Usuário sem nome';

  @override
  String get grantApprove => 'Aprovar';

  @override
  String get grantReject => 'Rejeitar';

  @override
  String get grantRemove => 'Remover';

  @override
  String get userTypeProfessor => 'Professor';

  @override
  String get userTypeStudent => 'Aluno';

  @override
  String get userTypeAdmin => 'Administrador';

  @override
  String get userTypeVisitor => 'Visitante';

  @override
  String get userTypeUnknown => 'Não informado';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleMember => 'Member';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionRetry => 'Tentar novamente';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDelete => 'Deletar';

  @override
  String get actionGenericError =>
      'Não foi possível concluir a ação. Tente novamente.';

  @override
  String get dialogSuccessDefault => 'Sucesso!';

  @override
  String get dialogErrorDefault => 'Erro ao abrir';

  @override
  String get dialogTimeoutTitle => 'Tempo excedido';

  @override
  String get dialogTimeoutDefault =>
      'A operação excedeu o tempo limite. Não obtive resposta do GateWise. Verifique se a fechadura abriu, ou tente novamente.';

  @override
  String get noDate => 'sem data';

  @override
  String get noDescription => 'Sem descrição cadastrada.';

  @override
  String get statusActive => 'ATIVO';

  @override
  String get statusInactive => 'INATIVO';

  @override
  String get statusActiveFem => 'ATIVA';

  @override
  String get statusInactiveFem => 'INATIVA';

  @override
  String get grantStatusPending => 'Pendente';

  @override
  String get grantStatusGranted => 'Autorizado';

  @override
  String get grantStatusRejected => 'Rejeitado';

  @override
  String get formValidationName => 'Informe o nome.';

  @override
  String get formValidationReason => 'Informe o motivo.';

  @override
  String get equipmentsSection => 'Equipamentos';

  @override
  String get equipmentsAddButton => 'Adicionar';

  @override
  String get equipmentsEmpty => 'Nenhum equipamento';

  @override
  String get equipmentsEmptyMessage =>
      'Este espaço ainda não tem equipamentos para controlar.';

  @override
  String get equipmentsEmptyManagerMessage =>
      'Cadastre ar-condicionado, TV, projetor e outros aparelhos controlados por infravermelho.';

  @override
  String get equipmentsLoadError => 'Não foi possível carregar os equipamentos';

  @override
  String equipmentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count equipamentos',
      one: '1 equipamento',
      zero: 'Nenhum equipamento',
    );
    return '$_temp0';
  }

  @override
  String equipmentsOnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ligados',
      one: '1 ligado',
    );
    return '$_temp0';
  }

  @override
  String get equipmentsEntryManagerHint => 'Toque para cadastrar o primeiro';

  @override
  String get equipmentFormRemoteLabel => 'Marca do controle';

  @override
  String get equipmentFormRemoteHint =>
      'Os botões do controle original da marca são criados automaticamente.';

  @override
  String equipmentFormRemoteButtons(int count) {
    return '$count botões serão criados automaticamente';
  }

  @override
  String get equipmentFormRemoteNone => 'Nenhuma (gravar os botões)';

  @override
  String get equipmentFormRemoteRequired => 'Escolha a marca';

  @override
  String get remoteTitle => 'Controle remoto';

  @override
  String get remoteVolumeLabel => 'VOL';

  @override
  String get remoteChannelLabel => 'CANAL';

  @override
  String get remoteNumbersToggle => 'Teclado numérico';

  @override
  String get remoteOtherButtons => 'Outros botões';

  @override
  String get equipmentInactiveBadge => 'Inativo';

  @override
  String get equipmentTypeAirConditioner => 'Ar-condicionado';

  @override
  String get equipmentTypeTv => 'TV';

  @override
  String get equipmentTypeProjector => 'Projetor';

  @override
  String get equipmentTypeFan => 'Ventilador';

  @override
  String get equipmentTypeLight => 'Iluminação';

  @override
  String get equipmentTypeSound => 'Som';

  @override
  String get equipmentTypeScreen => 'Tela';

  @override
  String get equipmentTypeOther => 'Outro';

  @override
  String get equipmentDetailsTitle => 'Equipamento';

  @override
  String get equipmentLoadError => 'Não foi possível carregar o equipamento';

  @override
  String equipmentUsageWindow(String start, String end) {
    return 'Uso das $start às $end';
  }

  @override
  String equipmentControllerInfo(String name) {
    return 'Controlador: $name';
  }

  @override
  String get equipmentNoControlTitle => 'Somente visualização';

  @override
  String get equipmentNoControlMessage =>
      'Peça a um gestor do espaço para liberar o controle dos equipamentos para você.';

  @override
  String equipmentLastChange(String name, String date) {
    return 'Última alteração por $name em $date';
  }

  @override
  String get equipmentCommandOk => 'Comando confirmado pelo equipamento.';

  @override
  String get equipmentCommandFailed =>
      'O controlador não conseguiu executar o comando.';

  @override
  String equipmentCommandFailedReason(String reason) {
    return 'O controlador não conseguiu executar o comando: $reason';
  }

  @override
  String get equipmentCommandTimeout =>
      'O controlador não respondeu. Verifique se ele está ligado e conectado.';

  @override
  String get equipmentUpdated => 'Equipamento atualizado.';

  @override
  String get equipmentDeleted => 'Equipamento removido.';

  @override
  String get equipmentDeleteTitle => 'Remover equipamento?';

  @override
  String equipmentDeleteMessage(String name) {
    return '\"$name\" será removido junto com seus botões e agendamentos.';
  }

  @override
  String get equipmentErrorForbidden =>
      'Você não tem permissão para controlar este equipamento.';

  @override
  String get equipmentErrorNotFound => 'Equipamento não encontrado.';

  @override
  String get equipmentErrorProtocol =>
      'Escolha uma marca de ar-condicionado ou capture o controle original.';

  @override
  String get equipmentFormNewTitle => 'Novo equipamento';

  @override
  String get equipmentFormEditTitle => 'Editar equipamento';

  @override
  String get equipmentFormSubtitle =>
      'Defina qual ESP32 controla o aparelho e quando ele pode ser usado.';

  @override
  String get equipmentFormNameLabel => 'Nome';

  @override
  String get equipmentFormNameHint => 'Ex.: Ar da sala 12';

  @override
  String get equipmentFormTypeLabel => 'Tipo';

  @override
  String get equipmentFormControllerLabel => 'Controlador (ESP32)';

  @override
  String get equipmentFormControllerHint =>
      'O ESP32 cujo LED infravermelho aponta para o aparelho.';

  @override
  String get equipmentFormNoControllers =>
      'Cadastre um controlador neste espaço antes de adicionar equipamentos.';

  @override
  String get equipmentFormControllerRequired => 'Escolha o controlador.';

  @override
  String get equipmentFormProtocolTitle => 'Marca do ar-condicionado';

  @override
  String get equipmentFormProtocolHint =>
      'Capture um sinal do controle original para detectar a marca automaticamente, ou escolha na lista.';

  @override
  String get equipmentFormLearnButton => 'Capturar do controle original';

  @override
  String equipmentFormLearned(String protocol) {
    return 'Detectado: $protocol';
  }

  @override
  String get equipmentFormProtocolLabel => 'Marca / protocolo';

  @override
  String get equipmentFormProtocolRequired => 'Escolha a marca do aparelho.';

  @override
  String get equipmentFormModelLabel => 'Modelo';

  @override
  String get equipmentFormMinTemperature => 'Temp. mínima';

  @override
  String get equipmentFormMaxTemperature => 'Temp. máxima';

  @override
  String get equipmentFormTemperatureInvalid => 'Use um valor entre 10 e 35.';

  @override
  String get equipmentFormUsageWindow => 'Limitar horário de uso';

  @override
  String get equipmentFormUsageWindowHint =>
      'Fora desse horário, só gestores conseguem usar o aparelho.';

  @override
  String get equipmentFormUsageStart => 'Início';

  @override
  String get equipmentFormUsageEnd => 'Fim';

  @override
  String get equipmentFormAutoOff => 'Desligar no fim do horário';

  @override
  String get equipmentFormAutoOffHint =>
      'Se estiver ligado, o ar é desligado automaticamente no horário final.';

  @override
  String get equipmentFormActive => 'Equipamento ativo';

  @override
  String get equipmentFormActiveHint =>
      'Equipamentos inativos ficam ocultos para os membros.';

  @override
  String get airConditionerOn => 'LIGADO';

  @override
  String get airConditionerOff => 'Desligado';

  @override
  String airConditionerAllowedRange(String min, String max) {
    return 'Temperatura permitida: $min° a $max°';
  }

  @override
  String get airConditionerModeLabel => 'Modo';

  @override
  String get airConditionerFanLabel => 'Ventilação';

  @override
  String get airConditionerSwingLabel => 'Direção do ar';

  @override
  String get airConditionerModeAuto => 'Auto';

  @override
  String get airConditionerModeCool => 'Frio';

  @override
  String get airConditionerModeHeat => 'Quente';

  @override
  String get airConditionerModeDry => 'Desumidificar';

  @override
  String get airConditionerModeFan => 'Ventilar';

  @override
  String get airConditionerLevelAuto => 'Auto';

  @override
  String get airConditionerLevelOff => 'Desligado';

  @override
  String get airConditionerFanMin => 'Mínima';

  @override
  String get airConditionerFanLow => 'Baixa';

  @override
  String get airConditionerFanMedium => 'Média';

  @override
  String get airConditionerFanHigh => 'Alta';

  @override
  String get airConditionerFanMax => 'Máxima';

  @override
  String get airConditionerSwingLowest => 'Mais baixo';

  @override
  String get airConditionerSwingLow => 'Baixo';

  @override
  String get airConditionerSwingMiddle => 'Meio';

  @override
  String get airConditionerSwingHigh => 'Alto';

  @override
  String get airConditionerSwingHighest => 'Mais alto';

  @override
  String get airConditionerSwingLeftMax => 'Extrema esquerda';

  @override
  String get airConditionerSwingLeft => 'Esquerda';

  @override
  String get airConditionerSwingRight => 'Direita';

  @override
  String get airConditionerSwingRightMax => 'Extrema direita';

  @override
  String get airConditionerSwingWide => 'Amplo';

  @override
  String get airConditionerTurbo => 'Turbo';

  @override
  String get airConditionerEcono => 'Econômico';

  @override
  String get airConditionerQuiet => 'Silencioso';

  @override
  String get airConditionerLight => 'Luz do painel';

  @override
  String get buttonsSection => 'Botões do controle';

  @override
  String get buttonsAddButton => 'Gravar botão';

  @override
  String get buttonsEmpty => 'Nenhum botão gravado';

  @override
  String get buttonsEmptyMessage =>
      'Grave os botões do controle remoto original para usá-los pelo app.';

  @override
  String get buttonCreated => 'Botão gravado.';

  @override
  String get buttonDeleteTitle => 'Remover botão?';

  @override
  String buttonDeleteMessage(String name) {
    return 'O botão \"$name\" será removido.';
  }

  @override
  String get buttonFormNewTitle => 'Novo botão';

  @override
  String get buttonFormEditTitle => 'Editar botão';

  @override
  String get buttonFormSubtitle =>
      'Dê um nome e um ícone para o sinal gravado.';

  @override
  String get buttonFormNameLabel => 'Nome do botão';

  @override
  String get buttonFormNameHint => 'Ex.: Liga/desliga';

  @override
  String get buttonFormIconLabel => 'Ícone';

  @override
  String get schedulesSection => 'Agendamentos';

  @override
  String get schedulesAddButton => 'Agendar';

  @override
  String get schedulesEmpty => 'Nenhum agendamento';

  @override
  String get schedulesEmptyMessage =>
      'Ligue ou desligue o aparelho automaticamente em dias e horários fixos.';

  @override
  String get scheduleSaved => 'Agendamento salvo.';

  @override
  String get scheduleDeleteTitle => 'Remover agendamento?';

  @override
  String get scheduleDeleteMessage => 'O agendamento deixará de ser executado.';

  @override
  String get scheduleInactive => 'Pausado';

  @override
  String get scheduleEveryDay => 'Todos os dias';

  @override
  String get scheduleWeekdays => 'Dias úteis';

  @override
  String scheduleTurnOnAt(String degrees) {
    return 'Ligar em $degrees°';
  }

  @override
  String schedulePress(String name) {
    return 'Apertar \"$name\"';
  }

  @override
  String get scheduleActionTurnOn => 'Ligar';

  @override
  String get scheduleActionTurnOff => 'Desligar';

  @override
  String get scheduleActionPressButton => 'Apertar um botão';

  @override
  String get scheduleFormNewTitle => 'Novo agendamento';

  @override
  String get scheduleFormEditTitle => 'Editar agendamento';

  @override
  String get scheduleFormSubtitle => 'O horário segue o fuso da organização.';

  @override
  String get scheduleFormNameLabel => 'Nome (opcional)';

  @override
  String get scheduleFormNameHint => 'Ex.: Desligar ao fim do expediente';

  @override
  String get scheduleFormTimeLabel => 'Horário';

  @override
  String get scheduleFormActionLabel => 'Ação';

  @override
  String get scheduleFormButtonLabel => 'Botão';

  @override
  String get scheduleFormNoButtons =>
      'Grave um botão neste equipamento para poder agendá-lo.';

  @override
  String scheduleFormTemperature(String degrees) {
    return 'Temperatura: $degrees°';
  }

  @override
  String get scheduleFormActive => 'Agendamento ativo';

  @override
  String get scheduleFormDaysRequired => 'Escolha pelo menos um dia.';

  @override
  String get scheduleFormButtonRequired => 'Escolha o botão.';

  @override
  String get historySection => 'Histórico de comandos';

  @override
  String get historyEmpty => 'Nenhum comando enviado ainda.';

  @override
  String historySeeAll(int count) {
    return 'Ver todos ($count)';
  }

  @override
  String get historyAirConditioner => 'Comando do ar-condicionado';

  @override
  String get historyButtonPressed => 'Botão do controle';

  @override
  String get historyLearn => 'Captura de sinal';

  @override
  String get historySourceManual => 'Manual';

  @override
  String get historySourceSchedule => 'Agendamento';

  @override
  String get historySourceAutoOff => 'Desligamento automático';

  @override
  String get learnTitle => 'Gravar sinal';

  @override
  String get learnSubtitleAirConditioner =>
      'Aponte o controle do ar para o ESP32 e aperte o botão de ligar.';

  @override
  String get learnSubtitleButton =>
      'Aponte o controle remoto para o ESP32 e aperte o botão que deseja gravar.';

  @override
  String get learnStarting => 'Preparando o controlador…';

  @override
  String get learnListening => 'Aguardando o sinal';

  @override
  String learnListeningHint(int seconds) {
    return 'Aperte o botão no controle remoto. $seconds s restantes.';
  }

  @override
  String get learnCaptured => 'Sinal capturado';

  @override
  String learnCapturedAirConditioner(String protocol) {
    return 'Ar-condicionado detectado ($protocol).';
  }

  @override
  String learnCapturedButton(String protocol) {
    return 'Sinal $protocol gravado.';
  }

  @override
  String get learnUseSignal => 'Usar este sinal';

  @override
  String get learnCaptureAgain => 'Capturar de novo';

  @override
  String get learnFailedTitle => 'Não foi possível gravar';

  @override
  String get learnFailed => 'O controlador não recebeu nenhum sinal.';

  @override
  String get learnTimeout =>
      'Nenhum sinal recebido a tempo. Aproxime o controle do ESP32 e tente de novo.';

  @override
  String learnNotAirConditioner(String protocol) {
    return 'O sinal ($protocol) não é de um ar-condicionado suportado. Escolha a marca na lista.';
  }

  @override
  String get learnErrorNotAirConditioner =>
      'O sinal capturado não é de um ar-condicionado suportado.';

  @override
  String get controllersSection => 'Outros controladores';

  @override
  String get controllersAddButton => 'Adicionar';

  @override
  String get controllersEmpty => 'Nenhum controlador';

  @override
  String get controllersEmptyMessage =>
      'Adicione aqui ESP32 extras para controlar equipamentos em outros pontos do espaço. O ESP32 da fechadura fica na tela do espaço.';

  @override
  String get controllersLoadError =>
      'Não foi possível carregar os controladores';

  @override
  String get spaceDeviceOtherControllersButton => 'Outros controladores';

  @override
  String get controllersScreenTitle => 'Controladores do espaço';

  @override
  String get controllerNoKeysBadge => 'Sem chaves';

  @override
  String get controllerNeverSeen => 'Nunca conectado';

  @override
  String get controllerSeenNow => 'Online agora';

  @override
  String controllerSeenMinutes(int count) {
    return 'Visto há $count min';
  }

  @override
  String controllerSeenHours(int count) {
    return 'Visto há $count h';
  }

  @override
  String controllerSeenDays(int count) {
    return 'Visto há $count d';
  }

  @override
  String get controllerRotateKeysAction => 'Gerar novas chaves';

  @override
  String get controllerRotateKeysTitle => 'Gerar novas chaves?';

  @override
  String controllerRotateKeysMessage(String name) {
    return 'O ESP32 \"$name\" deixará de funcionar até ser gravado com as novas chaves.';
  }

  @override
  String get controllerDeleteTitle => 'Remover controlador?';

  @override
  String controllerDeleteMessage(String name) {
    return '\"$name\" será removido deste espaço.';
  }

  @override
  String get controllerDeleted => 'Controlador removido.';

  @override
  String get controllerUpdated => 'Controlador atualizado.';

  @override
  String get controllerErrorHasEquipments =>
      'Mova ou remova os equipamentos deste controlador antes.';

  @override
  String get controllerErrorWithoutKeys =>
      'Gere as chaves do controlador antes.';

  @override
  String get controllerFormNewTitle => 'Novo controlador';

  @override
  String get controllerFormEditTitle => 'Editar controlador';

  @override
  String get controllerFormSubtitle =>
      'Depois de salvar, grave as chaves geradas no firmware do ESP32.';

  @override
  String get controllerFormNameLabel => 'Nome';

  @override
  String get controllerFormNameHint => 'Ex.: ESP32 do fundo da sala';

  @override
  String get controllerFormCreateButton => 'Criar e gerar chaves';

  @override
  String get provisionFirmwareIdsTitle => 'Identificação no firmware';

  @override
  String get provisionFirmwareIdsDesc =>
      'Use estes valores no lugar de <<SPACE_ID>> e <<CONTROLLER_ID>> no código do ESP32.';

  @override
  String get grantDeviceControlLabel => 'Pode controlar equipamentos';

  @override
  String get grantDeviceControlHint =>
      'Ar-condicionado, TV e outros aparelhos deste espaço.';

  @override
  String grantDeviceControlEnabled(String name) {
    return '$name agora pode controlar os equipamentos.';
  }

  @override
  String grantDeviceControlDisabled(String name) {
    return '$name não pode mais controlar os equipamentos.';
  }

  @override
  String get orgFormTimeZoneLabel => 'Fuso horário';

  @override
  String get orgFormTimeZoneHint =>
      'Usado nos horários de uso e agendamentos dos equipamentos.';
}
