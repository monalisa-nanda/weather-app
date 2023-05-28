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
    
    // MARK: Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupViewModel()
        setupUI()
    }

    // MARK: UI
    func setupUI() {
        //Implementation of SearBar using UIKIT
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
        //Implementation of Weather UI in Swift UI
        if let weatherUIView = weatherView {
            view.addSubview(weatherUIView.view)
            self.addChild(weatherUIView)
            weatherUIView.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                weatherUIView.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
                weatherUIView.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                weatherUIView.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                weatherUIView.view.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
            ])
        }
    }
    
    private func setupViewModel() {
        let networkManager = NetworkManager()
        let locationManager = LocationManager()
        
        viewModel = WeatherReportViewModel(networkManager: networkManager, locationManager: locationManager)
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

// MARK: Searbar Delegate
extension DisplayWeatherRootViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.viewModel?.weatherInfo.cityName = searchText
            updateData()
        }
    }
}
