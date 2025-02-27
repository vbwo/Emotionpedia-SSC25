import SwiftUI
import AVFoundation

/// Manages camera input for activities, supporting both front and back cameras.
/// Used in `HappyActivity` for clap detection and in `AngryActivity` as a background for bubble-blowing.
class ActivityCameraManager: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var onFrameCaptured: (CVPixelBuffer) -> Void
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureVideoDataOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var cameraPosition: AVCaptureDevice.Position
    var game: MusicGameManager?
    
    let rotationAngle: CGFloat = -.pi / 2
    
    init(onFrameCaptured: @escaping (CVPixelBuffer) -> Void, game: MusicGameManager?, cameraPosition: AVCaptureDevice.Position) {
        self.onFrameCaptured = onFrameCaptured
        self.game = game
        self.cameraPosition = cameraPosition
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    /// Configures the camera session, input, output, and preview.
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard setupCameraInput() else { return }
        setupVideoOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    /// Sets up and adds the camera input to the session.
    /// - Returns: `true` if successful, `false` otherwise.
    private func setupCameraInput() -> Bool {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoInput) else {
            return false
        }
        
        captureSession.addInput(videoInput)
        return true
    }
    
    /// Configures the video output for frame processing.
    private func setupVideoOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
    }
    
    /// Sets up the preview layer to display the camera feed.
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.setAffineTransform(CGAffineTransform(rotationAngle: rotationAngle))
        view.layer.addSublayer(previewLayer)
    }
    
    /// Updates the preview layer's frame to match the view's bounds.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    /// Processes each captured video frame.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        onFrameCaptured(pixelBuffer)
        game?.processFrame(pixelBuffer)
    }
}

