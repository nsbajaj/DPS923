//
//  ViewController+Photo.swift
//  egCamera
//

import UIKit

// To take or pick a photo, we must adopt these two protocols
extension FoodItemAdd: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Lifecycle
    func getPhotoWithCameraOrPhotoLibrary() {
        
        // Create the image picker controller
        let c = UIImagePickerController()
        
        // Determine what we can use...
        // Prefer the camera, but can use the photo library
        c.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        
        c.delegate = self
        c.allowsEditing = false
        // Show the controller
        present(c, animated: true, completion: nil)
    }
    
    // MARK: - Image picker delegate methods
    
    // Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Save
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photo = image
        foodItemPicture.setImage(photo , for: UIControlState.normal)
        
        dismiss(animated: true, completion: nil)
    }
}

