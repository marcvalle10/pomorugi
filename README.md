# 🕒 PomoRugi - Pomodoro (Flutter)

Aplicación móvil desarrollada en **Flutter** con un temporizador Pomodoro interactivo y dibujo procedural tipo sketch. El objetivo es mejorar productividad y descanso con una UI estilo cuaderno, animaciones suaves y controles claros.

<br>
<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/images/logo_unison.png" width="120" alt="Unison Logo"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/icons/icon_app.png" width="120" alt="PomoRugi Logo"/>
</td>
</tr>
</table>
</div>

<br><br>

---

## 👨‍💻 Autores

- Vallejo Leyva Marcos
- Casas Gastelum Ana Cecilia
- Murillo Monga Joshua David

---

## 📌 Descripción

**PomoRugi** es una aplicación Pomodoro que:

- Configura duración de trabajo, descanso corto y ciclos totales desde la pantalla inicial.
- Controla fases: `focus`, `shortBreak`, y `summary` usando `PomodoroController`.
- Integra un anillo de progreso con animaciones (`SketchProgressPainter`).
- Dibuja un patrón procedural visible durante el foco para estimulacion creativa.
- Permite pausar/reanudar, saltar fases y finalizar sesión con confirmación.
- Crea resumen final con total de ciclos, tiempo de enfoque y tiempo de descanso.
- Usa estilos visuales tipo papel con `PaperBackground`, `SketchCard` y `Caveat`.

---

## 🛠 Tecnologías Utilizadas

### 📱 Desarrollo

- Flutter SDK (3.x o mayor)
- Dart (3.x)
- Provider para gestión reactiva de estado

### 🎨 UI / UX

- Estética notebook / papel arrugado
- Tipografía manual (`Caveat`) y sistema de colores consistente
- Widgets composables (`SketchCard`, `PaperBackground`)
- Animaciones de fase y transición de color en pantalla de cronómetro

### 🔧 Control de Versiones

- Git
- GitHub

---

## 🖼 Imágenes de la aplicación

### Icono de la app

<div align="center">
<img src="assets/icons/icon_app.png" width="140" alt="App Icon" />
</div>

## Instalarción

<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/PomoRugi/insta_i.png" width="220" alt="Setup Screen"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/insta_acabo.png" width="220" alt="Timer Screen"/>
</td>
</tr>
</table>
</div>

### Interfaz principal y navegación

<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/PomoRugi/setup_sample.png" width="220" alt="Setup Screen"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/timer_sample_1.png" width="220" alt="Timer Screen"/>
</td>
</tr>
</table>
</div>

<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/PomoRugi/timer_sample_2.png" width="220" alt="Timer Screen"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/timer_sample_3.png" width="220" alt="Timer Screen"/>
</td>
</tr>
</table>
</div>

<div align="center">
<table>
<tr>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/timer_sample_4.png" width="220" alt="Timer Screen"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/alerta_1.png" width="220" alt="Ejemplo Alerta"/>
</td>
</tr>
</table>
</div>

<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/PomoRugi/alerta_2.png" width="220" alt="Ejemplo Alerta"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/alerta_3.png" width="220" alt="Ejemplo Alerta"/>
</td>
</tr>
</table>
</div>

<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/PomoRugi/alerta_4.png" width="220" alt="Ejemplo Alerta"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/alerta_5.png" width="220" alt="Ejemplo Alerta"/>
</td>
</tr>
</table>
</div>

<div align="center">
<table>
<tr>
<td align="center">
<b>Setup Screen</b><br><br>
<img src="assets/PomoRugi/alerta_6.png" width="220" alt="Ejemplo Alerta"/>
</td>
<td align="center">
<b>Timer Screen</b><br><br>
<img src="assets/PomoRugi/alerta_7.png" width="220" alt="Ejemplo Alerta"/>
</td>
</tr>
</table>
</div>

### Resultados y resumen

<div align="center">
<table>
<tr>
<td align="center">
<b>Summary Screen</b><br><br>
<img src="assets/PomoRugi/summary_sample.png" width="220" alt="Summary Screen"/>
</td>
</tr>
</table>
</div>

---

## 📂 Estructura del Proyecto (`lib/`)

```bash
lib/
├── main.dart                          # Punto de entrada de la app que inyecta providers y rutas
├── app.dart                           # Definición de rutas con NamedRoutes y tema global
│
├── controllers/
│   └── pomodoro_controller.dart       # Lógica central Pomodoro (tiempo, avance, fases, ciclo, resumen)
│
├── models/
│   ├── pomodoro_config.dart           # Configuración de tiempos y ciclos (work/break)
│   ├── session_phase.dart             # Enum de fases: setup, focus, shortBreak, summary
│   └── session_summary.dart           # Resumen final (ciclos completados, focus/break)
│
├── screens/
│   ├── setup_screen.dart              # UI de configuración (sliders + iniciar sesión)
│   ├── timer_screen.dart              # UI principal de Pomodoro + control de fases
│   └── summary_screen.dart            # UI de resultados y volver a iniciar
│
├── services/
│   └── sketch_generator.dart          # Generador random de patrones de dibujo procedural
│
└── widgets/
    ├── paper_background.dart          # Pintor de fondo estilo papel con reglas/dots/hojas
    ├── sketch_card.dart               # Tarjeta con borde dibujado y efecto handcrafted
    └── sketch_progress_painter.dart   # Pintor del anillo de progreso + sketch reveal/caos
```

