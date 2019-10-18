//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation
import CoreData
class CategoryRepository {
    var app: AppDelegate
    var context: NSManagedObjectContext
    
    init(_ app: AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    
    func insert(vm: VMCategory){
        let description = NSEntityDescription.entity(forEntityName: VMCategory.entityName, in: context)
        let category = NSManagedObject(entity: description!, insertInto: context)
        category.setValue(vm.id, forKey: VMCategory.colId)
        category.setValue(vm.name, forKey: VMCategory.colName)
        category.setValue(vm.image, forKey: VMCategory.colImage)
        app.saveContext()
    }
    
    func isExists(name: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategory.colName) = %@", name)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            return result.count > 0
        }catch{
            throw DataError.entityExistesError("判断数据获取失败")
        }
        
    }
    
    
    func get() throws -> [VMCategory] {
        var categories = [VMCategory]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
        let result = try context.fetch(fetch) as! [VMCategory]
            for  c in result{
                let vm = VMCategory()
                vm.id = c.id
                vm.name = c.name
                vm.image = c.image
                categories.append(vm)
            }
        }catch{
            throw DataError.readCollectionError("读取集合数据失败")
        }
        
        return categories
    }
    func delete(id: UUID) throws {
        let fetch =  NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetch.predicate = NSPredicate(format: "id = %@ ", id.uuidString)
        let result = try context.fetch(fetch) as! [Category]
        for m in result{
            context.delete(m)
        }
        app.saveContext()
        
    }
}
