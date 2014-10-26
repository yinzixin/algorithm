-module(qsortcount).
-compile(export_all).

read_integers()->
    {ok,Device}=file:open("QuickSort.txt",[read]),
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
    qsort1(Data).

qsort([])->[];
qsort([P|T])->
    qsort([X||X<-T,X=<P])++[P]++qsort([X||X<-T,X>P]).

qsort1([])->{0,[]};
qsort1([E])->{0,[E]};
qsort1([P|T])->
    Small=[X||X<-T,X=<P],
    {Csmall,SortedSmall}=qsort1(Small),
    Large=[X||X<-T,X>P],
    {Clarge,SortedLarge}=qsort1(Large),
    {length(T)+Csmall+Clarge,SortedSmall++[P]++SortedLarge}.

qsortn([])->{0,[]};
qsortn([E])->{0,[E]};
qsortn(L)->
    [P|T]=lists:reverse(L),
    Rest=lists:reverse(T),
    Small=[X||X<-Rest,X=<P],
    {Csmall,SortedSmall}=qsortn(Small),
    Large=[X||X<-Rest,X>P],
    {Clarge,SortedLarge}=qsortn(Large),
    {length(T)+Csmall+Clarge,SortedSmall++[P]++SortedLarge}.

qsortm([])->{0,[]};
qsortm([E])->{0,[E]};
qsortm(L)->
    [A|R]=L,
    Length=length(L),
    Index=if (Length rem 2)=:=0 ->
        Length div  2;
       true ->
        (Length+1) div 2
        end,
    B=lists:nth(Index,L),
    C=lists:nth(Length,L),
    P=median(A,B,C),
    Rest=if P=:=A ->
        R;
    
     B=:=P->
        {Left,Right}=lists:split(Index-1,L),
        Left++tl(Right);
    
     P=:=C->
       tl(lists:reverse(L))
    end,
    Small=[X||X<-Rest,X=<P],
    {Csmall,SortedSmall}=qsortm(Small),
    Large=[X||X<-Rest,X>P],
    {Clarge,SortedLarge}=qsortm(Large),
    {length(Rest)+Csmall+Clarge,SortedSmall++[P]++SortedLarge}.

    

median(X,Y,Z) ->
M=if Y=<X andalso X=<Z orelse Z=<X andalso X=<Y ->
    X;
    (X=<Y andalso Y=<Z) orelse (Z=< Y andalso Y=<X) ->
    Y;
    (X=<Z andalso Z=<Y) orelse (Y=<Z andalso Z=<X)->
    Z
end,
M.

