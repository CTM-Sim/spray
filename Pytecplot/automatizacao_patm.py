import tecplot as tp
from tecplot.constant import ExportFormat
import os

# Conecta ao Tecplot já aberto
tp.session.connect()

# Lista de diretórios a serem processados (substitua com seus caminhos)
diretorios = [
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Blob\Results_secondtest\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\Blob\Results_with_minimum\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ50\CP1\Blob\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ60\CP1\Blob\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP1\Blob\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\Rosin_Rammler test\first test\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Rosin-Rammler\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\RosinRammler\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ50\TEST\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ60\output",
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\output"
]

# Caminho do estilo (ajuste conforme necessário)
caminho_style = r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\EXPORT STYLES\enquadramento_padrao_spray_versao2.sty"

# Loop principal por cada diretório
for pasta_simulacoes in diretorios:
    # Cria pasta de exportação para cada diretório
    pasta_exportacao = os.path.join(pasta_simulacoes, "frames_exportadosv4")
    os.makedirs(pasta_exportacao, exist_ok=True)

    # Lista arquivos .h5 no diretório atual
    arquivos_h5 = [f for f in os.listdir(pasta_simulacoes) if f.endswith(".h5")]
    
    print(f"\n🔍 Processando diretório: {pasta_simulacoes}")
    print(f"📂 Encontrados {len(arquivos_h5)} arquivos .h5")

    # Processa cada arquivo .h5 no diretório atual
    for arquivo in arquivos_h5:
        caminho_h5 = os.path.join(pasta_simulacoes, arquivo)
        nome_base = os.path.splitext(arquivo)[0]

        try:
            # Cria novo layout e carrega o .h5
            tp.new_layout()
            tp.data.load_converge_hdf5([caminho_h5])

            # Aplica estilo
            frame = tp.active_frame()
            frame.load_stylesheet(caminho_style)
            frame.height = 6.25

            # Exporta como JPEG
            caminho_jpeg = os.path.join(pasta_exportacao, f"{nome_base}.jpg")
            tp.export.save_jpeg(caminho_jpeg, width=1400, supersample=1)
            
            print(f"✔ {arquivo} processado com sucesso!")
            
        except Exception as e:
            print(f"❌ Erro ao processar {arquivo}: {str(e)}")

print("\n✅ Todos os diretórios foram processados!")