//
//  DataManager.swift
//  CoreDataTest
//
//  Created by Jason on 02/08/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    
    private static let entityUserWord = "People"
    
    class func addObject(object: String,property: String,condition: String){
        
        let context = CoreDataManager.sharedInstance.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.entityUserWord)
        request.predicate = NSPredicate(format:"name = %@",object)
        
        do {
            let resultsList = try context.fetch(request)
            if resultsList.count > 0 {
                let people = resultsList[0] as! People
                people.name = object
                people.sex = property
                people.age = condition
                
            } else {
                let people = NSEntityDescription.insertNewObject(forEntityName: DataManager.entityUserWord, into: context)
                people.setValue(object, forKey: "name")
                people.setValue(property, forKey: "sex")
                people.setValue(condition, forKey: "age")
            }

            try context.save()
            
        } catch  {
            print("error: \(error)")
            
        }
        
    }
    
    class func deleteObject(object: String,property: String,condition: String){
        
        let context = CoreDataManager.sharedInstance.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.entityUserWord)
        request.predicate = NSPredicate(format:"name = %@ and sex = %@ and age = %@",object,property,condition)
        
        do {
            let resultsList = try context.fetch(request)
            if resultsList.count > 0 {
                for i in 0..<resultsList.count {
                    context.delete(resultsList[i] as! NSManagedObject)
                }
            }
            try context.save()
            
        } catch  {
            
             print("error: \(error)")
            
            
        }
        
        
    }
    
    class func changeObject(object: String,property: String,condition: String){
        let context = CoreDataManager.sharedInstance.context
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.entityUserWord)
        request.predicate = NSPredicate(format:"name = %@ and sex = %@ and age = %@",object,property,condition)
        
        do {
            let resultsList = try context.fetch(request)
            if resultsList.count > 0 {
                let people = resultsList[0] as! People
                people.name = object + "&ok"
                people.sex = property + "&ok"
                people.age = condition + "&ok"
            }
            try context.save()
            
        } catch  {
             print("error: \(error)")
            
            
        }

        
    }
    
    class func fetchObjectDetail(object: String,property: String,condition: String) -> [People]{
        let context = CoreDataManager.sharedInstance.context
        var peopleArr:[People] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.entityUserWord)
        request.predicate = NSPredicate(format:"name = %@ and sex = %@ and age = %@",object,property,condition)
        
        do {
            let resultsList = try context.fetch(request)
            if resultsList.count > 0 {
               peopleArr = resultsList as! [People]
            }
            try context.save()
            
        } catch  {
             print("error: \(error)")
            
            
        }
       return peopleArr
    }
    
    class func fetchAllObject() -> [People]{
        let context = CoreDataManager.sharedInstance.context
        var peopleArr:[People] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: DataManager.entityUserWord)
       
        do {
            let resultsList = try context.fetch(request)
            if resultsList.count > 0 {
                peopleArr = resultsList as! [People]
            }
            try context.save()
            
        } catch  {
            
            
        }
        return peopleArr
    }

    
    
}
