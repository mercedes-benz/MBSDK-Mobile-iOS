//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import Quick
import Nimble

@testable import MBMobileSDK

class NetworkModelMapperAssignmentTests: QuickSpec {
    
    
    override func spec() {

        describe("map apiAssignmentPreconditionMode") {
            it("should use correct input values") {
                let input = APIAssignmentPreconditionModel(assignmentType: "OWNER", baumusterDescription: "S Class", mercedesMePinRequired: true, salesDesignation: "S Class 600", termsOfUseRequired: true, vin: "AValidVin")
                
                let result = NetworkModelMapper.map(apiAssignmentPreconditionModel: input)
                
                expect(result.assignmentType) == .owner
                expect(result.model) == "S Class"
                expect(result.mercedesMePinRequired) == true
                expect(result.termsOfUseRequired) == true
                expect(result.vin) == "AValidVin"
            }
            
            it("should use defaults if no inputs are given") {
                let input = APIAssignmentPreconditionModel(assignmentType: nil, baumusterDescription: nil, mercedesMePinRequired: nil, salesDesignation: nil, termsOfUseRequired: nil, vin: "AValidVin")
                
                let result = NetworkModelMapper.map(apiAssignmentPreconditionModel: input)
                
                expect(result.assignmentType) == .unknown
                expect(result.model) == ""
                expect(result.mercedesMePinRequired) == false
                expect(result.termsOfUseRequired) == false
                expect(result.vin) == "AValidVin"
            }
            
            context("model name") {
                it("should use the baumusterDescription if available") {
                    let result = NetworkModelMapper.map(apiAssignmentPreconditionModel:
                        self.preconditionModel(baumuster: "aBaumuster", salesDesignation: nil))
                    expect(result.model) == "aBaumuster"
                }
                
                it("should use the salesDesignation if baumusterDescription is nil") {
                    let result = NetworkModelMapper.map(apiAssignmentPreconditionModel:
                        self.preconditionModel(baumuster: nil, salesDesignation: "aSalesDesignation"))
                    expect(result.model) == "aSalesDesignation"
                }
                
                it("should use the salesDesignation if baumusterDescription is empty") {
                    let result = NetworkModelMapper.map(apiAssignmentPreconditionModel:
                        self.preconditionModel(baumuster: "", salesDesignation: "aSalesDesignation"))
                    expect(result.model) == "aSalesDesignation"
                }
                
                it("should default to an empty string of no information is available") {
                    let result = NetworkModelMapper.map(apiAssignmentPreconditionModel:
                        self.preconditionModel(baumuster: "", salesDesignation: ""))
                    expect(result.model) == ""
                }
            }
        }
        
    }
    
    private func preconditionModel(baumuster: String?, salesDesignation: String?) -> APIAssignmentPreconditionModel {
        return APIAssignmentPreconditionModel(assignmentType: nil, baumusterDescription: baumuster, mercedesMePinRequired: nil, salesDesignation: salesDesignation, termsOfUseRequired: nil, vin: "AValidVin")
    }
    
}
