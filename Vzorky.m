% nahr�n� deseti vzork�

recorder = audiorecorder(44100,8,1);

disp('Zadejte desetkr�t slovo kter� chcete rozpoznat');
for i = 1:10
    file = sprintf('%s%d.wav','vzorek',i);
    input('N�hr�v�n� za�ne po stisknut� enter.');
    recordblocking(recorder, 2);
    play(recorder); 
    y = getaudiodata(recorder);
    audiowrite(file,y,44100);
end
disp('Nahr�v�n� bylo dokon�eno.')