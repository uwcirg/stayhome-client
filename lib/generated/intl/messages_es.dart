// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static m0(deploymentType) => "Este es un ${deploymentType} sistema - no para datos reales. ";

  static m1(duration, durationUnit) => "${duration} ${durationUnit}";

  static m2(number, unit) => "Una vez cada ${number} ${unit}";

  static m3(text) => "Notificación del Sistema ${text}";

  static m4(minF, maxF, minC, maxC) => "Ingrese un valor entre ${minF} y ${maxF} (°F) o ${minC} y ${maxC} (°C). Este valor no se guardará.";

  static m5(version) => "Versión  ${version}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about" : MessageLookupByLibrary.simpleMessage("Acerca"),
    "about_CIRG" : MessageLookupByLibrary.simpleMessage("Acerca de CIRG"),
    "about_stayhome" : MessageLookupByLibrary.simpleMessage("Acerca de StayHome"),
    "about_stayhome_info_text" : MessageLookupByLibrary.simpleMessage("La pandemia de COVID-19 está causando tensión en los procesos y flujo de trabajo existentes en la salud pública. El contagio con el COVID-19 es preocupante para muchos miembros de la comunidad. Para satisfacer esta necesidad, desarrollamos StayHome, la cual es una aplicación para ayudar a las personas que permanecen en casa a minimizar cualquier riesgo que puedan presentar para otros haciendo cosas como monitoreo de los síntomas y de la temperatura, enlaces a información y recursos pertinentes, y llevar un registro diario de las personas con las cuales entran en contacto. Esperamos que la aplicación también ayude a que las personas y la salud pública se conecten más fácilmente, cuando sea necesario, en situaciones donde los recursos de salud pública sean limitados."),
    "active" : MessageLookupByLibrary.simpleMessage("Activo"),
    "add_the_default_careplan_for_me" : MessageLookupByLibrary.simpleMessage("agregue el plan de cuidado preestablecido para mí"),
    "attempt_login_text" : MessageLookupByLibrary.simpleMessage("Attempt to log in..."),
    "back" : MessageLookupByLibrary.simpleMessage("regresar"),
    "back_to_login_register" : MessageLookupByLibrary.simpleMessage("Regrese a iniciar sesión / regístrese"),
    "birthdate" : MessageLookupByLibrary.simpleMessage("Fecha de nacimiento"),
    "calendar" : MessageLookupByLibrary.simpleMessage("Calendario"),
    "calender_history" : MessageLookupByLibrary.simpleMessage("Calendario e Historia "),
    "cancel" : MessageLookupByLibrary.simpleMessage("cancelar"),
    "cdc_symptom_checker" : MessageLookupByLibrary.simpleMessage("autoverificador de síntomas del CDC. "),
    "cdc_symptom_checker_continue_text" : MessageLookupByLibrary.simpleMessage("continúe a CDC.gov"),
    "cdc_symptom_checker_info_text" : MessageLookupByLibrary.simpleMessage("El Autoverificador del CDC es una herramienta interactiva para ayudarle a tomar decisiones y buscar cuidado médico apropiado para el COVID-19.\n\nEn la actualidad, usted debe ingresar sus síntomas nuevamente cuando use el Autoverificador, pero una versión futura de StayHome tendrá la habilidad de enviar al Autoverificador los síntomas que ya haya grabado (con su consentimiento)."),
    "cdc_symptom_checker_title_text" : MessageLookupByLibrary.simpleMessage("Autoverificador de Síntomas del CDC. "),
    "clear_birthdate_text" : MessageLookupByLibrary.simpleMessage("Borrar fecha de nacimiento"),
    "communications" : MessageLookupByLibrary.simpleMessage("Notificaciones "),
    "completed" : MessageLookupByLibrary.simpleMessage("Finalizado"),
    "contact_us" : MessageLookupByLibrary.simpleMessage("Contáctenos / envíe comentarios"),
    "continue_to_resources" : MessageLookupByLibrary.simpleMessage("pase a recursos "),
    "copied" : MessageLookupByLibrary.simpleMessage("Copiado"),
    "copy_to_clipboard" : MessageLookupByLibrary.simpleMessage("Copiar en portapapeles"),
    "create_one" : MessageLookupByLibrary.simpleMessage("cree uno"),
    "decimal_validation_text" : MessageLookupByLibrary.simpleMessage("Por favor ingrese un decimal válido"),
    "decline_to_state" : MessageLookupByLibrary.simpleMessage("rehúsa contestar"),
    "demoVersionBannerText" : m0,
    "developedByCIRG" : MessageLookupByLibrary.simpleMessage("Desarrollado por Clinical Informatics Research Group (CIRG) de la Universidad de Washington, 2019-2020."),
    "discard" : MessageLookupByLibrary.simpleMessage("desechar"),
    "dismiss" : MessageLookupByLibrary.simpleMessage("Descartar"),
    "done" : MessageLookupByLibrary.simpleMessage("hecho"),
    "duration" : MessageLookupByLibrary.simpleMessage("Duración:"),
    "duration_duration_durationunit" : m1,
    "email" : MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "enter_temperature_text" : MessageLookupByLibrary.simpleMessage("Ingrese temperatura corporal, en °F o °C"),
    "firstname" : MessageLookupByLibrary.simpleMessage("Nombre"),
    "fiuNH_body" : MessageLookupByLibrary.simpleMessage("You can choose to share your information directly with the NeighborhoodHELP program. If you do they will know if you might be sick from COVID-19, and what kind of help you or your family might need. If you share information with NeighborhoodHLEP they will have access to:\n- Your symptoms, testing, and health condition information,\n- Your general location information (zip code), AND\n- Your name and contact information (email and/or phone number)."),
    "fiuNH_title" : MessageLookupByLibrary.simpleMessage("Programa NeighborhoodHELP de FIU"),
    "fiuNH_toggle" : MessageLookupByLibrary.simpleMessage("Compartir mi información con NeighborhoodHELP de FIU"),
    "fiu_body" : MessageLookupByLibrary.simpleMessage("Puede optar por compartir su información directamente con FIU. Esto les ayudará a prepararse y a rastrear las necesidades y el bienestar relacionado con COVID de la comunidad de FIU. Si decide compartir información con FIU, ellos tendrán acceso a:\n- Sus sintomas, pruebas, e información de su condición de salud,\n- La información general de su ubicación (código postal), Y\n- Su nombre e información de contacto (correo electrónico y/o número de teléfono)."),
    "fiu_title" : MessageLookupByLibrary.simpleMessage("Florida International University (FIU): estudiante, profesor, o personal"),
    "fiu_toggle" : MessageLookupByLibrary.simpleMessage("Compartir mi información con Florida International University"),
    "form_error_text" : MessageLookupByLibrary.simpleMessage("El formulario contiene errores. Por favor desplácese hacia arriba y corrija su información."),
    "frequency" : MessageLookupByLibrary.simpleMessage("Frecuencia:"),
    "frequency_with_contents" : m2,
    "gender" : MessageLookupByLibrary.simpleMessage("Sexo"),
    "guest_home_text" : MessageLookupByLibrary.simpleMessage("StayHome incluye una lista de recursos que le brinda acceso directo a fuentes de información que consideramos correctas. Esperamos que estas fuentes le ayuden a mantenerse saludable, seguro y en buen estado durante este brote del COVID-19.\n\nSi no tiene una cuenta, usted puede \"continuar\" abajo navegando estos recursos, y seguir los enlaces que ellos contienen.\n\nSi decide crear una cuenta, en este momento o en el futuro, usted puede:\n\n- monitorear sus propios síntomas y temperatura\n- monitorear sus viajes y/o las veces que puede haber estado expuesto\n- registrar las pruebas de COVID-19, las cuales pueden ayudar a las agencias de salud pública a aparear sus resultados con la forma de contactarlo\n- registrar otra información, como embarazo y ocupación, que puede ayudar a las agencias de salud pública a identificar programas específicos o  protecciones para usted."),
    "history" : MessageLookupByLibrary.simpleMessage("Historia"),
    "home" : MessageLookupByLibrary.simpleMessage("Inicio"),
    "info_resource" : MessageLookupByLibrary.simpleMessage("Información y Recursos"),
    "information_sharing" : MessageLookupByLibrary.simpleMessage("Compartir Información"),
    "information_sharing_info" : MessageLookupByLibrary.simpleMessage("Le recomendamos que comparta su información con las agencias de salud pública y los investigadores, pero no tiene que hacerlo.  "),
    "languageName" : MessageLookupByLibrary.simpleMessage("Inglés (IN)"),
    "lastname" : MessageLookupByLibrary.simpleMessage("Apellido"),
    "loading_error_log_in_again" : MessageLookupByLibrary.simpleMessage("Error de carga. Intente cerrar la sesión y volver a iniciarla."),
    "login" : MessageLookupByLibrary.simpleMessage("iniciar sesión / regístrese"),
    "logout" : MessageLookupByLibrary.simpleMessage("Cerrar sesión "),
    "member_program_question" : MessageLookupByLibrary.simpleMessage("¿Participa o es miembro de uno de los siguientes programas? "),
    "more_charts_text" : MessageLookupByLibrary.simpleMessage("Hay más gráficas que no se muestran."),
    "my_trends" : MessageLookupByLibrary.simpleMessage("Mis tendencias"),
    "name_not_entered" : MessageLookupByLibrary.simpleMessage("(no ingresó nombre)"),
    "no_FHIR_patient_record_text" : MessageLookupByLibrary.simpleMessage("No tiene historial clínico en la base de datos de FHIR. "),
    "no_active_careplan_text" : MessageLookupByLibrary.simpleMessage("No tiene un plan de cuidado activo. "),
    "no_content" : MessageLookupByLibrary.simpleMessage("<no content>"),
    "no_data" : MessageLookupByLibrary.simpleMessage("Sin datos"),
    "no_data_to_show_text" : MessageLookupByLibrary.simpleMessage("No hay datos que mostrar. Comience el monitoreo y sus datos aparecerán aquí. "),
    "no_date" : MessageLookupByLibrary.simpleMessage("Sin fecha"),
    "not_now" : MessageLookupByLibrary.simpleMessage("continúe sin iniciar sesión"),
    "nothing_here" : MessageLookupByLibrary.simpleMessage("Nada que mostrar"),
    "profile" : MessageLookupByLibrary.simpleMessage("Perfil y Compartir Información"),
    "profile_about_you_title_text" : MessageLookupByLibrary.simpleMessage("Acerca de Usted "),
    "profile_contact_title_text" : MessageLookupByLibrary.simpleMessage("Información de Contacto"),
    "profile_create_text" : MessageLookupByLibrary.simpleMessage("Cree su perfil"),
    "profile_email_validation_error_text" : MessageLookupByLibrary.simpleMessage("Deje en blanco o ingrese un correo electrónico válido "),
    "profile_form_error_text" : MessageLookupByLibrary.simpleMessage("Ocurrió un error al guardar las actualizaciones del perfil. Por favor vuelva a intentar."),
    "profile_home_zipcode_label_text" : MessageLookupByLibrary.simpleMessage("Código postal de su hogar"),
    "profile_location_title_text" : MessageLookupByLibrary.simpleMessage("Ubicación"),
    "profile_phone_hint_text" : MessageLookupByLibrary.simpleMessage("¿Cuál es su número de teléfono?"),
    "profile_phone_label_text" : MessageLookupByLibrary.simpleMessage("Teléfono celular/móvil "),
    "profile_phone_validation_error_text" : MessageLookupByLibrary.simpleMessage("Deje en blanco o ingrese un número de teléfono válido "),
    "profile_preferred_contact_sms_text" : MessageLookupByLibrary.simpleMessage("texto"),
    "profile_preferred_contact_text" : MessageLookupByLibrary.simpleMessage("Método de contacto preferido"),
    "profile_preferred_contact_voicecall_text" : MessageLookupByLibrary.simpleMessage("llamada de voz"),
    "profile_save_error_text" : MessageLookupByLibrary.simpleMessage("Ocurrió un error al guardar las actualizaciones del perfil. Es posible que algunos o ninguno de los cambios se hayan guardado."),
    "profile_secondary_zipcode_hint_text" : MessageLookupByLibrary.simpleMessage("Si pasa mucho tiempo en otro lugar (trabajo, escuela, familia, etc.)"),
    "profile_secondary_zipcode_label_text" : MessageLookupByLibrary.simpleMessage("Segundo código postal "),
    "profile_updated_text" : MessageLookupByLibrary.simpleMessage("Actualizaciones del perfil guardadas"),
    "profile_zipcode_hint_text" : MessageLookupByLibrary.simpleMessage("Donde pasa la mayor parte de su tiempo "),
    "profile_zipcode_validation_error_text" : MessageLookupByLibrary.simpleMessage("Deje en blanco o ingrese un código postal válido "),
    "public_health_information_sharing_info" : MessageLookupByLibrary.simpleMessage("Su decisión de compartir su información con las agencias de salud pública les ayudará a planear y a afrontar el brote del COVID-19 en su área. Si comparte su nombre y su información de contacto, ellos pueden comunicarse con usted si creen que necesita ayuda."),
    "public_health_information_sharing_question" : MessageLookupByLibrary.simpleMessage("¿Cuál información quiere compartir con las **agencias de salud pública** en su área?"),
    "read_more" : MessageLookupByLibrary.simpleMessage("Lea Más"),
    "record_symptoms_and_temp" : MessageLookupByLibrary.simpleMessage("registre síntomas y temperatura"),
    "research_information_sharing_info" : MessageLookupByLibrary.simpleMessage("Su decisión de compartir su información con los investigadores les ayudará a adquirir más conocimiento sobre el brote del COVID-19 y a encontrar la forma de ayudar a personas como usted. Si comparte su nombre y su información de contacto, ellos pueden comunicarse con usted para preguntarle si quiere participar en estudios de investigación de COVID-19"),
    "research_information_sharing_question" : MessageLookupByLibrary.simpleMessage("¿Cuál información quiere compartir con los **investigadores** interesados en aprender más sobre COVID-19?"),
    "review_terms_of_use_title" : MessageLookupByLibrary.simpleMessage("Revise los Términos de Uso"),
    "save" : MessageLookupByLibrary.simpleMessage("guardar"),
    "scan_body" : MessageLookupByLibrary.simpleMessage("Puede optar por compartir su información directamente con la Red de Evaluación de Coronavirus de Seattle (SCAN). Si lo hace, ellos podrán crear un enlace entre su información de StayHome y la información del sistema. Si decide compartir información con SCAN, ellos tendrán acceso a:\n- Sus sintomas, pruebas, e información de su condición de salud,\n- La información general de su ubicación (código postal), Y\n- Su nombre e información de contacto (correo electrónico y/o número de teléfono)."),
    "scan_title" : MessageLookupByLibrary.simpleMessage("Red de Evaluación de Coronavirus de Seattle (SCAN)"),
    "scan_toggle" : MessageLookupByLibrary.simpleMessage("Compartir mi información con la Red de Evaluación de Coronavirus de Seattle (SCAN)"),
    "select" : MessageLookupByLibrary.simpleMessage("Seleccione"),
    "select_trend_text" : MessageLookupByLibrary.simpleMessage("Selecciones una pregunta para ver las tendencias "),
    "session_expired_please_log_in_again" : MessageLookupByLibrary.simpleMessage("La sesión caducó, por favor inicie sesión nuevamente."),
    "sign_up_or_log_in_to_access_all_functions" : MessageLookupByLibrary.simpleMessage("Inicie sesión para acceder a todas las funciones"),
    "springboard_COVID19_resources_text" : MessageLookupByLibrary.simpleMessage("información y recursos de COVID-19"),
    "springboard_enter_pregnancy_text" : MessageLookupByLibrary.simpleMessage("ingrese embarazo, ocupación y posibles riesgos"),
    "springboard_enter_travel_exposure_text" : MessageLookupByLibrary.simpleMessage("ingrese exposición o viaje"),
    "springboard_record_COVID19_text" : MessageLookupByLibrary.simpleMessage("registre las pruebas para COVID-19"),
    "springboard_record_symptom_text" : MessageLookupByLibrary.simpleMessage("registre síntomas y temperatura"),
    "springboard_review_calendar_history_text" : MessageLookupByLibrary.simpleMessage("revise calendario e historia"),
    "springboard_update_profile_text" : MessageLookupByLibrary.simpleMessage("actualice perfil y consentimientos"),
    "support_COVID19" : MessageLookupByLibrary.simpleMessage("Apoyo Durante COVID-19"),
    "system_announcement" : m3,
    "temperatureErrorMessage" : m4,
    "terms_of_use" : MessageLookupByLibrary.simpleMessage("Esta aplicación fue construida por Clinical Informatic Research Group (CIRG), en la Universidad de Washington, para el beneficio de las personas, como usted, a quienes les preocupa la infección con el Coronavirus (COVID-19). O, quienes simplemente quieren saber cómo “permanecer en casa” en forma óptima. El profesorado, los estudiantes y el personal de CIRG llevan a cabo este trabajo con el fin de ayudar a nuestras comunidades universitaria, local, regional, estatal, nacional y global.\n\nLa Universidad de Washington (UW) no es responsable de la exactitud de la información en su aplicación. La UW no desarrolló el sistema, no lo opera, y no la ha respaldado.\n\nLa privacidad de la información es importante para nosotros. Hacemos lo posible para mantener la seguridad y privacidad de nuestros sistemas de información clínica, pero ofrecemos esta aplicación sin ninguna seguridad o garantía.\n\nNo rastreamos la información del GPS de su teléfono. No enlazamos su dirección IP a nuestra información. Usamos un programa analítico estándar de la red (Matomo) para comprender los patrones del usuario y revisaremos los registros de acceso si sospechamos que ha habido un intento de poner en peligro el sistema de seguridad de nuestros sistemas.\n\nPuede usar esta aplicación sin ingresar ninguna información personal omitiendo las instrucciones que le piden esta información. El sistema no tendrá la misma habilidad de personalizar sus necesidades, pero aceptamos esas circunstancias. Queremos que use esta aplicación en la forma en que se sienta más cómodo.\n\nLa sección de Recursos de la aplicación está disponible para todos. Puede usar esa función sin crear una cuenta o iniciar una sesión.\n\nSi decide crear una cuenta, debe darnos su dirección de correo electrónico, pero puede usar un correo electrónico falso. Si su correo electrónico es falso, no podrá recobrar su contraseña, pero todo lo demás en la aplicación funcionará de la misma manera. Puede actualizar su correo electrónico más adelante, pero no puede cambiar su nombre de usuario.\n\nPor favor revise con atención su página de Perfil. En esa página explicamos el uso de su información personal, tal como su dirección de correo electrónico, un número de teléfono móvil, un código postal, etc. Le pedimos que bien sea use información correcta en su perfil, para así poder personalizar la aplicación para usted, o que deje estos espacios en blanco."),
    "terms_of_use_title" : MessageLookupByLibrary.simpleMessage("Términos de Uso"),
    "un_saved_alert_text" : MessageLookupByLibrary.simpleMessage("Tiene respuestas sin guardar"),
    "value_not_saved_text" : MessageLookupByLibrary.simpleMessage("Este valor no se guardará."),
    "versionString" : m5,
    "welcome" : MessageLookupByLibrary.simpleMessage("Gracias y bienvenido"),
    "what_do_you_want_to_do" : MessageLookupByLibrary.simpleMessage("¿Qué quiere hacer?"),
    "what_is_your_email_address" : MessageLookupByLibrary.simpleMessage("¿Cuál es su correo electrónico?"),
    "what_is_your_name" : MessageLookupByLibrary.simpleMessage("¿Cuál es su nombre?")
  };
}
