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
    var childs: [Tree]
    
    init(value: Int, childs: [Tree] = []) {
        self.value = value
        self.childs = childs
    }
}

/*
 Time: O(n) | Memory: O(m)
 */
func uberChallenge(root: Tree) -> [Int] {
    guard !root.childs.isEmpty else { return [root.value] }
    
    lazy var arc = [Int]()
    var total = 0
    var ind = 0

    func recursion(in trees: [Tree], h: Int) {
        var newChild = [Tree]()
        for tree in trees {
            newChild += tree.childs
        }
        
        if newChild.isEmpty { // parada da recursão
            total = h+(h-1)
            arc = Array(repeating: 0, count: total)
        } else {
            recursion(in: newChild, h: h+1)
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


// MARK: - Drafts
/*
 Primeira solução.
 */
func solution1Draft() {
    var height = 0
    var dict = [Int: (Int, Int)]()

    func ex(in root: Tree) {
        dict[height] = (root.value, root.value)
        
        var trees = root.childs
        while !trees.isEmpty {
            height += 1
            dict[height] = (trees[0].value, trees[trees.count-1].value)
            
            var newChild = [Tree]()
            for tree in trees {
                newChild += tree.childs
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
