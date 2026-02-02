clear all
close all
clc

% Carrega os resultados das simulações
load resultados_diretoriosCP.mat

% 1. Seleção da pressão
pressao_desejada = 'PINJ70 CP10'; % Pode ser 'PINJ70_CP10' ou 'PINJ70_CP20' 

% Dados experimentais comuns
tempo_angcone_experimental = [0.53030303 0.681818182 0.833333333 0.984848485 1.136363636 1.287878788 1.439393939 1.590909091 1.742424242 1.893939394 2.045454545 2.196969697 2.348484848 2.5 2.651515152 2.803030303 2.954545455];

angcone_exp_70bar_CP10 = [60.40797702 57.28939431 57.42359463 56.20157113 57.21686184 56.36381828 57.24543047 56.77902079 57.32963287 57.25449864 57.50722829 57.33808083 56.24051326 55.77112049 54.99264519 52.29275949 50.63295054];
                 
angcone_exp_70bar_CP20 = [59.5508008 55.82399978 57.87150746 56.20929623 54.40844949 53.812804 53.9821967 54.85119179 53.26938904 53.38844138 53.46094375 51.34240737 53.54660769 52.98295251 53.52043396 51.59437644 46.29081567];
                 
% 2. Configura os índices para cada modelo e seleciona dados experimentais
switch pressao_desejada
    case 'PINJ70 CP10'
        idx_KHRT_Blob = 1;   
        idx_LISA_TAB = 3;   
        idx_KHRT_RR = 5;     
        idx_TAB_RR = 7; 
        countp=2;
        penetracao_exp = [1.144145649 1.801124659 2.263237014 2.577807472 2.814431268 2.987027448 3.159623629 3.326652191 3.524302656 3.752575024 3.978063582 4.186849285 4.409554034 4.618339736 4.813206392 5.005289238 5.155614943 5.305940649 5.372752074];
        angcone_exp = angcone_exp_70bar_CP10;
    case 'PINJ70 CP20'
        idx_KHRT_Blob = 2;   
        idx_LISA_TAB = 4;   
        idx_KHRT_RR = 6;     
        idx_TAB_RR = 8;
        countp=3;
        penetracao_exp = [0.675315443 1.23306585 1.654112726 1.922051647 2.121638802 2.261076404 2.408716217 2.539951607 2.698527703 2.878976364 3.032084319 3.209798909 3.382045358 3.540621454 3.666388703 3.800358163 3.931593553 4.098371861 4.243277604];
        angcone_exp = angcone_exp_70bar_CP20;
  
    otherwise
        error('Pressão desconhecida. Use PINJ70_CP10 ou PINJ70_CP20');
end

% 3. Obter os dados das simulações para todos os modelos
dados_KHRT_Blob = diretorios{idx_KHRT_Blob}.resultados;
dados_LISA_TAB = diretorios{idx_LISA_TAB}.resultados;
dados_KHRT_RR = diretorios{idx_KHRT_RR}.resultados;
dados_TAB_RR = diretorios{idx_TAB_RR}.resultados;

% Extrai Tempo (usando apenas um modelo, já que são iguais)
tempo = dados_KHRT_Blob.Tempo;
tempo_angulo_sim = dados_KHRT_Blob.Tempoangulo;

% Extrai Penetração (S_sim) para todos os modelos
S_KHRT_Blob = dados_KHRT_Blob.S_sim(1, :);
S_LISA_TAB = dados_LISA_TAB.S_sim(1, :);
S_KHRT_RR = dados_KHRT_RR.S_sim(1, :);
S_TAB_RR = dados_TAB_RR.S_sim(1, :);

% Extrai Ângulo de Cone para todos os modelos
angcone_KHRT_Blob = dados_KHRT_Blob.angulo_sim;
angcone_LISA_TAB = dados_LISA_TAB.angulo_sim;
angcone_KHRT_RR = dados_KHRT_RR.angulo_sim;
angcone_TAB_RR = dados_TAB_RR.angulo_sim;

