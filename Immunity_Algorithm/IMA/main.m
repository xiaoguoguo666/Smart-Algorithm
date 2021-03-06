clear
clc
tic 
pop_size = 15;
chromosome_size = 10;
epochs = 50;
cross_rate = 0.4;
mutation_rate = 0.1;
a0 = 0.7;
zpop_size = 5;
best_fitness = 0;
nf = 0;
number = 0;
Image = imread('bird.bmp');
q = isRgb(Image);
if q == 1
    Image = rgb2gray(Image);
end
[m, n] = size(Image);
p = imhist(Image);
p = p';
p = p / (m * n);
figure(1);
subplot(121);
imshow(Image);
title('原始图片');
hold on;
pop = round(rand(pop_size, chromosome_size));
for epoch = 1: epochs
    [fitness, threshold, number] = fitnessty(pop, chromosome_size, Image, pop_size, m, n, number);
    if max(fitness) > best_fitness
        best_fitness = max(fitness);
        nf = 0;
        best_index = find(fitness == best_fitness);
        thres = threshold(1, best_index(1));
    elseif max(fitness) == best_fitness
        nf = nf + 1;
    end
    if nf >= 20
        fprintf('提前结束测试');
        break;
    end
    similar_chromosome = similarChromosome(pop);
    f = fit(similar_chromosome, fitness);
    pop = select(pop, f);
    pop = cross(pop, cross_rate, pop_size, chromosome_size);
    pop = mutation(pop, mutation_rate, chromosome_size, pop_size);
    similar_population = similarPopulation(pop);
    if similar_population > a0  % 防止早熟
        zpop = round(rand(zpop_size, chromosome_size));
        pop(pop_size + 1: pop_size + zpop_size, :) = zpop(:, :);
        [fitness, threshold, number] = fitnessty(pop, chromosome_size, Image, pop_size, m, n, number);
        similar_chromosome = similarChromosome(pop);
        f = fit(similar_chromosome, fitness);
        pop = select(pop, f);
    end
    if epoch == epochs
        [fitness, threshold, number] = fitnessty(pop, chromosome_size, Image, pop_size, m, n, number);
    end
    drawResult(Image, thres);
    subplot(122)
    fprintf('threshold = %d', thres);
%     title('分割后的结果');
end
toc
subplot(122);
drawResult(Image, thres);
title('分割以后的结果');
