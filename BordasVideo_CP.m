clear all
close all
clc

%% Cálculo das bordas dos resultados experimentais

load resultados_diretoriosCP.mat
load ResultadosDRcorreto.mat;
p_values = [1 2 3];
selected_p = 3; 
pressao_desejada = 'PINJ70 CP20'; % Pode ser 'PINJ70_CP10' ou 'PINJ70_CP20'


% 2. Configura os índices para cada modelo e seleciona dados experimentais
switch pressao_desejada
    case 'PINJ70 CP10'
        idx_KHRT_Blob = 1;   
        idx_LISA_TAB = 3;   
        idx_KHRT_RR = 5;     
        idx_TAB_RR = 7; 
        countp=2;
        FinalFilename = 'video_PINJ70_LISACP10.avi';
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\CP\CP10';
    case 'PINJ70 CP20'
        idx_KHRT_Blob = 2;   
        idx_LISA_TAB = 4;   
        idx_KHRT_RR = 6;     
        idx_TAB_RR = 8;
        countp=3;
        FinalFilename = 'video_PINJ70_KHRTCP20.avi';
        outputDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\CP\CP20';
    otherwise
        error('Pressão desconhecida. Use PINJ70_CP10 ou PINJ70_CP20');
end


% 3. Obter os dados das simulações
dados_KHRT_Blob = diretorios{idx_KHRT_Blob}.resultados;
dados_LISA_TAB = diretorios{idx_LISA_TAB}.resultados;
dados_KHRT_RR = diretorios{idx_KHRT_RR}.resultados;
dados_TAB_RR = diretorios{idx_TAB_RR}.resultados;


%p = 1; %(pressão de 50 bar)
%p = 2; %(pressão de 60 bar)
%p = 3; %(pressao de 70 bar)

k_x_khrt = -7.74756;
k_y_khrt = +1.00709;
k_x_lisa = -7.74756;
k_y_lisa = +1.00709;
%frames_especificos = [8, 18];
% k_x_khrt = 0;
% k_y_khrt = 0;
% k_x_lisa = 0;
% k_y_lisa = 0;
kexp=-0.4;
ky=0.2;

% v = VideoWriter(fullfile(outputDir, FinalFilename));
% v.FrameRate = 1;
% open(v);
% for p = p_values(selected_p)
%     for l=1:1:1
%         for n=1:20
%             figure;
%             hold on; 
% 
%             %Plot LISA em azul
%             plot(dados_LISA_TAB.dx_d_sim(:,l,n) + k_x_khrt, dados_LISA_TAB.dy_d_sim(:,l,n)+k_y_khrt, '.b');
%             plot(dados_LISA_TAB.dx_e_sim(:,l,n)+ k_x_khrt, dados_LISA_TAB.dy_e_sim(:,l,n)+k_y_khrt, '.b');
%             plot(dados_LISA_TAB.dx_i_sim(:,l,n)+ k_x_khrt, dados_LISA_TAB.dy_i_sim(:,l,n)+k_y_khrt, '.b');
%             plot(dados_LISA_TAB.dx_s_sim(:,l,n)+ k_x_khrt,dados_LISA_TAB.dy_s_sim(:,l,n)+k_y_khrt, '.b');
% 
%             % Plot TAB em vermelho
%             plot(dados_TAB_RR.dx_d_sim(:,l,n)+k_x_lisa, dados_TAB_RR.dy_d_sim(:,l,n)+k_y_lisa, '.r');
%             plot(dados_TAB_RR.dx_e_sim(:,l,n)+k_x_lisa, dados_TAB_RR.dy_e_sim(:,l,n)+k_y_lisa, '.r');
%             plot(dados_TAB_RR.dx_i_sim(:,l,n)+k_x_lisa, dados_TAB_RR.dy_i_sim(:,l,n)+k_y_lisa, '.r');
%             plot(dados_TAB_RR.dx_s_sim(:,l,n)+k_x_lisa, dados_TAB_RR.dy_s_sim(:,l,n)+k_y_lisa, '.r');
% 
%             % Plot dados EXPERIMENTAIS
%             if (n<=40)
%                 plot(dx_d(:,l,n,p,countp)+5.1+kexp, dy_d(:,l,n,p,countp), '.k');
%                 plot(dx_e(:,l,n,p,countp)+5.1+kexp, dy_e(:,l,n,p,countp), '.k');
%                 plot(dx_i(:,l,n,p,countp)+5.1+kexp, dy_i(:,l,n,p,countp), '.k');
%                 plot(dx_s(:,l,n,p,countp)+5.1+kexp, dy_s(:,l,n,p,countp), '.k');
%             end
% 
%             hold off;
%             xlabel('Posição (cm)', 'fontsize', 14);
%             ylabel('Posição (cm)', 'fontsize', 14);
%             xlim([0 20]);
%             ylim([-16 0]);
%             xticks(0:5:20);
%             yticks(-16:2:0);
%             set(gca, 'fontsize', 14);
%             grid on;
%             pause(0.1)
%             % Verifica se o frame atual está na lista de frames específicos
%            % if ismember(n, frames_especificos)
% 
%             %    epsFilename = fullfile(outputDir, sprintf('LISATAB_%s_p%02d_l%02d_n%02d.eps', pressao_desejada, p, l, n));
%              %   print('-depsc', epsFilename);  % Salva em formato EPS
% 
%               %  frameFilename = fullfile(outputDir, sprintf('LISATAB_%s_p%02d_l%02d_n%02d.png', pressao_desejada, p, l, n));
% 
% 
%             writeVideo(v,getframe(gcf));
%             close; % Fecha a figura após capturar o frame
%         end    
%     end
% end
% close(v);


