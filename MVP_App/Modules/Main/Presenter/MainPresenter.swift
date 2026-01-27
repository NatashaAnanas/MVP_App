//
//  MainPresenter.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 26.01.2026.
//

import UIKit

protocol MainPresenterProtocol: AnyObject {
    func fetchInfo()
    func numberOfItems() -> Int
    func item(at index: Int) -> String
    func fetchImage(at index: IndexPath)
    func cachedImage(at index: Int) -> UIImage?
    func didSelectItem(at index: Int)
}

final class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewProtocol?
    private let networkService: NetworkServiceProtocol
    private let router: MainRouterProtocol
    
    private var images: [String] = []
    private var imageCache: [String: UIImage] = [:]
    
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: MainRouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func fetchInfo() {
        networkService.request(
            urlString: "https://dog.ceo/api/breed/hound/images"
        ) { (result: Result<MainModel, NetworkError>) in
            switch result {
            case .success(let response):
                self.images = response.message
                DispatchQueue.main.async {
                    self.view?.updateValue()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfItems() -> Int {
        images.count
    }
    
    func item(at index: Int) -> String {
        images[index]
    }
    
    func fetchImage(at indexPath: IndexPath) {
        let url = images[indexPath.row]
        
        if let cached = imageCache[url] {
            view?.updateImage(cached, at: indexPath)
            return
        }
        
        networkService.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            self.imageCache[url] = image
            DispatchQueue.main.async {
                self.view?.updateImage(image, at: indexPath)
            }
        }
    }
    
    func cachedImage(at index: Int) -> UIImage? {
        let url = images[index]
        return imageCache[url]
    }
    
    func didSelectItem(at index: Int) {
        if let image = imageCache[images[index]] {
            router.showDogImage(image)
        }
    }
}
