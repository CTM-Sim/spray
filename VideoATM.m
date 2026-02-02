clear all
close all
clc

%% CONFIGURAÇÕES INICIAIS
load resultados_diretorios.mat
load Resultados.mat;

p_values = [1, 2, 3]; % 1=50bar, 2=60bar, 3=70bar
pressao_desejada = 'PINJ70';  % <-- Altere para PINJ60 ou PINJ70 se quiser

switch pressao_desejada
    case 'PINJ50'
        idx_KHRT_Blob = 1;
        idx_LISA_TAB = 4;
        idx_KHRT_RR = 7;
        idx_TAB_RR = 10;
        selected_p = 1;
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ50';
    case 'PINJ60'
        idx_KHRT_Blob = 2;
        idx_LISA_TAB = 5;
        idx_KHRT_RR = 8;
        idx_TAB_RR = 11;
        selected_p = 2;
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ60';
    case 'PINJ70'
        idx_KHRT_Blob = 3;
        idx_LISA_TAB = 6;
        idx_KHRT_RR = 9;
        idx_TAB_RR = 12;
        selected_p = 3;
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ70';
end

% Carrega os dados
dados_KHRT_Blob = diretorios{idx_KHRT_Blob}.resultados;
dados_LISA_TAB = diretorios{idx_LISA_TAB}.resultados;
dados_KHRT_RR = diretorios{idx_KHRT_RR}.resultados;
dados_TAB_RR = diretorios{idx_TAB_RR}.resultados;

% Ajustes de posição
kx = -7.42486;
kexp = 0;
ky = -0.87034;

%% ========== VÍDEO 1: KHRT ==========

FinalFilename_KHRT = 'video_KHRT.avi';
v = VideoWriter(fullfile(outputDir, FinalFilename_KHRT));
v.FrameRate = 1;
open(v);

p = p_values(selected_p);
for l = 1
    for n = 1:30
        figure;
        hold on;

        % KHRT em azul
        plot(dados_KHRT_Blob.dx_d_sim(:,l,n)+kx, dados_KHRT_Blob.dy_d_sim(:,l,n), '.b');
        plot(dados_KHRT_Blob.dx_e_sim(:,l,n)+kx, dados_KHRT_Blob.dy_e_sim(:,l,n), '.b');
        plot(dados_KHRT_Blob.dx_i_sim(:,l,n)+kx, dados_KHRT_Blob.dy_i_sim(:,l,n), '.b');
        plot(dados_KHRT_Blob.dx_s_sim(:,l,n)+kx, dados_KHRT_Blob.dy_s_sim(:,l,n), '.b');

        % RR em vermelho
        plot(dados_KHRT_RR.dx_d_sim(:,l,n)+kx, dados_KHRT_RR.dy_d_sim(:,l,n), '.r');
        plot(dados_KHRT_RR.dx_e_sim(:,l,n)+kx, dados_KHRT_RR.dy_e_sim(:,l,n), '.r');
        plot(dados_KHRT_RR.dx_i_sim(:,l,n)+kx, dados_KHRT_RR.dy_i_sim(:,l,n), '.r');
        plot(dados_KHRT_RR.dx_s_sim(:,l,n)+kx, dados_KHRT_RR.dy_s_sim(:,l,n), '.r');

        % Dados experimentais
        plot(dx_d(:,l,n,p)+kexp, dy_d(:,l,n,p)+ky, '.k');
        plot(dx_e(:,l,n,p)+kexp, dy_e(:,l,n,p)+ky, '.k');
        plot(dx_i(:,l,n,p)+kexp, dy_i(:,l,n,p)+ky, '.k');
        plot(dx_s(:,l,n,p)+kexp, dy_s(:,l,n,p)+ky, '.k');

        % Configurações do gráfico
        xlabel('Posição (cm)','fontsize',14);
        ylabel('Posição (cm)','fontsize',14);
        xlim([0 20]);
        ylim([-16 0]);
        xticks(0:5:20);
        yticks(-16:2:0);
        set(gca,'fontsize',14);
        grid on;
        drawnow;

        % Salva imagem opcional
        frameFilename = fullfile(outputDir, sprintf('KHRT_%s_p%02d_l%02d_n%02d.png', pressao_desejada, p, l, n));
        saveas(gcf, frameFilename);

        % Adiciona ao vídeo
        writeVideo(v, getframe(gcf));
        close;
    end
end
close(v);

%% ========== VÍDEO 2: LISA + TAB ==========

FinalFilename_LISATAB = 'video_LISATAB.avi';
v = VideoWriter(fullfile(outputDir, FinalFilename_LISATAB));
v.FrameRate = 1;
open(v);

for l = 1
    for n = 1:30
        figure;
        hold on;

        % LISA em azul
        plot(dados_LISA_TAB.dx_d_sim(:,l,n)+kx, dados_LISA_TAB.dy_d_sim(:,l,n), '.b');
        plot(dados_LISA_TAB.dx_e_sim(:,l,n)+kx, dados_LISA_TAB.dy_e_sim(:,l,n), '.b');
        plot(dados_LISA_TAB.dx_i_sim(:,l,n)+kx, dados_LISA_TAB.dy_i_sim(:,l,n), '.b');
        plot(dados_LISA_TAB.dx_s_sim(:,l,n)+kx, dados_LISA_TAB.dy_s_sim(:,l,n), '.b');

        % TAB em vermelho
        plot(dados_TAB_RR.dx_d_sim(:,l,n)+kx, dados_TAB_RR.dy_d_sim(:,l,n), '.r');
        plot(dados_TAB_RR.dx_e_sim(:,l,n)+kx, dados_TAB_RR.dy_e_sim(:,l,n), '.r');
        plot(dados_TAB_RR.dx_i_sim(:,l,n)+kx, dados_TAB_RR.dy_i_sim(:,l,n), '.r');
        plot(dados_TAB_RR.dx_s_sim(:,l,n)+kx, dados_TAB_RR.dy_s_sim(:,l,n), '.r');

        % Dados experimentais
        plot(dx_d(:,l,n,p)+kexp, dy_d(:,l,n,p)+ky, '.k');
        plot(dx_e(:,l,n,p)+kexp, dy_e(:,l,n,p)+ky, '.k');
        plot(dx_i(:,l,n,p)+kexp, dy_i(:,l,n,p)+ky, '.k');
        plot(dx_s(:,l,n,p)+kexp, dy_s(:,l,n,p)+ky, '.k');

        % Configurações do gráfico
        xlabel('Posição (cm)','fontsize',14);
        ylabel('Posição (cm)','fontsize',14);
        xlim([0 20]);
        ylim([-16 0]);
        xticks(0:5:20);
        yticks(-16:2:0);
        set(gca,'fontsize',14);
        grid on;
        drawnow;

        % Salva imagem opcional
        frameFilename = fullfile(outputDir, sprintf('LISATAB_%s_p%02d_l%02d_n%02d.png', pressao_desejada, p, l, n));
        saveas(gcf, frameFilename);

        % Adiciona ao vídeo
        writeVideo(v, getframe(gcf));
        close;
    end
end
close(v);
