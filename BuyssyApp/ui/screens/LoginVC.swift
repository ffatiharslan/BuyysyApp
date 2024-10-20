//
//  LoginVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import UIKit

class LoginVC: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        self.navigationItem.title = "Buyysy"
        
        containerView.layer.borderColor = UIColor(.gray).cgColor
        containerView.backgroundColor = .systemGray6
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont(name: "ADLaMDisplay-Regular", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    @IBAction func showPasswordButtonTapped(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
        
        if passwordTextField.isSecureTextEntry {
            showPasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            showPasswordButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.signInWithEmail(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.navigateToMainScreen()
            case .failure(let error):
                self?.showAlert(message: "Giriş hatası: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func signInWithGoogleButtonTapped(_ sender: Any) {
        // Google Sign-In işlemini başlatıyoruz
        viewModel.signInWithGoogle(presentingVC: self) { [weak self] result in
            switch result {
            case .success:
                self?.navigateToMainScreen()
            case .failure(let error):
                self?.showAlert(message: "Giriş hatası: \(error.localizedDescription)")
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
