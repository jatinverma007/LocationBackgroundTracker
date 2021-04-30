//
//  AppCorrdinator.swift
//  LocationTracker
//
//  Created by jatin verma on 30/04/21.
//

import Foundation
import UIKit

class AppCorrdinator {
    private let window: UIWindow!
    
    var homeVC:HomeViewController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "root_view_controller") as! HomeViewController
        let rootNC = UINavigationController(rootViewController: home)
        self.window?.rootViewController = rootNC
        self.window?.makeKeyAndVisible()
        
    }
}
