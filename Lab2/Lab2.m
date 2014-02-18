clear all
clc

Fs=30e3;
t=(1:128)*1/Fs;
f1=3e3;
f2=5e3;

% Define signals
s1=cos(2*pi*f1*t);
s2=cos(2*pi*f2*t);

s1FPGA=round(s1*128);
s1FPGA(s1FPGA==128)=127;

s2FPGA=round(s2*128);
s2FPGA(s2FPGA==128)=127;

% The following code writes the values of the signals to the Command
% window so that you may copy these values to your VHDL code
fprintf('\n');
for k=1:length(s1FPGA)
    fprintf('%d,',s1FPGA(k));
end
fprintf('\n');
for k=1:length(s2FPGA)
    fprintf('%d,',s2FPGA(k));
end

% Modify the code below so that the two multiplication results from
% MATLAB and VHDL checks
mult_out=s1FPGA.*s2FPGA;

% Mult result is 16 bits, for truncation MSB 8 bits are used so result
% is shifted by 8 bits equivalently divided to 256
mult_out = mult_out/2^8;

%%%TODO 128-point FFT
% kontrol ediniz
f = (Fs/2) * linspace(-1,1,128);
M = fftshift(fft(mult_out))/128;
plot(f,abs(M));
hold on;

sim_results = importdata('fft_output.txt')';	% fft results from FPGA
f_FPGA = (50e3/2) * linspace(-1,1,128);
plot(f_FPGA,sim_results,'r');