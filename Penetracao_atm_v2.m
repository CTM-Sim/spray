clear all
close all
clc

%% Cálculo das bordas dos resultados experimentais

load resultados_diretorios.mat
load Resultados.mat;
p_values = [1, 2, 3]; % 1=50bar, 2=60bar, 3=70bar
selected_p = 1; % Mude para 1, 2 ou 3 conforme necessário
%p = 1; %(pressão de 50 bar)
%p = 2; %(pressão de 60 bar)
%p = 3; %(pressao de 70 bar)
pressao_desejada = 'PINJ50';

switch pressao_desejada
    case 'PINJ50'
        idx_KHRT_Blob = 1;   % Linha 1: KHRT PINJ50
        idx_LISA_TAB = 4;   % Linha 4: LISA PINJ50
        idx_KHRT_RR = 7;     % Linha 7: KH PINJ50
        idx_TAB_RR = 10; % Linha 10: KH_ACT PINJ50
        selected_p = 1;
        FinalFilename = 'video_PINJ50_KHRT.avi';
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ50';
    case 'PINJ60'
        idx_KHRT_Blob = 2;   % Linha 2: KHRT PINJ60
        idx_LISA_TAB = 5;   % Linha 5: LISA PINJ60
        idx_KHRT_RR = 8;     % Linha 8: KH PINJ60
        idx_TAB_RR = 11; % Linha 11: KH_ACT PINJ60
        selected_p = 2;
        FinalFilename = 'video_PINJ60_KHRT.avi';
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ60';
    case 'PINJ70'
        idx_KHRT_Blob = 3;   % Linha 3: KHRT PINJ70
        idx_LISA_TAB = 6;   % Linha 6: LISA PINJ70
        idx_KHRT_RR = 9;     % Linha 9: KH PINJ70
        idx_TAB_RR = 12; % Linha 12: KH_ACT PINJ70
        selected_p = 3;
        FinalFilename = 'video_PINJ70_KHRT.avi';
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\PATM\PINJ70';
end


% 3. Obter os dados das simulações
dados_KHRT_Blob = diretorios{idx_KHRT_Blob}.resultados;
dados_LISA_TAB = diretorios{idx_LISA_TAB}.resultados;
dados_KHRT_RR = diretorios{idx_KHRT_RR}.resultados;
dados_TAB_RR = diretorios{idx_TAB_RR}.resultados;
frames_especificos = [8, 18];

%p = 1; %(pressão de 50 bar)
%p = 2; %(pressão de 60 bar)
%p = 3; %(pressao de 70 bar)

kx = -7.42486;
kexp = 0;
ky=-0.87034;


v = VideoWriter(fullfile(outputDir, FinalFilename));
v.FrameRate = 1;
open(v);
for p = p_values(selected_p)
    for l=1:1:1
        for n=1:30
            figure;
            hold on; 
            
            %Plot KHRT em azul
            plot(dados_KHRT_Blob.dx_d_sim(:,l,n)+kx, dados_KHRT_Blob.dy_d_sim(:,l,n), '.b');
            plot(dados_KHRT_Blob.dx_e_sim(:,l,n)+kx, dados_KHRT_Blob.dy_e_sim(:,l,n), '.b');
            plot(dados_KHRT_Blob.dx_i_sim(:,l,n)+kx, dados_KHRT_Blob.dy_i_sim(:,l,n), '.b');
            plot(dados_KHRT_Blob.dx_s_sim(:,l,n)+kx, dados_KHRT_Blob.dy_s_sim(:,l,n), '.b');
            
            % Plot LISA em vermelho
            plot(dados_KHRT_RR.dx_d_sim(:,l,n)+kx, dados_KHRT_RR.dy_d_sim(:,l,n), '.r');
            plot(dados_KHRT_RR.dx_e_sim(:,l,n)+kx, dados_KHRT_RR.dy_e_sim(:,l,n), '.r');
            plot(dados_KHRT_RR.dx_i_sim(:,l,n)+kx, dados_KHRT_RR.dy_i_sim(:,l,n), '.r');
            plot(dados_KHRT_RR.dx_s_sim(:,l,n)+kx, dados_KHRT_RR.dy_s_sim(:,l,n), '.r');
            
            % Plot dados EXPERIMENTAIS
            if (n<=30)
                plot(dx_d(:,l,n,p)+kexp, dy_d(:,l,n,p)+ky, '.k');
                plot(dx_e(:,l,n,p)+kexp, dy_e(:,l,n,p)+ky, '.k');
                plot(dx_i(:,l,n,p)+kexp, dy_i(:,l,n,p)+ky, '.k');
                plot(dx_s(:,l,n,p)+kexp, dy_s(:,l,n,p)+ky, '.k');
            end
            
            hold off;
            xlabel('Posição (cm)','fontsize',14);
            ylabel('Posição (cm)','fontsize',14);
            xlim([0 20])
            ylim([-16 0])
            xticks(0:5:20)
            yticks(-16:2:0)
            set(gca,'fontsize',14);
            grid on
            pause(0.1)
            % Verifica se o frame atual está na lista de frames específicos
            % if ismember(n, frames_especificos)
            % 
            %     epsFilename = fullfile(outputDir, sprintf('KHRT_%s_p%02d_l%02d_n%02d.eps', pressao_desejada, p, l, n));
            %     print('-depsc', epsFilename);  % Salva em formato EPS
            % 
            %     frameFilename = fullfile(outputDir, sprintf('KHRT_%s_p%02d_l%02d_n%02d.png', pressao_desejada, p, l, n));
            saveas(gcf, frameFilename);
            writeVideo(v,getframe(gcf));
            close; % Fecha a figura após capturar o frame
            % end

        end    
    end
