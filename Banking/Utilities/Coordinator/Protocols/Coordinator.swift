//
//  Coordinator.swift
//  Jumpa
//
//  Created by Nico Christian on 15/02/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
