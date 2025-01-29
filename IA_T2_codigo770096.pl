% Declarar predicados dinâmicos
:- dynamic jogador/1.
:- dynamic cartao_vermelho/1.
:- dynamic tecnico/1.
:- dynamic discute/2.
:- dynamic gols_sofridos/1.
:- dynamic gols_feitos/1.
:- dynamic salarios/1.
:- dynamic lento/1.
:- dynamic faltou_do_treino/1.

% Predicados para selecionar a situação
reset :-
    retractall(jogador(_)),
    retractall(cartao_vermelho(_)),
    retractall(tecnico(_)),
    retractall(discute(_, _)),
    retractall(gols_sofridos(_)),
    retractall(gols_feitos(_)),
    retractall(salarios(_)),
    retractall(lento(_)),
    retractall(faltou_do_treino(_)).

listar_fatos :-
    write('Fatos carregados:'), nl,
    forall(jogador(X), format('   jogador(~w).~n', [X])),
    forall(cartao_vermelho(X), format('   cartao_vermelho(~w).~n', [X])),
    forall(tecnico(X), format('   tecnico(~w).~n', [X])),
    forall(discute(X, Y), format('   discute(~w, ~w).~n', [X, Y])),
    forall(gols_sofridos(X), format('   gols_sofridos(~w).~n', [X])),
    forall(gols_feitos(X), format('   gols_feitos(~w).~n', [X])),
    forall(salarios(X), format('   salarios(~w).~n', [X])),
    forall(lento(X), format('   lento(~w).~n', [X])),
    forall(faltou_do_treino(X), format('   faltou_do_treino(~w).~n', [X])).

selecionar :-
    write('Escolha a situacao para analisar (1/2/3): '),
    read(Situacao),
    situacao(Situacao),
    listar_fatos, nl.

% BASE DE CONHECIMENTO
%Regras
problema(preparo_fisico) :- preparo_fisico(ruim).                                  %1
problema(equipe_tecnica) :- atritos(constantes), situacao_psicologica(ruim).       %2
problema(time) :- preparo_fisico(bom), atritos(raros), situacao_de_gols(ruim).     %3
problema(insatisfacao_financeira) :- atritos(constantes), salarios(atrasados).     %4
problema(nenhum) :- preparo_fisico(bom), situacao_de_gols(boa), salarios(em_dia).  %5
atritos(constantes) :- jogador(X), tecnico(Y), discute(X, Y).                      %6
atritos(constantes) :- jogador(X), jogador(Y), discute(X, Y).                      %7
atritos(raros) :- \+ atritos(constantes).                                          %aux1
situacao_psicologica(ruim) :- jogador(X), suspenso(X).                             %8
situacao_de_gols(ruim) :- gols_sofridos(X), gols_feitos(Y), maior(X, Y).           %9
situacao_de_gols(boa) :- gols_sofridos(X), gols_feitos(Y), \+ maior(X, Y).         %10
suspenso(X) :- cartao_vermelho(X).                                                 %11
preparo_fisico(ruim) :- jogador(X), faltou_do_treino(X).                           %12
preparo_fisico(ruim) :- jogador(X), lento(X).                                      %13
preparo_fisico(bom) :- \+ preparo_fisico(ruim).                                    %aux2
maior(X, Y) :- X > Y.                                                              %aux3

% SITUAÇÕES COM OS FATOS INICIAIS
situacao(1) :-
    reset,
    asserta(jogador(jorge)),              %14
    asserta(cartao_vermelho(jorge)),      %15
    asserta(tecnico(tecX)),               %16
    asserta(discute(jorge, tecX)),        %17
    asserta(gols_sofridos(1)),            %18
    asserta(gols_feitos(2)),              %19
    asserta(salarios(atrasados)).         %20

situacao(2) :-
    reset,
    asserta(jogador(lucas)),              %14
    asserta(lento(lucas)),                %15
    asserta(jogador(jogadorX)),           %16
    asserta(jogador(jogadorY)),           %17
    asserta(jogador(jogadorZ)),           %18
    asserta(cartao_vermelho(jogadorX)),   %19
    asserta(discute(jogadorY, jogadorZ)), %20
    asserta(gols_sofridos(3)),            %21
    asserta(gols_feitos(5)).              %22

situacao(3) :-
    reset,
    asserta(faltou_do_treino(ninguem)),   %14
    asserta(lento(ninguem)),              %15
    asserta(salarios(em_dia)),            %16
    asserta(gols_sofridos(1)),            %17
    asserta(gols_feitos(7)).              %18

