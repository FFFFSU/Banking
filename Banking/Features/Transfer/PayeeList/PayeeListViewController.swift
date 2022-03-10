//
//  PayeeListViewController.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import UIKit

class PayeeListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var coordinator: MainCoordinator?
    var payeeListDelegate: PayeeListDelegate?
    var payees: [PayeeData]?
    var selectedPayee: PayeeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = "Payee List"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        tableView.reloadData()
    }
}

extension PayeeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payees?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let payee = payees?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        cell.textLabel?.text = payee.name
        if selectedPayee?.accountNo == payee.accountNo { cell.accessoryType = .checkmark }
        return cell
    }
}

extension PayeeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let payee = payees?[indexPath.row] {
            payeeListDelegate?.didSelectPayee(payee)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
