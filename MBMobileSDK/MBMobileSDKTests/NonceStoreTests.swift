//
//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBMobileSDK

class NonceStoreTests: QuickSpec {

    override func spec() {
        
        var subject: NonceRepository!
        
        beforeEach {
            subject = NonceStore(defaults: UserDefaults(suiteName: "testSuite") ?? .standard)
        }
        
        describe("when a nonce was never saved") {
            it("store should return nil") {
                expect(subject.nonce()).to(beNil())
            }
        }
        
        describe("when a nonce was saved") {
            it("store should return this nonce") {
                subject.save(nonce: "WD40")
                expect(subject.nonce()).to(equal("WD40"))
            }
        }
        
        describe("when a nonce was overwritten") {
            it("store should return the new nonce") {
                subject.save(nonce: "WD40")
                expect(subject.nonce()).to(equal("WD40"))
                
                subject.save(nonce: "Dübel")
                expect(subject.nonce()).to(equal("Dübel"))
            }
        }
        
        describe("when a nonce was deleted") {
            it("store should return no nonce") {
                subject.save(nonce: "WD40")
                expect(subject.nonce()).to(equal("WD40"))
                
                subject.save(nonce: "Dübel")
                expect(subject.nonce()).to(equal("Dübel"))
                
                subject.save(nonce: nil)
                expect(subject.nonce()).to(beNil())
            }
        }
    }

}
