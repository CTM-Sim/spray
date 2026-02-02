clear all
close all
clc



%% Diretorios PINJ70

dir_KHRT_Blob_PINJ70_CP10 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP10\Blob\output\frames_exportadosv2';
dir_KHRT_Blob_PINJ70_CP20 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP20\BLOB\output\frames_exportadosv2';

dir_LISA_TAB_PINJ70_CP10 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP10\secondtry\output\frames_exportadosv2';
dir_LISA_TAB_PINJ70_CP20 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP20\secondtry\output\frames_exportadosv2';

dir_KHRT_RR_PINJ70_CP10 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP10\RosinRammler\Sexto_teste\output\frames_exportadosv2';
dir_KHRT_RR_PINJ70_CP20 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ70\CP20\Rosin_Rammler\output\frames_exportadosv2';

dir_TAB_RR_PINJ70_CP10 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\CP10\output\frames_exportadosv2';
dir_TAB_RR_PINJ70_CP20 = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\TAB\PINJ70\CP20\output\frames_exportadosv2';

% Criando uma estrutura de células para armazenar todos os diretórios
diretorios = {
    struct('modelo', 'KHRT_Blob', 'contrapressao', 'CP10', 'path', dir_KHRT_Blob_PINJ70_CP10);
    struct('modelo', 'KHRT_Blob', 'contrapressao', 'CP20', 'path', dir_KHRT_Blob_PINJ70_CP20);
    struct('modelo', 'LISA_TAB', 'contrapressao', 'CP10', 'path', dir_LISA_TAB_PINJ70_CP10);
    struct('modelo', 'LISA_TAB', 'contrapressao', 'CP20', 'path', dir_LISA_TAB_PINJ70_CP20);
    struct('modelo', 'KHRT_RR', 'contrapressao', 'CP10', 'path', dir_KHRT_RR_PINJ70_CP10);
    struct('modelo', 'KHRT_RR', 'contrapressao', 'CP20', 'path', dir_KHRT_RR_PINJ70_CP20);
    struct('modelo', 'TAB_RR', 'contrapressao', 'CP10', 'path', dir_TAB_RR_PINJ70_CP10);
    struct('modelo', 'TAB_RR', 'contrapressao', 'CP20', 'path', dir_TAB_RR_PINJ70_CP20);
};


%% Rotina de calculo da simulacao

% Parâmetros da rotina 

% i1_sim = 15;
i1_sim = 37;
%i2_sim = 448;
i2_sim = 997;
% j1_sim = 20;
j1_sim = 20;
%j2_sim = 448;
j2_sim = 997;
%DR_sim = 9.575472;
DR_sim = 21.7647;% Valor do código 2
corte_sim = 255;
%DR_sim = 36.36;
%DR_sim = 15.0944;
%DR_sim = 19.38;
%DR_sim=11.86;

% Parâmetros do injetor (mantidos do código 1 com ajuste de linha/coluna)
% linhavertice_sim = 17; % Ajustado para valor do código 2
% colunavertice_sim = 156; % Mantido do código 1
linhavertice_sim = 37; % Ajustado para valor do código 2
colunavertice_sim = 348; % Mantido do código 1
xv_sim = (colunavertice_sim-1)/DR_sim; % posição x em centímetros
yv_sim = -(linhavertice_sim-1)/DR_sim; % posição y em centímetros
pontos = 30; % Número de pontos para o polyfit
DeltaT = 0.1515; % Intervalo de tempo entre imagens
Numerodeinjecoes_sim = 20; % Novo parâmetro do código 2

