//
//  MainViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/30.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {
    private var viewControllerList = [CurrentWeatherViewController()]
    private let toolBar = UIToolbar()
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = 1
        pageControl.isUserInteractionEnabled = false
        
        return pageControl
    }()
    
    private let linkBarButton: UIBarButtonItem = {
        let githubImage = UIImage(named: "GitHub-Mark")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let barButtonItem = UIBarButtonItem(image: githubImage,
                                            style: .plain,
                                            target: self,
                                            action: nil)
        barButtonItem.tintColor = .white
        
        return barButtonItem
    }()
    
    private let listBarButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                            style: .plain,
                                            target: self,
                                            action: nil)
        barButtonItem.tintColor = .white
        
        return barButtonItem
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllerLayer()
        addSubviews()
        setupLayout()
        setupToolBar()
        setupPageViewController()
        bind()
    }
    
    private func bind() {
        linkBarButton.rx.tap
            .bind {
                let url = URL(string: "https://github.com/Allie-e/WeatherToday")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            .disposed(by: disposeBag)
        
        listBarButton.rx.tap
            .bind {
                let searchNavigationController = UINavigationController(rootViewController: SearchLocationViewController())
                searchNavigationController.modalPresentationStyle = .fullScreen
                self.present(searchNavigationController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func addSubviews() {
        addChild(pageViewController)
        [pageViewController.view, toolBar].forEach { view in
            self.view.addSubview(view)
        }
    }
    
    private func setupLayout() {
        toolBar.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolBar.snp.top)
        }
    }
    
    private func setupViewControllerLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let colors = [
            UIColor(red: 93/255, green: 140/255, blue: 210/255, alpha: 1.0).cgColor,
            UIColor(red: 138/255, green: 217/255, blue: 237/255, alpha: 1.0).cgColor,
            UIColor(red: 186/255, green: 238/255, blue: 251/255, alpha: 1.0).cgColor
        ]
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.addSublayer(gradientLayer)
    }
    
    private func setupPageViewController() {
        pageViewController.setViewControllers(viewControllerList,
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        pageViewController.didMove(toParent: self)        
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func setupToolBar() {
        let pageControl = UIBarButtonItem(customView: pageControl)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: self,
                                            action: nil)
        
        toolBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolBar.backgroundColor = .clear
        toolBar.tintColor = .white
        toolBar.setItems([linkBarButton, flexibleSpace, pageControl, flexibleSpace, listBarButton],
                         animated: true)
        toolBar.isHidden = false
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentWeatherViewController = viewController as? CurrentWeatherViewController else {
            return nil
        }
        guard let index = viewControllerList.firstIndex(of: currentWeatherViewController) else {
            return nil
        }
        let previousIndex = index - 1
        if previousIndex < 0 || viewControllerList.count <= previousIndex {
            return nil
        }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentWeatherViewController = viewController as? CurrentWeatherViewController else {
            return nil
        }
        guard let index = viewControllerList.firstIndex(of: currentWeatherViewController) else {
            return nil
        }
        let nextIndex = index + 1
        if viewControllerList.count <= nextIndex {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        
        if let viewController = pageViewController.viewControllers?.first {
            pageControl.currentPage = viewController.view.tag
        }
    }
}
