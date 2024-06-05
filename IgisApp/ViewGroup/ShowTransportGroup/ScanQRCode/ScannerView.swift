//
//  ScannerView.swift
//  IgisApp
//
//  Created by Гриша Шкробов on 12.12.2023.
//

import SwiftUI
import AVKit

struct ScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var navigationStack: NavigationPath
    
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permission = .idle
    
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment (\.openURL) private var openURL
    
    @StateObject private var qrDelegate = QRScannerDelegate()
    
    @State private var scannedCode: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                dismiss()
            } label: {
                Image (systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            
            Text ("Поместите QR-код в область сканирования")
                .font(.title3)
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 20)
            
            Text ("Сканирование начнется автоматически")
                .font(.callout)
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            // Scanner
            GeometryReader {
                let size = $0.size
                ZStack {
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                        .scaleEffect(0.97)
                    
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double (index) * 90
                        RoundedRectangle (cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap:
                                    .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                }
                // Sqaure Shape
                .frame(width: size.width, height: size.width)
                // Scanner Animation
                .overlay (alignment: .top, content: {
                    Rectangle ()
                        .fill(.blue)
                        .frame (height: 2.5)
                        .shadow (color: .black.opacity(0.8), radius: 8, x: 0, y: isScanning ? 15 : -15)
                        .offset (y: isScanning ? size.width : 0)
                })
                // To Make it Center
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(.horizontal, 45)
            
                
                Spacer(minLength: 15)
                
                Button {
                    if !session.isRunning && cameraPermission == .approved {
                        reactivateCamera()
                        activateScannerAnimation()
                    }
                } label: {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                
                Spacer (minLength: 45)
                
        }
        .onAppear(perform: checkCameraPermission)
        .alert(errorMessage, isPresented: $showError){
            if cameraPermission == .denied {
                Button("Настройки") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsURL = URL (string: settingsString) {
                        openURL(settingsURL)
                    }
                }
                
                Button ("Отменить", role: .cancel) {
                    dismiss()
                }
            }
        }
        .onChange(of: qrDelegate.scannedCode){ newValue in
            if let code = newValue {
                scannedCode = code
                session.stopRunning()
                deActivateScannerAnimation()
                qrDelegate.scannedCode = nil
                scanningSuccessful(scanText: code)
            }
        }
        .onDisappear {
            session.stopRunning()
        }
    }
    
    func scanningSuccessful(scanText: String){
   
        if(scanText.contains("https://igis-transport.ru/qr/")){
            
            if let transportId = scanText.components(separatedBy: "/").last{
                navigationStack.append(CurrentTransportSelectionView.showTransportUnit(transportId))
            }else{
                presentError ("QR-код не валидный")
            }
            
        }else if(scanText.contains("http://m.igis.ru/ts/")){
            
            if let transportId = scanText.components(separatedBy: "/").last{
                navigationStack.append(CurrentTransportSelectionView.showTransportUnit(transportId))
            }else{
                presentError("QR-код не валидный")
            }
            
        }else{
            presentError("Cканируемый QR-код не имеет отношения к порталу IGIS")
        }
        
    }
    
    func reactivateCamera ( ) {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    func deActivateScannerAnimation(){
        withAnimation(.easeInOut(duration: 0.85)) {
                isScanning = false
            }
    }
    
    func setupCamera(){
        do{
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video,
                                                                position: .back) .devices.first else {
            presentError ("Ошибка устройства")
            return
            }
            
            let input = try AVCaptureDeviceInput (device: device)
            // For Extra Saftey
            // Checking Whether input & output can be added to the session
            guard session.canAddInput (input), session.canAddOutput(qrOutput) else {
            presentError ("Ошибка видеопотока")
            return
            }
            
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            
            qrOutput.metadataObjectTypes = [.qr]
            
            qrOutput.setMetadataObjectsDelegate (qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
            
        }catch{
            presentError(error.localizedDescription)
        }
    }
    
    func activateScannerAnimation(){
        withAnimation(.easeInOut(duration: 0.85)
            .delay(0.1)
            .repeatForever(autoreverses: true)) {
                isScanning = true
            }
    }
    
    func checkCameraPermission(){
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                }else{
                    reactivateCamera()
                }
            case .notDetermined:
                if await AVCaptureDevice.requestAccess (for: .video) {
                    // Permission Granted
                    cameraPermission = .approved
                } else {
                    // Permission Denied
                    cameraPermission = .denied
                    presentError ("Для сканирования QR-кода необходим доступ к камере")
                }
            case .denied, .restricted:
                cameraPermission = .denied
                presentError ("Для сканирования QR-кода необходим доступ к камере")
            default: break
            }
        }
    }
    
    func presentError(_ message: String){
        errorMessage = message
        showError.toggle()
    }
}

struct ScannerView_Previews: PreviewProvider {
    
    @State static var stack = NavigationPath()
    
    static var previews: some View {
        ScannerView(navigationStack: $stack)
    }
}
