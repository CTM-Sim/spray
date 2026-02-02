clear all
close all
clc

% Definindo os diretórios para cada modelo e pressão
dir_KHRT_PINJ50 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\output\frames_exportados';  
dir_KHRT_PINJ60 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Blob\Results_secondtest\output\frames_exportados';
dir_KHRT_PINJ70 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\Blob\Results_with_minimum\output\frames_exportados';

dir_LISA_TAB_PINJ50 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ50\CP1\Blob\output\frames_exportados';
dir_LISA_TAB_PINJ60 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ60\CP1\Blob\output\frames_exportados';
dir_LISA_TAB_PINJ70 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP1\Blob\output\frames_exportados';

% Criando uma estrutura de células para armazenar todos os diretórios
diretorios = {
    struct('modelo', 'KHRT', 'pressao', 'PINJ50', 'path', dir_KHRT_PINJ50);
    struct('modelo', 'KHRT', 'pressao', 'PINJ60', 'path', dir_KHRT_PINJ60);
    struct('modelo', 'KHRT', 'pressao', 'PINJ70', 'path', dir_KHRT_PINJ70);
    struct('modelo', 'LISA_TAB', 'pressao', 'PINJ50', 'path', dir_LISA_TAB_PINJ50);
    struct('modelo', 'LISA_TAB', 'pressao', 'PINJ60', 'path', dir_LISA_TAB_PINJ60);
    struct('modelo', 'LISA_TAB', 'pressao', 'PINJ70', 'path', dir_LISA_TAB_PINJ70);
};

% Parâmetros da rotina (mantidos como no seu código original)
i1_sim = 31;
i2_sim = 600;
j1_sim = 80;
j2_sim = 864;
DR_sim = 23.52;
corte_sim = 255;

% Loop através de todos os diretórios
for d = 1:length(diretorios)
    current_dir = diretorios{d};
    fprintf('Processando: Modelo %s, Pressão %s\n', current_dir.modelo, current_dir.pressao);
    
    % Obter lista de arquivos de imagem no diretório
    imagefiles = dir(fullfile(current_dir.path, '*.jpg')); % ou '*.jpg' etc
    nfiles = length(imagefiles);
    
    % Inicializar variáveis de armazenamento para este diretório
    dx_e_sim = []; dy_e_sim = [];
    dx_d_sim = []; dy_d_sim = [];
    dx_i_sim = []; dy_i_sim = [];
    dx_s_sim = []; dy_s_sim = [];
    
    % Executar sua rotina de detecção de bordas
    l = 1;
    eta = 0;
    
    for n = 1:nfiles
        eta = 1 + eta;
        currentfilename{n} = imagefiles(n).name;  
        A_sim(:,:,1,n) = im2gray(imread(fullfile(current_dir.path, imagefiles(n).name)));
        
        % Detecção da borda esquerda
        k = 0;
        for i = i1_sim:i2_sim
            m = 0;
            for j = 2:800
                x(i,j,l,n) = (j-1)/DR_sim;
                y(i,j,l,n) = -(i-1)/DR_sim;
                if A_sim(i,j,l,n) >= corte_sim && m == 0
                    m = 1;
                    k = k+1;
                    dx_e_sim(k,l,n) = x(i,j,l,n);
                    dy_e_sim(k,l,n) = y(i,j,l,n);
                    A_sim(i,j,l,n) = 255;
                end
            end
        end
        
        % Detecção da borda direita
        k = 0;
        for i = i1_sim:i2_sim
            m = 0;
            for j = 800:-1:1
                if A_sim(i,j,l,n) >= corte_sim && m == 0
                    m = 1;
                    k = k+1;
                    dx_d_sim(k,l,n) = x(i,j,l,n);
                    dy_d_sim(k,l,n) = y(i,j,l,n);
                    A_sim(i,j,l,n) = 255;
                end
            end
        end
        
        % Detecção da borda inferior
        k = 0;
        for j = j1_sim:j2_sim
            m = 0;
            for i = i2_sim:-1:i1_sim
                x(i,j,l,n) = (j)/DR_sim;
                y(i,j,l,n) = -(i)/DR_sim;
                if A_sim(i,j,l,n) >= corte_sim && m == 0
                    m = 1;
                    k = k+1;
                    dx_i_sim(k,l,n) = x(i,j,l,n);
                    dy_i_sim(k,l,n) = y(i,j,l,n);
                    A_sim(i,j,l,n) = 255;
                end
            end
        end
        
        % Detecção da borda superior
        k = 0;
        for j = j1_sim:j2_sim
            m = 0;
            for i = i1_sim:i2_sim
                if A_sim(i,j,l,n) >= corte_sim && m == 0
                    m = 1;
                    k = k+1;
                    dx_s_sim(k,l,n) = x(i,j,l,n);
                    dy_s_sim(k,l,n) = y(i,j,l,n);
                    A_sim(i,j,l,n) = 255;
                end
            end
        end
    end
      
    % Limpar variáveis temporárias para o próximo diretório
    clear A_sim x y currentfilename
end

