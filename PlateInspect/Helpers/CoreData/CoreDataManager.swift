//
//  CoreDataManager.swift
//  PlateInspect
//
//  Created by Zabroda Gleb on 10.01.2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private let carInfoEntity = "CarInfoEntity"
    private let carInfroAttribute = "carInfo"
    
    private init() {
        CarInfoTransformer.register()
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveCustomStruct(_ carInfo: CarInfo) {
        guard let entity = NSEntityDescription.entity(forEntityName: carInfoEntity, in: context) else { return }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(carInfo.boxed, forKey: carInfroAttribute)
        
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Failed to save data: \(error)")
        }
    }
    
    func fetchCustomStructs() -> [CarInfo] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: carInfoEntity)
        
        do {
            let objects = try context.fetch(fetchRequest)
            return objects.compactMap { object in
                if let box = object.value(forKey: carInfroAttribute) as? CarInfoBox {
                    return box.unbox
                }
                return nil
            }
        } catch {
            print("Failed to fetch data: \(error)")
            return []
        }
    }
}

