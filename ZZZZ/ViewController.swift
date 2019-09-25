//
//  ViewController.swift
//  ZZZZ
//
//  Created by Hare Sudhan on 09/12/17.
//  Copyright © 2017 ZZZZ. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var submitButton: NSButton!
    @IBOutlet var jsonInputView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        if let textDict = jsonInputView.string.dict{
            print(CodeGenerator.convertJsonDictToModel(textDict))
        }else{
            let alert = NSAlert()
            alert.messageText = "Invalid JSON format"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.beginSheetModal(for: self.view.window!) { (modalResponse) in

            }
        }

    }
    
}

/*
 func setupCoreDataStack(_ model : NSManagedObjectModel){
 var storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
 storeURL.appendPathComponent("DTCache.cache")
 
 // setup persistent store coordinator
 let persistenceStore = NSPersistentStoreCoordinator(managedObjectModel: model)
 
 do{
 try persistenceStore.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
 
 try FileManager.default.removeItem(at: storeURL)
 }
 catch{
 abort()
 }
 
 
 // create MOC
 let managedObjContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
 managedObjContext.persistentStoreCoordinator = persistenceStore
 
 }
 
 
 func createModel(_ json : String) -> NSManagedObjectModel{
 let model = NSManagedObjectModel()
 
 // Create the entity
 let entity = NSEntityDescription()
 entity.name = "DTCachedFile"
 // Assume that there is a correct
 // `CachedFile` managed object class.
 entity.managedObjectClassName = String("Cached File")
 
 // Create the attributes
 var properties = Array<NSAttributeDescription>()
 
 let remoteURLAttribute = NSAttributeDescription()
 remoteURLAttribute.name = "remoteURL"
 remoteURLAttribute.attributeType = .stringAttributeType
 remoteURLAttribute.isOptional = false
 remoteURLAttribute.isIndexed = true
 properties.append(remoteURLAttribute)
 
 let fileDataAttribute = NSAttributeDescription()
 fileDataAttribute.name = "fileData"
 fileDataAttribute.attributeType = .binaryDataAttributeType
 fileDataAttribute.isOptional = false
 fileDataAttribute.allowsExternalBinaryDataStorage = true
 properties.append(fileDataAttribute)
 
 let lastAccessDateAttribute = NSAttributeDescription()
 lastAccessDateAttribute.name = "lastAccessDate"
 lastAccessDateAttribute.attributeType = .dateAttributeType
 lastAccessDateAttribute.isOptional = false
 properties.append(lastAccessDateAttribute)
 
 let expirationDateAttribute = NSAttributeDescription()
 expirationDateAttribute.name = "expirationDate"
 expirationDateAttribute.attributeType = .dateAttributeType
 expirationDateAttribute.isOptional = false
 properties.append(expirationDateAttribute)
 
 let contentTypeAttribute = NSAttributeDescription()
 contentTypeAttribute.name = "contentType"
 contentTypeAttribute.attributeType = .stringAttributeType
 contentTypeAttribute.isOptional = true
 properties.append(contentTypeAttribute)
 
 let fileSizeAttribute = NSAttributeDescription()
 fileSizeAttribute.name = "fileSize"
 fileSizeAttribute.attributeType = .integer32AttributeType
 fileSizeAttribute.isOptional = false
 properties.append(fileSizeAttribute)
 
 let entityTagIdentifierAttribute = NSAttributeDescription()
 entityTagIdentifierAttribute.name = "entityTagIdentifier"
 entityTagIdentifierAttribute.attributeType = .stringAttributeType
 entityTagIdentifierAttribute.isOptional = true
 properties.append(entityTagIdentifierAttribute)
 
 // Add attributes to entity
 entity.properties = properties
 
 // Add entity to model
 model.entities = [entity]
 
 // Done :]
 return model
 }
 */
