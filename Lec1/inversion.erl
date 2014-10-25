-module(inversion).
-compile(export_all).

read_integers()->
    {ok,Device}=file:open("IntegerArray.txt",[read]),
    read_integers(Device,[]). 

read_integers(Device,Acc)->
        case io:fread(Device,"","~d") of
        eof->
            lists:reverse(Acc);
        {ok,[Line]}->
	    read_integers(Device,[Line|Acc])
	end.

main()->
    Data=read_integers(),
    {C,_}=merge_sort_count(Data),
    C.

split(N,List) when is_integer(N),N>=0,is_list(List)->
	case split(N,List,[]) of
		{_,_}=Result->Result;
		Fault when is_atom(Fault)->
			erlang:error(Fault,[N,List])
	end;
split(N,List)->
	erlang:error(badarg,[N,List]).

split(0,L,R)->
	{lists:reverse(R,[]),L};
split(N,[H|T],R)->
	split(N-1,T,[H|R]);
split(_,[],_)->
	badarg.

merge([],L2,M,Count)->
	{Count,lists:reverse(M,L2)};
merge(L1,[],M,Count)->
	{Count,lists:reverse(M,L1)};
merge([H1|T1],[H2|T2],M,Count) when H1=<H2->
	merge(T1,[H2|T2],[H1|M],Count);
merge([H1|T1],[H2|T2],M,Count)->
        merge([H1|T1],T2,[H2|M],Count+length([H1|T1])).	
merge(L1,L2)->
        merge(L1,L2,[],0).

merge_sort_count([])->
	{0,[]};
merge_sort_count([E])->
	{0,[E]};
merge_sort_count(List)->
	{L,R}=split(length(List) div 2,List),
	{CountL,SortedL}=merge_sort_count(L),
    {CountR,SortedR}=merge_sort_count(R),
	{CountM,M}=merge(SortedL,SortedR),
	{CountM+CountL+CountR,M}.
	
