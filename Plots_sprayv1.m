clear all
close all
clc

% Carrega os resultados das simulações
load resultados_diretorios.mat

% 1. Seleção da pressão
pressao_desejada = 'PINJ70'; % Pode ser 'PINJ50', 'PINJ60' ou 'PINJ70'

% Dados experimentais comuns
tempo_angcone_experimental = [0.757575758, 1.060606061, 1.363636364, 1.666666667, ...
                              1.96969697, 2.272727273, 2.575757576, 2.878787879, ...
                              3.181818182, 3.484848485, 3.787878788, 4.090909091, ...
                              4.393939394, 4.696969697, 5, 5.303030303, 5.606060606];

angcone_exp_50bar = [60.09046001, 59.95742571, 60.26024149, 59.59994724, 58.22714168, ...
                     57.85989183, 58.01524959, 58.28000226, 57.88197616, 57.89312918, ...
                     56.53256286, 56.36843185, 55.76581704, 56.82935444, 57.46436208, ...
                     57.94568872, 58.32165902];
                 
angcone_exp_60bar = [60.56144548, 60.81941404, 60.75241587, 59.74517036, 59.43591283, ...
                     59.13401402, 58.83371999, 59.09989084, 59.02681057, 57.98291827, ...
                     57.26968856, 57.24163272, 57.98901306, 58.10256186, 58.49136441, ...
                     58.56915245, 58.80222396];
                 
angcone_exp_70bar = [61.23747034, 61.48652934, 60.21319526, 59.52270258, 59.38312294, ...
                     59.36848107, 59.28152883, 59.452358, 58.23814733, 57.56391286, ...
                     56.9376384, 58.00847545, 57.94546184, 58.69949056, 58.64995118, ...
                     58.32813178, 58.6998188];

% 2. Configura os índices para cada modelo e seleciona dados experimentais
switch pressao_desejada
    case 'PINJ50'
        idx_KHRT_Blob = 1;   % Linha 1: KHRT PINJ50
        idx_LISA_TAB = 4;   % Linha 4: LISA PINJ50
        idx_KHRT_RR = 7;     % Linha 7: KH PINJ50
        idx_TAB_RR = 10; % Linha 10: KH_ACT PINJ50
        penetracao_exp = [1.213788045, 2.788778878, 4.129079575, 5.071507151, 4.880821415, ...
                          5.493215988, 6.074440777, 6.611661166, 7.060872754, 7.392739274, ...
                          7.711771177, 8.039970664, 8.283828383, 8.540520719, 8.756875688, ...
                          9.096076274, 9.393105977, 9.631463146, 9.880821415];
        angcone_exp = angcone_exp_50bar;
        mediaangcone_exp = mean(angcone_exp_50bar);
    case 'PINJ60'
        idx_KHRT_Blob = 2;   % Linha 2: KHRT PINJ60
        idx_LISA_TAB = 5;   % Linha 5: LISA PINJ60
        idx_KHRT_RR = 8;     % Linha 8: KH PINJ60
        idx_TAB_RR = 11; % Linha 11: KH_ACT PINJ60
        penetracao_exp = [1.189952329, 2.724605794, 4.195086175, 5.093509351, 5.049504950, ...
                          5.643564356, 6.270627063, 6.791345801, 7.222222222, 7.601760176, ...
                          7.984965163, 8.364503117, 8.701870187, 9.004400440, 9.341767510, ...
                          9.655298863, 9.917491749, 10.24019069, 10.59772644];
        mediaangcone_exp = mean(angcone_exp_60bar);
        angcone_exp = angcone_exp_60bar;
    case 'PINJ70'
        idx_KHRT_Blob = 3;   % Linha 3: KHRT PINJ70
        idx_LISA_TAB = 6;   % Linha 6: LISA PINJ70
        idx_KHRT_RR = 9;     % Linha 9: KH PINJ70
        idx_TAB_RR = 12; % Linha 12: KH_ACT PINJ70
        penetracao_exp = [1.156949028, 2.946461313, 4.444444444, 5.264026403, 5.185185185, ...
                          5.821415475, 6.448478181, 6.982031536, 7.425742574, 7.849284928, ...
                          8.254492116, 8.621195453, 8.951228456, 9.303263660, 9.642464246, ...
                          10.04767143, 10.59405941, 11.10011001, 11.60249358];
        angcone_exp = angcone_exp_70bar;
        mediaangcone_exp = mean(angcone_exp_70bar);
    otherwise
        error('Pressão desconhecida. Use PINJ50, PINJ60 ou PINJ70');
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
mediaangcone_KHRT_Blob = mean(dados_KHRT_Blob.angulo_sim);
mediaangcone_LISA_TAB = mean(dados_LISA_TAB.angulo_sim);
mediaangcone_KHRT_RR = mean(dados_KHRT_RR.angulo_sim);
mediaangcone_TAB_RR = mean(dados_TAB_RR.angulo_sim);

