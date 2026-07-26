// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get authIotPill => 'Plataforma de automatización IoT';

  @override
  String get authTagline => 'La puerta de entrada a entornos inteligentes.';

  @override
  String get authSubtitle =>
      'Conecta, automatiza y protege cualquier entorno, a cualquier escala, de forma inteligente.';

  @override
  String get authLoginButton => 'Iniciar sesión con GateWise';

  @override
  String get authNoAccount => '¿No tienes cuenta?';

  @override
  String get authSignUp => 'Regístrate';

  @override
  String authLoginFailed(Object error) {
    return 'Error de inicio de sesión: $error';
  }

  @override
  String get splashTaglinePart1 => 'Conectar, automatizar y proteger.';

  @override
  String get splashTaglinePart2 => 'A cualquier escala';

  @override
  String get splashConnecting => 'Conectando de forma segura';

  @override
  String get splashLoadingText => 'cargando';

  @override
  String get navOrgs => 'Orgs';

  @override
  String get navHistory => 'Accesos';

  @override
  String get navProfile => 'Perfil';

  @override
  String wsAccessOpened(String spaceName) {
    return '¡Acceso autorizado, $spaceName abierto!';
  }

  @override
  String wsAccessFailed(String spaceName) {
    return 'Ocurrió un error al intentar abrir la cerradura de $spaceName. Inténtalo de nuevo o contacta con soporte.';
  }

  @override
  String get wsConnectionError => 'Error de conexión con el servidor.';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get profileSectionAccount => 'Datos de la cuenta';

  @override
  String get profileLabelName => 'Nombre';

  @override
  String get profileLabelEmail => 'Correo electrónico';

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
  String get profileGuestName => 'Usuario GateWise';

  @override
  String get profileNoEmail => 'Correo no informado';

  @override
  String get profileLogout => 'Cerrar sesión';

  @override
  String get profileErrorLoad => 'Error al cargar el perfil';

  @override
  String get profileRetry => 'Intentar de nuevo';

  @override
  String get profileNotFound => 'Usuario no encontrado';

  @override
  String get profileNotFoundMessage =>
      'Inicia sesión nuevamente para actualizar tus datos.';

  @override
  String get profileSectionLanguage => 'Idioma';

  @override
  String get profileLanguageDialogTitle => 'Seleccionar idioma';

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
  String get orgsTitle => 'Organizaciones';

  @override
  String get orgsSubtitle => 'Gestiona miembros, invitaciones y accesos.';

  @override
  String get orgsNewButton => 'Nueva organización';

  @override
  String get orgsJoinButton => 'Código';

  @override
  String get orgsMineSection => 'Mis organizaciones';

  @override
  String get orgsSection => 'Organizaciones';

  @override
  String get orgsActiveStatus => 'Organización activa';

  @override
  String get orgsInactiveStatus => 'Organización inactiva';

  @override
  String orgsMemberSince(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get orgsNoneFound => 'No se encontraron organizaciones';

  @override
  String get orgsNoneFoundMessage =>
      'Crea una organización o únete usando un código de invitación.';

  @override
  String get orgsErrorLoad => 'Error al cargar organizaciones';

  @override
  String get orgsCreatedSuccess => 'Organización creada con éxito.';

  @override
  String orgsJoinedSuccess(String name) {
    return 'Te uniste a $name.';
  }

  @override
  String get orgDetailsTitle => 'Organización';

  @override
  String get orgDetailsErrorLoad => 'Error al abrir la organización';

  @override
  String get orgDetailsNotFound => 'Organización no encontrada';

  @override
  String get orgDetailsNotFoundMessage =>
      'No fue posible localizar los datos solicitados.';

  @override
  String get orgTabSpaces => 'Espacios';

  @override
  String get orgTabMembers => 'Miembros';

  @override
  String get orgTabInvites => 'Invitaciones';

  @override
  String get orgManageButton => 'Gestionar';

  @override
  String get orgSpacesSection => 'Espacios de la organización';

  @override
  String get orgSpacesUnavailable => 'Espacios no disponibles';

  @override
  String get orgSpacesUnavailableMessage =>
      'No fue posible cargar los espacios.';

  @override
  String get orgSpacesNone => 'Sin espacios registrados';

  @override
  String get orgSpacesNoneMessage =>
      'Añade espacios para controlar el acceso a las puertas.';

  @override
  String get orgMembersUnavailable => 'Miembros no disponibles';

  @override
  String get orgMembersNone => 'No se encontraron miembros';

  @override
  String get orgMembersNoneMessage =>
      'Aún no hay miembros en esta organización.';

  @override
  String get orgInvitesSection => 'Invitaciones activas';

  @override
  String get orgInvitesNewButton => 'Nuevo';

  @override
  String get orgInvitesNone => 'Sin invitaciones activas';

  @override
  String get orgInvitesNoneMessage =>
      'Crea invitaciones para permitir la entrada de nuevos miembros.';

  @override
  String get orgInvitesUnavailable => 'Invitaciones no disponibles';

  @override
  String get orgUpdated => 'Organización actualizada.';

  @override
  String get orgDeleteTitle => '¿Eliminar organización?';

  @override
  String orgDeleteMessage(String name) {
    return 'Esta acción eliminará $name.';
  }

  @override
  String get orgDeleteConfirm => 'Eliminar';

  @override
  String get orgDeleteSuccess => 'Organización eliminada.';

  @override
  String get orgLeaveButton => 'Salir de la organización';

  @override
  String get orgLeaveTitle => '¿Salir de la organización?';

  @override
  String orgLeaveMessage(String name) {
    return '¿Seguro que quieres salir de $name? Esta acción no se puede deshacer.';
  }

  @override
  String get orgLeaveConfirm => 'Salir';

  @override
  String get orgLeaveSuccess => 'Saliste de la organización.';

  @override
  String get orgLeaveOnlyOwnerError =>
      'Eres el único propietario de esta organización. Transfiere la titularidad o elimina la organización antes de salir.';

  @override
  String get orgRemoveMemberTitle => '¿Eliminar miembro?';

  @override
  String orgRemoveMemberMessage(String name) {
    return '¿Eliminar a $name de la organización?';
  }

  @override
  String get orgRemoveMemberConfirm => 'Eliminar';

  @override
  String get orgRemoveMemberSuccess => 'Miembro eliminado.';

  @override
  String orgChangeRoleTitle(String name) {
    return 'Cambiar rol de $name';
  }

  @override
  String get orgChangeRoleSelectSpace => 'Selecciona al menos un espacio';

  @override
  String orgChangeRoleSuccess(String name, String role) {
    return 'Rol de $name actualizado a $role.';
  }

  @override
  String get orgNoSpacesError =>
      'No se encontraron espacios en esta organización.';

  @override
  String orgSelectSpaceDialog(String name) {
    return '¿Eliminar a $name de qué espacio?';
  }

  @override
  String get orgRemoveFromSpaceTitle => '¿Eliminar administrador del espacio?';

  @override
  String orgRemoveFromSpaceMessage(String name, String space) {
    return '¿Eliminar a $name como administrador de \"$space\"?\n\nSi no hay otros accesos o espacios gestionados, el usuario será eliminado de la organización automáticamente.';
  }

  @override
  String get orgRemoveFromSpaceConfirm => 'Eliminar';

  @override
  String orgRemoveFromSpaceSuccess(String name, String space) {
    return '$name eliminado de \"$space\".';
  }

  @override
  String get orgRevokeInviteTitle => '¿Revocar invitación?';

  @override
  String orgRevokeInviteMessage(String code) {
    return 'El código $code dejará de funcionar.';
  }

  @override
  String get orgRevokeInviteConfirm => 'Revocar';

  @override
  String get orgRevokeInviteSuccess => 'Invitación revocada.';

  @override
  String get orgRemoveSpaceTitle => '¿Eliminar espacio?';

  @override
  String orgRemoveSpaceMessageLast(String space, String code) {
    return 'Eliminar \"$space\" desactivará la invitación $code.';
  }

  @override
  String orgRemoveSpaceMessage(String space, String code) {
    return '¿Eliminar \"$space\" de la invitación $code?';
  }

  @override
  String get orgRemoveSpaceConfirm => 'Eliminar';

  @override
  String get orgRemoveSpaceSuccessDeactivated =>
      'Espacio eliminado. Invitación desactivada.';

  @override
  String get orgRemoveSpaceSuccess => 'Espacio eliminado.';

  @override
  String orgInviteCreated(String code) {
    return 'Invitación $code creada y copiada.';
  }

  @override
  String get thisSpace => 'este espacio';

  @override
  String get orgFormNewTitle => 'Nueva organización';

  @override
  String get orgFormEditTitle => 'Editar organización';

  @override
  String get orgFormNewSubtitle =>
      'Configura una nueva organización para gestionar miembros e invitaciones.';

  @override
  String get orgFormEditSubtitle =>
      'Actualiza los datos y el estado de tu organización.';

  @override
  String get orgFormNameLabel => 'Nombre';

  @override
  String get orgFormNameHint => 'Ej: Laboratorio GateWise';

  @override
  String get orgFormDescLabel => 'Descripción';

  @override
  String get orgFormDescHint => 'Detalles sobre la organización';

  @override
  String get orgFormStatusLabel => 'Estado de la organización';

  @override
  String get orgFormStatusActive => 'Activa y disponible para los miembros.';

  @override
  String get orgFormStatusInactive => 'Inactiva temporalmente.';

  @override
  String get orgFormSaveButton => 'Guardar organización';

  @override
  String get joinTitle => 'Unirse por invitación';

  @override
  String get joinCodeLabel => 'Código de invitación';

  @override
  String get joinCodeHint => 'ABC12345';

  @override
  String get joinButton => 'Unirse a la organización';

  @override
  String get inviteFormTitle => 'Crear invitación';

  @override
  String get inviteFormRoleLabel => 'Rol';

  @override
  String get inviteFormExpiresLabel => 'Expira en días';

  @override
  String get inviteFormExpiresHint => 'Vacío = sin expiración';

  @override
  String get inviteFormMaxUsesLabel => 'Usos máximos';

  @override
  String get inviteFormMaxUsesHint => 'Vacío = ilimitado';

  @override
  String get inviteFormStartsAtLabel => 'Inicio de acceso del miembro';

  @override
  String get inviteFormExpiresAtLabel => 'Expiración de acceso del miembro';

  @override
  String get inviteFormSpacesManagerLabel => 'Espacios del Manager *';

  @override
  String get inviteFormSpacesLabel => 'Espacios *';

  @override
  String get inviteFormGenerateButton => 'Generar invitación';

  @override
  String get inviteFormSelectSpaceManager =>
      'Selecciona al menos un espacio para el Manager.';

  @override
  String get inviteFormSelectSpace => 'Selecciona al menos un espacio.';

  @override
  String get inviteFormSpacesLoadError => 'No fue posible cargar los espacios.';

  @override
  String get inviteFormNoSpaces => 'Sin espacios registrados.';

  @override
  String get inviteFormDateNotSet => 'No definido';

  @override
  String get spacesTitle => 'Espacios';

  @override
  String get spacesHeroPill => 'ESPACIOS';

  @override
  String get spacesHeroTitle => 'Controla tus espacios';

  @override
  String get spacesHeroDescOwner =>
      'Monitoriza puertas, registra entornos y gestiona accesos en una interfaz segura y conectada.';

  @override
  String get spacesHeroDescMember =>
      'Visualiza y accede a los espacios disponibles en tu organización.';

  @override
  String get spacesMetricTotal => 'Total';

  @override
  String get spacesMetricActive => 'Activos';

  @override
  String get spacesMetricPaused => 'Pausados';

  @override
  String get spacesNewButton => 'Nuevo espacio';

  @override
  String get spacesOrgSection => 'Espacios de la organización';

  @override
  String spacesCountPill(int count) {
    return '$count registrados';
  }

  @override
  String get spacesErrorLoad => 'Error al cargar espacios';

  @override
  String get spacesNone => 'No se encontraron espacios';

  @override
  String get spacesNoneMessage =>
      'Crea el primer espacio para controlar el acceso a las puertas.';

  @override
  String get spaceDetailsTitle => 'Espacio';

  @override
  String get spaceDetailsErrorLoad => 'Error al abrir el espacio';

  @override
  String get spaceDetailsNotFound => 'Espacio no encontrado';

  @override
  String get spaceDetailsNotFoundMessage =>
      'No fue posible localizar los datos solicitados.';

  @override
  String get spaceDeviceSection => 'Dispositivo';

  @override
  String get spaceDeviceHardware => 'Hardware ESP32';

  @override
  String get spaceDeviceDesc =>
      'Genera las claves RSA para flashear en el dispositivo.';

  @override
  String get spaceDeviceProvisionButton => 'Aprovisionar dispositivo';

  @override
  String get spaceDeviceBackendKeyButton => 'Clave pública del servidor';

  @override
  String get spaceEsp32TutorialTitle => 'Cómo configurar el ESP32';

  @override
  String get spaceEsp32TutorialScan =>
      'Escanea el código QR a continuación para acceder al repositorio del firmware en GitHub:';

  @override
  String spaceEsp32TutorialIdHint(Object id) {
    return 'El ID de este space es $id — usa ese valor como identificador del dispositivo en el firmware.';
  }

  @override
  String get spaceEsp32TutorialKeysHint =>
      'Utiliza las claves descargadas arriba para completar la configuración de seguridad del dispositivo.';

  @override
  String get spaceGrantsSection => 'Solicitudes de acceso';

  @override
  String get spaceGrantsRequestButton => 'Solicitar';

  @override
  String get spaceGrantsUnavailable => 'Solicitudes no disponibles';

  @override
  String get spaceGrantsNone => 'Sin solicitudes';

  @override
  String get spaceGrantsNoneMessage =>
      'Las solicitudes de acceso aparecerán aquí para su aprobación.';

  @override
  String get spaceGrantsApproveTitle => '¿Aprobar acceso?';

  @override
  String spaceGrantsApproveMessage(String name) {
    return '¿Autorizar a $name para acceder a este espacio?';
  }

  @override
  String get spaceGrantsApproveConfirm => 'Aprobar';

  @override
  String get spaceGrantsApproveSuccess => 'Acceso aprobado.';

  @override
  String get spaceGrantsCannotApprove => 'No fue posible aprobar.';

  @override
  String get spaceGrantsRejectTitle => '¿Rechazar acceso?';

  @override
  String spaceGrantsRejectMessage(String name) {
    return '¿Rechazar la solicitud de $name?';
  }

  @override
  String get spaceGrantsRejectConfirm => 'Rechazar';

  @override
  String get spaceGrantsRejectSuccess => 'Acceso rechazado.';

  @override
  String get spaceGrantsCannotReject => 'No fue posible rechazar.';

  @override
  String get spaceGrantsDeleteTitle => '¿Eliminar acceso?';

  @override
  String spaceGrantsDeleteMessage(String name) {
    return '¿Eliminar el registro de acceso de $name?';
  }

  @override
  String spaceGrantsDeleteMessageLast(String name) {
    return '¿Eliminar el registro de acceso de $name?\n\nEste es el último acceso de este usuario en este espacio. Si no hay otros vínculos en la organización, será eliminado automáticamente.';
  }

  @override
  String get spaceGrantsDeleteConfirm => 'Eliminar';

  @override
  String get spaceGrantsDeleteSuccess => 'Registro eliminado.';

  @override
  String get spaceGrantsCannotRemove => 'No fue posible eliminar.';

  @override
  String get spaceGrantsCannotSend => 'No fue posible enviar la solicitud.';

  @override
  String get spaceGrantsSentSuccess => 'Solicitud enviada con éxito.';

  @override
  String get spaceDeleteTitle => '¿Eliminar espacio?';

  @override
  String spaceDeleteMessage(String name) {
    return 'Esta acción eliminará permanentemente \"$name\".';
  }

  @override
  String get spaceDeleteConfirm => 'Eliminar';

  @override
  String get spaceDeleteSuccess => 'Espacio eliminado.';

  @override
  String get spaceUpdated => 'Espacio actualizado.';

  @override
  String get spaceProvisionTitle => '¿Reaprovisionar dispositivo?';

  @override
  String spaceProvisionMessage(String name) {
    return 'Esto generará nuevas claves RSA para el ESP32 de \"$name\". Si ya hay un dispositivo configurado, será desconectado.';
  }

  @override
  String get spaceProvisionConfirm => 'Continuar';

  @override
  String get spaceBackendKeySheetTitle => 'Clave pública del servidor';

  @override
  String get spaceBackendKeyError =>
      'No fue posible obtener la clave pública del servidor.';

  @override
  String get spacePendingMessage =>
      'Tu solicitud está pendiente de aprobación.';

  @override
  String get spacePendingChip => 'PENDIENTE';

  @override
  String get spacePendingButton => 'Esperando aprobación';

  @override
  String get spaceRejectedMessage => 'Tu solicitud de acceso fue rechazada.';

  @override
  String get spaceRejectedChip => 'RECHAZADO';

  @override
  String get spaceRejectedButton => 'Volver a solicitar';

  @override
  String get spaceNoAccessMessage => 'No tienes acceso a este espacio.';

  @override
  String get spaceRequestAccessButton => 'Solicitar acceso';

  @override
  String get spaceMyAccess => 'Mi acceso';

  @override
  String get spaceAuthorizedChip => 'AUTORIZADO';

  @override
  String get spaceAccessInfo =>
      'Módulo conectado al control de acceso. Activa la cerradura solo cuando estés cerca del entorno autorizado.';

  @override
  String get spaceEnterButton => 'Entrar al espacio';

  @override
  String get spaceOpenButton => 'Abrir puerta';

  @override
  String get spaceOpeningButton => 'Abriendo puerta...';

  @override
  String dialogOpeningSpace(String spaceName) {
    return 'Abriendo $spaceName';
  }

  @override
  String get spaceCommandError => 'No fue posible enviar el comando.';

  @override
  String get spaceOpenError => 'Error al abrir el espacio.';

  @override
  String get membershipExpiredMessage =>
      'Tu acceso a esta organización ha expirado. Solicita una nueva invitación.';

  @override
  String get spaceLoadAccessError => 'Error al cargar el acceso';

  @override
  String get spaceFormNewTitle => 'Nuevo espacio';

  @override
  String get spaceFormEditTitle => 'Editar espacio';

  @override
  String get spaceFormNewSubtitle =>
      'Configura un nuevo espacio para controlar el acceso a la puerta.';

  @override
  String get spaceFormEditSubtitle =>
      'Actualiza los datos y el estado del espacio.';

  @override
  String get spaceFormNameLabel => 'Nombre';

  @override
  String get spaceFormNameHint => 'Ej: Laboratorio 66';

  @override
  String get spaceFormDescLabel => 'Descripción';

  @override
  String get spaceFormDescHint => 'Detalles del espacio';

  @override
  String get spaceFormStatusLabel => 'Estado del espacio';

  @override
  String get spaceFormStatusActive => 'Activo y disponible.';

  @override
  String get spaceFormStatusInactive => 'Inactivo temporalmente.';

  @override
  String get spaceFormSaveButton => 'Guardar espacio';

  @override
  String get requestAccessTitle => 'Solicitar acceso';

  @override
  String requestAccessSubtitle(String name) {
    return 'Indica el motivo para acceder a \"$name\".';
  }

  @override
  String get requestAccessReasonLabel => 'Motivo';

  @override
  String get requestAccessReasonHint =>
      'Ej: Necesito acceder para el proyecto X';

  @override
  String get requestAccessButton => 'Enviar solicitud';

  @override
  String get provisionTitle => 'Aprovisionar dispositivo';

  @override
  String get provisionLoading => 'Generando claves RSA...';

  @override
  String get provisionErrorTitle => 'Error al aprovisionar';

  @override
  String get provisionSuccessTitle => 'Dispositivo aprovisionado';

  @override
  String get provisionSuccessSubtitle =>
      'Descarga las claves y grábalas en el ESP32.';

  @override
  String get provisionWarningTitle => 'Atención: guarda la clave privada ahora';

  @override
  String get provisionWarningMessage =>
      'La clave privada del ESP32 no se almacena en nuestros servidores. Si cierras esta pantalla sin guardarla, deberás generar un nuevo par de claves y reconfigurar el hardware.';

  @override
  String get provisionBackendKeyTitle => 'Clave Pública del Servidor';

  @override
  String get provisionBackendKeyDesc =>
      'El ESP32 usa esta clave para verificar que los comandos MQTT provienen del servidor GateWise. Es la misma para todos los espacios.';

  @override
  String get provisionBackendKeyBadge => 'SE PUEDE DESCARGAR OTRA VEZ';

  @override
  String get provisionBackendKeyNote =>
      'Esta clave es pública y puede obtenerse de nuevo en cualquier momento desde la configuración del espacio.';

  @override
  String get provisionDeviceKeyTitle => 'Clave Privada del ESP32';

  @override
  String get provisionDeviceKeyDesc =>
      'Identifica este dispositivo en el sistema. El ESP32 la usa para firmar los eventos enviados al servidor.';

  @override
  String get provisionDeviceKeyBadge => 'NO LA GUARDAMOS';

  @override
  String get provisionViewMore => 'Ver más';

  @override
  String get provisionViewLess => 'Ver menos';

  @override
  String get provisionCopyButton => 'Copiar';

  @override
  String get provisionCopiedButton => '¡Copiado!';

  @override
  String get provisionGoToSpaceButton => 'Ir al espacio';

  @override
  String get provisionErrorGenKeys =>
      'Error al generar las claves del dispositivo.';

  @override
  String get keyExportSaveTitle => 'Guardar en el dispositivo';

  @override
  String get keyExportSaveDesc =>
      'Guarda el archivo .pem en el almacenamiento local';

  @override
  String get keyExportShareTitle => 'Compartir';

  @override
  String get keyExportShareDesc => 'Abre el sistema de compartir';

  @override
  String keyExportSaved(String path) {
    return 'Guardado en: $path';
  }

  @override
  String keyExportError(Object error) {
    return 'Error: $error';
  }

  @override
  String get historyTitle => 'Historial';

  @override
  String get accessTitle => 'Accesos';

  @override
  String get historyNone => 'Sin registros de acceso';

  @override
  String get historyNoneMessage =>
      'Cuando accedas a un entorno, el registro aparecerá aquí.';

  @override
  String get memberYou => 'Tú';

  @override
  String get memberUnnamed => 'Usuario sin nombre';

  @override
  String get memberActionChangeRole => 'Cambiar rol';

  @override
  String get memberActionRemoveFromSpace => 'Eliminar del espacio';

  @override
  String get memberActionRemove => 'Eliminar miembro';

  @override
  String get grantUnnamed => 'Usuario sin nombre';

  @override
  String get grantApprove => 'Aprobar';

  @override
  String get grantReject => 'Rechazar';

  @override
  String get grantRemove => 'Eliminar';

  @override
  String get userTypeProfessor => 'Profesor';

  @override
  String get userTypeStudent => 'Alumno';

  @override
  String get userTypeAdmin => 'Administrador';

  @override
  String get userTypeVisitor => 'Visitante';

  @override
  String get userTypeUnknown => 'No informado';

  @override
  String get roleOwner => 'Propietario';

  @override
  String get roleManager => 'Gestor';

  @override
  String get roleMember => 'Miembro';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionConfirm => 'Confirmar';

  @override
  String get actionRetry => 'Intentar de nuevo';

  @override
  String get actionOk => 'OK';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionEdit => 'Editar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionGenericError =>
      'No fue posible completar la acción. Inténtalo de nuevo.';

  @override
  String get dialogSuccessDefault => '¡Éxito!';

  @override
  String get dialogErrorDefault => 'Error al abrir';

  @override
  String get dialogTimeoutTitle => 'Tiempo excedido';

  @override
  String get dialogTimeoutDefault =>
      'La operación superó el tiempo límite. No se obtuvo respuesta de GateWise. Verifique si la cerradura se abrió, o intente nuevamente.';

  @override
  String get noDate => 'sin fecha';

  @override
  String get noDescription => 'Sin descripción registrada.';

  @override
  String get statusActive => 'ACTIVO';

  @override
  String get statusInactive => 'INACTIVO';

  @override
  String get statusActiveFem => 'ACTIVA';

  @override
  String get statusInactiveFem => 'INACTIVA';

  @override
  String get grantStatusPending => 'Pendiente';

  @override
  String get grantStatusGranted => 'Autorizado';

  @override
  String get grantStatusRejected => 'Rechazado';

  @override
  String get formValidationName => 'Introduce un nombre.';

  @override
  String get formValidationReason => 'Introduce un motivo.';
}
