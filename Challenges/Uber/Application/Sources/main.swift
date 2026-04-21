func main() {
    let ex01 =
    Tree(value: 4, childs: [
        Tree(value: 5, childs: [
            Tree(value: 12),
            Tree(value: 1)
        ]),
        Tree(value: 7, childs: [
            Tree(value: 8)
        ])
    ])
    
    let ex02 =
    Tree(value: 4, childs: [
        Tree(value: 5),
        Tree(value: 7, childs: [
            Tree(value: 12),
            Tree(value: 11, childs: [
                Tree(value: 13),
            ])
        ]),
        Tree(value: 8)
    ])
    
    let examples = [ex01, ex02]
    for ind in 0..<examples.count {
        let ex = examples[ind]
        let arc = uberChallenge(root: ex)
        
        print("Ex \(ind+1): \(arc)")
    }
}

main()
