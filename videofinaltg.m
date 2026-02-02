% Caminhos dos vídeos de entrada
videoPath2 = "C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\CP\CP20\video_PINJ70_KHRTCP20.avi";
videoPath1 = "C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\CP\CP20\video_PINJ70_LISACP20.avi";

% Caminho do vídeo de saída
outputPath = "C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\New_PX\CP\CP20\video70pinj20CP.mp4";

% Leitores de vídeo
v1 = VideoReader(videoPath1);
v2 = VideoReader(videoPath2);

% Verificação do número de frames e frame rate
assert(v1.NumFrames == v2.NumFrames, 'Vídeos têm número de frames diferentes.');
assert(v1.FrameRate == v2.FrameRate, 'Vídeos têm frame rates diferentes.');

% Cria writer para vídeo de saída
outputVideo = VideoWriter(outputPath);
outputVideo.FrameRate = v1.FrameRate;
open(outputVideo);

% Loop para combinar os frames
while hasFrame(v1) && hasFrame(v2)
    frame1 = readFrame(v1);
    frame2 = readFrame(v2);

    % Ajusta altura se necessário
    if size(frame1, 1) ~= size(frame2, 1)
        targetHeight = min(size(frame1, 1), size(frame2, 1));
        frame1 = imresize(frame1, [targetHeight NaN]);
        frame2 = imresize(frame2, [targetHeight NaN]);
    end

    % Agora os dois têm mesma altura → junta lado a lado
    frameCombined = [frame1, frame2];

    % Escreve no vídeo final
    writeVideo(outputVideo, frameCombined);
end

close(outputVideo);