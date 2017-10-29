function [ Hk ] = ChannelEstimationByLTS( rxTwoLTS )
%
% Получение комплексные Hk (52 штуки), характерезующих канал передачи в частотной обалсти (частотная характеристик канала).
%
% Для компенсации надо делить на полученные Hk
%
% @rxTwoLTS - 2 LTS во временной области
%
% Также полученные комплексные числа должны содержать составляющую exp(1i*fi0),
% где fi0 - разность фаз между колебаниями Tx и Rx осцилляторов
%
% !!! Отметим, что данный алгоритм предполагает ИДЕАЛЬНУЮ временную синхронизацию,
% то есть испоьзуемые LTS должны быть полностью выровнены относительно эталонных!
% Если это не так, то алгоритм НУЖНО модифицировать
%
% Также отметим, что длина имп. характеристики канала скорее всего меньше длины LTS!
% (CP характерезует длину имп. характ. канала). --> хорошо бы учесть это!!! Потом.
%
% Не компенсирует residual freq offset (который после FFT выливается в одинаковый
% фазовый сдвиг для всех поднесущих одного OFDM-символа)! Его компенсируем по пилотам!!!

% 	path(path, '../../02_ofdm_phy_802_11a_model/ofdm_phy_802_11a/');

	% L_-26_26
	etalonBPSKLTS = [ 1,  1, -1, -1,  1,  1, -1,  1, -1,  1, ...
	                  1,  1,  1,  1,  1, -1, -1,  1,  1, -1, ...
	                  1, -1,  1,  1,  1,  1, ...
	                  0, ...
	                  1, -1, -1,  1,  1, -1, ...
	                  1, -1,  1, -1, -1, -1, -1, -1,  1,  1, ...
	                 -1, -1,  1, -1,  1, -1,  1,  1,  1,  1 ];

	etalonBPSKLTS = [etalonBPSKLTS(28 : 53), etalonBPSKLTS(1 : 26)]; % нормальный порядок

	rxBPSKLTS1 = Constellate_From_LTS(rxTwoLTS(1 : 64));
	rxBPSKLTS2 = Constellate_From_LTS(rxTwoLTS(65 : 128));

	Hk = 1/2 * (rxBPSKLTS1 + rxBPSKLTS2) .* conj(etalonBPSKLTS);

% 	pilotHk = [Hk(7), Hk(21), Hk(32), Hk(46)];

% 	% другой способ ДОДЕЛАТЬ !!!
% 	Hk = 1/2 * (rxBPSKLTS1 + rxBPSKLTS2) ./ etalonBPSKLTS;
	
end

