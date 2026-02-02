clear all
close all
clc



%% Diretorios

dir_KHRT_Blob_PINJ50 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\output\frames_exportados';  
dir_KHRT_Blob_PINJ60 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Blob\Results_secondtest\output\frames_exportados';
dir_KHRT_Blob_PINJ70 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\Blob\Results_with_minimum\output\frames_exportados';

dir_LISA_TAB_PINJ50 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ50\CP1\Blob\output\frames_exportados';
dir_LISA_TAB_PINJ60 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ60\CP1\Blob\output\frames_exportados';
dir_LISA_TAB_PINJ70 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP1\Blob\output\frames_exportados';

dir_KHRT_RR_PINJ50 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Blob\Rosin_Rammler test\first test\output\frames_exportados';
dir_KHRT_RR_PINJ60 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ60\CP1\Rosin-Rammler\output\frames_exportados';
dir_KHRT_RR_PINJ70 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP1\RosinRammler\output\frames_exportados';

dir_TAB_RR_PINJ50 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ50\TEST\output\frames_exportados'; 
dir_TAB_RR_PINJ60 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ60\output\frames_exportados';
dir_TAB_RR_PINJ70 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\output\frames_exportados';

% Criando uma estrutura de células para armazenar todos os diretórios
diretorios = {
    struct('modelo', 'KHRT_Blob', 'pressao', 'PINJ50', 'path', dir_KHRT_Blob_PINJ50);
    struct('modelo', 'KHRT_Blob', 'pressao', 'PINJ60', 'path', dir_KHRT_Blob_PINJ60);
    struct('modelo', 'KHRT_Blob', 'pressao', 'PINJ70', 'path', dir_KHRT_Blob_PINJ70);
    struct('modelo', 'LISA_TAB', 'pressao', 'PINJ50', 'path', dir_LISA_TAB_PINJ50);
    struct('modelo', 'LISA_TAB', 'pressao', 'PINJ60', 'path', dir_LISA_TAB_PINJ60);
    struct('modelo', 'LISA_TAB', 'pressao', 'PINJ70', 'path', dir_LISA_TAB_PINJ70);
    struct('modelo', 'KHRT_RR', 'pressao', 'PINJ50', 'path', dir_KHRT_RR_PINJ50);
    struct('modelo', 'KHRT_RR', 'pressao', 'PINJ60', 'path', dir_KHRT_RR_PINJ60);
    struct('modelo', 'KHRT_RR', 'pressao', 'PINJ70', 'path', dir_KHRT_RR_PINJ70);
    struct('modelo', 'TAB_RR', 'pressao', 'PINJ50', 'path', dir_TAB_RR_PINJ50);
    struct('modelo', 'TAB_RR', 'pressao', 'PINJ60', 'path', dir_TAB_RR_PINJ60);
    struct('modelo', 'TAB_RR', 'pressao', 'PINJ70', 'path', dir_TAB_RR_PINJ70);
};


%% Rotina de calculo da simulacao

% Parâmetros da rotina 
i1_sim = 31;
i2_sim = 600;
j1_sim = 80;
j2_sim = 864;
DR_sim =18.84; %densidade de resolução, pixels/cm -> mudar para cada experimento.
corte_sim = 255; %para simulação no converge, o corte não precisa ser modificado

