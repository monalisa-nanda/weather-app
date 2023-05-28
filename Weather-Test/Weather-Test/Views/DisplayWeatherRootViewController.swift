//
//  DisplayWeatherRootViewController.swift
//  Weather-Test
//
//  Created by Monalisa Nanda on 5/27/23.
//

import UIKit
import SwiftUI

class DisplayWeatherRootViewController: UIViewController {
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private var weatherView: UIHostingController<WeatherInformationView>?
    private var viewModel: WeatherReportViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        assembleMVVM()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .brown
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant:-20)
            ])
        if let swiftUIView = weatherView {
            view.addSubview(swiftUIView.view)
            self.addChild(swiftUIView)
            swiftUIView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                swiftUIView.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
                swiftUIView.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                swiftUIView.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                swiftUIView.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
            ])
        }
    }
    
    private func assembleMVVM() {
        let networkManager = NetworkManager()
        viewModel = WeatherReportViewModel(networkManager: networkManager)
        if let vm = viewModel {
            weatherView = UIHostingController(rootView: WeatherInformationView(weatherReportViewModel: vm))
        }
    }
    
    private func updateData() {
        Task { @MainActor () -> Void in
            await self.viewModel?.loadData()
        }
    }
}

extension DisplayWeatherRootViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.viewModel?.weatherInfo.cityName = searchText
            updateData()
        }
    }
}
