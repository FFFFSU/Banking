//
//  TransactionTableViewCell.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var accountHolderLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(transactionData: TransactionData) {
        let amount = String(format: "%.2f", transactionData.amount)
        amountLabel.text = transactionData.transactionType == "transfer" ? "- " + amount : amount
        amountLabel.textColor = transactionData.transactionType == "transfer" ? .secondaryLabel : .systemGreen
        accountHolderLabel.text = transactionData.receipient.accountHolder
        accountNoLabel.text = transactionData.receipient.accountNo
    }
}