---

## � Descripción detallada de clases y componentes

### controllers/pomodoro_controller.dart

- Clase: `PomodoroController` (extiende `ChangeNotifier`)
- Propiedades claves:
  - `PomodoroConfig config`, `SessionPhase phase`, `Duration remaining`, `int currentCycle`, `bool isRunning`
  - Acumuladores: `_accFocus`, `_accBreak`
  - Dibujo procedural: `_pattern` (`SketchPattern`)
- Funciones:
  - `start()`, `pause()`, `toggle()`
  - `skipPhase()`, `resetSession()`, `buildSummary()`
  - `_tick()`, `_advancePhase()`, `_registerCompletedSecond()`
- Métodos de UI: `formattedRemaining`, `phaseProgress`, `sketchRevealProgress`, `chaosVisibility`, `statusLabel`, `randomBreakMessage()`

### models/pomodoro_config.dart

- Clase: `PomodoroConfig`
- Valores: `workMinutes`, `breakMinutes`, `totalCycles`
- Getters: `workDuration`, `breakDuration`

### models/session_phase.dart

- `enum SessionPhase { setup, focus, shortBreak, summary }`

### models/session_summary.dart

- Clase: `SessionSummary` con datos finales de sesión
- Método `format(Duration)` da formato de string amigable

### screens/setup_screen.dart

- Configuración inicial con sliders y botones:
  - `work`, `shortBreak`, `cycles`
  - `COMENZAR` crea `PomodoroConfig` y navega a `TimerScreen`
- Elementos UI: `S ketchCard` con datos de equipo, controles de slider, botones +/-

### screens/timer_screen.dart

- Muestra estado actual y controla el ciclo con `Provider<PomodoroController>`
- Dibuja progreso con `SketchProgressPainter` y muestra timer
- Botones interactivos: Pausa/Reanuda, Saltar, Salir sesión
- Transición automática a `SummaryScreen` al completar ciclos

### screens/summary_screen.dart

- Muestra mensaje motivacional según ciclos completados
- Estadísticas de sesión y resumen con botón `Nueva Sesión`

### services/sketch_generator.dart

- Generador de patrones aleatorios para el dibujo procedural
- Define tipos de raster/stroke usados por `SketchProgressPainter`

### widgets/paper_background.dart

- `PaperBackground` con líneas de cuaderno, puntos y selected leaves

### widgets/sketch_card.dart

- `SketchCard` con borde pintado y sombra

### widgets/sketch_progress_painter.dart

- `SketchProgressPainter` con anillo, cuerpo, cabeza animada y dibujo "reveal"

---

---

## �🧩 Flujo principal de la app

1. Usuario abre la app en `SetupScreen`.
2. Ajusta `workMinutes`, `breakMinutes`, `totalCycles`.
3. Presiona `COMENZAR` → se crea `PomodoroConfig` y navega a `TimerScreen`.
4. `PomodoroController` controla ciclo de foco/pausa, actualiza progresos y notifica cambios.
5. En `TimerScreen`, el `SketchProgressPainter` actualiza animaciones y se muestra tiempo restante.
6. Cuando se completa `totalCycles`, se navega a `SummaryScreen` con `SessionSummary`.

---

## 🔍 Componentes clave

- `PomodoroController`:
  - `start()`, `pause()`, `toggle()`, `skipPhase()`, `resetSession()`
  - Tiempo restante, progreso de fase, acumulado de focus/break, mensajes de pausa.
  - Transición automática entre fases y generación del resumen.

- `SketchProgressPainter`:
  - Circular progress bar con segmentos, cabezal animado, guía y caja de caos.
  - Dibujo procedural durante fase focus (chaos + reveal).

- `PaperBackground` y `SketchCard`:
  - Diseños visuales manuscritos y efecto de papel con líneas/cuadros/dibujo suave.

---

## 🏁 Instrucciones para ejecutar

```bash
flutter clean
flutter pub get
flutter run
```

### Generar APK

```bash
flutter build apk --release
```

Archivo generado:

```
build/app/outputs/flutter-apk/app-release.apk
```

## 🧪 Estado actual / próximos pasos

- ✅ Funcionalidad Pomodoro completa (setup, timer, resumen)
- ✅ experiencia visual distintiva con sketch procedural
- ⚙️ Mejoras recomendadas: persistencia local (SharedPreferences/SQLite), notificaciones en background, tests unitarios e integración, internacionalización.

---

## 📝 Notas adicionales

- El nombre interno de la app en UI es `PomoRugi`.
- El estilo visual se basa en colores amigables, fuentes manuscritas y diseño inspirado en cuaderno.
- Se incluyen íconos SVG / `.png` en `assets/images`, uso de `assets/images/logo_unison.png`.
