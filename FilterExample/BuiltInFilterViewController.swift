import UIKit

class BuiltInFilterViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func oneFilterDidTap(_ sender: Any) {
        applyFilter(name: "CISepiaTone")
    }
    
    @IBAction func multipleFiltersDidTap(_ sender: Any) {
        applyChainingFilters()
    }
    
    var beginImage: CIImage!
    var context: CIContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginImage = CIImage(image: UIImage(named: "milk")!)
        self.context = CIContext(options: nil)
    }
    
    func applyFilter(name: String) {
        let filter = CIFilter(name: "CISepiaTone")!
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(0.5, forKey: kCIInputIntensityKey)
                
        if let output = filter.outputImage {
            if let cgimg = context.createCGImage(output, from: output.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                self.imgView.image = processedImage
            }
        }
    }
    
    func applyChainingFilters() {
        let output = self.beginImage
            .applyingFilter("CISepiaTone", parameters: [
                kCIInputIntensityKey: 0.5
            ])
            .applyingFilter("CICMYKHalftone", parameters: [
                kCIInputWidthKey: 35
            ])

        if let cgimg = context.createCGImage(output, from: output.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imgView.image = processedImage
        }
    }
}