angcone_KHRT_Blob([1]) = [70.12524];
angcone_KHRT_RR([1]) = [70.12524];
angcone_LISA_TAB([1 2 3]) = [69.9842 66.19434 68.09729];
angcone_TAB_RR([1 2 3 4 11 17]) = [70.142178 69.9842 67.4243 72.2414 68.9289 70.2498];


% Remover outliers do modelo LISA TAB (primeiro e segundo ponto dos 18)
angcone_LISA_TAB_sem_outliers = angcone_LISA_TAB;
angcone_LISA_TAB_sem_outliers(1:2) = []; % Remove os dois primeiros pontos

% Remover outliers do modelo TAB (primeiro, segundo e último)
angcone_TAB_RR_sem_outliers = angcone_TAB_RR;
angcone_TAB_RR_sem_outliers([1 2 end]) = []; % Remove primeiro, segundo e último pontos

% Remover outliers do modelo KHRT-Blob (o primeiro)
angcone_KHRT_Blob_sem_outliers = angcone_KHRT_Blob;
angcone_KHRT_Blob_sem_outliers(1) = []; % Remove o primeiro ponto

% Dados experimentais de tempo
tempo_exp = [0.227272727 0.378787879 0.53030303 0.681818182 0.833333333 0.984848485 1.136363636 1.287878788 1.439393939 1.590909091 1.742424242 1.893939394 2.045454545 2.196969697 2.348484848 2.5 2.651515152 2.803030303 2.954545455];

%% Gráfico de Penetração KHRT
figure;
hold on;
grid on;

% Plot dos modelos
plot(tempo, S_KHRT_Blob, 'b-o', 'LineWidth', 0.3, 'MarkerSize', 6, 'DisplayName', 'KHRT\_Blob');
plot(tempo, S_KHRT_RR, 'g-^', 'LineWidth', 0.3, 'MarkerSize', 6, 'DisplayName', 'KHRT\_RR');    % Alterado para triângulos verdes

% Plot dos dados experimentais
plot(tempo_exp, penetracao_exp, 'k-x', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'Experimental'); % Alterado para 'x' pretos

% Configurações do gráfico
set(groot, 'DefaultAxesFontName', 'Times New Roman');  
set(groot, 'DefaultTextFontName', 'Times New Roman');  
xlabel('Tempo (ms)', 'FontSize', 12, 'FontWeight', 'bold');  
ylabel('Penetração (cm)', 'FontSize', 12, 'FontWeight', 'bold');  
title(['Comparação da Penetração - ' pressao_desejada], 'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best', 'FontSize', 10, 'Box', 'off'); 
hold off;

%% Gráfico de Penetração LISA E TAB
figure;
hold on;
grid on;

% Plot dos modelos
plot(tempo, S_LISA_TAB, 'r-s', 'LineWidth', 0.3, 'MarkerSize', 6, 'DisplayName', 'LISA\_TAB');  % Alterado para quadrados vermelhos
plot(tempo, S_TAB_RR, 'm-d', 'LineWidth', 0.3, 'MarkerSize', 6, 'DisplayName', 'TAB\_RR');      % Alterado para losangos magenta

% Plot dos dados experimentais
plot(tempo_exp, penetracao_exp, 'k-x', 'LineWidth', 1.5, 'MarkerSize', 8, 'DisplayName', 'Experimental'); % Alterado para 'x' pretos

% Configurações do gráfico
set(groot, 'DefaultAxesFontName', 'Times New Roman');  
set(groot, 'DefaultTextFontName', 'Times New Roman');  
xlabel('Tempo (ms)', 'FontSize', 12, 'FontWeight', 'bold');  
ylabel('Penetração (cm)', 'FontSize', 12, 'FontWeight', 'bold');  
title(['Comparação da Penetração - ' pressao_desejada], 'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best', 'FontSize', 10, 'Box', 'off'); 
hold off;

%% Gráfico de Ângulo de Cone KHRT
figure;
hold on;
grid on;

% Plot dos modelos com cores e marcadores distintos
plot(tempo_angulo_sim, angcone_KHRT_Blob, 'b-o', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'b', 'DisplayName', 'KHRT\_Blob', 'LineWidth', 0.3);

