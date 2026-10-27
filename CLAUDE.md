# Reglas de ingeniería inversa (CLAUDE.md)

Este repositorio usa REA (`rea-agents`) como servidor MCP y CLI (`rea`).
El hook `.claude/hooks/session-start.sh` lo instala en cada sesión en la nube.
Comprueba el estado con `rea doctor`.

## Autorización
- Analiza solo objetivos que sean míos o que esté autorizado a examinar.
  Indica la base de esa autorización una vez.
- Etiqueta cada afirmación: observación (lo vi), inferencia (lo deduje)
  o desconocido.
- Cita la evidencia: dirección, bytes, pseudocódigo o punto de llamada.
  Nada de afirmaciones sin fuente.

## Flujo de trabajo
- Empieza por el resumen más pequeño, no por un volcado completo. Amplía solo
  cuando haya un hueco concreto.
- Reutiliza la sesión abierta; nunca repitas un análisis idéntico.
- Separa los hechos estáticos de los hechos en ejecución. Nunca des por
  ejecutado algo que solo has leído.

## Reconstrucción
- Construye a partir del COMPORTAMIENTO y de especificaciones públicas, nunca
  a partir de código o recursos copiados.
- Lleva un registro de obligaciones: cada comportamiento recuperado necesita
  un test que pase antes de darlo por "hecho".
