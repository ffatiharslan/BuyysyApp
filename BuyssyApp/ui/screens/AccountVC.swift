//
//  ProfileVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import UIKit

class AccountVC: UIViewController {
    
    private let viewModel = AccountViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        
        viewModel.signOut { result in
            switch result {
            case .success:
                self.navigateToLoginScreen()
            case .failure(let error):
                self.showAlert(message: "Çıkış işlemi sırasında hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavController") as! UINavigationController

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = loginNavController
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
