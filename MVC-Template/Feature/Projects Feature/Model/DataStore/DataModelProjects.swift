//
//  DataModel.swift
//  BoardIt
//
//  Created by Gilbert Nicholas on 09/06/21.
//

import Foundation

protocol CollectionObserver {
    func didChange()
}

protocol TableObserver {
    func changeMultipleSelectStatus(status: Bool)
    func didDeleteTapped()
}

class ObserverController {
    
    var collObservers = [CollectionObserver]()
    var tableObservers = [TableObserver]()
    
}
