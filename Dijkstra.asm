section .data
    ; graph represented as an adjacency matrix
    graph db 5, 9, 0, 1, 0, 9, 20, 0, 5, 0, 0, 5, 8, 0, 0, 0, 8, 0
    ; distances array to store the shortest distances
    distances db 100, 100, 100, 100, 100
    ; visited array to keep track of visited nodes
    visited db 0, 0, 0, 0, 0
    ; start node
    startNode db 0
    ; number of nodes in the graph
    numNodes db 5

section .bss
    currentNode resb 1   ; variable to store current node

section .text
    global _start


_start:
    ; initialize distances for start node
    mov ebx, startNode
    mov [distances+ebx], 0
    call dijkstra

    ; exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; subroutine to implement dijkstra's algorithm
dijkstra:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; initialize variables
    mov ebx, 0
    mov esi, distances
    mov edi, graph

dijkstra_loop:
    ; find the node with the shortest distance that hasn't been visited
    mov ebx, 0
    mov ecx, 100
    mov edx, 0

find_node_loop:
    cmp [visited+edx], 0
    jne skip
    cmp [esi+edx], 0
    jle skip
    cmp [esi+edx], ecx
    jge skip
    mov ebx, edx
    mov ecx, [esi+edx]

skip:
    inc edx
    cmp edx, numNodes
    jl find_node_loop

    ; mark the current node as visited
    mov [visited+ebx], 1

    ; update distances for all unvisited neighbors
    mov edx, 0
update_distances_loop:
    cmp edx, numNodes
    jge end_loop
    cmp [visited+edx], 0
    jne skip_update
    cmp [edi+ebx*numNodes+edx], 0
    jne update

skip_update:
    inc edx
    jmp update_distances_loop

update:
    cmp [esi+ebx]+[edi+ebx*numNodes+edx], [esi+edx]
    jle skip_update
    mov eax, [esi+ebx]+[edi+ebx*numNodes+edx]
    mov [esi+edx], eax

end_loop:
    inc edx
    jmp update_distances_loop

    ; continue loop until all nodes have been visited
    cmp ebx, numNodes-1
    jne dijkstra_loop

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
