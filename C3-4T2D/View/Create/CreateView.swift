//
//  CreateView.swift
//  C3-4T2D
//
//  Created by Hwnag Seyeon on 5/29/25.
//

import SwiftUI

struct CreateView: View {
    @State private var projectName: String = ""
    @State private var showProjectSelector = false
    @State private var isPresentingCamera = false
    @State private var descriptionText: String = ""
    @State private var showPlaceholder: Bool = true
    
    @State private var selectedDate = Date()
    @State private var showDatePicker = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                CreateTitleView()
                    .padding(.bottom, 12)
                
                ScrollView {
                    
                    // 프로젝트명
                    CreateProjTitleView(projectName: $projectName, showProjectSelector: $showProjectSelector)
                    
                    // 날짜 선택
                    CreateDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                    
                    // 사진 업로드
                    CreatePhotoView(isPresentingCamera: $isPresentingCamera)
                    
                    // 메모 입력
                    CreateMemoView(descriptionText: $descriptionText)
                }
                .scrollDismissesKeyboard(.interactively)
                
                // MARK: 작성 완료 버트
                
                Spacer()
                
                Button(action: {
                    // 작성 완료 동작
                }) {
                    Text("작성 완료")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
            }
            .fullScreenCover(isPresented: $isPresentingCamera) {
                CameraView()
            }
            .sheet(isPresented: $showProjectSelector) {
                ProjectSelectorView()
                    .presentationDetents([.medium, .large])
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
    
#Preview {
    CreateView()
}
