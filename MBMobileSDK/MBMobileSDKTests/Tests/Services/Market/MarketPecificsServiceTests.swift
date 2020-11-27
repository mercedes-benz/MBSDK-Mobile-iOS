//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Foundation
import Nimble
import MBNetworkKit
@testable import MBMobileSDK


class MarketPecificsServiceTests: QuickSpec {
    
    override func spec() {
        var networking: MockNetworking!
        var subject: MarketsServiceRepresentable!
        
        beforeEach {
            networking = MockNetworking()
            subject = MarketsService(networking: networking)
        }
        
        context("profile fields") {
            describe("when networking returns error") {
                it("should return with failure") {
                    networking.onRequest = { _ in
                        return (nil, MBError(description: "timeout", type: .network(.timeOut(description: nil))))
                    }
                    
                    subject.fetchProfileFields(countryCode: "DE", locale: "de-DE") { result in
                        switch result {
                        case .failure(let error):
                            switch error {
                            case .network:
                                success()
                            }
                        case .success:
                            fail()
                        }
                    }
                }
                
                describe("when networking returns valid response") {
                    it("should return with failure") {
                        
                        let profileField1 = ProfileFieldModel(sequenceOrder: 0, fieldUsage: .mandatory, fieldValidation: nil, selectableValues: nil, field: "field")
                        let profileField2 = ProfileFieldModel(sequenceOrder: 1, fieldUsage: .optional, fieldValidation: nil, selectableValues: nil, field: "field2")
                        let mockedProfileFields: [ProfileFieldModel] = [profileField2, profileField1]
                        
                        let mockedReturn: ((EndpointRouter) -> (model: [ProfileFieldModel]?, error: MBError?)) = { _ in (mockedProfileFields, nil) }
                        networking.onRequest = mockedReturn
                        
                        subject.fetchProfileFields(countryCode: "DE", locale: "de-DE") { result in
                            switch result {
                            case .failure(let error):
                                switch error {
                                case .network:
                                    fail()
                                }
                            case .success(let models):
                                expect(models).to(equal(mockedProfileFields))
                            }
                        }
                    }
                }
            }
            
            context("fetch countries") {
                describe("when networking returns error") {
                    it("should return with failure") {
                        networking.onRequest = { _ in
                            return (nil, MBError(description: "parsing", type: .network(.parsing(description: nil))))
                        }
                        
                        subject.fetchCountries { result in
                            switch result {
                            case .failure(let error):
                                switch error {
                                case .network:
                                    success()
                                }
                            case .success:
                                fail()
                            }
                        }
                    }
                }
                    
                describe("when networking returns valid response") {
                    it("should return with failure") {
                        
                        let apiCountry = APICountryModel(availability: true, countryCode: "DE", countryName: "Germany", instance: "ECE", legalRegion: "DE", locales: nil, natconCountry: false)
                        let apiCountry2 = APICountryModel(availability: true, countryCode: "GB", countryName: "Great Britain", instance: "ECE", legalRegion: "GB", locales: nil, natconCountry: false)
                        
                        let mockedCountries: [APICountryModel] = [apiCountry, apiCountry2]
                        let mockedReturn: ((EndpointRouter) -> (model: [APICountryModel]?, error: MBError?)) = { _ in (mockedCountries, nil) }
                        networking.onRequest = mockedReturn
                        
                        subject.fetchCountries { result in
                            switch result {
                            case .failure(let error):
                                switch error {
                                case .network:
                                    fail()
                                }
                            case .success(let models):
                                expect(models).to(equal(NetworkModelMapper.map(apiCountries: [apiCountry, apiCountry2])))
                            }
                        }
                    }
                }
            }
        }
    }
}
