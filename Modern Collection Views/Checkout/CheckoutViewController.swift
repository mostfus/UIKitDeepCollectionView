/*
See the LICENSE.txt file for this sample's licensing information.

Abstract:
A view controller that presents a payment checkout in a WKWebView
and intercepts deep link redirects to navigate back into the app.
*/

import UIKit
import WebKit

protocol CheckoutViewControllerDelegate: AnyObject {
    func checkoutDidComplete(with deepLinkURL: URL)
    func checkoutDidCancel()
}

final class CheckoutViewController: UIViewController {

    private static let appScheme = "moderncollections"

    private static let demoCheckoutHTML = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: -apple-system, system-ui;
                background: #f5f5f7;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }
            .card {
                background: white;
                border-radius: 16px;
                padding: 32px;
                width: 90%;
                max-width: 400px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.08);
                text-align: center;
            }
            h2 { margin-bottom: 8px; }
            .amount { font-size: 36px; font-weight: 700; margin: 16px 0; }
            .order { color: #888; font-size: 14px; margin-bottom: 24px; }
            .btn {
                display: block;
                width: 100%;
                padding: 16px;
                border: none;
                border-radius: 12px;
                font-size: 18px;
                font-weight: 600;
                color: white;
                cursor: pointer;
                margin-top: 12px;
            }
            .btn-success { background: #34c759; }
            .btn-fail { background: #ff3b30; }
        </style>
    </head>
    <body>
        <div class="card">
            <h2>Checkout</h2>
            <div class="amount">$99.00</div>
            <div class="order">Order #12345</div>
            <button class="btn btn-success"
                onclick="window.location.href='moderncollections://payment/success?order_id=12345'">
                Pay Now
            </button>
            <button class="btn btn-fail"
                onclick="window.location.href='moderncollections://payment/failure?order_id=12345'">
                Simulate Failure
            </button>
        </div>
    </body>
    </html>
    """

    private let checkoutURL: URL? = nil
    private lazy var webView = WKWebView()

    weak var delegate: CheckoutViewControllerDelegate?

    private lazy var openPaymentButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Открыть оплату"
        config.cornerStyle = .large
        config.baseBackgroundColor = .systemBlue
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(openPaymentTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Checkout"
        configureButton()
    }
}

// MARK: - Configuration

private extension CheckoutViewController {

    func configureButton() {
        view.addSubview(openPaymentButton)
        NSLayoutConstraint.activate([
            openPaymentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPaymentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func showWebView() {
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let checkoutURL {
            webView.load(URLRequest(url: checkoutURL))
        } else {
            webView.loadHTMLString(Self.demoCheckoutHTML, baseURL: nil)
        }
    }

    func hideWebView() {
        webView.stopLoading()
        webView.navigationDelegate = nil
        webView.removeFromSuperview()
    }
}

// MARK: - Actions

private extension CheckoutViewController {

    @objc func openPaymentTapped() {
        showWebView()
    }
}

// MARK: - WKNavigationDelegate

extension CheckoutViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        if url.scheme == Self.appScheme {
            decisionHandler(.cancel)
            hideWebView()
            delegate?.checkoutDidComplete(with: url)
            return
        }

        decisionHandler(.allow)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        guard let failingURL = (error as NSError).userInfo["NSErrorFailingURLKey"] as? URL,
              failingURL.scheme == Self.appScheme else { return }
        hideWebView()
        delegate?.checkoutDidComplete(with: failingURL)
    }
}
