/*  Date: 15.04.26 - 10:00am  */

/* MARK: - Challenge
# Given an N-ary tree, print the nodes visible to a person walking from the
# bottom-left to the bottom-right in an arc that passes through the root.
#
# The person's path goes:
# - Up the **left boundary** from the bottom-left leaf to the root
# - Down the **right boundary** from the root to the bottom-right leaf
#
#
#        4
#       / \
#      5   7
#     / \   \
#    12   1   8
#
# Output: 12, 5, 4, 7, 8
*/

/* Other example
 
          4
        / | \
       5  7  8
         / \
        12 11
             \
             13
 
# Output: 13, 12, 5, 4, 8, 11, 13
 
 O input acaba sendo a estrutura de dados (Tree) já populada.
*/


// MARK: - Solução

/*
 PS: não consegui fazer o exercício a tempo.
 No fim, ele acabou dando uma dica. Logo dps que a entrevista acabou, continuei o exercício e consegui.
 */

class Tree {
    var value: Int
    var children: [Tree]
    
    init(value: Int, children: [Tree] = []) {
        self.value = value
        self.children = children
    }
}

/*
 Time: O(n) | Memory: O(m)
 */
func uberChallenge(root: Tree) -> [Int] {
    guard !root.children.isEmpty else { return [root.value] }
    
    lazy var arc = [Int]()
    var total = 0
    var ind = 0

    func recursion(in trees: [Tree], h: Int) {
        var newChild = [Tree]()
        for tree in trees {
            newChild += tree.children
        }
        
        if newChild.isEmpty { // parada da recursão
            total = h+(h-1)
            arc = Array(repeating: 0, count: total)
        } else {
            recursion(in: consume newChild, h: h+1)
            /* Consume: remove da memória o array newChild,
             já que para o resto do contexto não é mais necessário */
        }
        
        let i = ind
        let j = total-1 - ind
        
        let left = trees[0].value
        let right = trees[trees.count-1].value
        
        arc[i] = left
        arc[j] = right
        ind += 1
    }
    
    recursion(in: [root], h: 1)
    return arc
}

/* MARK: - Ai
 Solução da IA (Claude)
 Time: O(n) | Memory: O(w)  — onde w é a largura máxima da árvore

 Abordagem iterativa com BFS (level-order traversal).

 Por que é melhor que a recursão?
 1. Sem risco de stack overflow: recursão profunda (árvore com altura N) empilha N frames
    na call stack. BFS iterativo usa uma fila em heap — sem limite prático de profundidade.

 2. Sem precisar de `consume`: a solução recursiva usa `consume newChild` exatamente porque
    o array precisa ser liberado manualmente a cada frame. Aqui o loop sobrescreve `current`
    a cada iteração e o ARC cuida sozinho.

 3. Memória similar: ambas são O(n). Mas a recursão ainda carrega o overhead da call stack
    (O(h) frames), enquanto o BFS usa só O(w) no pico (w = largura máxima do nível).
 */
func solutionAI(root: Tree) -> [Int] {
    guard !root.children.isEmpty else { return [root.value] }

    var levels: [(left: Int, right: Int)] = []
    var current = [root]

    while !current.isEmpty {
        levels.append((left: current[0].value, right: current[current.count - 1].value))

        var next = [Tree]()
        for node in current {
            next += node.children
        }
        current = next
    }

    var arc = [Int]()
    var right = [Int]()

    for i in 0..<levels.count {
        arc.append(levels[levels.count - 1 - i].left)  // esquerda de baixo pra cima
        if i > 0 {
            right.append(levels[i].right)               // direita de cima pra baixo
        }
    }

    return arc + right
}

// MARK: - Drafts
/*
 Primeira solução.
 */
func solution1Draft() {
    var height = 0
    var dict = [Int: (Int, Int)]()

    func ex(in root: Tree) {
        dict[height] = (root.value, root.value)
        
        var trees = root.children
        while !trees.isEmpty {
            height += 1
            dict[height] = (trees[0].value, trees[trees.count-1].value)
            
            var newChild = [Tree]()
            for tree in trees {
                newChild += tree.children
            }
            trees = newChild
        }
        
        var arc = [Int]()
        var count = height
        var increase = -1
        var isLeftSide = true
        
        while count <= height {
            if count == 0 {
                increase = 1
                isLeftSide = false
            }
            
            let tuple = dict[count]
            let value = isLeftSide ? tuple?.0 : tuple?.1
            
            count += increase
            arc.append(value ?? 0)
        }
    }
}
