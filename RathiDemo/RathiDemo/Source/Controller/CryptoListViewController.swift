//  CryptoListViewController.swift
//  RathiDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

import UIKit

/// ViewController for displaying a list of cryptocurrencies
class CryptoListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: CryptoListViewModel
    private let searchBar = UISearchBar()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let mainStackView = UIStackView()
    private let filterView = UIStackView()
    private var isSearchActive = false
    
    private lazy var activeFilterButton: UIButton = createFilterButton(title: "Active Coins", isActive: true)
    private lazy var inactiveFilterButton: UIButton = createFilterButton(title: "Inactive Coins", isActive: false)
    private lazy var tokenFilterButton: UIButton = createFilterButton(title: "Only Tokens", filterType: "token")
    private lazy var coinFilterButton: UIButton = createFilterButton(title: "Only Coins", filterType: "coin")
    private lazy var newFilterButton: UIButton = createFilterButton(title: "New Coins")
    
    init(viewModel: CryptoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchCryptos()
    }
}
    
    // MARK: - Private Methods Extension
    private extension CryptoListViewController {
        
    // MARK: - UI Setup
    private func setupUI() {
        setupNavigationBar()
        setupMainStackView()
        setupFilterView()
        setupActivityIndicator()
    }

    private func setupNavigationBar() {
        view.backgroundColor = UIColor(hex: "#590DE4")
        title = "Coin"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(toggleSearchBar)
        )
    }

    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: "CryptoCell")

        mainStackView.addArrangedSubview(searchBar)
        mainStackView.addArrangedSubview(tableView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupFilterView() {
        mainStackView.addArrangedSubview(filterView)
        filterView.axis = .vertical
        filterView.distribution = .fillEqually
        filterView.spacing = 8
        filterView.alignment = .leading
        filterView.backgroundColor = UIColor(hex: "#C8C8C8")
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        filterView.isLayoutMarginsRelativeArrangement = true
        
        let filterView1 = UIStackView()
        filterView1.distribution = .fill
        filterView1.spacing = 8
        filterView1.addArrangedSubview(activeFilterButton)
        filterView1.addArrangedSubview(inactiveFilterButton)
        filterView1.addArrangedSubview(tokenFilterButton)
        filterView1.translatesAutoresizingMaskIntoConstraints = false
        filterView.addArrangedSubview(filterView1)

        let filterView2 = UIStackView()
        filterView2.distribution = .fill
        filterView2.spacing = 8
        filterView2.addArrangedSubview(coinFilterButton)
        filterView2.addArrangedSubview(newFilterButton)
        filterView2.translatesAutoresizingMaskIntoConstraints = false

        filterView.addArrangedSubview(filterView2)
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }

    // MARK: - ViewModel Bindings
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] errorMessage in
            self?.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Filter Button Setup
    private func createFilterButton(title: String, filterType: String? = nil, isActive: Bool? = nil) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 12)]))
        config.baseForegroundColor = .black
        config.baseBackgroundColor = UIColor(hex: "#D1D1D1")
        config.imagePadding = 2

        let button = UIButton(configuration: config, primaryAction: createFilterButtonAction(filterType: filterType, isActive: isActive))
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        return button
    }


    // MARK: - Reset Filter Buttons
    func resetFilterButtons(buttons: [UIButton]) {
        for button in buttons {
            button.configuration?.image = nil
            viewModel.applyFilters()
        }
    }
    
    // MARK: - Toggle Search Bar
    @objc func toggleSearchBar() {
        isSearchActive.toggle()
        searchBar.isHidden = !isSearchActive
        // Hide filter view and reset filter when search is shown
        filterView.isHidden = isSearchActive
        resetFilterButtons(buttons: [activeFilterButton, inactiveFilterButton, tokenFilterButton, coinFilterButton, newFilterButton])
        if !isSearchActive {
            searchBar.text = ""
            viewModel.search(query: "")
        }
    }
    
    func createFilterButtonAction(filterType: String?, isActive: Bool?) -> UIAction {
        return UIAction { [weak self] action in
            guard let self = self, let sender = action.sender as? UIButton else { return }
            self.activityIndicator.startAnimating()

            // Toggle manual selected state
            let isButtonSelected = sender.configuration?.image == nil
            if isButtonSelected {
                sender.configuration?.image = UIImage(named: "check-mark")
                sender.backgroundColor = UIColor(hex: "#E5E5E5")
            } else {
                sender.configuration?.image = nil
                sender.backgroundColor = UIColor(hex: "#D1D1D1")
            }

            // Apply filters based on button type
            if let filterType = filterType {
                self.viewModel.applyFilters(type: isButtonSelected ? filterType : nil)
            } else if let isActive = isActive {
                self.viewModel.applyFilters(isActive: isButtonSelected ? isActive : nil)
            } else {
                self.viewModel.applyFilters(isNew: isButtonSelected ? true : nil)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CryptoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as? CryptoTableViewCell else {
            return UITableViewCell()
        }
        let crypto = viewModel.getCrypto(at: indexPath.row)
        cell.configure(with: crypto)
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension CryptoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activityIndicator.startAnimating()
        viewModel.search(query: searchText)
    }
}
