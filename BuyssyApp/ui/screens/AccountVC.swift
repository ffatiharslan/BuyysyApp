//
//  ProfileVC.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import UIKit

class AccountVC: UIViewController {
    
    private let viewModel = AccountViewModel()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    
    private func setupTableView() {
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccountCell")
       }
       
       private func setupHeaderView() {
           // Email bilgisini elle ata
           viewModel.fetchUserEmail()
           emailLabel.text = viewModel.userEmail
       }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        
        viewModel.signOut { [weak self] result in
            switch result {
            case .success:
                self?.navigateToLoginScreen()
            case .failure(let error):
                self?.showAlert(message: "Çıkış işlemi sırasında hata oluştu: \(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavController") as! UINavigationController
        
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = loginNavController
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        cell.textLabel?.text = viewModel.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToDetail(for: indexPath.row)
    }
    
    private func navigateToDetail(for index: Int) {
        switch index {
        case 0:
            let favoritesVC = FavoritesVC()
            self.navigationController?.pushViewController(favoritesVC, animated: true)
        case 1:
            let cartVC = CartVC()
            self.navigationController?.pushViewController(cartVC, animated: true)
        /*case 2:
            let addressVC = DeliveryAddressesVC()
            self.navigationController?.pushViewController(addressVC, animated: true)*/
        default:
            break
        }
    }
}
