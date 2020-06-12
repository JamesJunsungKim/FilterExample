import UIKit

class CustomMetalViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func colorsDidTap(_ sender: UIButton) {
        applyColorKernel(number: sender.tag + 1)
    }
    
    @IBAction func blendBuiltInDidTap(_ sender: Any) {
        applyBuiltInBlendKernel()
    }
    
    @IBAction func blendCustomDidTap(_ sender: Any) {
        applyCustomBlendKernel()
    }
    
    @IBAction func warpsDidTap(_ sender: UIButton) {
        applyWarpKernel(number: sender.tag + 1)
    }
    
    var beginImage: CIImage!
    var context: CIContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.beginImage = CIImage(image: UIImage(named: "milk")!)
        self.context = CIContext(options: nil)
    }
    
    func applyColorKernel(number: Int) {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)

        let kernel = try! CIColorKernel(functionName: "color\(number)", fromMetalLibraryData: data)

        let output = kernel.apply(extent: beginImage.extent, arguments: [beginImage as Any])!

        if let cgimg = context.createCGImage(output, from: output.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imgView.image = processedImage
        }
    }
    
    func applyBuiltInBlendKernel() {
        let backgroundImage = CIImage(image: UIImage(named: "background")!)!
        
        let kernel = CIBlendKernel.vividLight
        
        let outputImage = kernel.apply(foreground: beginImage, background: backgroundImage)!
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imgView.image = processedImage
        }
    }
    
    func applyCustomBlendKernel() {
        let backgroundImage = CIImage(image: UIImage(named: "background")!)!
        
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)
        let kernel = try! CIBlendKernel(functionName: "averageBlend", fromMetalLibraryData: data)
        
        let outputImage = kernel.apply(foreground: beginImage, background: backgroundImage)!
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imgView.image = processedImage
        }
    }
        
    func applyWarpKernel(number: Int) {
        let url = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let data = try! Data(contentsOf: url)

        let kernel = try! CIWarpKernel(functionName: "warp\(number)", fromMetalLibraryData: data)

        let outputImage = kernel.apply(extent: beginImage.extent, roiCallback: { (index, rect) -> CGRect in
            return rect
        }, image: beginImage, arguments: [])!
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imgView.image = processedImage
        }
    }
}
