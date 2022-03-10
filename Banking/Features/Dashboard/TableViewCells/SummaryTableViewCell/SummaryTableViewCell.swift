//
//  SummaryTableViewCell.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var accountHolderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accountNoLabel.text = UserDefaults.standard.string(forKey: "accountNo")
        accountHolderLabel.text = UserDefaults.standard.string(forKey: "username")
    }

    public func configureBalance(balance: Double) {
        balanceLabel.text = "SGD " + String(format: "%.2f", balance)
    }
}
