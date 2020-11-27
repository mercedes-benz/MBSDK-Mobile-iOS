//
//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import MBCommonKit

class MockHeaderParamProviding: HeaderParamProviding {
    
    var authorizationHeaderParamKey: String = "authorizationHeaderParamKey"
    var authorizationModeParamKey: String = "authorizationModeParamKey"
    var countryCodeHeaderParamKey: String = "countryCodeHeaderParamKey"
    var defaultHeaderParams: [String : String] = ["header1": "param1"]
    var localeHeaderParamKey: String = "localeHeaderParamKey"
    var ldssoAppHeaderParams: [String : String] = ["lddsoHeader1": "ldssoParam1"]
}
