//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation

/// State for head unit language attribute
public enum LanguageState: Int, Codable, CaseIterable {
	case german = 0
	case englishImp = 1
	case french = 2
	case italian = 3
	case spanish = 4
	case japanese = 5
	case englishMet = 6
	case dutch = 7
	case danisch = 8
	case swedish = 9
	case turkish = 10
	case portuguese = 11
	case russian = 12
	case arabic = 13
	case chinese = 14
	case englishAm = 15
	case tradChinese = 16
	case korean = 17
	case finnish = 18
	case polish = 19
	case czech = 20
	case protugueseBrazil = 21
	case norwegian = 22
	case thai = 23
	case indonesian = 24
	case bulgarian = 25
	case slovakian = 26
	case croatian = 27
	case serbian = 28
	case hungarian = 29
	case ukrainian = 30
	case malayan = 31
	case vietnamese = 32
	case romanian = 33
	case tradChineseTw = 34
	case hebrew = 35
	case unknown
}


// MARK: - Extension

extension LanguageState {
	
	public var toString: String {
		switch self {
		case .arabic:			return "arabic"
		case .bulgarian:		return "bulgarian"
		case .chinese:			return "chinese"
		case .croatian:			return "croatian"
		case .czech:			return "czech"
		case .danisch:			return "danisch"
		case .dutch:			return "dutch"
		case .englishAm:		return "english am"
		case .englishImp:		return "english imp"
		case .englishMet:		return "english met"
		case .finnish:			return "finnish"
		case .french:			return "french"
		case .german:			return "german"
		case .hebrew:			return "hebrew"
		case .hungarian:		return "hungarian"
		case .indonesian:		return "indonesian"
		case .italian:			return "italian"
		case .japanese:			return "japanese"
		case .korean:			return "korean"
		case .malayan:			return "malayan"
		case .norwegian:		return "norwegian"
		case .polish:			return "polish"
		case .portuguese:		return "portuguese"
		case .protugueseBrazil:	return "portuguese brazil"
		case .romanian:			return "romanian"
		case .russian:			return "russian"
		case .serbian:			return "serbian"
		case .slovakian:		return "slovakian"
		case .spanish:			return "spanish"
		case .swedish:			return "swedish"
		case .thai:				return "thai"
		case .tradChinese:		return "chinese trad"
		case .tradChineseTw:	return "chinese trad taiwan"
		case .turkish:			return "turkish"
		case .ukrainian:		return "ukrainian"
		case .unknown:			return "unknown"
		case .vietnamese:		return "vietnamese"
		}
	}
}
