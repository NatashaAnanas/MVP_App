//
//  BaseBuilder.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 26.01.2026.
//

import UIKit

protocol BaseBuilderProtocol {
    func mainBuild() -> UIViewController
    func dogBuild(with image: UIImage) -> UIViewController
}

final class BaseBuilder: BaseBuilderProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let imageLoaderService: ImageLoaderServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared,
         imageLoaderService: ImageLoaderServiceProtocol = ImageLoaderService()) {
        self.networkService = networkService
        self.imageLoaderService = imageLoaderService
    }
    
    func mainBuild() -> UIViewController {
        let viewController = MainViewController()
        let router = MainRouter(viewController: viewController, builder: self)
        let presenter = MainPresenter(view: viewController,
                                      networkService: networkService,
                                      imageLoaderService: imageLoaderService,
                                      router: router)
        viewController.presenter = presenter
        
        return viewController
    }
    
    func dogBuild(with image: UIImage) -> UIViewController {
        let viewController = DogViewController()
        let presenter = DogPresenter(view: viewController, image: image)
        viewController.presenter = presenter
        
        return viewController
    }
}
