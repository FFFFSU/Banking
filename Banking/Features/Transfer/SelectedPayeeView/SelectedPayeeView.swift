//
//  SelectedPayeeView.swift
//  Banking
//
//  Created by Nico Christian on 10/03/22.
//

import UIKit

class SelectedPayeeView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var selectedPayeeLabel: UILabel!
    
    var tapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed(SelectedPayeeView.identifier, owner: self, options: nil)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        contentView.backgroundColor = .clear
        addSubview(contentView)
        layer.cornerRadius = 8
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    public func setPayeeLabel(_ accountHolder: String) {
        selectedPayeeLabel.text = accountHolder
    }
    
    @objc
    private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        if let tapAction = tapAction {
            tapAction()
        }
    }
}
