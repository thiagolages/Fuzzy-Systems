% Thiago Lages
% exercicios do slide 04-RegrasRaciocinioNebuloso

clf; clear; clc;

% exc1
% se x eh A1 entao y eh C1
% se x eh A2 entao y eh C2
% T-norma: produto
% S-norma: maximo

u = utils();

x = 0:0.001:10;

A1 = trapmf(x,[3,4,5,6]);
A2 = trapmf(x,[6, 6.5, 7, 7.5]);

C1 = trimf(x,[3,4,5]);
C2 = trimf(x,[4,5,6]);

A_ = trimf(x,[5,6,7]);

figure(1);
% Regra 1, antecedente 1 (A1)
subplot(321); hold on;
plot(x, A1);
title('A1');

% Regra 2, antecedente 2 (A2)
subplot(323); hold on;
plot(x, A2);
title('A2');

% Regra 1, consequente 1 (C1)
subplot(322); hold on;
plot(x, C1);
title('C1');

% Regra 2, consequente 2 (C2)
subplot(324); hold on;
plot(x, C2);
title('C2');

% Fato 1 (x eh A')
subplot(325); hold on;
plot(x, A_,'r');
title('Fato 1: x eh A' );

%%%%%%          PASSO 1: achar grau de compatibilidade              %%%%%%
% a partir da comparacao do fato nos antecedentes das regras.
% Usaremos max(min()), ou, neste caso, max(prod()), ja que temos
% S-norma de T-norma ---- [ mi_b'(y) = Vx( mi_a'(x) /\ mi_r(x,y) ) ]

%%%%%%                          plotar fatos em regras              %%%%%%
% plotar o fato A' em A1
subplot(321);
plot(x,A_,'r');

% plotar o fato A' em A2
subplot(323);
plot(x,A_,'r');

%%%%%%      calcular GRAU DE COMPATIBILIDADE de fatos com regras    %%%%%%
% grau de compatibilidade do fato 1 na regra 1
w1A1 = u.s_norma(u.t_norma(A_, A1)); %w1A2 = max(A_.*A1); 

% grau de compatibilidade do fato 1 na regra 2
w1A2 = u.s_norma(u.t_norma(A_, A2)); %w1A2 = max(A_.*A2); 


%%%%%%           plotar grau de compatibilidades nas regras         %%%%%%
% plotar resultado do grau de compatibilidade em A1
subplot(321);
yline(w1A1,'k--');

% plotar resultado do grau de compatibilidade em A2
subplot(323);
yline(w1A2,'k--');

%%%%%%             PASSO 2: achar GRAU DE ATIVACAO                  %%%%%%
% combinar graus de compatibilidade para cada regra usando T-norma ou
% S-norma para obter o grau de ativacao que indica o quanto parte do
% antecedente da regra wj foi satisfeita

% neste caso so ha um fato %
w1 = u.t_norma(w1A1, 1); % grau de ativacao da regra 1
w2 = u.t_norma(w1A2, 1); % grau de ativacao da regra 2


%%%%%%                      plotar graus de ativacao                %%%%%%
% plotar grau de ativacao em C1
subplot(322); 
yline(w1,'k--');

% plotar grau de ativacao em C2
subplot(324); 
yline(w2,'k--');

%%%%%%        PASSO 3: achar FUNCAO DE PERTINENCIA INDUZIDA         %%%%%%
% aplicar o grau de ativacao (wj) ao consequente de cada regra para gerar
% uma funcao de pertinencia induzida (ou qualificada).

mi_c1 = u.t_norma(w1,C1);
mi_c2 = u.t_norma(w1,C2);

%%%%%%               plotar funcoes de pertinencia induzidas        %%%%%%
% plotar funcao de pertinencia mi_c1
subplot(322); 
plot(x,mi_c1,'m-');

% plotar funcao de pertinencia mi_c2
subplot(324); 
plot(x,mi_c2,'m-');


%%%%%%         PASSO 4: achar FUNCAO DE PERTINENCIA GERAL           %%%%%%
% agregar todas as funcoes de pertinencias induzidas para obter uma geral

mi = u.s_norma(mi_c1, mi_c2);
subplot(326); 
plot(x,mi,'g');
axis([min(x) max(x) 0 1]);
