//
//  MainRouter.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 26.01.2026.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func showDogImage(_ image: UIImage)
}

final class MainRouter: MainRouterProtocol {
    
    private weak var viewController: UIViewController?
    private let builder: BaseBuilderProtocol
    
    init(viewController: UIViewController, builder: BaseBuilderProtocol) {
        self.viewController = viewController
        self.builder = builder
    }
    
    func showDogImage(_ image: UIImage) {
        let dogVC = builder.dogBuild(with: image)
        viewController?.navigationController?.pushViewController(dogVC, animated: true)
    }
}
