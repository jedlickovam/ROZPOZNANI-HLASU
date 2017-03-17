% nahrání deseti vzorkù

recorder = audiorecorder(44100,8,1);

disp('Zadejte desetkrát slovo které chcete rozpoznat');
for i = 1:10
    file = sprintf('%s%d.wav','vzorek',i);
    input('Náhrávání zaène po stisknutí enter.');
    recordblocking(recorder, 2);
    play(recorder); 
    y = getaudiodata(recorder);
    audiowrite(file,y,44100);
end
disp('Nahrávání bylo dokonèeno.')