% Parâmetros do injetor (adicionados do primeiro código)
linhavertice_sim = 34; % Linha na matriz referente à extremidade do injetor
colunavertice_sim = 306; % Coluna da matriz referente à extremidade do injetor
xv_sim = (colunavertice_sim-1)/DR_sim; % posição x em centímetros
yv_sim = -(linhavertice_sim-1)/DR_sim; % posição y em centímetros
pontos = 30; % Número de pontos para o polyfit (ajuste conforme necessário)
DeltaT = 0.303; % Intervalo de tempo entre imagens (ajuste conforme necessário)

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



    % Cálculos adicionais (do primeiro código que você enviou)
    % Inicializar variáveis para armazenar resultados
    Pd_sim = []; Pe_sim = []; angulo_sim = [];
    angulovd_sim = []; angulove_sim = [];
    desviod_sim = []; desvioe_sim = [];
    S_sim = []; Tempo = []; Tempoangulo = [];
    
    % Ajuste: verificar se temos frames suficientes para n=3:19
    max_n = min(19, nfiles); % Não ultrapassar o número de arquivos disponíveis
    
    for l = 1:1:1
        for n = 3:1:max_n
            % Verificar se temos dados suficientes para o polyfit
            if size(dx_d_sim,1) >= pontos && size(dx_e_sim,1) >= pontos
                Pd_sim(:,:,l,n-2) = polyfit(dx_d_sim(1:pontos,l,n), dy_d_sim(1:pontos,l,n), 1);
                Pe_sim(:,:,l,n-2) = polyfit(dx_e_sim(1:pontos,l,n), dy_e_sim(1:pontos,l,n), 1);
                
                % Cálculo dos ângulos
                angulo_sim(l,n-2) = (180/pi)*atan(abs((Pd_sim(1,1,l,n-2)-Pe_sim(1,1,l,n-2))/(1+Pd_sim(1,1,l,n-2)*Pe_sim(1,1,l,n-2))));
                angulovd_sim(l,n-2) = (180/pi)*atan(abs((1)/(Pd_sim(1,1,l,n-2))));
                angulove_sim(l,n-2) = (180/pi)*atan(abs((1)/(Pe_sim(1,1,l,n-2))));
                desviod_sim(l,n-2) = angulovd_sim(l,n-2)-((angulovd_sim(l,n-2)+angulove_sim(l,n-2))/2);
                desvioe_sim(l,n-2) = angulove_sim(l,n-2)-((angulovd_sim(l,n-2)+angulove_sim(l,n-2))/2);
               
            end
        end
        
        for n = 1:1:max_n
            if ~isempty(dy_i_sim)
                S_sim(l,n) = yv_sim - min(dy_i_sim(:,l,n));
            end
        end
    end
    
    for n = 1:1:max_n
        Tempo(n) = DeltaT/2 + (n-1)*DeltaT;
    end
    
    for n = 3:1:max_n
        Tempoangulo(n-2) = 5*(DeltaT/2) + (n-3)*DeltaT;
    end

    
    % Armazenar todos os resultados na estrutura diretorios
    diretorios{d}.resultados = struct(...
        'Pd_sim', Pd_sim, ...
        'Pe_sim', Pe_sim, ...
        'angulo_sim', angulo_sim, ...
        'angulovd_sim', angulovd_sim, ...
        'angulove_sim', angulove_sim, ...
        'desviod_sim', desviod_sim, ...
        'desvioe_sim', desvioe_sim, ...
        'S_sim', S_sim, ...
        'Tempo', Tempo, ...
        'Tempoangulo', Tempoangulo, ...
        'xv_sim', xv_sim, ...
        'yv_sim', yv_sim, ...
        'dx_e_sim', dx_e_sim, ...
        'dy_e_sim', dy_e_sim, ...
        'dx_d_sim', dx_d_sim, ...
        'dy_d_sim', dy_d_sim, ...
        'dx_i_sim', dx_i_sim, ...
        'dy_i_sim', dy_i_sim, ...
        'dx_s_sim', dx_s_sim, ...
        'dy_s_sim', dy_s_sim);
        
    
    % Limpar variáveis temporárias para o próximo diretório
    clear A_sim x y currentfilename Pd_sim Pe_sim angulo_sim angulovd_sim angulove_sim desviod_sim desvioe_sim S_sim Tempo Tempoangulo
end


%% Salvando a estrutura diretorios na pasta de trabalho
save(fullfile(pwd, 'resultados_diretorios.mat'), 'diretorios');
disp('Estrutura diretorios salva com sucesso na pasta de trabalho como resultados_diretorios.mat');