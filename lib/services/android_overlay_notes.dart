/// Integración sugerida para Android overlay.
///
/// Plugin recomendado: flutter_overlay_window
/// AndroidManifest.xml:
/// <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
///
/// Flujo real:
/// 1. Pedir permiso con FlutterOverlayWindow.isPermissionGranted()
/// 2. Si no existe, abrir settings del sistema.
/// 3. Mostrar bubble flotante con progreso serializado.
/// 4. Cuando se pausa la sesión, congelar también el frame del tomate/gusano.
///
/// No lo dejé cableado en este scaffold por una razón práctica:
/// el overlay ya entra en integración nativa y servicio en background,
/// no solo UI Flutter. Meterlo a medias te deja un proyecto inestable.
class AndroidOverlayNotes {
  static const manifestPermission = 'SYSTEM_ALERT_WINDOW';
}
