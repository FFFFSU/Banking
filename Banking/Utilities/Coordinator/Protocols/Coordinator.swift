//
//  Coordinator.swift
//  Jumpa
//
//  Created by Nico Christian on 15/02/22.
//

import UIKit

@objc protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    @objc optional func start()
}