% Loop através de todos os diretórios
for d = 1:length(diretorios)
    current_dir = diretorios{d};
    fprintf('Processando: Modelo %s, Contrapressão %s\n', current_dir.modelo, current_dir.contrapressao);
    
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
        for i = i1_sim:1:i2_sim
            m = 0;
            for j = 2:1:997
                x(i,j,l,n) = (j-1)/DR_sim;
                y(i,j,l,n) = -(i-1)/DR_sim;
                if A_sim(i,j,l,n) >= corte_sim & m == 0
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
        for i = i1_sim:1:i2_sim
            m = 0;
            for j = 997:-1:1  
                if A_sim(i,j,l,n) >= corte_sim & m == 0
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
        for j = j1_sim:1:j2_sim
            m = 0;
            for i = i2_sim:-1:i1_sim
                x(i,j,l,n) = (j)/DR_sim;
                y(i,j,l,n) = -(i)/DR_sim;
                if A_sim(i,j,l,n) >= corte_sim & m == 0
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
        for j = j1_sim:1:j2_sim
            m = 0;
            for i = i1_sim:1:i2_sim
                if A_sim(i,j,l,n) >= corte_sim & m == 0
                    m = 1;
                    k = k+1;
                    dx_s_sim(k,l,n) = x(i,j,l,n);
                    dy_s_sim(k,l,n) = y(i,j,l,n);
                    A_sim(i,j,l,n) = 255;
                end
            end
        end
    end
    
    
    % Cálculos adicionais com limite de NumeroDeInjecoes
    Pd_sim = []; Pe_sim = []; angulo_sim = [];
    angulovd_sim = []; angulove_sim = [];
    desviod_sim = []; desvioe_sim = [];
    S_sim = []; Tempo = []; Tempoangulo = [];
    
    % Ajuste: verificar se temos frames suficientes para n=3:19
    max_n = max(Numerodeinjecoes_sim, nfiles); % Não ultrapassar o número de arquivos disponíveis
    
    for l = 1:1:1
        % for n = 3:1:20
        % 
        %     %Verificar se temos dados suficientes para o polyfit
        %     if size(dx_d_sim,1) >= pontos && size(dx_e_sim,1) >= pontos
        %         Pd_sim(:,:,l,n-2) = polyfit(dx_d_sim(1:pontos,l,n), dy_d_sim(1:pontos,l,n), 1);
        %         Pe_sim(:,:,l,n-2) = polyfit(dx_e_sim(1:pontos,l,n), dy_e_sim(1:pontos,l,n), 1);
        % 
        %         % Cálculo dos ângulos
        %         angulo_sim(l,n-2) = (180/pi)*atan(abs((Pd_sim(1,1,l,n-2)-Pe_sim(1,1,l,n-2))/(1+Pd_sim(1,1,l,n-2)*Pe_sim(1,1,l,n-2))));
        %         angulovd_sim(l,n-2) = (180/pi)*atan(abs((1)/(Pd_sim(1,1,l,n-2))));
        %         angulove_sim(l,n-2) = (180/pi)*atan(abs((1)/(Pe_sim(1,1,l,n-2))));
        %         desviod_sim(l,n-2) = angulovd_sim(l,n-2)-((angulovd_sim(l,n-2)+angulove_sim(l,n-2))/2);
        %         desvioe_sim(l,n-2) = angulove_sim(l,n-2)-((angulovd_sim(l,n-2)+angulove_sim(l,n-2))/2);
        % 
        %     end
        % end
for n = 3:1:20
    %Verificar se temos dados suficientes para o polyfit
    if size(dx_d_sim,1) >= pontos && size(dx_e_sim,1) >= pontos
        % Ajustar as coordenadas relativas ao vértice do cone
        dx_d_adj = dx_d_sim(1:pontos,l,n) - xv_sim;
        dy_d_adj = dy_d_sim(1:pontos,l,n) - yv_sim;
        dx_e_adj = dx_e_sim(1:pontos,l,n) - xv_sim;
        dy_e_adj = dy_e_sim(1:pontos,l,n) - yv_sim;
        
        % Realizar o ajuste linear com as coordenadas ajustadas
        Pd_sim(:,:,l,n-2) = polyfit(dx_d_adj, dy_d_adj, 1);
        Pe_sim(:,:,l,n-2) = polyfit(dx_e_adj, dy_e_adj, 1);

        % Cálculo dos ângulos relativos ao vértice
        angulo_sim(l,n-2) = (180/pi)*atan(abs((Pd_sim(1,1,l,n-2)-Pe_sim(1,1,l,n-2))/(1+Pd_sim(1,1,l,n-2)*Pe_sim(1,1,l,n-2))));
        
        % Ângulos das retas em relação ao eixo x (passando pelo vértice)
        angulovd_sim(l,n-2) = (180/pi)*atan(abs(Pd_sim(1,1,l,n-2)));
        angulove_sim(l,n-2) = (180/pi)*atan(abs(Pe_sim(1,1,l,n-2)));
        
        % Cálculo dos desvios
        angulo_medio = (angulovd_sim(l,n-2) + angulove_sim(l,n-2))/2;
        desviod_sim(l,n-2) = angulovd_sim(l,n-2) - angulo_medio;
        desvioe_sim(l,n-2) = angulove_sim(l,n-2) - angulo_medio;
    end
end
        
        for n = 1:1:20
            if ~isempty(dy_i_sim)
                S_sim(l,n) = yv_sim - min(dy_i_sim(:,l,n));
            end
        end
    end
    
    for n = 1:1:20
        Tempo(n) = DeltaT/2 + (n-1)*DeltaT;
    end
    
    for n = 3:1:20
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
save(fullfile(pwd, 'resultados_diretoriosCP.mat'), 'diretorios');
disp('Estrutura diretorios salva com sucesso na pasta de trabalho como resultados_diretoriosCP.mat');