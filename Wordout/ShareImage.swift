//
//  ShareImage.swift
//  Wordout
//
//  Created by Alasdair Casperd on 30/11/2022.
//

import SwiftUI
import LinkPresentation

class ShareImage: UIActivityItemProvider {
  var image: UIImage

  override var item: Any {
    get {
      return self.image
    }
  }

  override init(placeholderItem: Any) {
    guard let image = placeholderItem as? UIImage else {
      fatalError("Couldn't create image from provided item")
    }

    self.image = image
    super.init(placeholderItem: placeholderItem)
  }

  @available(iOS 13.0, *)
  override func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {

    let metadata = LPLinkMetadata()
    metadata.title = "Result Image"

    var thumbnail: NSSecureCoding = NSNull()
    if let imageData = self.image.pngData() {
      thumbnail = NSData(data: imageData)
    }

    metadata.imageProvider = NSItemProvider(item: thumbnail, typeIdentifier: "public.png")

    return metadata
  }

}
