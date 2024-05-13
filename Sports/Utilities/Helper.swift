//
//  Helper.swift
//  Sports
//
//  Created by Omar on 11/05/2024.
//

import UIKit
import Reachability
class Helper {
    static func setupActivityIndicator(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return activityIndicator
    }
    
    static func presentAddToFavoritesAlert(from viewController: UIViewController, yesAction: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: Constants.Alerts.addFavoriteMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Alerts.yesButtonTitle, style: .default, handler: { _ in
            yesAction()
        }))
        alert.addAction(UIAlertAction(title: Constants.Alerts.noButtonTitle, style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true)
    }
    
    static func presentRemoveFromFavoritesAlert(from viewController: UIViewController, yesAction: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: Constants.Alerts.removeFavoriteMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Alerts.deleteButtonTitle, style: .destructive, handler: { _ in
            yesAction()
        }))
        alert.addAction(UIAlertAction(title: Constants.Alerts.noButtonTitle, style: .cancel, handler: nil))
        
        viewController.present(alert, animated: true)
    }
    
    static func presentNetworkAlert(from viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: Constants.Alerts.networkErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Alerts.openSettings, style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: Constants.Alerts.cancel, style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    static func isConnectedToNetwork() -> Bool {
        guard let reachability = try? Reachability() else { return false }
        
        switch reachability.connection {
        case .wifi, .cellular:
            return true
        case .unavailable, .none:
            return false
        }
    }
    static func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd MMM. yyyy"
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
}
