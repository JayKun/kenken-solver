:-use_module(library(clpfd)).

kenken(N,C,T):-

%predicate to check whether every row and column has numbers 1 to N
matrix_check(N,List):-
	length(List,N), fd_domain(List,1,N).

%predicate to process all the constraints
apply_constraints([],List).
apply_constraints([H|T],List):-constraint(H,List),apply_constraints(T,List).


get_entry(R,C,List,E):-
    nth0(R,List,R_List), nth0(C,R_List,E).

sum_(+(S,[]),0,List).
sum_(+(S,[Row-Col|Tail]),T,Sum):-
	get_entry(Row,Col,List,E),
	Sum is Temp_Sum+E,
	sum_(+(S,Tail),Temp_Sum).
   
prod_(*(P,[]),1,List).
prod_(*(P,[Row-Col|Tail]),Prod,List):-
	get_entry(Row,Col,List,E),
	Prod is Temp_Prod*E,
	prod_(*(S,Tail),Temp_Prod,List).
	

sub_(-(S,Row1-Col1,Row2-Col2),Sub,List):-
	get_entry(Row1,Col1,List,E1),
	get_entry(Row2,Col2,List,E2),
	Sub is E1-E2; Sub is E2-E1.
 
div_(/(S,Row1-Col1,Row2-Col2),Div,List):-
	get_entry(Row1,Col1,List,E1),
	get_entry(Row2,Col2,List,E2),
	Div is E1/E2; Div is E2/E1.

constraint(+(S,L),List):-
	sum_(+(S,L),S,List).

constraint(*(S,L),List):-
	prod_(*(S,L),S,List).

constraint(-(S,L1,L2),List):-
	sub_(-(S,L1,L2),S,List).

constraint(/(S,L1,L2),List):-
	div_(/(S,L1,L2),S,List).


