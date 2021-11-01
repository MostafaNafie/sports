//
//  CoreDataManager.swift
//  Sports
//
//  Created by Mostafa Nafie on 2/11/21.
//

import UIKit

struct CoreDataManager {

    private static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    static func saveSport(_ name: String?) {
        let sport = Sport(context: managedObjectContext)
        sport.name = name
        saveContext()
    }

    static func loadSports() -> [Sport]? {
        do {
            let sportRequest = try managedObjectContext.fetch(Sport.fetchRequest())
            return sportRequest
        } catch {
            print("Error: \(error)")
        }
        return nil
    }

    static func deleteSport(_ sport: Sport) {
        managedObjectContext.delete(sport)
        saveContext()
    }

    static func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                print("Success!")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
