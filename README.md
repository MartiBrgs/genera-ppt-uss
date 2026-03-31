# Genera PPT USS

Motor de automatización para generar presentaciones PowerPoint (`.pptx`) a partir de plantillas institucionales USS y archivos YAML de configuración.

## Arquitectura

El sistema separa tres componentes:

1. **Plantilla base** (`.pptx`) — Contiene los Slide Masters y recursos gráficos institucionales.
2. **Mapping** (`mapping.yml`) — Traduce nombres semánticos a índices técnicos de la plantilla.
3. **Manifiesto** (`content.yml`) — Define el contenido y flujo de slides de cada presentación.

```
data/
  ├── 4857105a (1).pptx   # Plantilla institucional
  └── mapping.yml          # Mapeo de layouts y placeholders
content.yml                # Contenido de la presentación
engine.py                  # Motor principal
```

## Instalación

```bash
uv venv .venv
source .venv/bin/activate
uv pip install -r requirements.txt
```

## Uso

### Generar una presentación

```bash
python engine.py run content.yml
```

### Inspeccionar una plantilla

```bash
python engine.py inspect "data/4857105a (1).pptx"
```

Muestra todos los layouts disponibles con sus placeholders, útil para crear el `mapping.yml` de una plantilla nueva.

## Configuración

### mapping.yml

Define la correspondencia entre nombres semánticos y los índices reales de la plantilla:

```yaml
version: "1.0"
template_file: "4857105a (1).pptx"

layouts:
  portada:
    index: 0
    placeholders:
      titulo: 0
      subtitulo: 1
  contenido_estandar:
    index: 3
    placeholders:
      titulo: 0
      cuerpo: 1
```

### content.yml

Define el contenido de la presentación:

```yaml
config:
  map_ref: "data/mapping.yml"
  output_file: "output/Mi_Presentacion.pptx"
  font_size_titulo: 28
  font_size_cuerpo: 18

slides:
  - layout: "portada"
    data:
      titulo: "MI PRESENTACION"
      subtitulo: "Subtitulo aqui"

  - layout: "contenido_estandar"
    data:
      titulo: "Primer tema"
      cuerpo: |
        Linea 1
        Linea 2
        Linea 3
```

### Tamaño de fuente

Se puede configurar por tipo de placeholder a nivel global (`config`) o por slide (`style`):

```yaml
config:
  font_size_titulo: 28    # Global para títulos
  font_size_cuerpo: 18    # Global para cuerpo

slides:
  - layout: "contenido_estandar"
    style:
      font_size_cuerpo: 14  # Override solo para este slide
    data:
      titulo: "..."
      cuerpo: "..."
```

Prioridad: `style` del slide > `config` global > formato de la plantilla.

## Layouts disponibles

| Nombre en YAML | Layout en plantilla | Placeholders |
|---|---|---|
| `portada` | PORTADA | titulo, subtitulo |
| `portada_alt` | PORTADA opcion 2 | titulo, subtitulo |
| `portadilla` | PORTADILLA | titulo |
| `contenido_estandar` | INTERIOR | titulo, cuerpo |
| `cierre` | CIERRE | (sin placeholders) |

## Dependencias

- Python 3.10+
- python-pptx
- PyYAML