angcone_KHRT_Blob = dados_KHRT_Blob.angulo_sim;
angcone_LISA_TAB = dados_LISA_TAB.angulo_sim;
angcone_KHRT_RR = dados_KHRT_RR.angulo_sim;
angcone_TAB_RR = dados_TAB_RR.angulo_sim;

% Dados experimentais de tempo (já definidos acima)
tempo_exp = [0.151515152, 0.454545455, 0.757575758, 1.060606061, 1.363636364, ...
             1.666666667, 1.96969697, 2.272727273, 2.575757576, 2.878787879, ...
             3.181818182, 3.484848485, 3.787878788, 4.090909091, 4.393939394, ...
             4.696969697, 5, 5.303030303, 5.606060606];

%% Função para exportar figuras em EPS com fundo branco
function export_figure_eps(fig, filename, export_dir)
    % Configura fundo branco
    set(fig, 'Color', 'w');
    
    % Garante que o diretório existe
    if ~exist(export_dir, 'dir')
        mkdir(export_dir);
    end
    
    % Caminho completo do arquivo
    full_path = fullfile(export_dir, filename);
    
    % Configurações de exportação EPS
    set(fig, 'PaperPositionMode', 'auto');          % Mantém as dimensões da figura
    print(fig, full_path, '-depsc', '-r300', '-vector'); % Exporta como EPS vetorial
    
    % Fecha a figura (opcional)
    % close(fig);
end

%% Set your export directory here
export_directory = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ70'; % Change this to your desired path


%% Gráfico de Penetração KHRT
figure;
fig1 = figure;
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
export_figure_eps(fig1, ['Penetracao_KHRT_' pressao_desejada '.eps'], export_directory);

%% Gráfico de Penetração LISA E TAB
figure;
fig2 = figure;
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
export_figure_eps(fig2, ['Penetracao_LISATAB_' pressao_desejada '.eps'], export_directory);


%% Gráfico de Ângulo de Cone KHRT
figure;
fig3 = figure;
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
export_figure_eps(fig3, ['Angulo_KHRT_' pressao_desejada '.eps'], export_directory);

%% Gráfico de Ângulo de Cone LISA E TAB
figure;
fig4 = figure;
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
export_figure_eps(fig4, ['Angulo_LISATAB_' pressao_desejada '.eps'], export_directory);
%%
% Dados de exemplo (substitua com seus valores)
angulo_exp_medio = mediaangcone_exp;       % Ângulo experimental médio
limite_inf_exp = mediaangcone_exp + mediaangcone_exp*0.05;          % Limite inferior experimental
limite_sup_exp = mediaangcone_exp - mediaangcone_exp*0.05;          % Limite superior experimental

angulos_modelos = [mediaangcone_LISA_TAB, mediaangcone_KHRT_RR, mediaangcone_KHRT_Blob, mediaangcone_TAB_RR];  % Valores dos modelos
nomes_modelos = {'LISA-TAB', 'KHRT-RR', 'KHRT-Blob', 'TAB-RR'};

% Criar figura
figure;
fig5 = figure;
hold on;
ylim([40, 70]); 
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
title('Comparação de Modelos vs Experimental');
grid on;
export_figure_eps(fig5, ['MediaAngulos_' pressao_desejada '.eps'], export_directory);