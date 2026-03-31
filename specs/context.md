# Technical Specification: Decoupled PPTX Generation Engine

## 1. Executive Summary
El objetivo es desarrollar un motor de automatización en Python para la generación de presentaciones de PowerPoint (`.pptx`). A diferencia de scripts de un solo uso, este sistema implementa una **arquitectura desacoplada** que separa la definición estructural de una plantilla institucional (Layouts y Placeholders) del contenido dinámico de la presentación. Esto permite la reutilización del motor con diversas plantillas sin modificar el código fuente.

## 2. System Architecture
El sistema se basa en tres componentes principales:
1.  [cite_start]**Base Template:** Archivo `.pptx` que contiene los *Slide Masters* y recursos gráficos institucionales[cite: 1, 4].
2.  **Template Map (`mapping.yml`):** Define una capa de abstracción sobre los índices técnicos de la plantilla.
3.  [cite_start]**Execution Manifest (`content.yml`):** Define el flujo y los datos específicos de la sesión a generar[cite: 273, 380].

---

## 3. Data Schema Definitions

### 3.1 Template Mapping Schema (`mapping.yml`)
Este archivo actúa como el "driver" de la plantilla. Traduce nombres semánticos a índices de la librería `python-pptx`.

```yaml
version: "1.0"
template_file: "4857105a (1).pptx"

layouts:
  portada:
    index: 1 # Slide 2 de la plantilla visual
    placeholders:
      titulo: 0
      subtitulo: 1
  agenda:
    index: 2 # Slide 3 de la plantilla visual
    placeholders:
      titulo: 0
      cuerpo: 1
  contenido_estandar:
    index: 3 # Slide 4 de la plantilla visual
    placeholders:
      titulo: 0
      cuerpo: 1
  cierre:
    index: 4 # Slide 5 de la plantilla visual
    placeholders:
      mensaje: 0
```

### 3.2 Execution Manifest Schema (`content.yml`)
Define la instancia específica de la presentación.

```yaml
config:
  map_ref: "mapping.yml"
  output_file: "output/Sesion_Ecoturismo_01.pptx"

slides:
  - layout: "portada"
    data:
      titulo: "CALIDAD Y SEGURIDAD EN SALUD"
      subtitulo: "NÚCLEO 2025"
  - layout: "contenido_estandar"
    data:
      titulo: "Ecosistema: Bosque Templado Lluioso"
      cuerpo: |
        [cite_start]• Ubicación: Biobío a Chiloé[cite: 338].
        [cite_start]• Precipitación: 2.000–5.000 mm/año[cite: 341].
        [cite_start]• Especie: Alerce (Fitzroya cupressoides)[cite: 345].
```

---

## 4. Technical Requirements

### 4.1 Core Logic (`engine.py`)
El motor debe implementar una clase `PPTXGenerator` con los siguientes métodos:
* **`load_config(path)`**: Valida y carga los archivos YAML.
* **`validate_template()`**: Verifica que la cantidad de layouts y placeholders coincida con el mapeo.
* **`render()`**: Itera sobre la lista de slides del manifiesto, instancia el layout correspondiente e inyecta el texto en los placeholders mediante `shape.text`.
* **`save()`**: Realiza el volcado al sistema de archivos.

### 4.2 Diagnostic Module (`inspect`)
Debe incluir una funcionalidad de introspección para facilitar al desarrollador la creación del `mapping.yml`:
* **Comando:** `python engine.py inspect <file.pptx>`
* **Output:** Una tabla en consola que liste:
    * Nombre e Índice del Layout.
    * Índice, Nombre y Tipo de cada Placeholder (Title, Body, Picture, etc.).

### 4.3 Error Handling
* **Mapping Mismatch:** Levantar excepción si un alias de placeholder en `content.yml` no existe en `mapping.yml`.
* **Index Out of Range:** Validar que los índices de layout no superen la cantidad disponible en la presentación base.
* **Encoding:** Asegurar soporte completo para UTF-8 (especialmente para caracteres en español como tildes y eñes).

---

## 5. User Interface (CLI)
El sistema debe operarse mediante una interfaz de línea de comandos robusta (ej. usando `argparse` o `click`):

```bash
# Para generar una presentación
$ python engine.py run content.yml

# Para inspeccionar una plantilla nueva
$ python engine.py inspect template_universidad.pptx
```

## 6. Implementation Notes for Claude Code
* Utilizar la librería `PyYAML` para el parseo de archivos de configuración.
* Utilizar `python-pptx` para la manipulación del objeto binario OpenXML.
* [cite_start]Garantizar que la inyección de texto en los placeholders preserve el **z-order** y el estilo de fuente (font family, size, color) definido en el *Slide Master* de la plantilla original[cite: 4, 272].
