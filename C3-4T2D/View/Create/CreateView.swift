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
                TopBarView()
                    .padding(.bottom, 12)
                
                ScrollView {
                    // MARK: 프로젝트명
                    
                    Button(action: {
                        showProjectSelector = true
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("프로젝트명")
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                    }
                    
                    TextField("프로젝트명을 적어주세요", text: $projectName)
                        .font(.system(size: 14))
                        .submitLabel(.done)
                        .padding(.vertical, 8)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray),
                            alignment: .bottom
                        )
                    
                    // MARK: 날짜 선택
                    
                    VStack(alignment: .leading) {
                        Text("과정 기록일")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                        
                        Button {
                            showDatePicker = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 16))
                                Text(formattedDate(date: selectedDate))
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.black)
                        }
                        Divider()
                            .background(Color.gray)
                    }
                    .padding(.vertical, 16)
                    .sheet(isPresented: $showDatePicker) {
                        DatePickerSheetView(
                            selectedDate: $selectedDate,
                            isPresented: $showDatePicker
                        )
                    }
                    
                    // MARK: 사진 업로드
                    
                    VStack(alignment: .leading) {
                        Text("진행 과정")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                        
                        VStack(spacing: 28) {
                            Button(action: {
                                isPresentingCamera = true
                            }) {
                                VStack {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 64, height: 64)
                                        .background(Color.yellow)
                                        .clipShape(Circle())
                                        .padding(.bottom, 16)
                                    
                                    Text("과정의 기록을 보여줄 수 있는 사진을 올려주세요")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.gray)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.vertical, 56)
                        }
                        .frame(maxWidth: .infinity) // 가운데 정렬
                    }
                    
                    // MARK: 설명 입력
                    
                    VStack(alignment: .leading) {
                        Text("과정에 관한 설명")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.bottom, 8)
                        
                        ZStack(alignment: .topLeading) {
                            if descriptionText.isEmpty {
                                Text("과정에 대하여 남기고 싶은 내용이 있으면 적어주세요")
                                    .foregroundColor(.gray)
                                    .padding(.top, 12)
                                    .padding(.leading, 8)
                                    .font(.system(size: 14))
                            }
                            
                            // 실제 입력창
                            TextEditor(text: $descriptionText)
                                .padding(8)
                                .font(.system(size: 14))
                                .scrollContentBackground(.hidden)
                                .scrollDisabled(true)
                                .frame(height: 120)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.vertical, 16)
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
    
func formattedDate(date: Date) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
        
    if calendar.isDateInToday(date) {
        formatter.dateFormat = "M월 d일 (E)"
        let today = formatter.string(from: date)
        return "오늘, \(today)"
    } else {
        formatter.dateFormat = "M월 d일 (E)"
        return formatter.string(from: date)
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
