import tecplot as tp
from tecplot.constant import ExportFormat
import os

# Conecta ao Tecplot já aberto
tp.session.connect()

# Caminhos
pasta_simulacoes = r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\CP20\output" # <-- Altere aqui a pasta com o output .h5 do converge
caminho_style = r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\EXPORT STYLES\enquadramento_counterpressure_style.sty"  # <-- Altere aqui pro seu .sty
pasta_exportacao = os.path.join(pasta_simulacoes, "frames_exportados")
os.makedirs(pasta_exportacao, exist_ok=True)

# Lista os arquivos .h5
arquivos_h5 = [f for f in os.listdir(pasta_simulacoes) if f.endswith(".h5")]

# Loop para processar cada .h5
for arquivo in arquivos_h5:
    caminho_h5 = os.path.join(pasta_simulacoes, arquivo)
    nome_base = os.path.splitext(arquivo)[0]

    # Cria novo layout e carrega o .h5 usando load_converge_hdf5()
    tp.new_layout()
    tp.data.load_converge_hdf5([caminho_h5])  # Carrega o arquivo .h5 do CONVERGE

    # Aplica o estilo do frame (.sty) com load_stylesheet()
    frame = tp.active_frame()
    frame.load_stylesheet(caminho_style)

    # Ajusta altura do frame ativo
    frame.height = 9

    # Exporta o frame como JPEG
    caminho_jpeg = os.path.join(pasta_exportacao, f"{nome_base}.jpg")
    tp.export.save_jpeg(caminho_jpeg, width=448, supersample=1)

print("✅ Todos os arquivos .h5 foram processados com sucesso!")
