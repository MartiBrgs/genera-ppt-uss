"""Interfaz web para Genera PPT USS."""

import io
from pathlib import Path

import streamlit as st
import yaml

from engine import PPTXGenerator, MappingError, TemplateError

CLASES_DIR = Path("clases")


def list_clases():
    """Lista los archivos .yml disponibles en clases/."""
    files = sorted(CLASES_DIR.glob("*.yml"))
    return [f for f in files if f.name != "_plantilla.yml"]


def load_yaml(path):
    """Carga un archivo YAML."""
    with open(path, encoding="utf-8") as f:
        return yaml.safe_load(f)


def render_preview(content):
    """Muestra una vista previa del contenido."""
    config = content.get("config", {})
    slides = content.get("slides", [])

    st.markdown(f"**Archivo de salida:** `{config.get('output_file', 'N/A')}`")

    font_t = config.get("font_size_titulo")
    font_c = config.get("font_size_cuerpo")
    if font_t or font_c:
        cols = st.columns(2)
        if font_t:
            cols[0].metric("Font titulo", f"{font_t} pt")
        if font_c:
            cols[1].metric("Font cuerpo", f"{font_c} pt")

    st.divider()

    for i, slide in enumerate(slides, 1):
        layout = slide.get("layout", "?")
        data = slide.get("data", {})

        with st.container(border=True):
            st.caption(f"Slide {i} — `{layout}`")
            for key, value in data.items():
                if key == "titulo":
                    st.markdown(f"**{value}**")
                else:
                    st.text(str(value).strip())


def generate_pptx(yml_path):
    """Genera el PPTX y retorna los bytes."""
    gen = PPTXGenerator()
    gen.load_config(str(yml_path))
    gen.validate_template()
    gen.render()

    buffer = io.BytesIO()
    gen.prs.save(buffer)
    buffer.seek(0)
    return buffer


def main():
    st.set_page_config(page_title="Genera PPT USS", page_icon="📊", layout="centered")
    st.title("Genera PPT USS")

    clases = list_clases()

    if not clases:
        st.warning("No hay archivos `.yml` en la carpeta `clases/`. Copia `_plantilla.yml` y renombralo.")
        st.stop()

    # Selector de clase
    nombres = [f.stem for f in clases]
    selected_idx = st.selectbox("Selecciona una clase", range(len(nombres)), format_func=lambda i: nombres[i])
    selected_file = clases[selected_idx]

    # Vista previa
    content = load_yaml(selected_file)
    st.subheader("Vista previa")
    render_preview(content)

    # Botón generar
    st.divider()
    if st.button("Generar presentacion", type="primary", use_container_width=True):
        try:
            with st.spinner("Generando..."):
                buffer = generate_pptx(selected_file)

            output_name = Path(content["config"]["output_file"]).name
            st.success("Presentacion generada!")
            st.download_button(
                label="Descargar PPTX",
                data=buffer,
                file_name=output_name,
                mime="application/vnd.openxmlformats-officedocument.presentationml.presentation",
                use_container_width=True,
            )
        except (MappingError, TemplateError) as e:
            st.error(f"Error: {e}")
        except Exception as e:
            st.error(f"Error inesperado: {e}")


if __name__ == "__main__":
    main()
