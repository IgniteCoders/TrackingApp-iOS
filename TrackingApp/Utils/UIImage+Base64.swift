//
//  UIImage+Base64.swift
//  Utils-iOS
//
//  Created by IgniteCoders on 11/2/26.
//

import UIKit

// MARK: - UIImage <-> Base64 Helpers

extension UIImage {
    /// Encodes the image to a Base64 string.
    /// - Parameters:
    ///   - format: The image format to encode as. Defaults to `.jpeg(quality: 0.9)`.
    ///   - includeDataURLPrefix: If true, prefixes the string with a proper data URL header (e.g. `data:image/jpeg;base64,`).
    /// - Returns: Base64 string or nil if encoding fails.
    func base64EncodedString(
        as format: ImageEncodingFormat = .jpeg(quality: 0.9),
        includeDataURLPrefix: Bool = false
    ) -> String? {
        guard let data = self.encodedData(as: format) else { return nil }
        let base64 = data.base64EncodedString()
        if includeDataURLPrefix {
            return format.dataURLPrefix + base64
        }
        return base64
    }

    /// Returns PNG or JPEG data for the image according to the provided format.
    /// - Parameter format: The desired encoding format.
    /// - Returns: Encoded image data or nil.
    func encodedData(as format: ImageEncodingFormat = .jpeg(quality: 0.9)) -> Data? {
        switch format {
        case .png:
            return self.pngData()
        case .jpeg(let quality):
            return self.jpegData(compressionQuality: quality)
        }
    }
}

/// Supported encoding formats for Base64 export.
public enum ImageEncodingFormat: Equatable {
    case png
    case jpeg(quality: CGFloat)

    var utiMimeType: String {
        switch self {
        case .png: return "image/png"
        case .jpeg: return "image/jpeg"
        }
    }

    var dataURLPrefix: String {
        return "data:\(utiMimeType);base64,"
    }
}

extension String {
    /// Decodes a Base64 string into a UIImage.
    /// Handles optional `data:image/...;base64,` prefixes and ignores unknown characters.
    var imageFromBase64: UIImage? {
        UIImage.fromBase64String(self)
    }
}

extension UIImage {
    /// Decodes a Base64 string (with or without a data URL prefix) into a UIImage.
    /// - Parameter base64String: The Base64 string to decode.
    /// - Returns: A UIImage if decoding succeeds; otherwise nil.
    static func fromBase64String(_ base64String: String) -> UIImage? {
        // Strip possible data URL prefix like: data:image/png;base64,
        let cleaned: String
        if let range = base64String.range(of: ",") , base64String.hasPrefix("data:") , base64String.contains(";base64") {
            cleaned = String(base64String[range.upperBound...])
        } else {
            cleaned = base64String
        }

        guard let imageData = Data(base64Encoded: cleaned, options: .ignoreUnknownCharacters), !imageData.isEmpty else {
            return nil
        }
        return UIImage(data: imageData)
    }
}

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio = size.width / size.height

        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }

        default:
            fatalError("UIImage.resizeImage(_:opaque:contentMode:): Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            renderFormat.scale = 1
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image { _ in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 1)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            if let img = UIGraphicsGetImageFromCurrentImageContext() {
                newImage = img
            } else {
                newImage = self
            }
            UIGraphicsEndImageContext()
        }

        return newImage
    }
}
