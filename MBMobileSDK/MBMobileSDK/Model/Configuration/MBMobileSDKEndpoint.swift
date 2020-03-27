//
// Copyright © 2020 MBition GmbH. All rights reserved.
//

import Foundation

public struct MBMobileSDKEndpoint: EndpointConfiguration {
    
    public typealias Region = EndpointRegion
    public typealias Stage = EndpointStage
    
    // MARK: Properties
    
    let region: Region
    let stage: Stage
    

    // MARK: - Init
    
    public init(region: Region, stage: Stage) {

        self.region = region
        self.stage = stage
    }
}
