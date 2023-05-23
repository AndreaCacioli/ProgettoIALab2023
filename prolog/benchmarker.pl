test :-
    consult('astar'),
    write("\nTesting A*\n"),
    start,
    unload_file('astar'),

    consult('bfs'),
    write("\nTesting BFS\n"),
    start,
    unload_file('bfs'),

    consult('prof.pl'),
    write("\nTesting ID\n"),
    start,

    assert(maxProf(2000)),
    write("\nTesting DFS\n"),
    prova(Cammino),
    write(Cammino),

    unload_file('prof.pl').