//
//  CategoryFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation

final class CategoryFactory{
    var repository: Repository<VMCategory>
    var app: AppDelegate?
    private static var instance: CategoryFactory?
    private  init(_ app:AppDelegate) {
        repository = Repository<VMCategory>(app)
        self.app = app
    }
    
    static func getInstance(_ app: AppDelegate) -> CategoryFactory{
        if let obj = instance{
            return obj
        }else{
            let  token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil{
                    instance = CategoryFactory(app)
                }
                
            })
            return instance!
        }
    }
    func getAllCategories() throws-> [VMCategory] {
        return try repository.get()
    }
    func addCategory(category: VMCategory) -> (Bool,String?) {
        do{
            if try repository.isEntityExists([VMCategory.colName], keyword: category.name!){
                return (false,"同样的类别已经存在")
            }
            
            repository.insert(vm: category)
            return(true, nil)
        }catch DataError.entityExistesError(let info){
            return (false, info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    
    func getBookCountOfCategory(category id: UUID) -> Int? {
        do{
            return try
            BookFactory.getInstance(app!).getBooksOf(category: id).count
        }catch{
            return nil
        }
    }
    
    
    func remove(category: VMCategory)  throws -> (Bool,String?){
        if let count = getBookCountOfCategory(category: category.id){
            if count > 0{
            return (false, "存在该类别图书，不能删除")
            }
        }else{
            return (false, "无法获取类别信息")
        }
        
        do{
            try repository.delete(id: category.id)
            return (true,nil)
        }catch DataError.deleteExtityError(let info){
            return (false, info)
        }catch{
            return (false,error.localizedDescription)
        }
    }
    
    private  static let plistName = "CategoryTimeList"
    static func updateEditTime(id: UUID){
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)
        dic?.setObject(Date.dateNowAsString(pattern: "yyyy/MM/dd  HH:mm"), forKey: id.uuidString as NSCopying)
        dic?.write(toFile: path! , atomically: true)
    }
    static func getEditTimeFromPlist(id: UUID) -> String{
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)
        if let time = dic?[id.uuidString] as? String {
            return time
        }
        return Date.dateNowAsString(pattern: "yyyy/MM/dd  HH:mm")
    }
    static func removeEditTime(id: UUID){
        let path = Bundle.main.path(forResource: plistName, ofType: "plist")
        let dic = NSMutableDictionary(contentsOfFile: path!)
        dic?.removeObject(forKey: id.uuidString)
        dic?.write(toFile: path!, atomically: true)
    }
}



extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block: () -> Void) {
        
        objc_sync_enter(self)
        
        defer {
            
            objc_sync_exit(self)
            
        }
        
        if _onceTracker.contains(token) {
            
            return
            
        }
        
        _onceTracker.append(token)
        
        block()
        
    }
    
}
