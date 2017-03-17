%%%%    Semestrální práce: ZSK
%%%%    Markéta Jedlièková

slovnik = zeros (88200,10);              % 10 vzorku
r = zeros (10,1);
for j = 1:10
    soubor = sprintf('%s%d.wav','vzorek',j);
    [y ,Fs] = audioread(soubor);         % subplot(5,2,j); plot(y);
    s = abs(y);                          % figure(2); plot(s);
    start = 1;
    last = 88200;
    
    while s(start) <= 0.1
        start = start+1;
    end
    
    while s(last) <= 0.1
        last = last - 1;
    end
    
    r(j) = last-start;
    slovnik(1: last - start + 1,j) = y(start:last);
    % subplot(5,2,j);  plot( y(start:last));
end

% vsechny na stejnou velikost --> prùmìr
prumer = int32(sum(r)/10);
y = zeros(prumer,10);
for i = 1:10
    y(:,i) = slovnik(1:prumer,i);
    % subplot(5,2,i);    plot(y(:,i));
end

% fft and power spectral density
fy = fft(y);
fy = fy.*conj(fy);
% plot(fy);

% normalizace (frekvence do 600 Hz odpovida hlasu)
norm = zeros(600,10);
for i = 1:10
    % figure(1); plot(fy(1:600,1));
    norm(1:600,i) = fy(1:600,i)/sqrt(sum(fy(1:600,i).^2)); % euklidovská norma
    % subplot(5,2,i); plot(norm(1:600,1));
end

% vektor prumerovy
prumer = zeros(600,1);
for i = 1:10
    prumer = prumer + norm(1:600,i);
end
prumer = prumer/10;
%figure(1); plot(prumer);

%% nalezeni standartni odchylky
std = 0;
for i = 1:10
    std = std + sum((norm(1:600,i)-prumer).^2);
end
std = sqrt(std/10);

%% Proces rozpoznávání
input('Zmáèknìte enter a øeknìte slovo, které chcete rozpoznat.')

% Nahrání slova
recorder = audiorecorder(44100,8,1);
recordblocking(recorder, 2);
y = getaudiodata(recorder);
play(recorder);

% oøíznutí
s = abs(y);
start = 1;
last = 88200;

while s(start) <= 0.07
    start = start+1;
end

while s(last) <= 0.07
    last = last - 1;
end

% Transform the recording with FFT and normalize
% figure(1); plot(y(start:last));
signal = y(start:last);
furier= fft(signal);
furier= furier.*conj(furier);
vysek = furier(1:600);
normalizovana = vysek/sqrt(sum((vysek).^2));
figure(12); plot(normalizovana);

% Plot the spectra of the recording along with the average normal vector
hold on;
subplot (2,1,1);
plot (normalizovana)
title ('Normalizované spektrum')
subplot (2,1,2);
plot (prumer);
title ('Normalizované spektrum prumeru deseti vzorkù')

% Confirm weather user's voice is within two standard deviations of mean.
s = sqrt(sum((normalizovana - prumer).^2));
if s < 1.7*std
    disp('Bylo rozpoznáno slovo Markéta !!!!');
else
    disp('Nebylo rozpoznáno slovo Markéta !!!!');
end
