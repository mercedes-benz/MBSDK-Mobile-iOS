//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

func pass(_ file: FileString = #file, line: UInt = #line) {
    expect(true) == true
}

func success() {
    expect(true) == true
}

func assert(subset: [String: String], toBeIn all: [String: String]) {
    subset.forEach { (defaultKey, defaultValue) in
        let matches = all.contains { key, value -> Bool in
            key == defaultKey && value == defaultValue
        }
        expect(matches).to(beTrue())
    }
}
