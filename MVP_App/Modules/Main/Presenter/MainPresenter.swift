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
    func fetchImage(at index: Int)
    func cachedImage(at index: Int) -> UIImage?
    func didSelectItem(at index: Int)
}

final class MainPresenter: MainPresenterProtocol {
    
    private weak var view: MainViewProtocol?
    private let networkService: NetworkServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol
    private let router: MainRouterProtocol
    
    private var images: [String] = []
    
    init(view: MainViewProtocol,
         networkService: NetworkServiceProtocol,
         imageLoaderService: ImageLoaderServiceProtocol,
         router: MainRouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
        self.router = router
    }
    
    func fetchInfo() {
        networkService.request(
            urlString: Constants.mainURL
        ) {  [weak self] (result: Result<MainModel, NetworkError>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.images = response.message
                self.view?.reloadData()
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
    
    func fetchImage(at index: Int) {
        let url = images[index]
        
        if let cached = imageLoaderService.getCachedImage(for: url) {
            view?.updateImage(cached, at: index)
            return
        }
        
        imageLoaderService.loadImage(from: url) { [weak self] image in
            guard let self, let image else { return }
            self.view?.updateImage(image, at: index)
        }
    }
    
    func cachedImage(at index: Int) -> UIImage? {
        let url = images[index]
        return imageLoaderService.getCachedImage(for: url)
    }
    
    func didSelectItem(at index: Int) {
        let url = images[index]
        
        if let cached = imageLoaderService.getCachedImage(for: url) {
            router.showDogImage(cached)
            return
        }
        
        imageLoaderService.loadImage(from: url) { [weak self] image in
            guard let image else { return }
            self?.router.showDogImage(image)
        }
    }
}

private enum Constants {
    static let mainURL = "https://dog.ceo/api/breed/hound/images"
}
