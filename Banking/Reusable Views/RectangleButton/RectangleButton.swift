//
//  RectangleButton.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import UIKit

class RectangleButton: UIButton {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }()
    
    var title: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        layer.cornerRadius = 8
    }
    
    public func configure(buttonType: RectangleButtonType) {
        setTitle(buttonType.getTitle(), for: .normal)
        backgroundColor = buttonType.getBackgroundColor()
        tintColor = buttonType.getTintColor()
        layer.borderColor = buttonType.getBorderColor().cgColor
        layer.borderWidth = buttonType.getBorderWidth()
    }
    
    public func startLoading() {
        setTitle("", for: .normal)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        activityIndicator.startAnimating()
    }
    
    public func stopLoading() {
        setTitle(title, for: .normal)
        activityIndicator.stopAnimating()
    }
}
