//
//  LoginVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import UIKit

class LoginVC: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.login(email: email, password: password) { result in
            switch result {
            case .success:
                print("Giriş başarılı, ana ekrana yönlendiriliyor...")
                self.navigateToMainScreen()
            case .failure(let error):
                print("Giriş hatası: \(error.localizedDescription)")
                // Hata mesajı gösterin
                self.showAlert(message: "Giriş hatası: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func navigateToMainScreen() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")

        guard let window = UIApplication.shared.windows.first else { return }
           window.rootViewController = mainTabBarController
           UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
       }

       private func showAlert(message: String) {
           let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
}
