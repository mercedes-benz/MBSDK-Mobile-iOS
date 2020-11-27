//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBMobileSDK

class BffAgreementRouterTest: QuickSpec {

    override func spec() {
         
        var bffProviderMock: BffProviderMock!
        
        beforeEach {
            bffProviderMock = BffProviderMock(sdkVersion: "1.0")
            IngressKit.bffProvider = bffProviderMock
        }
        
        describe("general router behaviour") {
            var getRoute: BffAgreementRouter!
            var updateRoute: BffAgreementRouter!
            
            beforeEach {
                getRoute = BffAgreementRouter.get(accessToken: "token", countryCode: "DE", locale: "de-DE", checkForNewVersions: true)
                updateRoute = BffAgreementRouter.update(accessToken: "token", locale: "de-DE", requestModel: ["key": "value"])
            }
            
            describe("baseURL") {
                it("should use the bffProvider baseUrl") {
                    expect(getRoute.baseURL) == bffProviderMock.urlProvider.baseUrl
                    expect(updateRoute.baseURL) == bffProviderMock.urlProvider.baseUrl
                }
            }
            
            describe("httpHeader") {
                it("should have all default headers") {
                    assert(subset: bffProviderMock.headerParamProvider.defaultHeaderParams, toBeIn: getRoute.httpHeaders!)
                    assert(subset: bffProviderMock.headerParamProvider.defaultHeaderParams, toBeIn: updateRoute.httpHeaders!)
                }
                
                it("should have ldsso headers") {
                    assert(subset: bffProviderMock.headerParamProvider.ldssoAppHeaderParams, toBeIn: getRoute.httpHeaders!)
                    assert(subset: bffProviderMock.headerParamProvider.ldssoAppHeaderParams, toBeIn: updateRoute.httpHeaders!)
                }
            }
            
            describe("cachePolicy") {
                it("should have no cache policy") {
                    expect(getRoute.cachePolicy).to(beNil())
                    expect(updateRoute.cachePolicy).to(beNil())
                }
            }
            
            describe("timeout") {
                it("should use the default timeout") {
                    expect(getRoute.timeout) == bffProviderMock.urlProvider.requestTimeout
                    expect(updateRoute.timeout) == bffProviderMock.urlProvider.requestTimeout
                }
            }
        }
        
        
        describe("get") {
            var getRoute: BffAgreementRouter!
            
            beforeEach {
                getRoute = BffAgreementRouter.get(accessToken: "token", countryCode: "DE", locale: "de-DE", checkForNewVersions: true)
            }
            
            describe("httpHeaders") {
                it("should have locale header") {
                    assert(subset: [bffProviderMock.headerParamProvider.localeHeaderParamKey: "de-DE"], toBeIn: getRoute.httpHeaders!)
                }
                
                it("should have add bearer prefix to the token if needed") {
                    expect(getRoute.httpHeaders?[bffProviderMock.headerParamProvider.authorizationHeaderParamKey]) == "Bearer token"
                }
            }
            
            it("should be a get request") {
                expect(getRoute.method) == .get
            }
            
            it("should use the correct path") {
                expect(getRoute.path) == "agreements"
            }
            
            describe("parameters") {
                var params: [String: String]!
                
                beforeEach {
                    params = getRoute.parameters! as? [String: String]
                }
                
                it("should have address and locale params") {
                    expect(params["addressCountry"]) == "DE"
                    expect(params["locale"]) == "de-DE"
                }
                
                it("should have usecase param if checkForNewVersion is true") {
                    expect(params["usecase"]) == "CHECK_FOR_NEW_VERSIONS"
                }
                
                it("should not have usecase param if checkForNewVersion is false") {
                    let route = BffAgreementRouter.get(accessToken: "token", countryCode: "DE", locale: "de-DE", checkForNewVersions: false)
                    expect(route.parameters?.first { $0.key == "usecase"}).to(beNil())
                }
            }
            
            it("should use url standard parameter encoding") {
                expect(getRoute.parameterEncoding) == .url(type: .standard)
            }
            
            it("should not have body parameters") {
                expect(getRoute.bodyParameters).to(beNil())
            }
        }
        
        describe("update") {
            var updateRoute: BffAgreementRouter!
            
            beforeEach {
                updateRoute = BffAgreementRouter.update(accessToken: "token", locale: "de-DE", requestModel: ["key": "value"])
            }
            
            describe("httpHeaders") {
                it("should have locale header") {
                    assert(subset: [bffProviderMock.headerParamProvider.localeHeaderParamKey: "de-DE"], toBeIn: updateRoute.httpHeaders!)
                }
                
                it("should have add bearer prefix to the token if needed") {
                    expect(updateRoute.httpHeaders?[bffProviderMock.headerParamProvider.authorizationHeaderParamKey]) == "Bearer token"
                }
            }
            
            it("should be a post request") {
                expect(updateRoute.method) == .post
            }
            
            it("should use the correct path") {
                expect(updateRoute.path) == "/user/agreements"
            }
            
            it("should not have url parameters") {
                expect(updateRoute.parameters).to(beNil())
            }
            
            it("should use the given model as body parameters") {
                expect(updateRoute.bodyParameters as? [String: String]) == ["key": "value"]
            }
            
            it("should use json encoding for the body") {
                expect(updateRoute.bodyEncoding) == .json
            }
        }
        
    }

}
