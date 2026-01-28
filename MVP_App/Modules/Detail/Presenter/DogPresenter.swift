//
//  DogPresenter.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 26.01.2026.
//

import UIKit

protocol DogPresenterProtocol: AnyObject {
    func getInfo()
}

final class DogPresenter: DogPresenterProtocol {
    
    private weak var view: DogViewProtocol?
    private let image: UIImage?
    
    init(view: DogViewProtocol, image: UIImage?) {
        self.view = view
        self.image = image
    }
    
    func getInfo() {
        if let image = self.image  {
            self.view?.setupImage(image)
        }
    }
}