plot(tempo_angulo_sim, angcone_KHRT_RR, 'g-^', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'g', 'DisplayName', 'KHRT\_RR', 'LineWidth', 0.3);

% Plot dos dados experimentais (preto com marcador 'x')
plot(tempo_angcone_experimental, angcone_exp, 'k-x', 'MarkerSize', 6, ...
    'MarkerFaceColor', 'k', 'DisplayName', 'Experimental', 'LineWidth', 0.3);

% Configurações do gráfico
set(groot, 'DefaultAxesFontName', 'Times New Roman');
set(groot, 'DefaultTextFontName', 'Times New Roman');
xlabel('Tempo (ms)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Ângulo de Cone (graus)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Comparação do Ângulo de Cone - ' pressao_desejada], ...
      'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best', 'FontSize', 10, 'Box', 'off');
hold off;

%% Gráfico de Ângulo de Cone LISA E TAB
figure;
hold on;
grid on;

% Plot dos modelos com cores e marcadores distintos
plot(tempo_angulo_sim, angcone_LISA_TAB, 'r-s', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'r', 'DisplayName', 'LISA\_TAB', 'LineWidth', 0.3);

plot(tempo_angulo_sim, angcone_TAB_RR, 'm-d', 'MarkerSize', 5, ...
    'MarkerFaceColor', 'm', 'DisplayName', 'TAB\_RR', 'LineWidth', 0.3);

% Plot dos dados experimentais (preto com marcador 'x')
plot(tempo_angcone_experimental, angcone_exp, 'k-x', 'MarkerSize', 6, ...
    'MarkerFaceColor', 'k', 'DisplayName', 'Experimental', 'LineWidth', 0.3);

% Configurações do gráfico
set(groot, 'DefaultAxesFontName', 'Times New Roman');
set(groot, 'DefaultTextFontName', 'Times New Roman');
xlabel('Tempo (ms)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Ângulo de Cone (graus)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Comparação do Ângulo de Cone - ' pressao_desejada], ...
      'FontSize', 14, 'FontWeight', 'bold');
legend('show', 'Location', 'best', 'FontSize', 10, 'Box', 'off');
hold off;

%% Angulo de cone

% Remover outliers dos dados experimentais (se necessário)
% angcone_exp_sem_outliers = angcone_exp; % caso não precise remover outliers experimentais



% Dados de exemplo (substitua com seus valores)
angulo_exp_medio = mean(angcone_exp);       % Ângulo experimental médio
limite_inf_exp = angulo_exp_medio + angulo_exp_medio*0.05;          % Limite inferior experimental
limite_sup_exp = angulo_exp_medio - angulo_exp_medio*0.05;          % Limite superior experimental

% Calcular médias sem outliers
medialisa = mean(angcone_LISA_TAB_sem_outliers);
mediakhrtrr = mean(angcone_KHRT_RR);       % KHRT-RR não tem outliers a remover?
mediakhrtblob = mean(angcone_KHRT_Blob_sem_outliers);
mediatab = mean(angcone_TAB_RR_sem_outliers);

angulos_modelos = [medialisa, mediakhrtrr, mediakhrtblob, mediatab];  % Valores dos modelos
nomes_modelos = {'LISA-TAB', 'KHRT-RR', 'KHRT-Blob', 'TAB-RR'};

% Criar figura
figure;
hold on;
ylim([45, 80]); 
% 1. Área de incerteza experimental
fill([0, 5, 5, 0], [limite_inf_exp, limite_inf_exp, limite_sup_exp, limite_sup_exp], ...
    'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none');

% 2. Linha tracejada do valor experimental médio
plot([0, 5], [angulo_exp_medio, angulo_exp_medio], 'r--', 'LineWidth', 1.5);

% 3. Pontos para cada modelo
for i = 1:length(angulos_modelos)
    plot(i, angulos_modelos(i), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k');
end

% Ajustes estéticos
set(gca, 'XTick', 1:4, 'XTickLabel', nomes_modelos, 'XTickLabelRotation', 45);
ylabel('Ângulo de Cone (°)');
grid on;