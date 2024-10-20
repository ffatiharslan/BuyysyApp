//
//  FirestoreManager.swift
//  BuyssyApp
//
//  Created by fatih arslan on 15.10.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

class FirestoreManager {
    
    private let db = Firestore.firestore()
    private let userID: String? = Auth.auth().currentUser?.uid
    
    var favoriteProductList = BehaviorSubject<[Products]>(value: [Products]())

    func addProductToFavorites(product: Products, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = userID else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış."])))
            return
        }
        
        let productData: [String: Any] = [
            "id": product.id ?? 0,
            "ad": product.ad ?? "",
            "resim": product.resim ?? "",
            "kategori": product.kategori ?? "",
            "fiyat": product.fiyat ?? 0,
            "marka": product.marka ?? ""
        ]
        
        db.collection("users").document(userID).collection("favorites").document("\(product.id ?? 0)").setData(productData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
    func removeProductFromFavorites(productID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = userID else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış."])))
            return
        }

        db.collection("users").document(userID).collection("favorites").document("\(productID)").delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
    func fetchFavoriteProducts(completion: @escaping (Result<[Products], Error>) -> Void) {
        guard let userID = userID else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış."])))
            return
        }

        var list = [Products]()
        
        db.collection("users").document(userID).collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        let id = data["id"] as? Int ?? 0
                        let ad = data["ad"] as? String ?? ""
                        let resim = data["resim"] as? String ?? ""
                        let kategori = data["kategori"] as? String ?? ""
                        let fiyat = data["fiyat"] as? Int ?? 0
                        let marka = data["marka"] as? String ?? ""
                        
                        let product = Products(id: id, ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka)
                        list.append(product)
                    }
                }
                self.favoriteProductList.onNext(list)
                completion(.success(list))
            }
        }
    }
    
    
    
    func isProductFavorited(productID: Int, completion: @escaping (Bool) -> Void) {
        guard let userID = userID else {
            completion(false)
            return
        }
        
        let docRef = db.collection("users").document(userID).collection("favorites").document("\(productID)")
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

