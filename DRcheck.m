clear all
clc

img = imread("C:\Users\USER\Desktop\CARACTERIZACAODEINJETORES\LISA\PINJ70\CP1\Blob\output\frames_exportados\post000001_+0.00000e+00.jpg");
imgray = im2gray(img);
imshow(imgray)
impixelinfo