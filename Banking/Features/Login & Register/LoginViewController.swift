//
//  LoginViewController.swift
//  Banking
//
//  Created by Nico Christian on 09/03/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var usernamePromptLabel: UILabel!
    @IBOutlet weak var passwordPromptLabel: UILabel!
    @IBOutlet weak var confirmPasswordPromptLabel: UILabel!
    @IBOutlet weak var loginButton: RectangleButton!
    @IBOutlet weak var registerButton: RectangleButton!
    
    weak var coordinator: MainCoordinator?
    var loginPageMode: LoginPageMode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    private func setupView() {
        title = loginPageMode?.rawValue
        
        if let loginPageMode = loginPageMode {
            if loginPageMode == .login {
                confirmPasswordTextField.isHidden = true
                loginButton.configure(buttonType: .login)
                registerButton.configure(buttonType: .registerSecondary)
            } else if loginPageMode == .register {
                confirmPasswordTextField.isHidden = false
                loginButton.isHidden = true
                registerButton.configure(buttonType: .registerPrimary)
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: RectangleButton) {
        
        if let username = usernameTextField.text, let password = passwordTextField.text {
            usernamePromptLabel.isHidden = !username.isEmpty
            passwordPromptLabel.isHidden = !password.isEmpty

            if !username.isEmpty && !password.isEmpty {
                loginButton.startLoading()
                APIService.shared.postData(apiType: .login, httpBody: APIService.formatAuthenticationBody(username: username, password: password), expecting: AuthenticationResponse.self) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self.verifyLogin(data: data, login: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    @IBAction func registerButtonAction(_ sender: RectangleButton) {
        if let loginPageMode = loginPageMode, loginPageMode == .login {
            coordinator?.toRegister()
        } else {
            if let username = usernameTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
                usernamePromptLabel.isHidden = !username.isEmpty
                passwordPromptLabel.isHidden = !password.isEmpty
                confirmPasswordPromptLabel.isHidden = !confirmPassword.isEmpty
                confirmPasswordPromptLabel.text = "Confirm password is required!"

                if password != confirmPassword {
                    confirmPasswordPromptLabel.isHidden = false
                    confirmPasswordPromptLabel.text = "Confirm password not match"
                    return
                }
                
                if !username.isEmpty && !password.isEmpty && !confirmPassword.isEmpty {
                    registerButton.startLoading()
                    APIService.shared.postData(apiType: .register, httpBody: APIService.formatAuthenticationBody(username: username, password: password), expecting: AuthenticationResponse.self) { result in
                        switch result {
                        case .success(let data):
                            DispatchQueue.main.async {
                                self.verifyLogin(data: data, login: false)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    private func verifyLogin(data: AuthenticationResponse, login: Bool) {
        if data.status == Status.success.rawValue, let username = data.username, let accountNo = data.accountNo, login {
            UserDefaults.standard.set(data.token, forKey: "token")
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.set(accountNo, forKey: "accountNo")
            self.coordinator?.toDashboard()
        } else if data.status == Status.success.rawValue, !login {
            let alertController = UIAlertController(title: "Registration successful", message: "You can login now", preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: .default, handler: { _ in
                self.coordinator?.popViewController()
            })
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else if data.status == Status.failed.rawValue, let error = data.error {
            showAlert(title: "Login failed", message: error.firstUppercased)
        }
    }
    
    public func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default, handler: { _ in
            self.loginButton.stopLoading()
            self.registerButton.stopLoading()
            
        })
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === usernameTextField {
            usernamePromptLabel.isHidden = true
        } else  if textField === passwordTextField {
            passwordPromptLabel.isHidden = true
        } else if textField === confirmPasswordTextField {
            confirmPasswordPromptLabel.isHidden = true
        }
        return true
    }
}
