
% Transpose function
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
        lists_firsts_rests(Ms, Ts, Ms1),
        transpose(Rs, Ms1, Tss).

lists_firsts_rests([], [], []).
lists_firsts_rests([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
        lists_firsts_rests(Rest, Fs, Oss).

labeling([]).
labeling([Head|Tail]):-fd_labeling(Head), labeling(Tail).

check_rows(N,[]).
check_rows(N,[Head|Tail]):-length(Head,N),
			   fd_domain(Head,1,N),
			   fd_all_different(Head),
			   check_rows(N,Tail).

check_cols(N,[]).
check_cols(N,L):-check_rows(N,L).

%predicate to process all the constraints
apply_constraints([],T).
apply_constraints([H|Tail],T):-constraint(H,T),apply_constraints(Tail,T).


get_entry(R,C,T,E):-
    nth(R,T,R_List), nth(C,R_List,E).

sum_(+(S,[]),0,T).
sum_(+(S,[[Row|Col]|Tail]),Sum,T):-
	get_entry(Row,Col,T,E),
	sum_(+(S,Tail),Temp_Sum,T),
	Temp_Sum #= Sum-E.
   
prod_(*(P,[]),1,T).
prod_(*(P,[[Row|Col]|Tail]),Prod,T):-
	get_entry(Row,Col,T,E),
	prod_(*(S,Tail),Temp_Prod,T),
	Prod #= Temp_Prod*E.
	

sub_(-(S,[Row1|Col1],[Row2|Col2]),Sub,T):-
	get_entry(Row1,Col1,T,E1),
	get_entry(Row2,Col2,T,E2),
	(Sub #= E1-E2; Sub #= E2-E1).
 
div_(/(S,[Row1|Col1],[Row2|Col2]),Div,T):-
	get_entry(Row1,Col1,T,E1),
	get_entry(Row2,Col2,T,E2),
	(Div #= E1/E2; Div #= E2/E1).

constraint(+(S,L),T):-
	sum_(+(S,L),S,T).

constraint(*(S,L),T):-
	prod_(*(S,L),S,T).

constraint(-(S,L1,L2),T):-
	sub_(-(S,L1,L2),S,T).

constraint(/(S,L1,L2),T):-
	div_(/(S,L1,L2),S,T).

kenken_testcase(
  6,
  [
   +(11, [[1|1], [2|1]]),
   /(2, [1|2], [1|3]),
   *(20, [[1|4], [2|4]]),
   *(6, [[1|5], [1|6], [2|6], [3|6]]),
   -(3, [2|2], [2|3]),
   /(3, [2|5], [3|5]),
   *(240, [[3|1], [3|2], [4|1], [4|2]]),
   *(6, [[3|3], [3|4]]),
   *(6, [[4|3], [5|3]]),
   +(7, [[4|4], [5|4], [5|5]]),
   *(30, [[4|5], [4|6]]),
   *(6, [[5|1], [5|2]]),
   +(9, [[5|6], [6|6]]),
   +(8, [[6|1], [6|2], [6|3]]),
   /(2, [6|4], [6|5])
  ]
).

kenken(N,C,T):-
	length(T,N),check_rows(N,T),
	transpose(T,T_tran),
	check_cols(N,T_tran),
	apply_constraints(C,T),
	labeling(T).



%Plain %kenken
plain_kenken(N,C,T):- length(T,N),
		      p_check_rows(N,T),
		      transpose(T,Trans_T),
		      p_check_cols(N,Trans_T),
                      p_apply_constraints(C,T).

p_check_rows(N,[]).
p_check_rows(N,[Head|Tail]):-length(Head,N),
			   bagof(X,between(1,N,X),Temp),
			   permutation(Temp,Head),	   
			   all_distinct(Head),
			   p_check_rows(N,Tail).

all_distinct([]).
all_distinct([H|T]):- \+member(H,T),all_distinct(T). 

p_check_cols(N,[]).
p_check_cols(N,L):-p_check_rows(N,L).

%predicate %to %process %all %the %constraints
p_apply_constraints([],T).
p_apply_constraints([H|Tail],T):-constraint(H,T),p_apply_constraints(Tail,T).
