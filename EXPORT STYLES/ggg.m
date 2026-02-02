% 1. Load the images (using imread instead of imshow)
image1 = imread("test2.jpeg");
image2 = imread("test3compare.jpeg");

% 2. Create comparison figure
figure;

% First subplot
subplot(1,2,1);
imshow(image1);  % Display the image data, not the handle
title('Image 1');

% Second subplot
subplot(1,2,2);
imshow(image2);  % Display the image data, not the handle
title('Image 2');

% 3. Add pixel information tool
impixelinfo;