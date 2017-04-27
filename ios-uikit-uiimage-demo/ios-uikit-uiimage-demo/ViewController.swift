//
//  ViewController.swift
//  ios-uikit-uiimage-demo
//
//  Created by OkuderaYuki on 2017/02/07.
//  Copyright © 2017年 YukiOkudera. All rights reserved.
//

import UIKit
import CoreFoundation

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    var imagePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveImage()
        setupImage()
        
        outputImage()
    }
    
    //MARK:- 事前準備
    
    /// Documentsディレクトリ直下にDog.jpgを保存する
    private func saveImage() {
        guard let resourcePath = Bundle.main.path(forResource: "Dog", ofType: "jpg") else { return }
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        imagePath = documentsDirectory.appending("/Dog.jpg")
        try? FileManager.default.copyItem(atPath: resourcePath, toPath: imagePath)
    }
    
    private func outputImage() {
        imageView.contentMode = .center
        imageView.image = self.image
    }
    
    //MARK:- initializer
    
    /// 画像名を指定して、UIImageを設定する(自動でキャッシュされる)
    private func setupImage() {
        image = UIImage.init(named: "Raccoon")
//        image = UIImage.init(named: "Cat.jpg", in: Bundle.main, compatibleWith: nil)
    }
    
    /// 画像名を指定して、UIImageを設定する(自動でキャッシュされない)
    private func setupImageContentsOfFile() {
        image = UIImage.init(contentsOfFile: imagePath)
    }
    
    /// 画像のURLを指定して、UIImageを設定する
    private func setupImageFromUrl() {
        let imageUrlString = "https://images-na.ssl-images-amazon.com/images/I/619XgyIYnBL._AC_UL115_.jpg"
        guard let url = URL(string: imageUrlString) else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        image = UIImage.init(data: imageData)
    }
    
    //MARK:- properties
    
    /// 画像の向きの情報を取得する
    private func imageOrientation() {
        guard let image = image else { return }
        let imageOrientation = image.imageOrientation
        
        // up:0, down:1, left:2, right:3
        print("imageOrientation: \(imageOrientation.rawValue)")
    }
    
    /// 画像のサイズを取得する
    private func size() {
        guard let image = image else { return }
        let imageSize = image.size
        
        print("size: \(imageSize)")
    }
    
    /// 画像のスケールを取得する
    private func scale() {
        guard let image = image else { return }
        let imageScale = image.scale
        
        print("scale: \(imageScale)")
    }
    
    //MARK:- options
    
    /// 画像を回転させる
    private func rotate() {
        guard let cgImage = image?.cgImage else { return }
        let rotateImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .left)
        self.image = rotateImage
    }
    
    /// 画像の大きさを変更する
    private func resize() {
        guard let image = image else { return }
        
        // 画像の幅、高さを取得する
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        print("size:\(image.size)")
        
        let newSize = CGSize(width: imageWidth * 0.5, height: imageHeight * 0.5)
        UIGraphicsBeginImageContext(newSize)
        
        // 指定した範囲内に描画する (リサイズ)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = resizeImage
        print("newSize:\(String(describing: resizeImage?.size))")
    }
    
    /// 画像の一部分を切り抜く
    private func crop() {
        guard let cgImage = image?.cgImage else { return }
        
        let newSize = CGSize(width: 90, height: 90)
        let croppedRect = CGRect(x: 50, y: 120, width: newSize.width, height: newSize.height)
        
        // 画像の一部分を切り抜いて、新しい画像を作成する
        guard let cropCGImageRef = cgImage.cropping(to: croppedRect) else { return }
        
        let croppedImage = UIImage(cgImage: cropCGImageRef)
        self.image = croppedImage
    }
    
    /// 画像を塗りつぶす
    private func fillInImage() {
        guard let image = image else { return }
        
        let fillColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1).cgColor
        let fillRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContext(image.size)
        
        guard let cgContextRef = UIGraphicsGetCurrentContext() else { return }
        
        // 色、透過度、範囲を指定して塗りつぶす
        cgContextRef.setFillColor(fillColor)
        cgContextRef.setAlpha(0.8)
        cgContextRef.fill(fillRect)
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = colorImage
    }

    // MARK: - UIImageをカメラロールに保存する
    // MARK: info.plist > Privacy - Photo Library Usage Description を設定しておかないとiOS10以降だと落ちる
    @IBAction func didTapWriteToSavedPhotosAlbumButton(_ sender: UIButton) {
        writeToSaveImage()
    }

    /// カメラロールに保存する
    private func writeToSaveImage() {
        guard let image = image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(resultWriteToSave(image:error:contextInfo:)), nil)
    }

    /// UIImageWriteToSavedPhotosAlbum実行後に呼ばれる
    func resultWriteToSave(image: UIImage, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {

        let title: String
        let message: String

        // 写真の利用を許可していなかったりするとerror
        if let error = error {
            title = "Error!"
            message = error.localizedDescription
        } else {
            title = "完了"
            message = "画像をカメラロールに保存しました"
        }

        showAlert(title: title, message: message)
    }

    /// アラート呼ぶメソッド（UIImageには関係ないです）
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

