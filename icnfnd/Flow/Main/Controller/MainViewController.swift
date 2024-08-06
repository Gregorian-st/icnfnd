//
//  MainViewController.swift
//  icnfnd
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let networkService = NetworkService()
    private let cellIconReuseID = "iconCell"
    private let rowHeight: CGFloat = 82
    
    private var icons = Icons()
    private var imageLoader = ImageLoader()

    // MARK: - Outlets
    
    @IBOutlet weak var iconsTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.layer.cornerRadius = searchButton.frame.size.height / 2
        }
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.layer.cornerRadius = searchTextField.frame.size.height / 2
            searchTextField.layer.borderWidth = 0.5
            searchTextField.layer.borderColor = UIColor.systemGray2.cgColor
            searchTextField.layer.masksToBounds = true
            searchTextField.setLeftPaddingPoints(10)
            searchTextField.delegate = self
        }
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        fetchIcons(searchText: searchTextField.text ?? "")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView()
        dismissKeyboardRecognizer()
    }
    
    // MARK: - Logic
    
    private func fetchIcons(searchText: String) {
        
        view.endEditing(true)
        
        let trimmedText = searchText.trimmingCharacters(in: [" "])
        
        guard !trimmedText.isEmpty
        else {
            showAlert(title: "Error!", message: "Empty search query")
            return
        }
        
        networkService.fetchIcons(searchText: trimmedText) { [weak self] result in
            guard let self = self
            else { return }
            
            switch result {
            case .success(let iconsResult):
                DispatchQueue.main.async {
                    self.icons.totalCount = iconsResult.totalCount
                    self.icons.items = iconsResult.items
                    self.iconsTableView.setContentOffset(.zero, animated: false)
                    self.iconsTableView.reloadData()
                    if self.icons.totalCount == 0 {
                        self.showAlert(title: "Oops!", message: "Nothing found 😕")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(title: "Error!", message: "\(error.code) - \(error.message)")
                }
            }
        }
    }
    
    private func setupTableView() {
        
        iconsTableView.register(UINib(nibName: "IconCell", bundle: nil), forCellReuseIdentifier: cellIconReuseID)
        iconsTableView.cellLayoutMarginsFollowReadableWidth = true
        iconsTableView.separatorStyle = .none
    }
    
    private func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func imageSave(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            showAlert(title: "Save error", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved!", message: "The image has been saved to your photos.")
        }
    }
    private func dismissKeyboardRecognizer() {
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        icons.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIconReuseID, for: indexPath) as! IconCell
        cell.imageLoader = imageLoader
        cell.icon = icons.items[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let icon = icons.items[indexPath.row]
        if let maxSizeIndex = icon.maxRasterSizeIndex {
            let urlString = icon.rasterSizes[maxSizeIndex].formats.first?.previewURL ?? ""
            imageLoader.fetchImage(urlString: urlString) { [weak self] image in
                if let image = image {
                    DispatchQueue.main.async {
                        UIImageWriteToSavedPhotosAlbum(image,
                                                       self,
                                                       #selector(self?.imageSave(_:didFinishSavingWithError:contextInfo:)),
                                                       nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Error!", message: "The image is empty")
                    }
                }
            }
        } else {
            showAlert(title: "Error!", message: "Max Size not found")
        }
        
    }
}

// MARK: - UITextFieldDelegate

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        fetchIcons(searchText: searchTextField.text ?? "")
        return true
    }
}
