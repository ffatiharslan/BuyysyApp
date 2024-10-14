//
//  RegisterVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 14.10.2024.
//

import UIKit

class RegisterVC: UIViewController {
    
    private let viewModel = RegisterViewModel()
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        // Kullanıcıdan bilgileri alıyoruz.
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurun")
            return
        }
        
        // Kayıt işlemini başlatıyoruz.
        viewModel.register(email: email, password: password, confirmPassword: confirmPassword) { result in
            switch result {
            case .success:
                self.showAlert(message: "Kayıt başarılı!", completion: {
                    // Giriş ekranına yönlendirme veya ana sayfaya geçiş
                    self.dismiss(animated: true, completion: nil)
                })
            case .failure(let error):
                self.showAlert(message: "Hata: \(error.localizedDescription)")
            }
        }
    }
    
    // Hata ve başarı mesajlarını göstermek için basit bir alert fonksiyonu
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}
