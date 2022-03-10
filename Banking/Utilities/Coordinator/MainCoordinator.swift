//
//  MainCoordinator.swift
//  Jumpa
//
//  Created by Nico Christian on 15/02/22.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        navigationController.setViewControllers([vc], animated: false)
        
        APIService.shared.getData(apiType: .balance, expecting: BalanceResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.status == Status.success.rawValue {
                        self.toDashboard()
                    } else if response.status == Status.failed.rawValue {
                        self.toLogin(animated: false)
                    }
                case .failure(_):
                    self.toLogin(animated: false)
                }
            }
        }
    }
    
    func toLogin(animated: Bool) {
        let loginVC = LoginViewController(nibName: LoginViewController.identifier, bundle: .main)
        loginVC.coordinator = self
        loginVC.loginPageMode = .login
        self.navigationController.setViewControllers([loginVC], animated: animated)
    }
    
    func toRegister() {
        let registerVC = LoginViewController(nibName: LoginViewController.identifier, bundle: .main)
        registerVC.coordinator = self
        registerVC.loginPageMode = .register
        navigationController.pushViewController(registerVC, animated: true)
    }
    
    func toDashboard() {
        let dashboardVC = DashboardViewController(nibName: DashboardViewController.identifier, bundle: .main)
        dashboardVC.coordinator = self
        navigationController.setViewControllers([dashboardVC], animated: false)
    }
    
    func toTransfer() {
        let transferVC = TransferViewController(nibName: TransferViewController.identifier, bundle: .main)
        transferVC.coordinator = self
        navigationController.pushViewController(transferVC, animated: true)
    }
    
    func toPayeeList(payees: [PayeeData], sender: TransferViewController, selectedPayee: PayeeData?) {
        let payeeListVC = PayeeListViewController(nibName: PayeeListViewController.identifier, bundle: .main)
        payeeListVC.coordinator = self
        payeeListVC.payees = payees
        payeeListVC.selectedPayee = selectedPayee
        payeeListVC.payeeListDelegate = sender
        
        let navController = UINavigationController()
        navController.setViewControllers([payeeListVC], animated: false)
        
        if let sheet = navController.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        
        
        navigationController.present(navController, animated: true, completion: nil)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