end
close(v);


v = VideoWriter(fullfile(outputDir, FinalFilename));
v.FrameRate = 1;
open(v);
for p = p_values(selected_p)
    for l=1:1:1
        for n=1:30
            figure;
            hold on; 
            
            %Plot KHRT em azul
            plot(dados_LISA_TAB.dx_d_sim(:,l,n)+kx, dados_LISA_TAB.dy_d_sim(:,l,n), '.b');
            plot(dados_LISA_TAB.dx_e_sim(:,l,n)+kx, dados_LISA_TAB.dy_e_sim(:,l,n), '.b');
            plot(dados_LISA_TAB.dx_i_sim(:,l,n)+kx, dados_LISA_TAB.dy_i_sim(:,l,n), '.b');
            plot(dados_LISA_TAB.dx_s_sim(:,l,n)+kx, dados_LISA_TAB.dy_s_sim(:,l,n), '.b');
            
            % Plot LISA em vermelho
            plot(dados_TAB_RR.dx_d_sim(:,l,n)+kx, dados_TAB_RR.dy_d_sim(:,l,n), '.r');
            plot(dados_TAB_RR.dx_e_sim(:,l,n)+kx, dados_TAB_RR.dy_e_sim(:,l,n), '.r');
            plot(dados_TAB_RR.dx_i_sim(:,l,n)+kx, dados_TAB_RR.dy_i_sim(:,l,n), '.r');
            plot(dados_TAB_RR.dx_s_sim(:,l,n)+kx, dados_TAB_RR.dy_s_sim(:,l,n), '.r');
            
            % Plot dados EXPERIMENTAIS
            if (n<=30)
                plot(dx_d(:,l,n,p)+kexp, dy_d(:,l,n,p)+ky, '.k');
                plot(dx_e(:,l,n,p)+kexp, dy_e(:,l,n,p)+ky, '.k');
                plot(dx_i(:,l,n,p)+kexp, dy_i(:,l,n,p)+ky, '.k');
                plot(dx_s(:,l,n,p)+kexp, dy_s(:,l,n,p)+ky, '.k');
            end
            
            hold off;
            xlabel('Posição (cm)','fontsize',14);
            ylabel('Posição (cm)','fontsize',14);
            xlim([0 20])
            ylim([-16 0])
            xticks(0:5:20)
            yticks(-16:2:0)
            set(gca,'fontsize',14);
            grid on
            pause(0.1)
            % Verifica se o frame atual está na lista de frames específicos
            if ismember(n, frames_especificos)
                
                epsFilename = fullfile(outputDir, sprintf('LISATAB_%s_p%02d_l%02d_n%02d.eps', pressao_desejada, p, l, n));
                print('-depsc', epsFilename);  % Salva em formato EPS
                               
                frameFilename = fullfile(outputDir, sprintf('LISATAB_%s_p%02d_l%02d_n%02d.png', pressao_desejada, p, l, n));
                saveas(gcf, frameFilename);
            writeVideo(v,getframe(gcf));
            close; % Fecha a figura após capturar o frame
            end
           
        end    
    end
end
close(v);
