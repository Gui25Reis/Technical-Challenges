import XCTest

final class TechnicalChallengeTests: XCTestCase {
    /* Aux */
    private func validate(tree: Tree, expected: [Int]) {
        let result = uberChallenge(root: tree)
        XCTAssertEqual(expected, result)
    }


    /* Testes */
    func test_01() {
        // Tree:
        //        4
        //       / \
        //      5   7
        //     / \   \
        //    12   1   8
        let tree =
        Tree(value: 4, childs: [
            Tree(value: 5, childs: [
                Tree(value: 12),
                Tree(value: 1)
            ]),
            Tree(value: 7, childs: [
                Tree(value: 8)
            ])
        ])

        validate(tree: tree, expected: [12, 5, 4, 7, 8])
    }

    func test_02() {
        // Tree:
        //          4
        //        / | \
        //       5  7  8
        //         / \
        //        12 11
        //              \
        //              13
        let tree =
        Tree(value: 4, childs: [
            Tree(value: 5),
            Tree(value: 7, childs: [
                Tree(value: 12),
                Tree(value: 11, childs: [
                    Tree(value: 13)
                ])
            ]),
            Tree(value: 8)
        ])

        validate(tree: tree, expected: [13, 12, 5, 4, 8, 11, 13])
    }


    /* Additional tests */

    func test_03() {
        // Single node — no children
        let tree =
        Tree(value: 1)

        validate(tree: tree, expected: [1])
    }

    func test_04() {
        // Two levels — root with 3 children
        //       1
        //     / | \
        //    2  3  4
        let tree =
        Tree(value: 1, childs: [
            Tree(value: 2),
            Tree(value: 3),
            Tree(value: 4)
        ])

        validate(tree: tree, expected: [2, 1, 4])
    }

    func test_05() {
        // Linear tree — single child per level
        //    1
        //    |
        //    2
        //    |
        //    3
        let tree =
        Tree(value: 1, childs: [
            Tree(value: 2, childs: [
                Tree(value: 3)
            ])
        ])

        validate(tree: tree, expected: [3, 2, 1, 2, 3])
    }

    func test_06() {
        // Asymmetric deep tree — left side goes deeper
        //       1
        //      / \
        //     2   3
        //    /
        //   4
        //  /
        // 5
        let tree =
        Tree(value: 1, childs: [
            Tree(value: 2, childs: [
                Tree(value: 4, childs: [
                    Tree(value: 5)
                ])
            ]),
            Tree(value: 3)
        ])

        validate(tree: tree, expected: [5, 4, 2, 1, 3, 4, 5])
    }
}
