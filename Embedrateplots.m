% Embedrate is Embedding rate
% ssim are the SSIMs
% psnr
% mse
% mseuntextured, mselowtextured, msemandril,msetextured
% psnruntextured, psnrlowtextured, psnrmandril,pnsrtextured
% ssimuntextured, ssimlowtextured, ssimmandril,ssimtextured
% eruntextured, erlowtextured, ermandril,ertextured - Embedding rates

 mse= [20.57,0.20,4.03,0.23,41.58,0.18,2.01,22.60,0.25,0.02,1.91,33.20,32.13,0.06,0.02,0.25,20.60,1.99,0.06,2.04,0.21,16.50,0.16,1.75];
 mseuntextured=[0
0.18
0.23
0.2
3.5352
2.8865
41.58
4.03
];
 mselowtextured=[0
0.02
0.25
2.01
1.91
22.6
33.2
];
 msemandril=[0
0.02
0.06
0.25
1.99
20.6
32.13
];
 msetextured=[0
0.06
0.16
0.21
1.75
2.04
16.5
];
 
ssim=[ 0.7707 0.6002 0.3279 0.6205 0.4152 0.6352 0.894 0.7852 0.9373 0.9844 0.858 0.61164 0.892 0.9994 0.9999 0.9989 0.956 0.9922 0.9999 0.9963 0.9996 0.9839 0.9997 0.997];
ssimuntextured=[1 0.6352 0.6205 0.6002 0.22473 0.18373 0.4152 0.3279];
ssimlowtextured=[1 0.9844 0.9373 0.894 0.858 0.7852 0.61164];
ssimmandril=[1 0.9999 0.9994 0.9989 0.9922 0.956 0.892];
ssimtextured= [1 0.9999 0.9997 0.9996 0.997 0.9963 0.9839];

psnr=[35 55.19 42.08 54.61 31.94 55.47 45.09 34.59 54.08 65.82 45.32 32.92 33.06 60.15 66.18 54.16 34.99 45.15 59.15 44.29 54.22 35.21 55.22 44.94];
psnruntextured=[90 55.47 54.61 55.19 42.6466 43.5271 31.94 42.08];
psnrlowtextured=[90 65.82 54.08 45.09 45.32 34.59 32.92];
psnrmandril=[90 66.18 60.15 54.16 45.15 34.99 33.06];
psnrtextured=[90 59.15 55.22 54.22 44.94 44.29 35.21]; 

Embedrate=[ 1.1367 0.4143 2.9155 0.3939 2.383 0.3793 1.2209 2.0002 0.5002 0.0314 1.9594 3.7386 3.7386 0.1258 0.0314 0.5002 2.0002 1.2209 0.1252 1.657 0.4142 2.9155 0.3287 1.4564];
eruntextured=[0
0.3793
0.3939
0.4143
1.5803
1.657
2.383
2.9155
];
erlowtextured=[0 0.0314 0.5002 1.2209 1.9594 2.0002 3.7386]; 
ermandril=[0
0.0314
0.1258
0.5002
1.2209
2.0002
3.7386
];
ertextured=[0
0.1252
0.3287
0.4142
1.4564
1.657
2.9155
];

subplot(2,2,1)
% plot(Embedrate,ssim)
plot(eruntextured,ssimuntextured,'g',erlowtextured,ssimlowtextured,'b--o',ermandril,ssimmandril,'-*',ertextured,ssimtextured,'--gs')
legend('show')
legend('Non-Textured','Low Textured','Mandrill','Textured')
xlabel('Embed Rate(Bpp)')
ylabel('SSIM')
title('Embed Rate Vs SSIM');
grid on

%Line fittings for SSIM
[Cuntextured,R2Untextured] = linefit(eruntextured,ssimuntextured)
[Clowtextured,R2lowtextured] = linefit(erlowtextured,ssimlowtextured)
[CMandril,R2Mandril] = linefit(ermandril,ssimmandril)
[Ctextured,R2textured] = linefit(ertextured,ssimtextured)



subplot(2,2,2)
% plot(Embedrate,psnr)
plot(eruntextured,psnruntextured,'g',erlowtextured,psnrlowtextured,'b--o',ermandril,psnrmandril,'-*',ertextured,psnrtextured,'--gs')
legend('show')
legend('Non-Textured','Low Textured','Mandrill','Textured')
xlabel('Embed Rate(Bpp)')
ylabel('PSNR')
title('Embed Rate Vs PSNR');
grid on

%Line fittings for PSNR
[CPSNRuntextured,R2PSNRUntextured] = linefit(eruntextured,psnruntextured)
[CPSNRlowtextured,R2PSNRlowtextured] = linefit(erlowtextured,psnrlowtextured)
[CPSNRMandril,R2PSNRMandril] = linefit(ermandril,psnrmandril)
[CPSNRtextured,R2PSNRtextured] = linefit(ertextured,psnrtextured)

subplot(2,2,3)
% plot(Embedrate,mse)
plot(eruntextured,mseuntextured,'g',erlowtextured,mselowtextured,'b--o',ermandril,msemandril,'-*',ertextured,msetextured,'--gs')
legend('show')
legend('Non-Textured','Low Textured','Mandrill','Textured')
xlabel('Embed Rate(Bpp)')
ylabel('MSE')
title('Embed Rate Vs MSE');
grid on
