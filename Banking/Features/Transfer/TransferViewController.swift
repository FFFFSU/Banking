//
//  TransferViewController.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import UIKit

class TransferViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    @IBOutlet weak var selectedPayeeView: SelectedPayeeView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountPromptLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var transferNowButton: RectangleButton!
    var payees: [PayeeData] = []
    var selectedPayee: PayeeData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transfer"
        amountTextField.delegate = self
        descriptionTextField.delegate = self
        setupView()
        fetchPayees()
        transferNowButton.addTarget(self, action: #selector(transferNowButtonAction(_:)), for: .touchUpInside)
        selectedPayeeView.tapAction = {
            self.coordinator?.toPayeeList(payees: self.payees, sender: self, selectedPayee: self.selectedPayee)
        }
    }
    
    private func setupView() {
        transferNowButton.configure(buttonType: .transferNow)
        
        let toolbar = UIToolbar()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [spacer, doneButton]
        toolbar.sizeToFit()
        
        amountTextField.inputAccessoryView = toolbar
        descriptionTextField.inputAccessoryView = toolbar
    }
    
    func fetchPayees() {
        APIService.shared.getData(apiType: .payees, expecting: Payee.self) { result in
            switch result {
            case .success(let payees):
                DispatchQueue.main.async {
                    if payees.status == Status.success.rawValue, let data = payees.data {
                        self.payees = data
                    } else if payees.status == Status.failed.rawValue {
                        
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func transferNowButtonAction(_ sender: RectangleButton) {
        if let amount = amountTextField.text, amount.isEmpty {
            amountPromptLabel.isHidden = false
        }
        if selectedPayee == nil {
            let alertController = UIAlertController(title: "No Payee Selected", message: "Please select a payee first.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else if let amountString = amountTextField.text, !amountString.isEmpty, let amount = Double(amountString.replacingOccurrences(of: ",", with: ".")), let selectedPayee = selectedPayee, let description = descriptionTextField.text {
            transferNowButton.startLoading()
            APIService.shared.postData(apiType: .transfer, httpBody: APIService.formatTransferBody(receipientAccountNo: selectedPayee.accountNo, amount: amount, description: description), expecting: TransferResponse.self) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if response.status == Status.success.rawValue {
                            let alertController = UIAlertController(title: "Transfer successful", message: "You have successfully transfered SGD \(amount) to \(selectedPayee.name)", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Close", style: .default, handler: { _ in
                                self.coordinator?.popViewController()
                            })
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                        } else if response.status == Status.failed.rawValue {
                            let alertController = UIAlertController(title: "Transfer failed!", message: response.error?.firstUppercased, preferredStyle: .alert)
                            let action = UIAlertAction(title: "Close", style: .default, handler: { _ in
                                self.transferNowButton.stopLoading()
                            })
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    @objc
    private func doneButtonAction(_ sender: UIBarButtonItem) {
        amountTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}

extension TransferViewController: PayeeListDelegate {
    func didSelectPayee(_ payee: PayeeData) {
        self.selectedPayee = payee
        selectedPayeeView.setPayeeLabel(payee.name)
    }
}

extension TransferViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === amountTextField {
            amountPromptLabel.isHidden = true
        }
        return true
    }
}
