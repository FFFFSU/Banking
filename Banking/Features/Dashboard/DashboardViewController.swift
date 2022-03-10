//
//  DashboardViewController.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var makeTransferButton: RectangleButton!
    
    weak var coordinator: MainCoordinator?
    var transactionDatas: [TransactionData]?
    var groupedTransactions = [[TransactionData]]()
    var balance: Double = 0
    
    lazy var logoutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonAction(_:)))
        return button
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        title = "Dashboard"
        setupTableView()
        navigationItem.rightBarButtonItem = logoutButton
        makeTransferButton.configure(buttonType: .makeTransfer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SummaryTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: SummaryTableViewCell.identifier)
        tableView.register(UINib(nibName: TransactionTableViewCell.identifier, bundle: .main), forCellReuseIdentifier: TransactionTableViewCell.identifier)
    }
    
    @objc private func refreshData() {
        fetchBalance()
        fetchTransaction()
        refreshControl.endRefreshing()
    }
    
    private func fetchBalance() {
        APIService.shared.getData(apiType: .balance, expecting: BalanceResponse.self) { result in
            switch result {
            case .success(let balance):
                if balance.status == Status.success.rawValue, let balance = balance.balance {
                    DispatchQueue.main.async {
                        self.balance = balance
                    }
                } else if balance.status == Status.failed.rawValue {
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchTransaction() {
        APIService.shared.getData(apiType: .transaction, expecting: Transaction.self) { result in
            switch result {
            case .success(let transactions):
                DispatchQueue.main.async {
                    self.transactionDatas = transactions.data
                    self.groupedTransactions.removeAll()
                    if let transactionDatas = self.transactionDatas {
                        let dates = transactionDatas.map { $0.transactionDate.iso8601withFractionalSeconds.removeTimeStamp() }
                        let uniqueDates = Array(Set(dates)).sorted(by: { $0 > $1 })
                        for uniqueDate in uniqueDates {
                            let filteredData = transactionDatas.filter { $0.transactionDate.iso8601withFractionalSeconds.removeTimeStamp() == uniqueDate }
                            self.groupedTransactions.append(filteredData)
                        }
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func logoutButtonAction(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(nil, forKey: "token")
        coordinator?.toLogin(animated: true)
    }
    @IBAction func makeTransferButtonAction(_ sender: Any) {
        coordinator?.toTransfer()
    }
}

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + groupedTransactions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return groupedTransactions[section - 1].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SummaryTableViewCell.identifier, for: indexPath) as? SummaryTableViewCell else { return UITableViewCell() }
            cell.configureBalance(balance: balance)
            return cell
        } else {
            let transactionData = groupedTransactions[indexPath.section - 1][indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
            cell.configure(transactionData: transactionData)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        default:
            return groupedTransactions[section - 1][0].transactionDate.iso8601withFractionalSeconds.dashboardFormat()
        }
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
