-module(cut).
-compile(export_all).

into_list(File)->
    {ok,IO}=file:open(File,[read]),
    into_list(io:get_line(IO,''),IO,[]).

into_list(eof,_IO,Acc)->lists:reverse(Acc);
into_list({error,_Error},_IO,Acc)->lists:reverse(Acc);
into_list(Line,IO,Acc)->
    T=string:tokens(Line,"\t\n"),
    Ints=lists:map(fun(X)->{Int,_}=string:to_integer(X),Int end,T),
    into_list(io:get_line(IO,''),IO,[Ints|Acc]).

build_graph(L)->
    G=digraph:new(),
    build_graph(L,G).

build_graph([],G)->G;
build_graph([H|T],G)->
    [V1|Vertices]=H,
    add_edge(G,V1,Vertices),
    build_graph(T,G).

add_edge(G,V1,[])->G;
add_edge(G,V1,Vertices)->
    [V2|R]=Vertices,
    digraph:add_vertex(G,V1),
    digraph:add_vertex(G,V2),
    digraph:add_edge(G,V1,V2),
    add_edge(G,V1,R),
    G.

contract(G)->
    Edges=digraph:edges(G),
    Vertices=digraph:vertices(G),
    io:format("~p vertices,~p Edges\n",[length(Vertices),length(Edges)]),
    if length(Vertices)>2 ->
        Index=random:uniform(length(Edges)),
        Edge=lists:nth(Index,Edges),
        {_,V1,V2,_}=digraph:edge(G,Edge),
        MergeEdges=digraph:edges(G,V1),
        mergeEdge(G,V1,V2,MergeEdges),
        digraph:del_vertex(G,V1),
        contract(G);
        true->G
    end.


mergeEdge(G,_V1,_V2,[])->G;
mergeEdge(G,V1,V2,Edges)->
    [H|T]=Edges,
    {_,U1,U2,_}=digraph:edge(G,H),
    if U2=:=V1 andalso U1/=V2->
         digraph:add_edge(G,U1,V2);
       U1=:=V1 andalso V2/=U2->
         digraph:add_edge(G,V2,U2);
       true->ok
    end,
    mergeEdge(G,V1,V2,T),
    G.
        
main()->
    random:seed(now()),
    List=into_list("mincut.txt"),
    G=build_graph(List),
    contract(G),
    [V1|R]=digraph:vertices(G),
    digraph:in_degree(G,V1).
