//
//  Copyright © 2020 MBition GmbH. All rights reserved.
//

import RealmSwift
import MBRealmKit

class ImageDbModelMapper: DbModelMapping {
	
	typealias BusinessModel = TopImageModel
	typealias DbModel = DBTopImageModel
	
	func map(_ dbModel: DBTopImageModel) -> TopImageModel {
		return TopImageModel(vin: dbModel.vin,
							 components: dbModel.components.map { self.map($0) })
	}
	
	func map(_ businessModel: TopImageModel) -> DBTopImageModel {
		
		let components = List<DBTopImageComponentModel>()
		components.append(objectsIn: businessModel.components.map {  self.map($0) })
		
		let dbTopImage = DBTopImageModel()
		dbTopImage.components = components
		dbTopImage.vin = businessModel.vin
		return dbTopImage
	}
	
	
	// MARK: - Helper
	
	private func map(_ model: DBTopImageComponentModel) -> TopImageComponentModel {
		return TopImageComponentModel(name: model.name,
									  imageData: model.imageData)
	}
	
	private func map(_ model: TopImageComponentModel) -> DBTopImageComponentModel {
		
		let dbTopImageComponent = DBTopImageComponentModel()
		dbTopImageComponent.name = model.name
		dbTopImageComponent.imageData = model.imageData
		return dbTopImageComponent
	}
}