v = VideoWriter(fullfile(outputDir, FinalFilename));
v.FrameRate = 1;
open(v);
for p = p_values(selected_p)
    for l=1:1:1
        for n=1:20
            figure;
            hold on; 

            %Plot KHRT em azul
            plot(dados_KHRT_Blob.dx_d_sim(:,l,n) + k_x_khrt, dados_KHRT_Blob.dy_d_sim(:,l,n)+k_y_khrt, '.b');
            plot(dados_KHRT_Blob.dx_e_sim(:,l,n)+ k_x_khrt, dados_KHRT_Blob.dy_e_sim(:,l,n)+k_y_khrt, '.b');
            plot(dados_KHRT_Blob.dx_i_sim(:,l,n)+ k_x_khrt, dados_KHRT_Blob.dy_i_sim(:,l,n)+k_y_khrt, '.b');
            plot(dados_KHRT_Blob.dx_s_sim(:,l,n)+ k_x_khrt,dados_KHRT_Blob.dy_s_sim(:,l,n)+k_y_khrt, '.b');

            % Plot khrt rr em vermelho
            plot(dados_KHRT_RR.dx_d_sim(:,l,n)+k_x_lisa, dados_KHRT_RR.dy_d_sim(:,l,n)+k_y_lisa, '.r');
            plot(dados_KHRT_RR.dx_e_sim(:,l,n)+k_x_lisa, dados_KHRT_RR.dy_e_sim(:,l,n)+k_y_lisa, '.r');
            plot(dados_KHRT_RR.dx_i_sim(:,l,n)+k_x_lisa, dados_KHRT_RR.dy_i_sim(:,l,n)+k_y_lisa, '.r');
            plot(dados_KHRT_RR.dx_s_sim(:,l,n)+k_x_lisa, dados_KHRT_RR.dy_s_sim(:,l,n)+k_y_lisa, '.r');

            % Plot dados EXPERIMENTAIS
            if (n<=40)
                plot(dx_d(:,l,n,p,countp)+5.1+kexp, dy_d(:,l,n,p,countp), '.k');
                plot(dx_e(:,l,n,p,countp)+5.1+kexp, dy_e(:,l,n,p,countp), '.k');
                plot(dx_i(:,l,n,p,countp)+5.1+kexp, dy_i(:,l,n,p,countp), '.k');
                plot(dx_s(:,l,n,p,countp)+5.1+kexp, dy_s(:,l,n,p,countp), '.k');
            end

            hold off;
            xlabel('Posição (cm)', 'fontsize', 14);
            ylabel('Posição (cm)', 'fontsize', 14);
            xlim([0 20]);
            ylim([-16 0]);
            xticks(0:5:20);
            yticks(-16:2:0);
            set(gca, 'fontsize', 14);
            grid on;
            pause(0.1)

            writeVideo(v,getframe(gcf));
            close; % Fecha a figura após capturar o frame
        end    
    end
end

close(v);

