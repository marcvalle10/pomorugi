/// Estado actual:
/// - El proyecto ya genera notificaciones visibles en la bandeja de Android
///   cuando cambia de enfoque a descanso, de descanso a enfoque, al terminar
///   toda la sesión y cuando permanece pausado demasiado tiempo.
/// - Eso cubre lo que se ve en el panel de notificaciones del teléfono.
///
/// Overlay flotante real sobre otras apps:
/// - Sigue requiriendo integrar flutter_overlay_window con permiso
///   SYSTEM_ALERT_WINDOW y un entrypoint de overlay.
/// - Esa parte no queda 100% funcional solo editando lib/; también exige
///   cambios en AndroidManifest.xml y pruebas en dispositivo real.
class AndroidOverlayNotes {
  static const manifestPermission = 'SYSTEM_ALERT_WINDOW';
}
