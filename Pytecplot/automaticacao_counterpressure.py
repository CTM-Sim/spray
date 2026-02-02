import os
import tecplot as tp

# Connect to Tecplot
tp.session.connect()

# Style path (keep your existing style file)
style_path = r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\EXPORT STYLES\enquadramento_counterpressure_style.sty"
#style_path = r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\EXPORT STYLES\enquadramento_padrao_spray_versao2.sty" # <-- Altere aqui pro seu .sty

# List of 6 simulation directories to process
simulation_dirs = [
    #r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP10\Blob\output", #KHRT-BLOBCP10
    #r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP20\BLOB\output", #KHRT-BLOBCP20
    #r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP10\RosinRammler\Sexto_teste\output", #KHRT-RRCP10
    #r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP20\Rosin_Rammler\output", #KHRT-RRBCP20
   # r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\CP10\output", #TAB-RRCP10
    #r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\CP20\output",  #TAB-RRCP20
    r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP10\thirdtry\output", #LISATABCP10
   #r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP20\thirdtry\output"  #LISATABCP20

r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\output",  
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Blob\Results_secondtest\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\Blob\Results_with_minimum\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ50\CP1\Blob\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ60\CP1\Blob\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP1\Blob\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\Rosin_Rammler test\first test\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Rosin-Rammler\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\RosinRammler\output",

r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ50\TEST\output" ,
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ60\output",
r"C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\output"
]

for sim_dir in simulation_dirs:
    # Create export directory for each simulation
    export_dir = os.path.join(sim_dir, "frames_exportadosv3")
    os.makedirs(export_dir, exist_ok=True)
    
    # List .h5 files in current directory
    h5_files = [f for f in os.listdir(sim_dir) if f.endswith(".h5")]
    
    print(f"🔍 Processing directory: {sim_dir} ({len(h5_files)} files found)")
    
    for h5_file in h5_files:
        h5_path = os.path.join(sim_dir, h5_file)
        base_name = os.path.splitext(h5_file)[0]
        
        try:
            # Create new layout and load .h5
            tp.new_layout()
            tp.data.load_converge_hdf5([h5_path])
            
            # Apply style
            frame = tp.active_frame()
            frame.load_stylesheet(style_path)
            frame.height = 9
            
            # Export as JPEG
            jpeg_path = os.path.join(export_dir, f"{base_name}.jpg")
            #tp.export.save_jpeg(jpeg_path, width=1400, supersample=3)
            tp.export.save_jpeg(jpeg_path, width=1000, supersample=3)
            print(f"  ✔ Processed: {h5_file}")
            
        except Exception as e:
            print(f"  ❌ Error processing {h5_file}: {str(e)}")
    
    print(f"✅ Finished processing directory: {sim_dir}\n")

print("🎉 All directories processed successfully!")