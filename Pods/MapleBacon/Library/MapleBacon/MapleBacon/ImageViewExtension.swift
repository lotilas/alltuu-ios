//
// Copyright (c) 2015 Zalando SE. All rights reserved.
//

import UIKit

private var ImageViewAssociatedObjectHandle: UInt8 = 0

extension UIImageView {

    public func setImageWithURL(url: NSURL, placeholder: UIImage? = nil, crossFadePlaceholder crossFade: Bool = true,
            cacheScaled: Bool = false, completion: ImageDownloaderCompletion? = nil) {
        if let placeholder = placeholder {
            image = placeholder
        }
        cancelDownload()
        if let operation = downloadOperationWithURL(url, placeholder: placeholder, crossFadePlaceholder: crossFade,
            cacheScaled: cacheScaled, completion: completion) {
            self.operation = operation
        }
    }

    private func downloadOperationWithURL(url: NSURL, placeholder: UIImage? = nil, crossFadePlaceholder crossFade: Bool = true,
            cacheScaled: Bool = false, completion: ImageDownloaderCompletion? = nil) -> ImageDownloadOperation? {
        return ImageManager.sharedManager.downloadImageAtURL(url, cacheScaled: cacheScaled, imageView: self) {
            [weak self] imageInstance, error in
            dispatch_async(dispatch_get_main_queue()) {
                if let image = imageInstance?.image {
                    if let _ = placeholder where crossFade {
                        self?.layer.addAnimation(CATransition(), forKey: nil)
                    }
                    self?.image = image
                }
                completion?(imageInstance, error)
            }
        }
    }

    private var operation: ImageDownloadOperation? {
        get {
            return objc_getAssociatedObject(self, &ImageViewAssociatedObjectHandle) as? ImageDownloadOperation
        }
        set {
            objc_setAssociatedObject(self, &ImageViewAssociatedObjectHandle, newValue,
                    objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

    func cancelDownload() {
        operation?.cancel()
    }

}
