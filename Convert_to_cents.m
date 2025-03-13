clear;

subject = 1;
Data_all = [];
f0_all= [];
f0_shifted_all = [];

cd(sprintf('/Users/.../Subject%d',subject));
 
%% Run it for each block

for block = 1:2
    
    f0 = [];
    f0_shifted = [];
    load(sprintf('PitchShift_Subj%d_Block%d.mat',subject, block));
    
    for i = 1:75
        raw = csvread(sprintf('PitchShift_Subj%d_Block%d_Trial%d.Table',subject,block,i),1);
        raw_shifted = csvread(sprintf('PitchShift_Subj%d_Block%d_Trial%d_Shifted.Table',subject,block,i),1);
        
        shift_onset = Data(i).jitter;
        shift_onset = find(single(raw(:,1))==single(double(shift_onset)));
        
        if isempty(shift_onset)==1
            shift_onset = Data(i).jitter+0.0005;
            shift_onset = find(single(raw(:,1))==single(double(shift_onset)));
        end
        
        f0_cents = 1200*log2(raw(:,2)/mean(raw(shift_onset-100:shift_onset,2))); % baseline: -100 to 0 before perturbation
        f0_cents_shifted = 1200*log2(raw_shifted(:,2)/mean(raw_shifted(shift_onset-100:shift_onset,2))); % baseline: -100 to 0 before perturbation
        
        f0 = [f0 f0_cents(shift_onset-200:shift_onset+800,:)]; % epoch: -200 to 500 ms
        f0_shifted = [f0_shifted f0_cents_shifted(shift_onset-200:shift_onset+800,:)];
        
        %clear raw raw_shifted f0_cents f0_cents_shifted
    end
    
    Data_all = [Data_all Data];
    f0_all = [f0_all f0];
    f0_shifted_all = [f0_shifted_all f0_shifted];
    
    clear Data f0 f0_shifted
    
end

%% Save all

save('Data_all','Data_all');
save('f0_all','f0_all');
save('f0_shifted_all','f0_shifted_all');
