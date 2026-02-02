imageDir = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\KHRT\PINJ50\CP1\Rosin_rammler\thirdtest_Cb0_ct05_b12\output\frames_exportados';
outputVideoPath = 'C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\Plots_finais\PATM\PINJ50\FramesKHRT\video_final.avi';

% Obtém os arquivos
filesStruct = dir(fullfile(imageDir, '*.jpg'));
fileNames = {filesStruct.name};
fileNames = sort(fileNames);  % ordem alfabética

disp(fileNames);  % debug
disp(['Total de imagens encontradas: ', num2str(numel(fileNames))]);

v = VideoWriter(outputVideoPath);
v.FrameRate = 1;
open(v);

numFrames = min(30, numel(fileNames));

for k = 1:numFrames
    imgPath = fullfile(imageDir, fileNames{k});
    img = imread(imgPath);

    f = figure('Units', 'pixels', 'Position', [100, 100, 560, 420]);
    imshow(img, 'Border', 'tight');
    axis off;
    drawnow;

    frame = getframe(f);
    writeVideo(v, frame);
    close(f);
end

close(v);

