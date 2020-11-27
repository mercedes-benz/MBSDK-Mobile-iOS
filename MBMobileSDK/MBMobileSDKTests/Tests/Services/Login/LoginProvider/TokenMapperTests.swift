//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble
import Foundation

@testable import MBMobileSDK

class TokenMapperTests: QuickSpec {

    override func spec() {
        
        var subject: TokenMappable!
        
        beforeEach {
            subject = TokenMapper()
        }
        
        
        describe("map from apiLoginModel") {
            it("should map the token correctly") {
                let loginModel = self.apiLoginModel(expiresIn: 927)
                let expectedExpirationDate = Date(timeIntervalSinceNow: 927)
                
                let token = subject.map(from: loginModel, authenticationType: .keycloak)
                
                expect(token.tokenType).to(equal(.keycloak))
                expect(token.authenticationType).to(equal(.keycloak))
                expect(token.accessToken).to(equal(loginModel.accessToken))
                expect(token.refreshToken).to(equal(loginModel.refreshToken))
                expect(token.expirationDate).to(beCloseTo(expectedExpirationDate))
            }
            
            it("should map ciam tokens correctly") {
                let loginModel = self.apiLoginModel(expiresIn: 927)
 
                let token = subject.map(from: loginModel, authenticationType: .ciam)
                
                expect(token.authenticationType).to(equal(.ciam))
            }
            
            it("should map keycloak tokens correctly") {
                let loginModel = self.apiLoginModel(expiresIn: 927)

                let token = subject.map(from: loginModel, authenticationType: .keycloak)

                expect(token.authenticationType).to(equal(.keycloak))
            }
            
            it("should use tokenType unknown if the token is not a bearer token") {
                let loginModel = self.apiLoginModel(tokenType: "invalid", expiresIn: 927)
                
                let token = subject.map(from: loginModel, authenticationType: .keycloak)
                
                expect(token.tokenType).to(equal(.keycloak))
            }
        }
    }
    
    private func apiLoginModel(tokenType: String = "Bearer", expiresIn: Int) -> APILoginModel {
        let apiLoginModel = APILoginModel(accessToken: "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJraHAwZHhjTDZzTGU3ZFNBcWJrLW8wQXduVkU4aUVQM2czRkxzNlVJOHc4In0.eyJqdGkiOiI3NDgxODBlZi0zODI2LTQ1N2UtOTU3Mi04NzVhZjMyMzI3YmQiLCJleHAiOjE1ODg4NTc4NjMsIm5iZiI6MCwiaWF0IjoxNTg4ODU3MjYzLCJpc3MiOiJodHRwczovL2tleWNsb2FrLnJpc2luZ3N0YXJzLmRhaW1sZXIuY29tL2F1dGgvcmVhbG1zL0RhaW1sZXIiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiZTNkMGYzNjMtZTYyZi00MTkzLWE1ZjAtMzBkZTNiM2ZlYzhiIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYXBwIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNDNhOWZlZTgtN2RmMC00YjI5LTgyYWEtNzg2OTA4NzFiZTVjIiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIG9mZmxpbmVfYWNjZXNzIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImNpYW1pZCI6IjAwMTAwNjE1YTYwMGVlNGEiLCJuYW1lIjoiSm9uYXMgUmVpY2hlcnQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJqb25hcy5yZWljaGVydEBtYWlsYm94Lm9yZyIsImxvY2FsZSI6ImRlLURFIiwiZ2l2ZW5fbmFtZSI6IkpvbmFzIiwiZmFtaWx5X25hbWUiOiJSZWljaGVydCIsImVtYWlsIjoiam9uYXMucmVpY2hlcnRAbWFpbGJveC5vcmcifQ.iGvoI0as-qZF_cwL96ooFbCrH7CuIce5-nmBeKhP94x4BUOQKBX-aL89EhLBe_cuuMHOmO6JhyJ5TIpALwZOGOSF8cHQmzni6dUn01RY4AwDLj1NmtDtKMCe6TK6gdiddcgoycHimEwMqbH6FjVj-NuhNRnxZa49bUlHjZCrotLepCzIw0HkuJuXCmc__bdpuX90dKppFrJ6QkLIe8G4WNRT7uXdQkfMe9XIoTdss_ZvNBX0XXplDZJMMpquJK0CYm0IltSKcabkbOsYkURGOjBrRsGDmcdDimeoimWxgqgPwrpZGaoxg4lPWsxbQrZ0B3IDxUQt5YprSJLc8OgfmA", expiresIn: expiresIn, refreshToken: "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI4M2QzN2Q0NC00M2ZlLTQ4NjItYWMzNS02YjYyM2MwZjU1NTYifQ.eyJqdGkiOiI3ZjQxM2YwMi1lOTgxLTRiMzItYjRiYi02ZDM5MTVlMjU4ZGEiLCJleHAiOjAsIm5iZiI6MCwiaWF0IjoxNTg4ODU3MjY0LCJpc3MiOiJodHRwczovL2tleWNsb2FrLnJpc2luZ3N0YXJzLmRhaW1sZXIuY29tL2F1dGgvcmVhbG1zL0RhaW1sZXIiLCJhdWQiOiJodHRwczovL2tleWNsb2FrLnJpc2luZ3N0YXJzLmRhaW1sZXIuY29tL2F1dGgvcmVhbG1zL0RhaW1sZXIiLCJzdWIiOiJlM2QwZjM2My1lNjJmLTQxOTMtYTVmMC0zMGRlM2IzZmVjOGIiLCJ0eXAiOiJPZmZsaW5lIiwiYXpwIjoiYXBwIiwiYXV0aF90aW1lIjowLCJzZXNzaW9uX3N0YXRlIjoiNDNhOWZlZTgtN2RmMC00YjI5LTgyYWEtNzg2OTA4NzFiZTVjIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6InByb2ZpbGUgZW1haWwgb2ZmbGluZV9hY2Nlc3MifQ.QlIOFSxGR-ROQOn8767bzx2MJfgRlTFswEs31BK3jHU", tokenType: tokenType)
        
        return apiLoginModel
    }

}
